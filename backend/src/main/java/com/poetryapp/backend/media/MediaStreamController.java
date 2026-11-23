package com.poetryapp.backend.media;

import java.util.UUID;

import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/media")
public class MediaStreamController {

    private static final MediaType MP4 = MediaType.parseMediaType("video/mp4");

    private final MediaStreamService mediaStreamService;

    public MediaStreamController(MediaStreamService mediaStreamService) {
        this.mediaStreamService = mediaStreamService;
    }

    @GetMapping("/{id}/stream")
    public ResponseEntity<Resource> stream(@PathVariable UUID id) {
        Resource resource = mediaStreamService.getPublishedMp4(id);

        // Spring MVC converts valid Range requests to 206 / Content-Range automatically.
        // Keep this response at 200 and return a file-backed Resource.
        return ResponseEntity.ok()
                .contentType(MP4)
                .header(HttpHeaders.ACCEPT_RANGES, "bytes")
                .header("X-Content-Type-Options", "nosniff")
                .cacheControl(CacheControl.noStore())
                .body(resource);
    }
}
