package com.poetryapp.backend.catalog.domain;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

@Entity
@Table(name = "transcript")
public class Transcript {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "media_item_id", nullable = false, unique = true)
    private MediaItem mediaItem;

    @Column(name = "language_code", length = 12)
    private String languageCode;

    @Column(name = "full_text", columnDefinition = "text")
    private String fullText;

    @Column(name = "start_offset_ms", nullable = false)
    private long startOffsetMs;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @OneToMany(mappedBy = "transcript", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TranscriptSegment> segments = new ArrayList<>();

    protected Transcript() {
    }

    public Transcript(MediaItem mediaItem, String languageCode, String fullText) {
        this.mediaItem = mediaItem;
        this.languageCode = languageCode;
        this.fullText = fullText;
    }

    public MediaItem getMediaItem() { return mediaItem; }
    public String getLanguageCode() { return languageCode; }
    public String getFullText() { return fullText; }
    public long getStartOffsetMs() { return startOffsetMs; }
    public List<TranscriptSegment> getSegments() { return segments; }

    public void setStartOffsetMs(long startOffsetMs) {
        if (startOffsetMs < 0) throw new IllegalArgumentException("Negative transcript offset");
        this.startOffsetMs = startOffsetMs;
    }

    public void addSegment(String text, Long startMs, Long endMs) {
        segments.add(new TranscriptSegment(this, segments.size(), text, startMs, endMs));
    }

    @PrePersist
    void prePersist() {
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    void preUpdate() {
        updatedAt = Instant.now();
    }
}
