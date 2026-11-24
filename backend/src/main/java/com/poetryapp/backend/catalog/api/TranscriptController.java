package com.poetryapp.backend.catalog.api;

import java.util.UUID;
import java.util.List;
import com.poetryapp.backend.catalog.service.TranscriptService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/media")
public class TranscriptController {

    private final TranscriptService transcripts;

    public TranscriptController(TranscriptService transcripts) {
        this.transcripts = transcripts;
    }

    @GetMapping("/{id}/transcripts")
    public List<TranscriptResponse> tracks(@PathVariable UUID id) {
        return transcripts.allForPublishedMedia(id);
    }

    @GetMapping("/{id}/transcript")
    public TranscriptResponse transcript(@PathVariable UUID id) {
        return transcripts.forPublishedMedia(id);
    }
}
