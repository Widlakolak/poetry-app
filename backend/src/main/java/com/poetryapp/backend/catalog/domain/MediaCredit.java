package com.poetryapp.backend.catalog.domain;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
        name = "media_credit",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_media_credit_item_creator_role",
                columnNames = {"media_item_id", "creator_id", "credit_role"}))
public class MediaCredit {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "media_item_id", nullable = false)
    private MediaItem mediaItem;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "creator_id", nullable = false)
    private Creator creator;

    @Enumerated(EnumType.STRING)
    @Column(name = "credit_role", nullable = false, length = 16)
    private CreatorRole creditRole;

    protected MediaCredit() {
    }

    public MediaCredit(MediaItem mediaItem, Creator creator, CreatorRole creditRole) {
        this.mediaItem = mediaItem;
        this.creator = creator;
        this.creditRole = creditRole;
    }
}
