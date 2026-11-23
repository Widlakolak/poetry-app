package com.poetryapp.backend.media;

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
        MediaItem mediaItem = mediaImportService.importMp4(fileName, title);
        System.out.println("Media import complete: id=" + mediaItem.getId());
    }
}
