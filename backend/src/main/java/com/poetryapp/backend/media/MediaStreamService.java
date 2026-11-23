package com.poetryapp.backend.media;

import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.util.UUID;
import java.util.regex.Pattern;

import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import com.poetryapp.backend.common.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

@Service
public class MediaStreamService {

    // The Stage 5 importer creates UUID-based storage keys, not user-provided paths.
    private static final Pattern MP4_STORAGE_KEY =
            Pattern.compile("[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\\.mp4");
    private static final Pattern MP3_STORAGE_KEY =
            Pattern.compile("[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\\.mp3");

    public record StreamedMedia(Resource resource, String contentType) {}


    private final MediaItemRepository mediaItemRepository;
    private final Path mediaDirectory;

    public MediaStreamService(
            MediaItemRepository mediaItemRepository,
            @Value("${app.media.storage-dir:/data/media}") String mediaDirectory) {
        this.mediaItemRepository = mediaItemRepository;
        this.mediaDirectory = Path.of(mediaDirectory).toAbsolutePath().normalize();
    }

    public StreamedMedia getPublishedMedia(UUID id) {
        MediaItem item = mediaItemRepository
                .findByIdAndPublicationStatus(id, PublicationStatus.PUBLISHED)
                .orElseThrow(MediaStreamService::notFound);

        if (item.getSourceType() != MediaSourceType.LOCAL_FILE) {
            throw notFound();
        }

        String contentType;
        Pattern allowedKey;
        if (item.getMediaType() == MediaType.VIDEO) {
            contentType = "video/mp4";
            allowedKey = MP4_STORAGE_KEY;
        } else if (item.getMediaType() == MediaType.AUDIO) {
            contentType = "audio/mpeg";
            allowedKey = MP3_STORAGE_KEY;
        } else {
            throw notFound();
        }

        String storageKey = item.getStorageKey();
        if (storageKey == null || !allowedKey.matcher(storageKey).matches()) {
            throw notFound();
        }

        Path file = mediaDirectory.resolve(storageKey).normalize();
        if (!file.getParent().equals(mediaDirectory)
                || !Files.isRegularFile(file, LinkOption.NOFOLLOW_LINKS)
                || !Files.isReadable(file)) {
            throw notFound();
        }

        // Unlike InputStreamResource, FileSystemResource supports byte ranges in Spring MVC.
        return new StreamedMedia(new FileSystemResource(file), contentType);
    }

    private static ResourceNotFoundException notFound() {
        return new ResourceNotFoundException("Media not found");
    }
}
