CREATE TABLE creator (
    id UUID PRIMARY KEY,
    display_name VARCHAR(160) NOT NULL,
    biography TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_creator_display_name CHECK (length(trim(display_name)) > 0)
);

CREATE TABLE media_item (
    id UUID PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    media_type VARCHAR(16) NOT NULL,
    source_type VARCHAR(20) NOT NULL,
    source_url VARCHAR(2048),
    original_filename VARCHAR(255),
    storage_key VARCHAR(512),
    mime_type VARCHAR(120),
    file_size_bytes BIGINT,
    sha256 VARCHAR(64),
    duration_ms BIGINT,
    publication_status VARCHAR(20) NOT NULL,
    transcript_status VARCHAR(20) NOT NULL DEFAULT 'NOT_AVAILABLE',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT chk_media_title CHECK (length(trim(title)) > 0),
    CONSTRAINT chk_media_type CHECK (media_type IN ('AUDIO', 'VIDEO')),
    CONSTRAINT chk_media_source_type CHECK (source_type IN ('LOCAL_FILE', 'YOUTUBE')),
    CONSTRAINT chk_media_source_url CHECK (
        (source_type = 'YOUTUBE' AND source_url IS NOT NULL)
        OR (source_type = 'LOCAL_FILE' AND source_url IS NULL)
    ),
    CONSTRAINT chk_media_publication_status CHECK (
        publication_status IN ('PROCESSING', 'PUBLISHED', 'ERROR')
    ),
    CONSTRAINT chk_media_transcript_status CHECK (
        transcript_status IN ('NOT_AVAILABLE', 'DRAFT', 'VERIFIED')
    ),
    CONSTRAINT chk_media_file_size CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    CONSTRAINT chk_media_duration CHECK (duration_ms IS NULL OR duration_ms >= 0),
    CONSTRAINT chk_media_sha256 CHECK (sha256 IS NULL OR length(sha256) = 64),
    CONSTRAINT chk_published_media_has_source CHECK (
        publication_status <> 'PUBLISHED'
        OR (source_type = 'YOUTUBE' AND source_url IS NOT NULL)
        OR (source_type = 'LOCAL_FILE' AND storage_key IS NOT NULL)
    ),
    CONSTRAINT chk_published_media_timestamp CHECK (
        publication_status <> 'PUBLISHED' OR published_at IS NOT NULL
    )
);

CREATE TABLE media_credit (
    id UUID PRIMARY KEY,
    media_item_id UUID NOT NULL,
    creator_id UUID NOT NULL,
    credit_role VARCHAR(16) NOT NULL,
    CONSTRAINT fk_media_credit_item
        FOREIGN KEY (media_item_id) REFERENCES media_item(id) ON DELETE CASCADE,
    CONSTRAINT fk_media_credit_creator
        FOREIGN KEY (creator_id) REFERENCES creator(id) ON DELETE RESTRICT,
    CONSTRAINT chk_media_credit_role CHECK (credit_role IN ('POET', 'ARTIST')),
    CONSTRAINT uk_media_credit_item_creator_role UNIQUE (media_item_id, creator_id, credit_role)
);

CREATE TABLE transcript (
    id UUID PRIMARY KEY,
    media_item_id UUID NOT NULL UNIQUE,
    language_code VARCHAR(12),
    full_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transcript_media_item
        FOREIGN KEY (media_item_id) REFERENCES media_item(id) ON DELETE CASCADE
);

CREATE TABLE transcript_segment (
    id UUID PRIMARY KEY,
    transcript_id UUID NOT NULL,
    sequence_number INTEGER NOT NULL,
    segment_text TEXT NOT NULL,
    start_ms BIGINT,
    end_ms BIGINT,
    CONSTRAINT fk_transcript_segment_transcript
        FOREIGN KEY (transcript_id) REFERENCES transcript(id) ON DELETE CASCADE,
    CONSTRAINT uk_transcript_segment_sequence UNIQUE (transcript_id, sequence_number),
    CONSTRAINT chk_transcript_segment_sequence CHECK (sequence_number >= 0),
    CONSTRAINT chk_transcript_segment_start CHECK (start_ms IS NULL OR start_ms >= 0),
    CONSTRAINT chk_transcript_segment_end CHECK (end_ms IS NULL OR end_ms >= 0),
    CONSTRAINT chk_transcript_segment_order CHECK (
        start_ms IS NULL OR end_ms IS NULL OR end_ms >= start_ms
    )
);

CREATE INDEX idx_media_item_publication_created
    ON media_item (publication_status, published_at DESC);

CREATE INDEX idx_media_item_title
    ON media_item (title);

CREATE INDEX idx_media_credit_creator_role
    ON media_credit (creator_id, credit_role);

CREATE INDEX idx_media_credit_media_item
    ON media_credit (media_item_id);

CREATE INDEX idx_transcript_segment_order
    ON transcript_segment (transcript_id, sequence_number);
