// Treat external video addresses as untrusted catalog data.
// Only validated official YouTube links may be converted to embeds.
const VIDEO_ID_PATTERN = /^[A-Za-z0-9_-]{11}$/;

export function youtubeVideoId(sourceUrl: string | null): string | null {
  if (!sourceUrl) return null;

  try {
    const url = new URL(sourceUrl);
    if (url.protocol !== "https:") return null;

    const host = url.hostname.toLowerCase();
    let id: string | null = null;

    if (host === "www.youtube.com" || host === "youtube.com" || host === "m.youtube.com") {
      if (url.pathname === "/watch") id = url.searchParams.get("v");
    } else if (host === "youtu.be") {
      const match = /^\/([A-Za-z0-9_-]{11})\/?$/.exec(url.pathname);
      id = match?.[1] ?? null;
    }

    return id && VIDEO_ID_PATTERN.test(id) ? id : null;
  } catch {
    return null;
  }
}

export function youtubeWatchUrl(id: string): string | null {
  return VIDEO_ID_PATTERN.test(id) ? "https://www.youtube.com/watch?v=" + id : null;
}
