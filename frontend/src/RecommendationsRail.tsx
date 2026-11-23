import { useEffect, useState } from "react";
import { Film, Music2, Play, X } from "lucide-react";
import HorizontalCardRail from "./HorizontalCardRail";
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
  content: MediaItem[];
  page: number;
  totalPages: number;
};

type PlaybackKind = "video" | "audio" | "youtube";

function isMediaItem(value: unknown): value is MediaItem {
  if (!value || typeof value !== "object") return false;
  return (
    "id" in value && typeof value.id === "string" &&
    "title" in value && typeof value.title === "string" &&
    "mediaType" in value && typeof value.mediaType === "string" &&
    "sourceType" in value && typeof value.sourceType === "string" &&
    "sourceUrl" in value && (typeof value.sourceUrl === "string" || value.sourceUrl === null)
  );
}

function isMediaPage(value: unknown): value is MediaPage {
  if (!value || typeof value !== "object") return false;
  return (
    "content" in value && Array.isArray(value.content) &&
    value.content.every(isMediaItem) &&
    "page" in value && value.page === 0 &&
    "totalPages" in value && typeof value.totalPages === "number" &&
    Number.isInteger(value.totalPages) && value.totalPages >= 0
  );
}

function playbackKind(item: MediaItem): PlaybackKind | null {
  if (item.sourceType === "YOUTUBE") {
    return item.mediaType === "VIDEO" && youtubeVideoId(item.sourceUrl)
      ? "youtube" : null;
  }

  if (item.sourceType !== "LOCAL_FILE") return null;
  if (item.mediaType === "VIDEO") return "video";
  if (item.mediaType === "AUDIO") return "audio";
  return null;
}

export default function RecommendationsRail() {
  const [media, setMedia] = useState<MediaItem[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [retry, setRetry] = useState(0);
  const [playingId, setPlayingId] = useState<string | null>(null);
  const [playbackError, setPlaybackError] = useState(false);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");
    setPlayingId(null);
    setPlaybackError(false);

    async function loadRecommendations() {
      try {
        // A bounded preview of real, recently published catalog material;
        // no fabricated recommendations or personalization algorithm.
        const response = await fetch("/api/v1/media?page=0&size=20", {
          signal: controller.signal,
        });
        if (!response.ok) throw new Error("Nie można pobrać materiałów");

        const payload: unknown = await response.json();
        if (!isMediaPage(payload)) throw new Error("Nieprawidłowy katalog");

        if (controller.signal.aborted) return;
        setMedia(payload.content.filter((item) => playbackKind(item) !== null));
        setStatus("ready");
      } catch {
        if (!controller.signal.aborted) setStatus("error");
      }
    }

    void loadRecommendations();
    return () => controller.abort();
  }, [retry]);

  if (status !== "ready" || media.length === 0) {
    const message = status === "loading"
      ? "Wczytywanie dostępnych nagrań…"
      : status === "error"
        ? "Nie udało się wczytać dostępnych nagrań."
        : "Ta sekcja zostanie wypełniona na podstawie rzeczywistych materiałów.";

    return (
      <div className="collection-placeholder">
        <div className="empty-collection">
          <span className="empty-collection-mark" aria-hidden="true">
            <Film size={21} strokeWidth={1.6} />
          </span>
          <div>
            <p role="status">{message}</p>
            {status === "error" ? (
              <button
                className="library-action collection-retry"
                type="button"
                onClick={() => setRetry((value) => value + 1)}
              >
                Spróbuj ponownie
              </button>
            ) : null}
          </div>
        </div>
      </div>
    );
  }

  return (
    <HorizontalCardRail
      labelledBy="recommended-title"
      label="Wybrane dla Ciebie"
      items={media.map((item) => {
        const kind = playbackKind(item);
        const videoId = kind === "youtube" ? youtubeVideoId(item.sourceUrl) : null;
        const playing = playingId === item.id;
        const typeLabel = kind === "youtube" ? "YOUTUBE" :
          kind === "audio" ? "NAGRANIE AUDIO" : "NAGRANIE WIDEO";

        return {
          key: item.id,
          content: (
            <article className="catalog-media-card">
              <div className="catalog-media-cover" aria-hidden="true">
                {kind === "audio" ? <Music2 size={32} strokeWidth={1.3} /> :
                  <Film size={32} strokeWidth={1.3} />}
                <span>{typeLabel}</span>
              </div>
              <div className="catalog-media-body">
                <h3>{item.title}</h3>
                {playing && kind ? (
                  <div className="catalog-media-player">
                    {kind === "youtube" && videoId ? (
                      <YouTubeEmbed videoId={videoId} title={item.title} />
                    ) : kind === "audio" ? (
                      <audio
                        controls
                        controlsList="nodownload"
                        autoPlay
                        preload="metadata"
                        src={`/api/v1/media/${encodeURIComponent(item.id)}/stream`}
                        aria-label={`Odtwarzanie: ${item.title}`}
                        onError={() => setPlaybackError(true)}
                      >
                        Twoja przeglądarka nie obsługuje odtwarzania audio.
                      </audio>
                    ) : (
                      <video
                        controls
                        controlsList="nodownload"
                        autoPlay
                        playsInline
                        preload="metadata"
                        src={`/api/v1/media/${encodeURIComponent(item.id)}/stream`}
                        aria-label={`Odtwarzanie: ${item.title}`}
                        onError={() => setPlaybackError(true)}
                      >
                        Twoja przeglądarka nie obsługuje odtwarzania wideo.
                      </video>
                    )}
                    {playbackError ? (
                      <p className="library-error" role="alert">
                        Nie udało się odtworzyć nagrania.
                      </p>
                    ) : null}
                    <button
                      className="library-action"
                      type="button"
                      onClick={() => { setPlayingId(null); setPlaybackError(false); }}
                      aria-label={`Zamknij odtwarzacz: ${item.title}`}
                    >
                      <X size={16} aria-hidden="true" /> Zamknij
                    </button>
                  </div>
                ) : (
                  <button
                    className="library-action catalog-media-play"
                    type="button"
                    onClick={() => { setPlayingId(item.id); setPlaybackError(false); }}
                    aria-label={`Odtwórz: ${item.title}`}
                  >
                    <Play size={16} aria-hidden="true" /> Odtwórz tutaj
                  </button>
                )}
              </div>
            </article>
          ),
        };
      })}
    />
  );
}
