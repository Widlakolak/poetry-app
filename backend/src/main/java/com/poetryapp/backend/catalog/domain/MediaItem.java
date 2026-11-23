package com.poetryapp.backend.catalog.domain;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "media_item")
public class MediaItem {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 200)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "media_type", nullable = false, length = 16)
    private MediaType mediaType;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_type", nullable = false, length = 20)
    private MediaSourceType sourceType;

    @Column(name = "source_url", length = 2048)
    private String sourceUrl;

    @Column(name = "original_filename", length = 255)
    private String originalFilename;

    @Column(name = "storage_key", length = 512)
    private String storageKey;

    @Column(name = "mime_type", length = 120)
    private String mimeType;

    @Column(name = "file_size_bytes")
    private Long fileSizeBytes;

    @Column(name = "sha256", length = 64)
    private String sha256;

    @Column(name = "duration_ms")
    private Long durationMs;

    @Enumerated(EnumType.STRING)
    @Column(name = "publication_status", nullable = false, length = 20)
    private PublicationStatus publicationStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "transcript_status", nullable = false, length = 20)
    private TranscriptStatus transcriptStatus;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "published_at")
    private Instant publishedAt;

    @OneToMany(mappedBy = "mediaItem")
    private List<MediaCredit> credits = new ArrayList<>();

    protected MediaItem() {
    }

    public MediaItem(
            String title,
            MediaType mediaType,
            MediaSourceType sourceType,
            String sourceUrl,
            String originalFilename,
            String storageKey,
            String mimeType,
            Long fileSizeBytes,
            String sha256,
            Long durationMs,
            PublicationStatus publicationStatus,
            TranscriptStatus transcriptStatus) {
        this.title = title;
        this.mediaType = mediaType;
        this.sourceType = sourceType;
        this.sourceUrl = sourceUrl;
        this.originalFilename = originalFilename;
        this.storageKey = storageKey;
        this.mimeType = mimeType;
        this.fileSizeBytes = fileSizeBytes;
        this.sha256 = sha256;
        this.durationMs = durationMs;
        this.publicationStatus = publicationStatus;
        this.transcriptStatus = transcriptStatus;
    }

    @PrePersist
    void prePersist() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
    }

    public UUID getId() { return id; }
    public String getTitle() { return title; }
    public MediaType getMediaType() { return mediaType; }
    public MediaSourceType getSourceType() { return sourceType; }
    public String getSourceUrl() { return sourceUrl; }
    public Long getDurationMs() { return durationMs; }
    public PublicationStatus getPublicationStatus() { return publicationStatus; }
    public TranscriptStatus getTranscriptStatus() { return transcriptStatus; }
    public Instant getPublishedAt() { return publishedAt; }

    public void publish() {
        this.publicationStatus = PublicationStatus.PUBLISHED;
        this.publishedAt = Instant.now();
    }
}
