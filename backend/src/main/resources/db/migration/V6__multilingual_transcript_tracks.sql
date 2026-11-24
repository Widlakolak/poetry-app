-- Preserve legacy transcript IDs, text, timing and verification status.
-- Rebuild the two tables to remove the unnamed one-to-one unique constraint
-- consistently on PostgreSQL and the H2 integration-test database.
CREATE TABLE transcript_v6 (
    id UUID PRIMARY KEY,
    media_item_id UUID NOT NULL,
    language_code VARCHAR(12) NOT NULL,
    full_text TEXT,
    translator_name VARCHAR(200),
    verification_status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    public_visible BOOLEAN NOT NULL DEFAULT FALSE,
    start_offset_ms BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transcript_v6_media FOREIGN KEY (media_item_id) REFERENCES media_item(id) ON DELETE CASCADE,
    CONSTRAINT uk_transcript_media_language UNIQUE (media_item_id, language_code),
    CONSTRAINT chk_transcript_v6_status CHECK (verification_status IN ('NOT_AVAILABLE', 'DRAFT', 'VERIFIED')),
    CONSTRAINT chk_transcript_v6_offset CHECK (start_offset_ms >= 0),
    CONSTRAINT chk_transcript_v6_language CHECK (length(trim(language_code)) > 0)
);
INSERT INTO transcript_v6 (id, media_item_id, language_code, full_text, verification_status, public_visible, start_offset_ms, created_at, updated_at)
SELECT t.id, t.media_item_id, COALESCE(NULLIF(lower(trim(t.language_code)), ''), 'und'), t.full_text,
       m.transcript_status, TRUE, t.start_offset_ms, t.created_at, t.updated_at
FROM transcript t JOIN media_item m ON m.id = t.media_item_id;

CREATE TABLE transcript_segment_v6 (
    id UUID PRIMARY KEY,
    transcript_id UUID NOT NULL,
    sequence_number INTEGER NOT NULL,
    segment_text TEXT NOT NULL,
    start_ms BIGINT,
    end_ms BIGINT,
    CONSTRAINT fk_transcript_segment_v6 FOREIGN KEY (transcript_id) REFERENCES transcript_v6(id) ON DELETE CASCADE,
    CONSTRAINT uk_transcript_segment_v6_sequence UNIQUE (transcript_id, sequence_number),
    CONSTRAINT chk_transcript_segment_v6_sequence CHECK (sequence_number >= 0),
    CONSTRAINT chk_transcript_segment_v6_start CHECK (start_ms IS NULL OR start_ms >= 0),
    CONSTRAINT chk_transcript_segment_v6_end CHECK (end_ms IS NULL OR end_ms >= 0),
    CONSTRAINT chk_transcript_segment_v6_order CHECK (start_ms IS NULL OR end_ms IS NULL OR end_ms >= start_ms)
);
INSERT INTO transcript_segment_v6 (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
SELECT id, transcript_id, sequence_number, segment_text, start_ms, end_ms FROM transcript_segment;

DROP TABLE transcript_segment;
DROP TABLE transcript;
ALTER TABLE transcript_v6 RENAME TO transcript;
ALTER TABLE transcript_segment_v6 RENAME TO transcript_segment;
CREATE INDEX idx_transcript_segment_order ON transcript_segment (transcript_id, sequence_number);
