package com.poetryapp.backend.catalog.api;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;

class PoetryStreamSeedMigrationTest {
    private static final String DB_URL = "jdbc:h2:mem:poetryapp-seed-check;DB_CLOSE_DELAY=-1";

    @Test
    void importsSixWorksFiveArchiveRecordingsAndOrderedDraftLines() throws Exception {
        Flyway.configure()
                .dataSource(DB_URL, "sa", "")
                .locations("classpath:db/migration", "classpath:db/production")
                .load()
                .migrate();

        try (Connection connection = DriverManager.getConnection(DB_URL, "sa", "");
             Statement stmt = connection.createStatement()) {
            assertEquals(6, count(stmt, "SELECT count(*) FROM literary_work WHERE is_published = TRUE"));
            assertEquals(5, count(stmt, "SELECT count(*) FROM media_item WHERE source_type = 'EXTERNAL_AUDIO' AND publication_status = 'PUBLISHED'"));
            assertEquals(5, count(stmt, "SELECT count(*) FROM transcript WHERE language_code = 'pl'"));
            assertEquals(254, count(stmt, "SELECT count(*) FROM transcript_segment WHERE start_ms IS NULL AND end_ms IS NULL"));
            assertEquals(5, count(stmt, "SELECT count(*) FROM work_recording"));
            assertEquals(10, count(stmt, "SELECT count(*) FROM media_credit"));
            assertEquals(15000, count(stmt, "SELECT start_offset_ms FROM transcript t JOIN media_item m ON m.id = t.media_item_id WHERE m.title = 'Okulary'"));
            assertEquals(1, count(stmt, "SELECT count(*) FROM literary_work WHERE slug = 'the-love-song-of-j-alfred-prufrock'"));
            assertEquals(0, count(stmt, "SELECT count(*) FROM work_recording wr JOIN literary_work w ON w.id = wr.work_id WHERE w.slug = 'the-love-song-of-j-alfred-prufrock'"));
        }
    }

    private static long count(Statement statement, String sql) throws Exception {
        try (ResultSet result = statement.executeQuery(sql)) {
            result.next();
            return result.getLong(1);
        }
    }
}
