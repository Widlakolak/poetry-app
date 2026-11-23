-- Separate literary works from their recordings: a poem can have many
-- performances and a compilation can contain more than one work.
-- This migration is structural only: it does not attribute existing media.
CREATE TABLE literary_work (
    id UUID PRIMARY KEY,
    slug VARCHAR(160) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    author_id UUID NOT NULL,
    summary TEXT,
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_literary_work_author
        FOREIGN KEY (author_id) REFERENCES creator(id) ON DELETE RESTRICT,
    CONSTRAINT chk_literary_work_slug CHECK (length(trim(slug)) > 0),
    CONSTRAINT chk_literary_work_title CHECK (length(trim(title)) > 0)
);

CREATE TABLE work_recording (
    work_id UUID NOT NULL,
    media_item_id UUID NOT NULL,
    PRIMARY KEY (work_id, media_item_id),
    CONSTRAINT fk_work_recording_work
        FOREIGN KEY (work_id) REFERENCES literary_work(id) ON DELETE CASCADE,
    CONSTRAINT fk_work_recording_media
        FOREIGN KEY (media_item_id) REFERENCES media_item(id) ON DELETE CASCADE
);

CREATE INDEX idx_literary_work_author
    ON literary_work (author_id);

CREATE INDEX idx_work_recording_media
    ON work_recording (media_item_id);
