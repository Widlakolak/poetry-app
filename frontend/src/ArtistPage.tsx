import { useEffect, useState } from "react";
import { ArrowLeft, BookOpen, Headphones, UsersRound } from "lucide-react";
import {
  creatorSlug,
  fetchArtistRecordings,
  fetchArtists,
  fetchWorks,
  type CreatorRecord,
  type RecordingRecord,
  type WorkRecord,
} from "./catalogApi";

type ArtistDetails = {
  artist: CreatorRecord;
  recordings: RecordingRecord[];
  works: WorkRecord[];
};

export default function ArtistPage({ slug }: { slug: string }) {
  const [details, setDetails] = useState<ArtistDetails | null | undefined>(undefined);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const controller = new AbortController();

    async function loadArtist() {
      try {
        const artists = await fetchArtists(controller.signal);
        const artist = artists.find((entry) => creatorSlug(entry.displayName) === slug);
        if (!artist) {
          if (!controller.signal.aborted) setDetails(null);
          return;
        }

        const [recordings, works] = await Promise.all([
          fetchArtistRecordings(artist.id, controller.signal),
          fetchWorks(controller.signal),
        ]);
        if (!controller.signal.aborted) {
          setDetails({ artist, recordings, works });
        }
      } catch {
        if (!controller.signal.aborted) setFailed(true);
      }
    }

    void loadArtist();
    return () => controller.abort();
  }, [slug]);

  if (failed) {
    return (
      <main className="home-content editorial-content">
        <div className="library-feedback" role="alert">
          <p>Nie udało się wczytać katalogu artystów.</p>
          <button className="library-action" type="button" onClick={() => window.location.reload()}>
            Spróbuj ponownie
          </button>
        </div>
      </main>
    );
  }

  if (details === undefined) {
    return (
      <main className="home-content editorial-content">
        <p className="library-feedback" role="status">Wczytywanie profilu artysty…</p>
      </main>
    );
  }

  if (details === null) {
    return (
      <main className="home-content editorial-content">
        <header className="editorial-hero">
          <p className="eyebrow">ARTYŚCI</p>
          <h1>Nie znaleziono artysty</h1>
          <p className="editorial-lead">Brak tego wykonawcy w opublikowanym katalogu.</p>
        </header>
        <a className="editorial-library-link" href="/">Wróć do strony głównej</a>
      </main>
    );
  }

  const { artist, recordings, works } = details;

  return (
    <main className="home-content editorial-content">
      <a className="editorial-back" href="/">
        <ArrowLeft size={16} aria-hidden="true" /> Ekran główny
      </a>
      <header className="editorial-hero">
        <p className="eyebrow">ARTYŚCI</p>
        <h1>{artist.displayName}</h1>
        <p className="editorial-lead">
          {artist.biography ?? "Wykonawca nagrań dostępnych w katalogu Poetry App."}
        </p>
      </header>

      <section className="editorial-panel" aria-labelledby="artist-recordings">
        <h2 id="artist-recordings">Interpretacje w Poetry App</h2>
        {recordings.length > 0 ? (
          <div className="editorial-work-list">
            {recordings.map((recording) => {
              const relatedWorks = works.filter((work) =>
                work.recordings.some((item) => item.id === recording.id));

              return (
                <article className="editorial-work-link artist-recording-card" key={recording.id}>
                  <span className="editorial-work-icon">
                    <UsersRound size={20} aria-hidden="true" />
                  </span>
                  <div>
                    <strong>{recording.title}</strong>
                    <small>
                      {recording.sourceType === "YOUTUBE" ? "YouTube" :
                        recording.mediaType === "AUDIO" ? "Audio" : "Wideo"}
                    </small>
                    {relatedWorks.map((work) => (
                      <a href={"/utwory/" + work.slug} key={work.id} className="library-work-link">
                        <BookOpen size={13} aria-hidden="true" /> O utworze: {work.title}
                      </a>
                    ))}
                  </div>
                </article>
              );
            })}
          </div>
        ) : (
          <p>Brak opublikowanych nagrań przypisanych temu wykonawcy.</p>
        )}
      </section>

      {recordings.length > 0 ? (
        <a className="editorial-library-link" href="/biblioteka">
          <Headphones size={18} aria-hidden="true" /> Odtwórz nagrania w Bibliotece
        </a>
      ) : null}

      <p className="editorial-caution">
        Nazwisko i przypisanie nagrań do wykonawcy pochodzą z katalogu.
        Brak biografii oznacza, że nie została jeszcze dodana do bazy.
      </p>
    </main>
  );
}
