import { useEffect, useState } from "react";
import { LibraryBig } from "lucide-react";

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

  return (
    <>
      <article className="featured-card">
        <div className="featured-artwork">
          <div className="artwork-grain" aria-hidden="true" />
          <span className="artwork-kicker">INTERPRETACJA POETYCKA</span>
          <div className="artwork-title">
            <span>Miron</span>
            <span>Białoszewski</span>
          </div>
          <span className="artwork-work">Sen Peszek</span>
          <span className="artwork-line" aria-hidden="true" />
          {media ? (
            <a
              className="play-button"
              href="/biblioteka"
              aria-label="Przejdź do Biblioteki, aby obejrzeć nagranie"
              title="Zobacz w Bibliotece"
            >
              <LibraryBig size={22} strokeWidth={1.8} aria-hidden="true" />
            </a>
          ) : (
            <button
              className="play-button"
              type="button"
              disabled
              aria-label="Nagranie niedostępne"
              title="Nagranie niedostępne"
            >
              <LibraryBig size={22} strokeWidth={1.8} aria-hidden="true" />
            </button>
          )}
          <span className="artwork-status" role="status">
            {loadState === "ready"
              ? "DOSTĘPNE W BIBLIOTECE"
              : loadState === "loading"
                ? "SPRAWDZANIE KATALOGU"
                : "MATERIAŁ NIEDOSTĘPNY"}
          </span>
        </div>
        <div className="featured-details">
          <div>
            <p className="content-kicker">NAGRANIE WIDEO</p>
            <h3>{media?.title ?? FEATURED_TITLE}</h3>
            <p className="featured-caption">Odtwarzanie jest dostępne w Bibliotece.</p>
          </div>
          <span className="media-type">MP4</span>
        </div>
      </article>
      <p className="section-note" role="status">
        {loadState === "loading"
          ? "Sprawdzanie dostępności nagrania…"
          : loadState === "unavailable"
            ? "Nagranie jest obecnie niedostępne."
            : "Otwórz Bibliotekę, aby odtworzyć nagranie."}
      </p>
    </>
  );
}
