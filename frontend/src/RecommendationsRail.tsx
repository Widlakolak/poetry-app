import { useEffect, useState } from "react";
import { ArrowUpRight, Film, Music2 } from "lucide-react";
import HorizontalCardRail from "./HorizontalCardRail";
import { fetchMedia, type MediaRecord } from "./catalogApi";
import { playbackSource } from "./playbackSource";

export default function RecommendationsRail() {
  const [media, setMedia] = useState<MediaRecord[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [retry, setRetry] = useState(0);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");
    setMedia([]);

    void fetchMedia(controller.signal)
      .then((records) => {
        if (controller.signal.aborted) return;
        // Same newest-first curated preview as before, now links instead of inline players.
        setMedia(records.slice(0, 20).filter((item) => playbackSource(item) !== null));
        setStatus("ready");
      })
      .catch(() => {
        if (!controller.signal.aborted) setStatus("error");
      });
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
        const source = playbackSource(item);
        const isAudio = source?.kind === "audio";
        const typeLabel = source?.kind === "youtube" ? "YOUTUBE"
          : isAudio ? "NAGRANIE AUDIO" : "NAGRANIE WIDEO";

        return {
          key: item.id,
          content: (
            <a
              className="catalog-media-card catalog-media-card-link"
              href={"/nagrania/" + encodeURIComponent(item.id)}
              aria-label={"Otwórz nagranie i napisy: " + item.title}
            >
              <div className="catalog-media-cover" aria-hidden="true">
                {isAudio ? <Music2 size={32} strokeWidth={1.3} /> :
                  <Film size={32} strokeWidth={1.3} />}
                <span>{typeLabel}</span>
              </div>
              <div className="catalog-media-body">
                <h3>{item.title}</h3>
                <span className="library-action catalog-media-play">
                  <ArrowUpRight size={16} aria-hidden="true" /> Otwórz nagranie
                </span>
              </div>
            </a>
          ),
        };
      })}
    />
  );
}
