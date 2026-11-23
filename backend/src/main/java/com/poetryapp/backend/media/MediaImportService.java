package com.poetryapp.backend.media;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.Locale;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class MediaImportService {

    private static final int BUFFER_SIZE = 64 * 1024;

    private final MediaItemRepository mediaItemRepository;
    private final Path incomingDirectory;
    private final Path mediaDirectory;
    private final long maxFileSizeBytes;

    public MediaImportService(
            MediaItemRepository mediaItemRepository,
            @Value("${app.media.incoming-dir:/data/incoming}") String incomingDirectory,
            @Value("${app.media.storage-dir:/data/media}") String mediaDirectory,
            @Value("${app.media.max-file-size-bytes:2147483648}") long maxFileSizeBytes) {
        this.mediaItemRepository = mediaItemRepository;
        this.incomingDirectory = Path.of(incomingDirectory);
        this.mediaDirectory = Path.of(mediaDirectory);
        this.maxFileSizeBytes = maxFileSizeBytes;
    }

    public MediaItem importMp4(String fileName, String title) throws IOException {
        validateInput(fileName, title);
        requireDirectory(incomingDirectory, "Incoming directory");
        requireDirectory(mediaDirectory, "Media directory");

        Path source = incomingDirectory.resolve(fileName);
        if (!Files.isRegularFile(source, LinkOption.NOFOLLOW_LINKS)) {
            throw new IllegalArgumentException("Source is missing, is not a regular file, or is a symbolic link");
        }
        long sourceSize = Files.size(source);
        if (sourceSize <= 0 || sourceSize > maxFileSizeBytes) {
            throw new IllegalArgumentException("Source size is zero or exceeds configured limit");
        }
        validateMp4Header(source);

        Path stagingFile = Files.createTempFile(mediaDirectory, ".import-", ".part");
        Path targetFile = null;
        try {
            MessageDigest digest = sha256();
            long bytesCopied = copyAndDigest(source, stagingFile, digest);
            if (bytesCopied != sourceSize || Files.size(source) != sourceSize) {
                throw new IOException("Source changed during import");
            }

            String hash = HexFormat.of().formatHex(digest.digest());
            var existing = mediaItemRepository.findBySha256(hash);
            if (existing.isPresent()) {
                return existing.get();
            }

            String storageKey = UUID.randomUUID() + ".mp4";
            targetFile = mediaDirectory.resolve(storageKey);
            try {
                Files.move(stagingFile, targetFile, StandardCopyOption.ATOMIC_MOVE);
            } catch (AtomicMoveNotSupportedException exception) {
                Files.move(stagingFile, targetFile);
            }

            MediaItem item = new MediaItem(
                    title, MediaType.VIDEO, MediaSourceType.LOCAL_FILE,
                    null, fileName, storageKey, "video/mp4", bytesCopied,
                    hash, null, PublicationStatus.PROCESSING,
                    TranscriptStatus.NOT_AVAILABLE);
            item.publish();
            return mediaItemRepository.saveAndFlush(item);
        } catch (IOException | RuntimeException exception) {
            if (targetFile != null) {
                try {
                    Files.deleteIfExists(targetFile);
                } catch (IOException cleanupFailure) {
                    exception.addSuppressed(cleanupFailure);
                }
            }
            throw exception;
        } finally {
            Files.deleteIfExists(stagingFile);
        }
    }

    private void validateInput(String fileName, String title) {
        if (fileName == null || fileName.isBlank()
                || !fileName.equals(Path.of(fileName).getFileName().toString())
                || fileName.contains("\\") || fileName.equals(".") || fileName.equals("..")
                || fileName.indexOf('\n') >= 0 || fileName.indexOf('\r') >= 0
                || !fileName.toLowerCase(Locale.ROOT).endsWith(".mp4")) {
            throw new IllegalArgumentException("Expected one MP4 filename, without a path");
        }
        if (title == null || title.isBlank() || title.strip().length() > 200) {
            throw new IllegalArgumentException("Title must have 1 to 200 characters");
        }
        if (maxFileSizeBytes < 1) {
            throw new IllegalArgumentException("Configured size limit must be positive");
        }
    }

    private static void requireDirectory(Path directory, String description) {
        if (!Files.isDirectory(directory)) {
            throw new IllegalStateException(description + " is not mounted");
        }
    }

    private static void validateMp4Header(Path source) throws IOException {
        try (InputStream input = Files.newInputStream(source)) {
            byte[] header = input.readNBytes(12);
            if (header.length < 12 || header[4] != 'f' || header[5] != 't'
                    || header[6] != 'y' || header[7] != 'p') {
                throw new IllegalArgumentException("File does not have an MP4 ftyp header");
            }
        }
    }

    private long copyAndDigest(Path source, Path destination, MessageDigest digest) throws IOException {
        long total = 0;
        try (InputStream input = Files.newInputStream(source);
             OutputStream output = Files.newOutputStream(destination)) {
            byte[] buffer = new byte[BUFFER_SIZE];
            int read;
            while ((read = input.read(buffer)) != -1) {
                total += read;
                if (total > maxFileSizeBytes) {
                    throw new IllegalArgumentException("Source grew beyond configured size limit");
                }
                digest.update(buffer, 0, read);
                output.write(buffer, 0, read);
            }
        }
        return total;
    }

    private static MessageDigest sha256() {
        try {
            return MessageDigest.getInstance("SHA-256");
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException("SHA-256 is not available", exception);
        }
    }
}
