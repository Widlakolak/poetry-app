import { youtubeVideoId } from "./youtubeSource";
import type { MediaRecord } from "./catalogApi";

export type PlaybackSource =
  | { kind: "audio"; src: string }
  | { kind: "video"; src: string }
  | { kind: "youtube"; videoId: string };

// Only allow the exact archive host or its subdomains, HTTPS and MP3 paths.
// Catalog URLs are untrusted input, including when sourced from migrations.
export function trustedArchiveAudioUrl(value: string | null): string | null {
  if (!value) return null;
  try {
    const url = new URL(value);
    const host = url.hostname.toLowerCase();
    if (url.protocol !== "https:"
        || (host !== "archive.org" && !host.endsWith(".archive.org"))
        || !url.pathname.toLowerCase().endsWith(".mp3")
        || url.username || url.password || url.port) return null;
    return url.toString();
  } catch {
    return null;
  }
}

export function playbackSource(item: MediaRecord): PlaybackSource | null {
  if (item.sourceType === "YOUTUBE") {
    const videoId = item.mediaType === "VIDEO" ? youtubeVideoId(item.sourceUrl) : null;
    return videoId ? { kind: "youtube", videoId } : null;
  }

  if (item.sourceType === "EXTERNAL_AUDIO" && item.mediaType === "AUDIO") {
    const url = trustedArchiveAudioUrl(item.sourceUrl);
    return url ? { kind: "audio", src: url } : null;
  }

  if (item.sourceType === "LOCAL_FILE") {
    const src = "/api/v1/media/" + encodeURIComponent(item.id) + "/stream";
    if (item.mediaType === "AUDIO") return { kind: "audio", src };
    if (item.mediaType === "VIDEO") return { kind: "video", src };
  }
  return null;
}
