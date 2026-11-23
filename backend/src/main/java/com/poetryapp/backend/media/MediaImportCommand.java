package com.poetryapp.backend.media;

import java.util.Locale;

import com.poetryapp.backend.catalog.domain.MediaItem;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "app.import.filename")
public class MediaImportCommand implements ApplicationRunner {

    private final MediaImportService mediaImportService;
    private final String fileName;
    private final String title;

    public MediaImportCommand(
            MediaImportService mediaImportService,
            @Value("${app.import.filename}") String fileName,
            @Value("${app.import.title:}") String title) {
        this.mediaImportService = mediaImportService;
        this.fileName = fileName;
        this.title = title;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        MediaItem mediaItem;
        if (fileName != null && fileName.toLowerCase(Locale.ROOT).endsWith(".mp3")) {
            mediaItem = mediaImportService.importMp3(fileName, title);
        } else if (fileName != null && fileName.toLowerCase(Locale.ROOT).endsWith(".mp4")) {
            mediaItem = mediaImportService.importMp4(fileName, title);
        } else {
            throw new IllegalArgumentException("Supported import formats: .mp3 and .mp4");
        }
        System.out.println("Media import complete: id=" + mediaItem.getId());
    }
}
