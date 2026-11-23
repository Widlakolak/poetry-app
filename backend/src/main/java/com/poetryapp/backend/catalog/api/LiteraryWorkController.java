package com.poetryapp.backend.catalog.api;

import com.poetryapp.backend.catalog.service.LiteraryWorkService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/works")
public class LiteraryWorkController {

    private final LiteraryWorkService literaryWorkService;

    public LiteraryWorkController(LiteraryWorkService literaryWorkService) {
        this.literaryWorkService = literaryWorkService;
    }

    @GetMapping
    public PageResponse<LiteraryWorkResponse> list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return literaryWorkService.publishedWorks(page, size);
    }

    @GetMapping("/{slug}")
    public LiteraryWorkResponse detail(@PathVariable String slug) {
        return literaryWorkService.publishedWork(slug);
    }
}
