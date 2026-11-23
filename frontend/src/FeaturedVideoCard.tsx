import { useEffect, useState } from "react";
import { Play, X } from "lucide-react";

type MediaItem = {
  id: string;
  title: string;
  mediaType: string;
  sourceType: string;
};

const FEATURED_TITLE = "Białoszewski - Sen Peszek";

function isMediaItem(value: unknown): value is MediaItem {
  if (value === null || typeof value !== "object") return false;
  return (
    "id" in value && typeof value.id === "string" &&
    "title" in value && typeof value.title === "string" &&
    "mediaType" in value && typeof value.mediaType === "string" &&
    "sourceType" in value && typeof value.sourceType === "string"
  );
}

function findFeaturedMedia(payload: unknown): MediaItem | null {
  if (payload === null || typeof payload !== "object" || !("content" in payload)) {
    throw new Error("Nieprawidłowa odpowiedź katalogu");
  }
  if (!Array.isArray(payload.content)) {
    throw new Error("Brak listy materiałów");
  }
  return (
    payload.content.find(
      (candidate: unknown) =>
        isMediaItem(candidate) &&
        candidate.title === FEATURED_TITLE &&
        candidate.mediaType === "VIDEO" &&
        candidate.sourceType === "LOCAL_FILE",
    ) ?? null
  );
}

export default function FeaturedVideoCard() {
  const [media, setMedia] = useState<MediaItem | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [playbackError, setPlaybackError] = useState(false);
  const [loadState, setLoadState] = useState<"loading" | "ready" | "unavailable">("loading");

  useEffect(() => {
    const controller = new AbortController();

    async function loadFeaturedMedia() {
      try {
        const response = await fetch("/api/v1/media?size=100", { signal: controller.signal });
        if (!response.ok) {
          throw new Error("Nie można pobrać katalogu");
        }
        const item = findFeaturedMedia(await response.json());
        if (controller.signal.aborted) return;
        setMedia(item);
        setLoadState(item ? "ready" : "unavailable");
      } catch {
        if (!controller.signal.aborted) {
          setLoadState("unavailable");
        }
      }
    }

    void loadFeaturedMedia();
    return () => controller.abort();
  }, []);

  function closePlayer() {
    setIsPlaying(false);
    setPlaybackError(false);
  }

  return (
    <>
      <article className="featured-card">
        <div className={`featured-artwork${isPlaying ? " featured-artwork-playing" : ""}`}>
          {isPlaying && media ? (
            <div className="featured-player">
              <video
                controls
                controlsList="nodownload"
                autoPlay
                playsInline
                preload="metadata"
                src={`/api/v1/media/${encodeURIComponent(media.id)}/stream`}
                aria-label={`Odtwarzanie: ${media.title}`}
                onError={() => setPlaybackError(true)}
              >
                Twoja przeglądarka nie obsługuje odtwarzania wideo.
              </video>
              <button
                className="player-close-button"
                type="button"
                onClick={closePlayer}
                aria-label="Zamknij odtwarzacz"
                title="Zamknij odtwarzacz"
              >
                <X size={20} strokeWidth={2} aria-hidden="true" />
              </button>
              {playbackError ? (
                <p className="player-error" role="alert">
                  Nie udało się odtworzyć filmu. Zamknij odtwarzacz i spróbuj ponownie.
                </p>
              ) : null}
            </div>
          ) : (
            <>
              <div className="artwork-grain" aria-hidden="true" />
              <span className="artwork-kicker">INTERPRETACJA POETYCKA</span>
              <div className="artwork-title">
                <span>Miron</span>
                <span>Białoszewski</span>
              </div>
              <span className="artwork-work">Sen Peszek</span>
              <span className="artwork-line" aria-hidden="true" />
              <button
                className="play-button"
                type="button"
                disabled={!media}
                onClick={() => { setPlaybackError(false); setIsPlaying(true); }}
                aria-label="Odtwórz film Białoszewski - Sen Peszek"
                title={media ? "Odtwórz nagranie" : "Nagranie niedostępne"}
              >
                <Play size={22} fill="currentColor" strokeWidth={1.5} aria-hidden="true" />
              </button>
              <span className="artwork-status" role="status">
                {loadState === "ready"
                  ? "GOTOWE DO ODTWORZENIA"
                  : loadState === "loading"
                    ? "SPRAWDZANIE KATALOGU"
                    : "MATERIAŁ NIEDOSTĘPNY"}
              </span>
            </>
          )}
        </div>
        <div className="featured-details">
          <div>
            <p className="content-kicker">NAGRANIE WIDEO</p>
            <h3>{media?.title ?? FEATURED_TITLE}</h3>
            <p className="featured-caption">Odtwórz tutaj albo wybierz nagranie w Bibliotece.</p>
          </div>
          <span className="media-type">MP4</span>
        </div>
      </article>
      <p className="section-note" role="status">
        {loadState === "loading"
          ? "Sprawdzanie dostępności nagrania…"
          : loadState === "unavailable"
            ? "Nagranie jest obecnie niedostępne."
            : "Wybierz Play, aby obejrzeć nagranie. Możesz je zatrzymać i przewijać."}
      </p>
    </>
  );
}
