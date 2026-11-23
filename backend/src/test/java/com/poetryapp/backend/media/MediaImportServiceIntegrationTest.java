package com.poetryapp.backend.media;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;

@SpringBootTest
@ActiveProfiles("test")
class MediaImportServiceIntegrationTest {

    @TempDir
    static Path root;

    @DynamicPropertySource
    static void mediaPaths(DynamicPropertyRegistry registry) {
        registry.add("app.media.incoming-dir", () -> root.resolve("incoming").toString());
        registry.add("app.media.storage-dir", () -> root.resolve("media").toString());
        registry.add("app.media.max-file-size-bytes", () -> "1024");
    }

    @Autowired
    private MediaImportService importer;

    @Autowired
    private MediaItemRepository repository;

    @BeforeEach
    void reset() throws IOException {
        Files.createDirectories(root.resolve("incoming"));
        Files.createDirectories(root.resolve("media"));
        repository.deleteAll();
        try (var files = Files.list(root.resolve("incoming"))) {
            for (Path path : files.toList()) {
                Files.delete(path);
            }
        }
        try (var files = Files.list(root.resolve("media"))) {
            for (Path path : files.toList()) {
                Files.delete(path);
            }
        }
    }

    @Test
    void importsVideoIntoMediaAndPublishesMetadata() throws Exception {
        Files.write(root.resolve("incoming/test.mp4"), mp4Header());

        var item = importer.importMp4("test.mp4", "Test recording");

        assertEquals(MediaSourceType.LOCAL_FILE, item.getSourceType());
        assertEquals(PublicationStatus.PUBLISHED, item.getPublicationStatus());
        assertNotNull(item.getPublishedAt());
        assertEquals(1, repository.count());
        assertEquals(1, countFiles(root.resolve("media")));
        assertTrue(Files.exists(root.resolve("incoming/test.mp4")));
    }

    @Test
    void importingSameContentAgainReturnsExistingItem() throws Exception {
        Files.write(root.resolve("incoming/test.mp4"), mp4Header());

        var first = importer.importMp4("test.mp4", "Test recording");
        var second = importer.importMp4("test.mp4", "Test recording");

        assertEquals(first.getId(), second.getId());
        assertEquals(1, repository.count());
        assertEquals(1, countFiles(root.resolve("media")));
    }

    @Test
    void rejectsRelativeTraversal() {
        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp4("../escape.mp4", "Test"));
    }

    @Test
    void rejectsInvalidMp4HeaderWithoutWritingMedia() throws Exception {
        Files.write(root.resolve("incoming/fake.mp4"), new byte[20]);

        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp4("fake.mp4", "Test"));
        assertEquals(0, repository.count());
        assertEquals(0, countFiles(root.resolve("media")));
    }

    @Test
    void rejectsFileExceedingConfiguredLimit() throws Exception {
        Files.write(root.resolve("incoming/large.mp4"), new byte[2048]);

        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp4("large.mp4", "Test"));
        assertEquals(0, repository.count());
        assertEquals(0, countFiles(root.resolve("media")));
    }

    @Test
    void importsMp3WithMpegFrameAndPreservesOriginal() throws Exception {
        byte[] data = mp3Header();
        Files.write(root.resolve("incoming/test.mp3"), data);

        var item = importer.importMp3("test.mp3", "Recording from source file");

        assertEquals(MediaType.AUDIO, item.getMediaType());
        assertEquals(MediaSourceType.LOCAL_FILE, item.getSourceType());
        assertEquals(PublicationStatus.PUBLISHED, item.getPublicationStatus());
        assertNotNull(item.getPublishedAt());
        assertEquals(1, repository.count());
        assertEquals(1, countFiles(root.resolve("media")));
        try (var files = Files.list(root.resolve("media"))) {
            assertTrue(files.findFirst().orElseThrow().toString().endsWith(".mp3"));
        }
        assertTrue(Files.exists(root.resolve("incoming/test.mp3")));
    }

    @Test
    void acceptsMp3WithId3v2Tag() throws Exception {
        byte[] id3AndFrame = new byte[] {
                'I', 'D', '3', 3, 0, 0, 0, 0, 0, 4,
                0, 0, 0, 0,
                (byte) 0xff, (byte) 0xfb, (byte) 0x90, 0x64
        };
        Files.write(root.resolve("incoming/tagged.mp3"), id3AndFrame);

        var item = importer.importMp3("tagged.mp3", "Tagged recording");

        assertEquals(MediaType.AUDIO, item.getMediaType());
        assertEquals(1, repository.count());
    }

    @Test
    void mp3ReimportIsIdempotent() throws Exception {
        Files.write(root.resolve("incoming/test.mp3"), mp3Header());

        var first = importer.importMp3("test.mp3", "Recording");
        var second = importer.importMp3("test.mp3", "Recording");

        assertEquals(first.getId(), second.getId());
        assertEquals(1, repository.count());
        assertEquals(1, countFiles(root.resolve("media")));
    }

    @Test
    void rejectsInvalidMp3HeaderAndTraversal() throws Exception {
        Files.write(root.resolve("incoming/fake.mp3"), new byte[32]);

        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp3("fake.mp3", "Test"));
        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp3("../escape.mp3", "Test"));
        assertEquals(0, repository.count());
        assertEquals(0, countFiles(root.resolve("media")));
    }

    @Test
    void rejectsMp3ExceedingSizeLimit() throws Exception {
        Files.write(root.resolve("incoming/large.mp3"), new byte[2048]);

        assertThrows(IllegalArgumentException.class,
                () -> importer.importMp3("large.mp3", "Test"));
        assertEquals(0, repository.count());
        assertEquals(0, countFiles(root.resolve("media")));
    }

    private static byte[] mp3Header() {
        return new byte[] {(byte) 0xff, (byte) 0xfb, (byte) 0x90, 0x64, 0, 0, 0, 0};
    }

    private static byte[] mp4Header() {
        return new byte[] {
                0, 0, 0, 24, 'f', 't', 'y', 'p',
                'i', 's', 'o', 'm', 0, 0, 0, 0,
                'i', 's', 'o', 'm', 'a', 'v', 'c', '1'
        };
    }

    private static long countFiles(Path directory) throws IOException {
        try (var files = Files.list(directory)) {
            return files.count();
        }
    }
}
