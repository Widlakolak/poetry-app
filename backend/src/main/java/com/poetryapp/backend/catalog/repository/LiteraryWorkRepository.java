package com.poetryapp.backend.catalog.repository;

import java.util.Optional;
import java.util.UUID;

import com.poetryapp.backend.catalog.domain.LiteraryWork;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LiteraryWorkRepository extends JpaRepository<LiteraryWork, UUID> {

    Page<LiteraryWork> findAllByPublishedTrue(Pageable pageable);

    Optional<LiteraryWork> findBySlugAndPublishedTrue(String slug);
}
