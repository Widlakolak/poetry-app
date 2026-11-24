-- Allow HTTPS archive recordings to be catalogued without copying them to QNAP.
-- Existing local and YouTube records remain unchanged.
ALTER TABLE media_item DROP CONSTRAINT chk_media_source_type;
ALTER TABLE media_item ADD CONSTRAINT chk_media_source_type
    CHECK (source_type IN ('LOCAL_FILE', 'YOUTUBE', 'EXTERNAL_AUDIO'));

ALTER TABLE media_item DROP CONSTRAINT chk_media_source_url;
ALTER TABLE media_item ADD CONSTRAINT chk_media_source_url CHECK (
    (source_type = 'YOUTUBE' AND source_url IS NOT NULL)
    OR (source_type = 'EXTERNAL_AUDIO' AND media_type = 'AUDIO'
        AND (source_url LIKE 'https://%.archive.org/%' OR source_url LIKE 'https://archive.org/%'))
    OR (source_type = 'LOCAL_FILE' AND source_url IS NULL)
);

ALTER TABLE media_item DROP CONSTRAINT chk_published_media_has_source;
ALTER TABLE media_item ADD CONSTRAINT chk_published_media_has_source CHECK (
    publication_status <> 'PUBLISHED'
    OR (source_type IN ('YOUTUBE', 'EXTERNAL_AUDIO') AND source_url IS NOT NULL)
    OR (source_type = 'LOCAL_FILE' AND storage_key IS NOT NULL)
);

-- When source material only has a start offset and ordered lines,
-- keep that offset instead of inventing line-level timing.
ALTER TABLE transcript ADD COLUMN start_offset_ms BIGINT NOT NULL DEFAULT 0;
ALTER TABLE transcript ADD CONSTRAINT chk_transcript_start_offset
    CHECK (start_offset_ms >= 0);
