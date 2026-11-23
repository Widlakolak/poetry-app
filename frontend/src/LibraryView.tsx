import { useEffect, useState } from "react";
import { Film, LibraryBig, Play, X } from "lucide-react";

type MediaItem = {
  id: string;
  title: string;
  mediaType: string;
  sourceType: string;
};

type MediaPage = {
  content: MediaItem[];
  page: number;
  totalPages: number;
  totalElements: number;
};

const PAGE_SIZE = 20;

function isMediaItem(value: unknown): value is MediaItem {
  if (value === null || typeof value !== "object") return false;

  return (
    "id" in value && typeof value.id === "string" &&
    "title" in value && typeof value.title === "string" &&
    "mediaType" in value && typeof value.mediaType === "string" &&
    "sourceType" in value && typeof value.sourceType === "string"
  );
}

function isMediaPage(value: unknown): value is MediaPage {
  if (value === null || typeof value !== "object") return false;

  return (
    "content" in value && Array.isArray(value.content) &&
    value.content.every(isMediaItem) &&
    "page" in value && typeof value.page === "number" &&
    Number.isInteger(value.page) && value.page >= 0 &&
    "totalPages" in value && typeof value.totalPages === "number" &&
    Number.isInteger(value.totalPages) && value.totalPages >= 0 &&
    "totalElements" in value && typeof value.totalElements === "number" &&
    Number.isInteger(value.totalElements) && value.totalElements >= 0
  );
}

function isPlayableVideo(item: MediaItem): boolean {
  return item.mediaType === "VIDEO" && item.sourceType === "LOCAL_FILE";
}

export default function LibraryView() {
  const [page, setPage] = useState(0);
  const [retry, setRetry] = useState(0);
  const [catalog, setCatalog] = useState<MediaPage | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [playbackError, setPlaybackError] = useState(false);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");
    setCatalog(null);
    setSelectedId(null);
    setPlaybackError(false);

    async function loadPage() {
      try {
        const response = await fetch(
          `/api/v1/media?page=${page}&size=${PAGE_SIZE}`,
          { signal: controller.signal },
        );
        if (!response.ok) throw new Error("Nie udało się pobrać katalogu");

        const payload: unknown = await response.json();
        if (!isMediaPage(payload) || payload.page !== page) {
          throw new Error("Nieprawidłowa odpowiedź API");
        }

        if (controller.signal.aborted) return;
        setCatalog(payload);
        setStatus("ready");
      } catch {
        if (!controller.signal.aborted) {
          setStatus("error");
        }
      }
    }

    void loadPage();
    return () => controller.abort();
  }, [page, retry]);

  const selectedItem = catalog?.content.find((item) => item.id === selectedId);

  function selectItem(id: string) {
    setSelectedId(id);
    setPlaybackError(false);
  }

  function closePlayer() {
    setSelectedId(null);
    setPlaybackError(false);
  }

  return (
    <main className="home-content library-content">
      <header className="library-heading">
        <p className="eyebrow">ODKRYWAJ NAGRANIA</p>
        <h1>Biblioteka</h1>
        <p className="welcome-copy">
          Obejrzyj opublikowane materiały w jednym miejscu.
        </p>
      </header>

      {status === "loading" ? (
        <p className="library-feedback" role="status">Wczytywanie biblioteki…</p>
      ) : null}

      {status === "error" ? (
        <div className="library-feedback" role="alert">
          <p>Nie udało się wczytać biblioteki.</p>
          <button className="library-action" type="button" onClick={() => setRetry((value) => value + 1)}>
            Spróbuj ponownie
          </button>
        </div>
      ) : null}

      {status === "ready" && catalog?.content.length === 0 ? (
        <div className="library-feedback" role="status">
          Nie ma jeszcze opublikowanych nagrań.
        </div>
      ) : null}

      {status === "ready" && catalog && catalog.content.length > 0 ? (
        <>
          <p className="library-count">Opublikowane materiały: {catalog.totalElements}</p>
          <ul className="library-list">
            {catalog.content.map((item) => {
              const playable = isPlayableVideo(item);
              const expanded = selectedId === item.id;

              return (
                <li className="library-item" key={item.id}>
                  <div className="library-item-row">
                    <span className="library-item-icon" aria-hidden="true">
                      {playable ? <Film size={21} strokeWidth={1.7} /> : <LibraryBig size={21} strokeWidth={1.7} />}
                    </span>
                    <div className="library-item-info">
                      <h2>{item.title}</h2>
                      <p>{item.mediaType === "VIDEO" ? "Wideo" : item.mediaType === "AUDIO" ? "Audio" : "Materiał"}</p>
                    </div>
                    {playable ? (
                      <button
                        className="library-action"
                        type="button"
                        onClick={() => expanded ? closePlayer() : selectItem(item.id)}
                        aria-label={expanded ? `Zamknij odtwarzacz: ${item.title}` : `Odtwórz: ${item.title}`}
                        aria-expanded={expanded}
                      >
                        {expanded ? <X size={17} aria-hidden="true" /> : <Play size={17} aria-hidden="true" />}
                        <span>{expanded ? "Zamknij" : "Odtwórz"}</span>
                      </button>
                    ) : (
                      <span className="library-unavailable">Brak odtwarzacza</span>
                    )}
                  </div>

                  {expanded && selectedItem && playable ? (
                    <div className="library-video">
                      <video
                        key={selectedItem.id}
                        controls
                        autoPlay
                        playsInline
                        preload="metadata"
                        src={`/api/v1/media/${encodeURIComponent(selectedItem.id)}/stream`}
                        aria-label={`Odtwarzanie: ${selectedItem.title}`}
                        onError={() => setPlaybackError(true)}
                      >
                        Twoja przeglądarka nie obsługuje odtwarzania wideo.
                      </video>
                      {playbackError ? (
                        <p role="alert" className="library-error">
                          Nie udało się odtworzyć nagrania. Spróbuj ponownie.
                        </p>
                      ) : null}
                    </div>
                  ) : null}
                </li>
              );
            })}
          </ul>
          <nav className="library-pagination" aria-label="Strony biblioteki">
            <button
              className="library-action"
              type="button"
              disabled={page === 0}
              onClick={() => setPage((current) => Math.max(0, current - 1))}
            >
              Poprzednia
            </button>
            <span>Strona {page + 1} z {Math.max(1, catalog.totalPages)}</span>
            <button
              className="library-action"
              type="button"
              disabled={page + 1 >= catalog.totalPages}
              onClick={() => setPage((current) => current + 1)}
            >
              Następna
            </button>
          </nav>
        </>
      ) : null}
    </main>
  );
}
