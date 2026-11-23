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
        return importFile(fileName, title, ".mp4", MediaType.VIDEO, "video/mp4");
    }

    public MediaItem importMp3(String fileName, String title) throws IOException {
        return importFile(fileName, title, ".mp3", MediaType.AUDIO, "audio/mpeg");
    }

    private MediaItem importFile(String fileName, String title, String extension,
            MediaType mediaType, String mimeType) throws IOException {
        validateInput(fileName, title, extension);
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
        if (mediaType == MediaType.VIDEO) {
            validateMp4Header(source);
        } else {
            validateMp3Header(source);
        }

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

            String storageKey = UUID.randomUUID() + extension;
            targetFile = mediaDirectory.resolve(storageKey);
            try {
                Files.move(stagingFile, targetFile, StandardCopyOption.ATOMIC_MOVE);
            } catch (AtomicMoveNotSupportedException exception) {
                Files.move(stagingFile, targetFile);
            }

            MediaItem item = new MediaItem(
                    title, mediaType, MediaSourceType.LOCAL_FILE,
                    null, fileName, storageKey, mimeType, bytesCopied,
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

    private void validateInput(String fileName, String title, String extension) {
        if (fileName == null || fileName.isBlank()
                || !fileName.equals(Path.of(fileName).getFileName().toString())
                || fileName.contains("\\") || fileName.equals(".") || fileName.equals("..")
                || fileName.indexOf('\n') >= 0 || fileName.indexOf('\r') >= 0
                || !fileName.toLowerCase(Locale.ROOT).endsWith(extension)) {
            throw new IllegalArgumentException("Expected one " + extension + " filename, without a path");
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

    /**
     * Verify a real MPEG Layer III audio frame, optionally following an ID3v2 tag.
     * This is a lightweight format check, not a decoder or full codec validator.
     */
    private static void validateMp3Header(Path source) throws IOException {
        try (InputStream input = Files.newInputStream(source)) {
            byte[] first = input.readNBytes(10);
            if (first.length < 4) {
                throw new IllegalArgumentException("File does not have an MP3 frame header");
            }

            byte[] frameHeader = first;
            if (first[0] == 'I' && first[1] == 'D' && first[2] == '3') {
                int version = first[3] & 0xff;
                if (first.length < 10 || version < 2 || version > 4
                        || ((first[6] | first[7] | first[8] | first[9]) & 0x80) != 0) {
                    throw new IllegalArgumentException("Invalid ID3v2 header");
                }
                long tagSize = ((long) first[6] << 21)
                        | ((long) first[7] << 14)
                        | ((long) first[8] << 7)
                        | first[9];
                long footerSize = version == 4 && (first[5] & 0x10) != 0 ? 10 : 0;
                long frameStart = 10 + tagSize + footerSize;
                if (frameStart + 4 > Files.size(source)) {
                    throw new IllegalArgumentException("ID3 tag contains no audio frames");
                }
                input.skipNBytes(tagSize + footerSize);
                frameHeader = input.readNBytes(4);
            }

            if (!isMpegLayerThreeFrame(frameHeader)) {
                throw new IllegalArgumentException("File does not have an MP3 frame header");
            }
        }
    }

    private static boolean isMpegLayerThreeFrame(byte[] header) {
        if (header.length < 4) {
            return false;
        }
        int bits = ((header[0] & 0xff) << 24)
                | ((header[1] & 0xff) << 16)
                | ((header[2] & 0xff) << 8)
                | (header[3] & 0xff);
        int version = (bits >>> 19) & 0x3;
        int layer = (bits >>> 17) & 0x3;
        int bitrate = (bits >>> 12) & 0xf;
        int sampleRate = (bits >>> 10) & 0x3;
        return (bits >>> 21) == 0x7ff
                && version != 1 && layer == 1
                && bitrate > 0 && bitrate < 15
                && sampleRate != 3;
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
