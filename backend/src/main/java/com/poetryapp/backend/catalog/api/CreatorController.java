package com.poetryapp.backend.catalog.api;

import java.util.UUID;

import com.poetryapp.backend.catalog.domain.CreatorRole;
import com.poetryapp.backend.catalog.service.CatalogService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/creators")
public class CreatorController {

    private final CatalogService catalogService;

    public CreatorController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping
    public PageResponse<CreatorResponse> getCreators(
            @RequestParam(required = false) CreatorRole role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return catalogService.getCreators(role, page, size);
    }

    @GetMapping("/{id}/media")
    public PageResponse<MediaItemResponse> getCreatorMedia(
            @PathVariable UUID id,
            @RequestParam CreatorRole role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return catalogService.getPublishedCreatorMedia(id, role, page, size);
    }
}
