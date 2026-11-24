package com.poetryapp.backend.catalog.service;

import java.util.UUID;
import java.util.List;
import java.util.Comparator;
import com.poetryapp.backend.catalog.api.TranscriptResponse;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import com.poetryapp.backend.catalog.repository.TranscriptRepository;
import com.poetryapp.backend.common.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class TranscriptService {

    private final MediaItemRepository media;
    private final TranscriptRepository transcripts;

    public TranscriptService(MediaItemRepository media, TranscriptRepository transcripts) {
        this.media = media;
        this.transcripts = transcripts;
    }

    public TranscriptResponse forPublishedMedia(UUID mediaId) {
        return allForPublishedMedia(mediaId).stream()
                .min(Comparator.comparingInt(track -> "pl".equals(track.languageCode()) ? 0 : "en".equals(track.languageCode()) ? 1 : 2))
                .orElseThrow(() -> new ResourceNotFoundException("Transcript not found"));
    }

    public List<TranscriptResponse> allForPublishedMedia(UUID mediaId) {
        media.findByIdAndPublicationStatus(mediaId, PublicationStatus.PUBLISHED)
                .orElseThrow(() -> new ResourceNotFoundException("Transcript not found"));
        return transcripts.findByMediaItem_IdAndPublicVisibleTrueOrderByLanguageCodeAsc(mediaId)
                .stream().map(TranscriptResponse::from).toList();
    }
}
