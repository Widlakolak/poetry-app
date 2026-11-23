package com.poetryapp.backend.catalog.api;

import java.util.Comparator;
import java.util.List;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.LiteraryWork;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.PublicationStatus;

public record LiteraryWorkResponse(
        UUID id,
        String slug,
        String title,
        String summary,
        UUID authorId,
        String authorName,
        List<MediaItemResponse> recordings) {

    public static LiteraryWorkResponse from(LiteraryWork work) {
        List<MediaItemResponse> publishedRecordings = work.getRecordings().stream()
                .filter(media -> media.getPublicationStatus() == PublicationStatus.PUBLISHED)
                .sorted(Comparator.comparing(MediaItem::getTitle).thenComparing(MediaItem::getId))
                .map(MediaItemResponse::from)
                .toList();

        return new LiteraryWorkResponse(
                work.getId(),
                work.getSlug(),
                work.getTitle(),
                work.getSummary(),
                work.getAuthor().getId(),
                work.getAuthor().getDisplayName(),
                publishedRecordings);
    }
}
