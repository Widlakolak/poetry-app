package com.poetryapp.backend.catalog.repository;

import java.util.Optional;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MediaItemRepository extends JpaRepository<MediaItem, UUID> {

    Page<MediaItem> findAllByPublicationStatus(PublicationStatus status, Pageable pageable);

    Optional<MediaItem> findByIdAndPublicationStatus(UUID id, PublicationStatus status);
}
