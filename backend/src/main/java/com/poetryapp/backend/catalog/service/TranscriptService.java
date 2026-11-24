package com.poetryapp.backend.catalog.service;

import java.util.UUID;
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
        // Never reveal draft or private media through transcript lookup.
        media.findByIdAndPublicationStatus(mediaId, PublicationStatus.PUBLISHED)
                .orElseThrow(() -> new ResourceNotFoundException("Transcript not found"));
        return transcripts.findByMediaItem_Id(mediaId)
                .map(TranscriptResponse::from)
                .orElseThrow(() -> new ResourceNotFoundException("Transcript not found"));
    }
}
