package com.poetryapp.backend.catalog.repository;

import java.util.List;
import java.util.UUID;
import com.poetryapp.backend.catalog.domain.Transcript;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TranscriptRepository extends JpaRepository<Transcript, UUID> {
    @EntityGraph(attributePaths = "segments")
    List<Transcript> findByMediaItem_IdAndPublicVisibleTrueOrderByLanguageCodeAsc(UUID mediaItemId);
}
