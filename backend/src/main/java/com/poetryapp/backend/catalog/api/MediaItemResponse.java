package com.poetryapp.backend.catalog.api;

import java.time.Instant;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;

public record MediaItemResponse(
        UUID id,
        String title,
        MediaType mediaType,
        MediaSourceType sourceType,
        String sourceUrl,
        Long durationMs,
        TranscriptStatus transcriptStatus,
        Instant publishedAt) {

    public static MediaItemResponse from(MediaItem mediaItem) {
        return new MediaItemResponse(
                mediaItem.getId(),
                mediaItem.getTitle(),
                mediaItem.getMediaType(),
                mediaItem.getSourceType(),
                mediaItem.getSourceUrl(),
                mediaItem.getDurationMs(),
                mediaItem.getTranscriptStatus(),
                mediaItem.getPublishedAt());
    }
}
