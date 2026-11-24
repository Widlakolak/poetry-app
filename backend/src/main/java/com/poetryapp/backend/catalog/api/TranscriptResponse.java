package com.poetryapp.backend.catalog.api;

import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import com.poetryapp.backend.catalog.domain.Transcript;
import com.poetryapp.backend.catalog.domain.TranscriptSegment;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;

public record TranscriptResponse(
        UUID mediaId,
        String languageCode,
        String fullText,
        TranscriptStatus status,
        long startOffsetMs,
        List<Segment> segments) {

    public record Segment(int sequenceNumber, String text, Long startMs, Long endMs) {
        static Segment from(TranscriptSegment segment) {
            return new Segment(
                    segment.getSequenceNumber(),
                    segment.getText(),
                    segment.getStartMs(),
                    segment.getEndMs());
        }
    }

    public static TranscriptResponse from(Transcript transcript) {
        return new TranscriptResponse(
                transcript.getMediaItem().getId(),
                transcript.getLanguageCode(),
                transcript.getFullText(),
                transcript.getMediaItem().getTranscriptStatus(),
                transcript.getStartOffsetMs(),
                transcript.getSegments().stream()
                        .sorted(Comparator.comparingInt(TranscriptSegment::getSequenceNumber))
                        .map(Segment::from)
                        .toList());
    }
}
