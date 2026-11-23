package com.poetryapp.backend.catalog.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import com.poetryapp.backend.catalog.domain.Creator;
import com.poetryapp.backend.catalog.domain.LiteraryWork;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;
import com.poetryapp.backend.catalog.repository.CreatorRepository;
import com.poetryapp.backend.catalog.repository.LiteraryWorkRepository;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
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
class LiteraryWorkControllerIntegrationTest {

    @Autowired
    private MockMvc mvc;

    @Autowired
    private CreatorRepository creators;

    @Autowired
    private LiteraryWorkRepository works;

    @Autowired
    private MediaItemRepository mediaItems;

    @Test
    void shouldReturnEmptyListBeforeAnyWorksArePublished() throws Exception {
        mvc.perform(get("/api/v1/works"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(0))
                .andExpect(jsonPath("$.content.length()").value(0));
    }

    @Test
    void shouldHideDraftWorkAndUnknownSlugs() throws Exception {
        Creator author = creators.saveAndFlush(new Creator("Poetka testowa", null));
        works.saveAndFlush(new LiteraryWork("roboczy-utwor", "Roboczy utwór", null, author));

        mvc.perform(get("/api/v1/works"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(0));

        mvc.perform(get("/api/v1/works/roboczy-utwor"))
                .andExpect(status().isNotFound());

        mvc.perform(get("/api/v1/works/nieznany"))
                .andExpect(status().isNotFound());
    }

    @Test
    void shouldReturnAuthorAndOnlyPublishedRecordingsForPublishedWork() throws Exception {
        Creator author = creators.saveAndFlush(new Creator("Autor testowy", "Biografia testowa"));

        MediaItem publicRecording = recording("Nagranie opublikowane");
        publicRecording.publish();
        mediaItems.saveAndFlush(publicRecording);

        MediaItem draftRecording = recording("Nagranie nieopublikowane");
        mediaItems.saveAndFlush(draftRecording);

        LiteraryWork work = new LiteraryWork("wiersz-testowy", "Wiersz testowy",
                "Zweryfikowany opis testowy", author);
        work.addRecording(publicRecording);
        work.addRecording(draftRecording);
        work.publish();
        works.saveAndFlush(work);

        mvc.perform(get("/api/v1/works/wiersz-testowy"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.slug").value("wiersz-testowy"))
                .andExpect(jsonPath("$.title").value("Wiersz testowy"))
                .andExpect(jsonPath("$.summary").value("Zweryfikowany opis testowy"))
                .andExpect(jsonPath("$.authorId").value(author.getId().toString()))
                .andExpect(jsonPath("$.authorName").value("Autor testowy"))
                .andExpect(jsonPath("$.recordings.length()").value(1))
                .andExpect(jsonPath("$.recordings[0].id").value(publicRecording.getId().toString()));

        mvc.perform(get("/api/v1/works").param("size", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(1))
                .andExpect(jsonPath("$.content[0].slug").value("wiersz-testowy"))
                .andExpect(jsonPath("$.content[0].recordings.length()").value(1));
    }

    @Test
    void shouldRejectInvalidPagination() throws Exception {
        mvc.perform(get("/api/v1/works").param("size", "101"))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/works").param("size", "0"))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/v1/works").param("page", "-1"))
                .andExpect(status().isBadRequest());
    }

    private MediaItem recording(String title) {
        return new MediaItem(
                title,
                MediaType.AUDIO,
                MediaSourceType.LOCAL_FILE,
                null,
                "test.mp3",
                UUID.randomUUID() + ".mp3",
                "audio/mpeg",
                1024L,
                null,
                null,
                PublicationStatus.PROCESSING,
                TranscriptStatus.NOT_AVAILABLE);
    }
}
