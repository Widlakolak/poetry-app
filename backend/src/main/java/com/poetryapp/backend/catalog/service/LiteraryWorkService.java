package com.poetryapp.backend.catalog.service;

import com.poetryapp.backend.catalog.api.LiteraryWorkResponse;
import com.poetryapp.backend.catalog.api.PageResponse;
import com.poetryapp.backend.catalog.repository.LiteraryWorkRepository;
import com.poetryapp.backend.common.ResourceNotFoundException;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class LiteraryWorkService {

    private static final int MAX_PAGE_SIZE = 100;

    private final LiteraryWorkRepository repository;

    public LiteraryWorkService(LiteraryWorkRepository repository) {
        this.repository = repository;
    }

    public PageResponse<LiteraryWorkResponse> publishedWorks(int page, int size) {
        if (page < 0) {
            throw new IllegalArgumentException("Page must be greater than or equal to zero");
        }
        if (size < 1 || size > MAX_PAGE_SIZE) {
            throw new IllegalArgumentException("Page size must be between 1 and " + MAX_PAGE_SIZE);
        }

        return PageResponse.from(repository.findAllByPublishedTrue(
                PageRequest.of(page, size, Sort.by("title", "id"))).map(LiteraryWorkResponse::from));
    }

    public LiteraryWorkResponse publishedWork(String slug) {
        return repository.findBySlugAndPublishedTrue(slug)
                .map(LiteraryWorkResponse::from)
                .orElseThrow(() -> new ResourceNotFoundException("Literary work not found"));
    }
}
