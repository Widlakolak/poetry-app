package com.poetryapp.backend.catalog.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import com.poetryapp.backend.catalog.domain.Creator;
import com.poetryapp.backend.catalog.domain.CreatorRole;
import com.poetryapp.backend.catalog.domain.MediaCredit;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;
import com.poetryapp.backend.catalog.repository.CreatorRepository;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class CreatorMediaControllerIntegrationTest {

    @Autowired
    private MockMvc mvc;

    @Autowired
    private CreatorRepository creators;

    @Autowired
    private MediaItemRepository mediaItems;

    @Autowired
    private EntityManager entityManager;

    @Test
    void shouldReturnOnlyPublishedArtistRecordingsWithoutExposingOtherCredits() throws Exception {
        Creator performer = creators.saveAndFlush(new Creator("Wykonawca testowy", null));
        Creator poet = creators.saveAndFlush(new Creator("Poeta testowy", null));

        MediaItem published = createVideo("Opublikowane nagranie", true);
        MediaItem processing = createVideo("Nieopublikowane nagranie", false);
        MediaItem poetOnly = createVideo("Bez kredytu artysty", true);

        entityManager.persist(new MediaCredit(published, performer, CreatorRole.ARTIST));
        entityManager.persist(new MediaCredit(processing, performer, CreatorRole.ARTIST));
        entityManager.persist(new MediaCredit(poetOnly, performer, CreatorRole.POET));
        entityManager.persist(new MediaCredit(published, poet, CreatorRole.POET));
        entityManager.flush();

        mvc.perform(get("/api/v1/creators/{id}/media", performer.getId())
                        .param("role", "ARTIST"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(1))
                .andExpect(jsonPath("$.content.length()").value(1))
                .andExpect(jsonPath("$.content[0].id").value(published.getId().toString()))
                .andExpect(jsonPath("$.content[0].title").value("Opublikowane nagranie"))
                .andExpect(jsonPath("$.content[0].sourceType").value("YOUTUBE"));

        mvc.perform(get("/api/v1/creators").param("role", "ARTIST"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].displayName").value("Wykonawca testowy"));
    }

    @Test
    void shouldReturnEmptyPageForCreatorWithoutMatchingRole() throws Exception {
        Creator creator = creators.saveAndFlush(new Creator("Bez nagrań", null));

        mvc.perform(get("/api/v1/creators/{id}/media", creator.getId())
                        .param("role", "ARTIST"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    void shouldRejectMissingCreatorAndInvalidParameters() throws Exception {
        mvc.perform(get("/api/v1/creators/{id}/media", UUID.randomUUID())
                        .param("role", "ARTIST"))
                .andExpect(status().isNotFound());

        Creator creator = creators.saveAndFlush(new Creator("Test paginacji", null));

        mvc.perform(get("/api/v1/creators/{id}/media", creator.getId())
                        .param("role", "ARTIST")
                        .param("size", "101"))
                .andExpect(status().isBadRequest());

        mvc.perform(get("/api/v1/creators/{id}/media", creator.getId())
                        .param("role", "ARTIST")
                        .param("page", "-1"))
                .andExpect(status().isBadRequest());

        mvc.perform(get("/api/v1/creators/{id}/media", creator.getId()))
                .andExpect(status().isBadRequest());
    }

    private MediaItem createVideo(String title, boolean publish) {
        MediaItem media = new MediaItem(
                title,
                MediaType.VIDEO,
                MediaSourceType.YOUTUBE,
                "https://www.youtube.com/watch?v=PLNsPhKlucY",
                null,
                null,
                null,
                null,
                null,
                null,
                PublicationStatus.PROCESSING,
                TranscriptStatus.NOT_AVAILABLE);
        if (publish) {
            media.publish();
        }
        return mediaItems.saveAndFlush(media);
    }
}
