import { useEffect, useState } from "react";
import { Film, Play, X } from "lucide-react";
import { youtubeVideoId } from "./youtubeSource";
import YouTubeEmbed from "./YouTubeEmbed";

type MediaItem = {
  id: string;
  title: string;
  mediaType: string;
  sourceType: string;
  sourceUrl: string | null;
};

type MediaPage = {
  content: unknown[];
  page: number;
  totalPages: number;
};

function isMediaItem(value: unknown): value is MediaItem {
  if (value === null || typeof value !== "object") return false;
  return (
    "id" in value && typeof value.id === "string" &&
    "title" in value && typeof value.title === "string" &&
    "mediaType" in value && typeof value.mediaType === "string" &&
    "sourceType" in value && typeof value.sourceType === "string" &&
    "sourceUrl" in value && (typeof value.sourceUrl === "string" || value.sourceUrl === null)
  );
}

function isMediaPage(value: unknown): value is MediaPage {
  if (value === null || typeof value !== "object") return false;
  return (
    "content" in value && Array.isArray(value.content) &&
    "page" in value && typeof value.page === "number" &&
    "totalPages" in value && typeof value.totalPages === "number" &&
    Number.isInteger(value.totalPages) && value.totalPages >= 0
  );
}

export default function YouTubeRecommendation() {
  const [media, setMedia] = useState<MediaItem | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "empty" | "error">("loading");
  const [isPlaying, setIsPlaying] = useState(false);

  useEffect(() => {
    const controller = new AbortController();

    async function loadVideo() {
      try {
        let page = 0;
        while (true) {
          const response = await fetch("/api/v1/media?page=" + page + "&size=100", {
            signal: controller.signal,
          });
          if (!response.ok) throw new Error("Failed to load catalog");
          const payload: unknown = await response.json();
          if (!isMediaPage(payload) || payload.page !== page) {
            throw new Error("Invalid catalog page");
          }
          const found = payload.content.find((item) =>
            isMediaItem(item) && item.sourceType === "YOUTUBE" &&
            item.mediaType === "VIDEO" && youtubeVideoId(item.sourceUrl));
          if (found && isMediaItem(found)) {
            if (!controller.signal.aborted) {
              setMedia(found);
              setStatus("ready");
            }
            return;
          }
          if (page + 1 >= payload.totalPages) {
            if (!controller.signal.aborted) setStatus("empty");
            return;
          }
          page += 1;
        }
      } catch {
        if (!controller.signal.aborted) setStatus("error");
      }
    }

    void loadVideo();
    return () => controller.abort();
  }, []);

  const videoId = media ? youtubeVideoId(media.sourceUrl) : null;

  if (!media || !videoId) {
    return (
      <div className="collection-placeholder">
        <div className="empty-collection">
          <span className="empty-collection-mark" aria-hidden="true">
            <Film size={21} strokeWidth={1.6} />
          </span>
          <p role="status">
            {status === "loading" ? "Wczytywanie polecanych nagrań…" :
              status === "error" ? "Nie udało się wczytać polecanych nagrań." :
                "Ta sekcja zostanie wypełniona na podstawie rzeczywistych materiałów."}
          </p>
        </div>
      </div>
    );
  }

  return (
    <article className="featured-card recommended-youtube-card">
      <div className="recommended-youtube-header">
        <p className="content-kicker">NAGRANIE Z YOUTUBE</p>
        <h3>{media.title}</h3>
      </div>
      {isPlaying ? (
        <div className="recommended-youtube-player">
          <YouTubeEmbed videoId={videoId} title={media.title} />
          <button className="library-action" type="button" onClick={() => setIsPlaying(false)}>
            <X size={16} aria-hidden="true" /> Zamknij odtwarzacz
          </button>
        </div>
      ) : (
        <div className="recommended-youtube-action">
          <button className="library-action" type="button" onClick={() => setIsPlaying(true)}>
            <Play size={17} aria-hidden="true" /> Odtwórz tutaj
          </button>
        </div>
      )}
    </article>
  );
}
