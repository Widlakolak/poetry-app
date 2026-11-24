import { useEffect, useRef, useState } from "react";
import { BookOpen, Film, Music2, Play, Search, UsersRound, X } from "lucide-react";
import {
  creatorSlug,
  fetchArtists,
  fetchMedia,
  fetchPoets,
  fetchWorks,
  type CreatorRecord,
  type MediaRecord,
  type WorkRecord,
} from "./catalogApi";
import { youtubeVideoId } from "./youtubeSource";
import YouTubeEmbed from "./YouTubeEmbed";
import { trustedArchiveAudioUrl } from "./playbackSource";

type SearchCatalog = {
  media: MediaRecord[];
  works: WorkRecord[];
  poets: CreatorRecord[];
  artists: CreatorRecord[];
};

type PlaybackKind = "video" | "audio" | "youtube";

function normalized(value: string): string {
  return value
    .replace(/ł/g, "l")
    .replace(/Ł/g, "L")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

// All query words must be present, regardless of case, word order or Polish diacritics.
function matches(query: string, ...fields: string[]): boolean {
  const words = normalized(query).split(/\s+/).filter(Boolean);
  const searchable = normalized(fields.join(" "));
  return words.length > 0 && words.every((word) => searchable.includes(word));
}

function playbackKind(item: MediaRecord): PlaybackKind | null {
  if (item.sourceType === "YOUTUBE") {
    return item.mediaType === "VIDEO" && youtubeVideoId(item.sourceUrl) ? "youtube" : null;
  }
  if (item.sourceType === "EXTERNAL_AUDIO") {
    return item.mediaType === "AUDIO" && trustedArchiveAudioUrl(item.sourceUrl) ? "audio" : null;
  }
  if (item.sourceType !== "LOCAL_FILE") return null;
  if (item.mediaType === "AUDIO") return "audio";
  if (item.mediaType === "VIDEO") return "video";
  return null;
}

export default function SearchView() {
  const [query, setQuery] = useState("");
  const [catalog, setCatalog] = useState<SearchCatalog | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [retry, setRetry] = useState(0);
  const [playingId, setPlayingId] = useState<string | null>(null);
  const [playbackError, setPlaybackError] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");
    setCatalog(null);
    setPlayingId(null);
    setPlaybackError(false);

    void Promise.all([
      fetchMedia(controller.signal),
      fetchWorks(controller.signal),
      fetchPoets(controller.signal),
      fetchArtists(controller.signal),
    ])
      .then(([media, works, poets, artists]) => {
        if (controller.signal.aborted) return;
        setCatalog({ media, works, poets, artists });
        setStatus("ready");
      })
      .catch(() => {
        if (!controller.signal.aborted) setStatus("error");
      });

    return () => controller.abort();
  }, [retry]);

  function changeQuery(next: string) {
    setQuery(next);
    setPlayingId(null);
    setPlaybackError(false);
  }

  const hasQuery = normalized(query).length > 0;
  const media = hasQuery && catalog ? catalog.media.filter((item) => matches(query, item.title)) : [];
  const works = hasQuery && catalog ? catalog.works.filter((work) =>
    matches(query, work.title, work.authorName)) : [];
  const poets = hasQuery && catalog ? catalog.poets.filter((poet) =>
    matches(query, poet.displayName)) : [];
  const artists = hasQuery && catalog ? catalog.artists.filter((artist) =>
    matches(query, artist.displayName)) : [];
  const resultCount = media.length + works.length + poets.length + artists.length;

  return (
    <main className="home-content search-content">
      <header className="library-heading">
        <p className="eyebrow">ODKRYWAJ POEZJĘ</p>
        <h1>Szukaj</h1>
        <p className="welcome-copy">Znajdź nagranie, utwór, poetę lub artystę.</p>
      </header>

      <div className="search-form">
        <label htmlFor="catalog-search">Szukaj w katalogu Poetry App</label>
        <div className="search-input-wrap">
          <Search size={21} strokeWidth={1.8} aria-hidden="true" />
          <input
            ref={inputRef}
            id="catalog-search"
            type="search"
            autoComplete="off"
            value={query}
            onChange={(event) => changeQuery(event.target.value)}
            placeholder="Tytuł, poeta lub artysta…"
          />
          {query ? (
            <button
              className="search-clear"
              type="button"
              aria-label="Wyczyść wyszukiwanie"
              onClick={() => { changeQuery(""); inputRef.current?.focus(); }}
            >
              <X size={19} aria-hidden="true" />
            </button>
          ) : null}
        </div>
      </div>

      {status === "loading" ? (
        <p className="library-feedback" role="status">Wczytywanie katalogu do wyszukiwania…</p>
      ) : null}
      {status === "error" ? (
        <div className="library-feedback" role="alert">
          <p>Nie udało się wczytać katalogu. Sprawdź połączenie i spróbuj ponownie.</p>
          <button className="library-action" type="button" onClick={() => setRetry((value) => value + 1)}>
            Spróbuj ponownie
          </button>
        </div>
      ) : null}
      {status === "ready" && !hasQuery ? (
        <p className="library-feedback" role="status">
          Wpisz nazwisko twórcy lub fragment tytułu. Wyszukiwanie obejmuje wyłącznie opublikowany katalog.
        </p>
      ) : null}
      {status === "ready" && hasQuery && resultCount === 0 ? (
        <div className="library-feedback" role="status">
          Brak wyników dla podanej frazy. Spróbuj krótszego tytułu lub innego nazwiska.
        </div>
      ) : null}

      {status === "ready" && hasQuery && resultCount > 0 ? (
        <div className="search-results">
          <p className="library-count" role="status">
            {resultCount === 1 ? "Znaleziono 1 wynik." : "Znaleziono " + resultCount + " wyników."}
          </p>

          {media.length > 0 ? (
            <section className="search-group" aria-labelledby="search-media-heading">
              <h2 id="search-media-heading">Nagrania <span>({media.length})</span></h2>
              <ul className="search-list">
                {media.map((item) => {
                  const kind = playbackKind(item);
                  const expanded = playingId === item.id;
                  const videoId = kind === "youtube" ? youtubeVideoId(item.sourceUrl) : null;
                  return (
                    <li className="search-item" key={item.id}>
                      <div className="search-item-row">
                        <span className="search-item-icon" aria-hidden="true">
                          {kind === "audio" ? <Music2 size={20} /> : <Film size={20} />}
                        </span>
                        <div className="search-item-info">
                          <span className="search-item-type">
                            {kind === "youtube" ? "YOUTUBE" : item.mediaType === "AUDIO" ? "AUDIO" : "WIDEO"}
                          </span>
                          <h3>{item.title}</h3>
                          {kind ? <a className="library-work-link" href={"/nagrania/" + item.id}>Otwórz z napisami</a> : null}
                        </div>
                        {kind ? (
                          <button
                            className="library-action"
                            type="button"
                            aria-expanded={expanded}
                            aria-label={(expanded ? "Zamknij odtwarzacz: " : "Odtwórz: ") + item.title}
                            onClick={() => {
                              setPlayingId(expanded ? null : item.id);
                              setPlaybackError(false);
                            }}
                          >
                            {expanded ? <X size={17} aria-hidden="true" /> : <Play size={17} aria-hidden="true" />}
                            <span>{expanded ? "Zamknij" : "Odtwórz"}</span>
                          </button>
                        ) : (
                          <span className="library-unavailable">Brak odtwarzacza</span>
                        )}
                      </div>
                      {expanded && kind ? (
                        <div className="search-item-player">
                          {kind === "youtube" && videoId ? (
                            <YouTubeEmbed videoId={videoId} title={item.title} />
                          ) : kind === "audio" ? (
                            <audio
                              controls
                              controlsList="nodownload"
                              autoPlay
                              preload="metadata"
                              src={item.sourceType === "EXTERNAL_AUDIO"
                                ? trustedArchiveAudioUrl(item.sourceUrl) ?? undefined
                                : "/api/v1/media/" + encodeURIComponent(item.id) + "/stream"}
                              aria-label={"Odtwarzanie: " + item.title}
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
                              src={"/api/v1/media/" + encodeURIComponent(item.id) + "/stream"}
                              aria-label={"Odtwarzanie: " + item.title}
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
                        </div>
                      ) : null}
                    </li>
                  );
                })}
              </ul>
            </section>
          ) : null}

          {works.length > 0 ? (
            <section className="search-group" aria-labelledby="search-works-heading">
              <h2 id="search-works-heading">Utwory <span>({works.length})</span></h2>
              <ul className="search-list">
                {works.map((work) => (
                  <li key={work.id}>
                    <a className="search-item search-item-link" href={"/utwory/" + work.slug}>
                      <span className="search-item-icon" aria-hidden="true"><BookOpen size={20} /></span>
                      <span className="search-item-info">
                        <span className="search-item-type">UTWÓR · {work.authorName}</span>
                        <strong>{work.title}</strong>
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </section>
          ) : null}

          {poets.length > 0 ? (
            <section className="search-group" aria-labelledby="search-poets-heading">
              <h2 id="search-poets-heading">Poeci <span>({poets.length})</span></h2>
              <ul className="search-list">
                {poets.map((poet) => (
                  <li key={poet.id}>
                    <a className="search-item search-item-link" href={"/poeci/" + creatorSlug(poet.displayName)}>
                      <span className="search-item-icon" aria-hidden="true"><BookOpen size={20} /></span>
                      <span className="search-item-info">
                        <span className="search-item-type">POETA</span>
                        <strong>{poet.displayName}</strong>
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </section>
          ) : null}

          {artists.length > 0 ? (
            <section className="search-group" aria-labelledby="search-artists-heading">
              <h2 id="search-artists-heading">Artyści <span>({artists.length})</span></h2>
              <ul className="search-list">
                {artists.map((artist) => (
                  <li key={artist.id}>
                    <a className="search-item search-item-link" href={"/artysci/" + creatorSlug(artist.displayName)}>
                      <span className="search-item-icon" aria-hidden="true"><UsersRound size={20} /></span>
                      <span className="search-item-info">
                        <span className="search-item-type">ARTYSTA</span>
                        <strong>{artist.displayName}</strong>
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </section>
          ) : null}
        </div>
      ) : null}
    </main>
  );
}
