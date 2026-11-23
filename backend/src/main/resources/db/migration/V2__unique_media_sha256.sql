-- NULL values are allowed: YouTube items do not have a local file checksum.
-- A unique checksum makes local-file import safe to retry.
CREATE UNIQUE INDEX uk_media_item_sha256 ON media_item (sha256);
