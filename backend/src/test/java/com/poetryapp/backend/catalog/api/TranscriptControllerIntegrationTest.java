package com.poetryapp.backend.catalog.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;
import com.poetryapp.backend.catalog.domain.MediaItem;
import com.poetryapp.backend.catalog.domain.MediaSourceType;
import com.poetryapp.backend.catalog.domain.MediaType;
import com.poetryapp.backend.catalog.domain.PublicationStatus;
import com.poetryapp.backend.catalog.domain.Transcript;
import com.poetryapp.backend.catalog.domain.TranscriptStatus;
import com.poetryapp.backend.catalog.repository.MediaItemRepository;
import com.poetryapp.backend.catalog.repository.TranscriptRepository;
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
class TranscriptControllerIntegrationTest {
    @Autowired MockMvc mvc;
    @Autowired MediaItemRepository media;
    @Autowired TranscriptRepository transcripts;

    @Test
    void returnsOrderedSegmentsOffsetAndVerificationState() throws Exception {
        MediaItem recording = media.saveAndFlush(recording());
        recording.publish();
        media.saveAndFlush(recording);

        Transcript transcript = new Transcript(recording, "pl", "Pierwszy wers\nDrugi wers");
        transcript.setStartOffsetMs(8000);
        transcript.addSegment("Pierwszy wers", null, null);
        transcript.addSegment("Drugi wers", 11000L, 14000L);
        transcripts.saveAndFlush(transcript);

        mvc.perform(get("/api/v1/media/{id}/transcript", recording.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mediaId").value(recording.getId().toString()))
                .andExpect(jsonPath("$.status").value("DRAFT"))
                .andExpect(jsonPath("$.startOffsetMs").value(8000))
                .andExpect(jsonPath("$.segments.length()").value(2))
                .andExpect(jsonPath("$.segments[0].sequenceNumber").value(0))
                .andExpect(jsonPath("$.segments[0].startMs").isEmpty())
                .andExpect(jsonPath("$.segments[1].startMs").value(11000))
                .andExpect(jsonPath("$.segments[1].text").value("Drugi wers"));
    }

    @Test
    void hidesDraftMediaAndAbsentTranscripts() throws Exception {
        MediaItem draft = media.saveAndFlush(recording());
        mvc.perform(get("/api/v1/media/{id}/transcript", draft.getId()))
                .andExpect(status().isNotFound());

        MediaItem published = media.saveAndFlush(recording());
        published.publish();
        media.saveAndFlush(published);
        mvc.perform(get("/api/v1/media/{id}/transcript", published.getId()))
                .andExpect(status().isNotFound());

        mvc.perform(get("/api/v1/media/{id}/transcript", UUID.randomUUID()))
                .andExpect(status().isNotFound());
    }

    private static MediaItem recording() {
        return new MediaItem("Próba", MediaType.AUDIO, MediaSourceType.EXTERNAL_AUDIO,
                "https://archive.org/download/example/example.mp3", null, null,
                "audio/mpeg", null, null, null, PublicationStatus.PROCESSING,
                TranscriptStatus.DRAFT);
    }
}
