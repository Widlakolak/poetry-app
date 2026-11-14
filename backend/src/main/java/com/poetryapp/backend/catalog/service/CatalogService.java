package com.poetryapp.backend.catalog.service;

import java.util.UUID;

import com.poetryapp.backend.catalog.api.CreatorResponse;
import com.poetryapp.backend.catalog.api.MediaItemResponse;
import com.poetryapp.backend.catalog.api.PageResponse;
import com.poetryapp.backend.catalog.domain.CreatorRole;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.repository.CreatorRepository;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import com.poetryapp.backend.common.ResourceNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class CatalogService {

    private static final int MAX_PAGE_SIZE = 100;

    private final MediaItemRepository mediaItemRepository;
    private final CreatorRepository creatorRepository;

    public CatalogService(
            MediaItemRepository mediaItemRepository,
            CreatorRepository creatorRepository) {
        this.mediaItemRepository = mediaItemRepository;
        this.creatorRepository = creatorRepository;
    }

    public PageResponse<MediaItemResponse> getPublishedMedia(int page, int size) {
        PageRequest pageRequest = pageRequest(page, size, Sort.by(
                Sort.Order.desc("publishedAt"),
                Sort.Order.asc("title")));

        Page<MediaItemResponse> response = mediaItemRepository
                .findAllByPublicationStatus(PublicationStatus.PUBLISHED, pageRequest)
                .map(MediaItemResponse::from);

        return PageResponse.from(response);
    }

    public MediaItemResponse getPublishedMedia(UUID id) {
        MediaItem mediaItem = mediaItemRepository
                .findByIdAndPublicationStatus(id, PublicationStatus.PUBLISHED)
                .orElseThrow(() -> new ResourceNotFoundException("Media item not found"));

        return MediaItemResponse.from(mediaItem);
    }

    public PageResponse<CreatorResponse> getCreators(CreatorRole role, int page, int size) {
        PageRequest pageRequest = pageRequest(page, size, Sort.by("displayName"));

        Page<CreatorResponse> response = (role == null
                ? creatorRepository.findAll(pageRequest)
                : creatorRepository.findAllByRole(role, pageRequest))
                .map(CreatorResponse::from);

        return PageResponse.from(response);
    }

    private PageRequest pageRequest(int page, int size, Sort sort) {
        if (page < 0) {
            throw new IllegalArgumentException("Page must be greater than or equal to zero");
        }
        if (size < 1 || size > MAX_PAGE_SIZE) {
            throw new IllegalArgumentException("Page size must be between 1 and " + MAX_PAGE_SIZE);
        }
        return PageRequest.of(page, size, sort);
    }
}
