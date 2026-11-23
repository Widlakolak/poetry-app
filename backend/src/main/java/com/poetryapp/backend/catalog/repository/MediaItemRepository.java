package com.poetryapp.backend.catalog.repository;

import java.util.Optional;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.CreatorRole;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface MediaItemRepository extends JpaRepository<MediaItem, UUID> {

    Page<MediaItem> findAllByPublicationStatus(PublicationStatus status, Pageable pageable);

    Optional<MediaItem> findByIdAndPublicationStatus(UUID id, PublicationStatus status);

    @Query(
            value = """
                    select distinct item
                    from MediaItem item
                    join item.credits credit
                    where credit.creator.id = :creatorId
                      and credit.creditRole = :role
                      and item.publicationStatus = :status
                    """,
            countQuery = """
                    select count(distinct item.id)
                    from MediaItem item
                    join item.credits credit
                    where credit.creator.id = :creatorId
                      and credit.creditRole = :role
                      and item.publicationStatus = :status
                    """)
    Page<MediaItem> findPublishedMediaCreditedToCreator(
            @Param("creatorId") UUID creatorId,
            @Param("role") CreatorRole role,
            @Param("status") PublicationStatus status,
            Pageable pageable);

    Optional<MediaItem> findBySha256(String sha256);
}
