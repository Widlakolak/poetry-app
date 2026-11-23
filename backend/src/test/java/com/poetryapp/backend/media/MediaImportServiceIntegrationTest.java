package com.poetryapp.backend.media;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import com.poetryapp.backend.catalog.domain.MediaSourceType;
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
