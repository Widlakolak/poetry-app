package com.poetryapp.backend.catalog.api;

import java.util.UUID;

import com.poetryapp.backend.catalog.service.CatalogService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/media")
public class MediaController {

    private final CatalogService catalogService;

    public MediaController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping
    public PageResponse<MediaItemResponse> getPublishedMedia(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return catalogService.getPublishedMedia(page, size);
    }

    @GetMapping("/{id}")
    public MediaItemResponse getPublishedMedia(@PathVariable UUID id) {
        return catalogService.getPublishedMedia(id);
    }
}
