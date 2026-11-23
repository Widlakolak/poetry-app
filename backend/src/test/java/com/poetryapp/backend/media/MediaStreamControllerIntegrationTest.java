package com.poetryapp.backend.media;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class MediaStreamControllerIntegrationTest {

    private static final byte[] VIDEO_BYTES = "ABCDEFGHIJKL".getBytes(StandardCharsets.US_ASCII);

    @TempDir
    static Path mediaDirectory;

    @DynamicPropertySource
    static void mediaPath(DynamicPropertyRegistry registry) {
        registry.add("app.media.storage-dir", () -> mediaDirectory.toString());
    }

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private MediaItemRepository mediaItemRepository;

    @BeforeEach
    void resetCatalogAndStorage() throws Exception {
        mediaItemRepository.deleteAll();
        try (var paths = Files.list(mediaDirectory)) {
            for (Path path : paths.toList()) {
                Files.delete(path);
            }
        }
    }

    @Test
    void returnsCompleteMp4ForNormalGet() throws Exception {
        UUID id = createVideo(PublicationStatus.PUBLISHED, true, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", id))
                .andExpect(status().isOk())
                .andExpect(header().string("Accept-Ranges", "bytes"))
                .andExpect(header().string("Content-Type", "video/mp4"))
                .andExpect(content().bytes(VIDEO_BYTES));
    }

    @Test
    void supportsByteRangeWithoutTransferringWholeFile() throws Exception {
        UUID id = createVideo(PublicationStatus.PUBLISHED, true, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", id)
                        .header("Range", "bytes=0-3"))
                .andExpect(status().isPartialContent())
                .andExpect(header().string("Content-Range", "bytes 0-3/12"))
                .andExpect(content().bytes("ABCD".getBytes(StandardCharsets.US_ASCII)));
    }

    @Test
    void supportsRangeFromEndOfFile() throws Exception {
        UUID id = createVideo(PublicationStatus.PUBLISHED, true, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", id)
                        .header("Range", "bytes=-3"))
                .andExpect(status().isPartialContent())
                .andExpect(header().string("Content-Range", "bytes 9-11/12"))
                .andExpect(content().bytes("JKL".getBytes(StandardCharsets.US_ASCII)));
    }

    @Test
    void unknownAndUnpublishedVideosAreNotAvailable() throws Exception {
        UUID unpublishedId = createVideo(PublicationStatus.PROCESSING, true, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", unpublishedId))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/v1/media/{id}/stream", UUID.randomUUID()))
                .andExpect(status().isNotFound());
    }

    @Test
    void missingFileIsNotAvailable() throws Exception {
        UUID id = createVideo(PublicationStatus.PUBLISHED, false, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", id))
                .andExpect(status().isNotFound());
    }

    @Test
    void rejectsStorageKeysThatAreNotCreatedByTheImporter() throws Exception {
        UUID id = createVideo(PublicationStatus.PUBLISHED, false, "../private.mp4");

        mockMvc.perform(get("/api/v1/media/{id}/stream", id))
                .andExpect(status().isNotFound());
        assertTrue(Files.notExists(mediaDirectory.resolve("../private.mp4")));
    }

    @Test
    void returnsAudioMpegAndSupportsMp3ByteRange() throws Exception {
        UUID id = createAudio(PublicationStatus.PUBLISHED, true, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", id))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Type", "audio/mpeg"))
                .andExpect(content().bytes(VIDEO_BYTES));
        mockMvc.perform(get("/api/v1/media/{id}/stream", id)
                        .header("Range", "bytes=1-4"))
                .andExpect(status().isPartialContent())
                .andExpect(header().string("Content-Type", "audio/mpeg"))
                .andExpect(header().string("Content-Range", "bytes 1-4/12"))
                .andExpect(content().bytes("BCDE".getBytes(StandardCharsets.US_ASCII)));
    }

    @Test
    void unpublishedAudioAndMissingMp3AreNotAvailable() throws Exception {
        UUID unpublished = createAudio(PublicationStatus.PROCESSING, true, null);
        UUID missing = createAudio(PublicationStatus.PUBLISHED, false, null);

        mockMvc.perform(get("/api/v1/media/{id}/stream", unpublished))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/v1/media/{id}/stream", missing))
                .andExpect(status().isNotFound());
    }

    @Test
    void rejectsInvalidMp3StorageKeyAndMediaTypeMismatch() throws Exception {
        UUID traversal = createAudio(PublicationStatus.PUBLISHED, false, "../secret.mp3");
        UUID mismatch = createAudio(PublicationStatus.PUBLISHED, true, UUID.randomUUID() + ".mp4");

        mockMvc.perform(get("/api/v1/media/{id}/stream", traversal))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/v1/media/{id}/stream", mismatch))
                .andExpect(status().isNotFound());
    }

    private UUID createAudio(PublicationStatus status, boolean createFile, String overrideStorageKey)
            throws Exception {
        String storageKey = overrideStorageKey != null ? overrideStorageKey : UUID.randomUUID() + ".mp3";
        if (createFile) {
            Files.write(mediaDirectory.resolve(storageKey), VIDEO_BYTES);
        }

        MediaItem item = new MediaItem(
                "Integration test audio", MediaType.AUDIO, MediaSourceType.LOCAL_FILE,
                null, "test.mp3", storageKey, "audio/mpeg", (long) VIDEO_BYTES.length,
                null, null, status, TranscriptStatus.NOT_AVAILABLE);
        if (status == PublicationStatus.PUBLISHED) {
            item.publish();
        }
        return mediaItemRepository.saveAndFlush(item).getId();
    }

    private UUID createVideo(PublicationStatus status, boolean createFile, String overrideStorageKey)
            throws Exception {
        String storageKey = overrideStorageKey != null
                ? overrideStorageKey
                : UUID.randomUUID() + ".mp4";
        if (createFile) {
            Files.write(mediaDirectory.resolve(storageKey), VIDEO_BYTES);
        }

        MediaItem item = new MediaItem(
                "Integration test video", MediaType.VIDEO, MediaSourceType.LOCAL_FILE,
                null, "test.mp4", storageKey, "video/mp4", (long) VIDEO_BYTES.length,
                null, null, status, TranscriptStatus.NOT_AVAILABLE);
        if (status == PublicationStatus.PUBLISHED) {
            item.publish();
        }
        return mediaItemRepository.saveAndFlush(item).getId();
    }
}
