package com.poetryapp.backend.catalog.api;

import java.util.UUID;

import com.poetryapp.backend.catalog.domain.Creator;

public record CreatorResponse(UUID id, String displayName, String biography) {

    public static CreatorResponse from(Creator creator) {
        return new CreatorResponse(
                creator.getId(),
                creator.getDisplayName(),
                creator.getBiography());
    }
}
