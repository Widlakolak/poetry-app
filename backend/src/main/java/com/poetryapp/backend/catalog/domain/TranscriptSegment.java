package com.poetryapp.backend.catalog.domain;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
        name = "transcript_segment",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_transcript_segment_sequence",
                columnNames = {"transcript_id", "sequence_number"}))
public class TranscriptSegment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "transcript_id", nullable = false)
    private Transcript transcript;

    @Column(name = "sequence_number", nullable = false)
    private int sequenceNumber;

    @Column(name = "segment_text", nullable = false, columnDefinition = "text")
    private String text;

    @Column(name = "start_ms")
    private Long startMs;

    @Column(name = "end_ms")
    private Long endMs;

    protected TranscriptSegment() {
    }

    public int getSequenceNumber() { return sequenceNumber; }
    public String getText() { return text; }
    public Long getStartMs() { return startMs; }
    public Long getEndMs() { return endMs; }

    public TranscriptSegment(
            Transcript transcript,
            int sequenceNumber,
            String text,
            Long startMs,
            Long endMs) {
        this.transcript = transcript;
        this.sequenceNumber = sequenceNumber;
        this.text = text;
        this.startMs = startMs;
        this.endMs = endMs;
    }
}
