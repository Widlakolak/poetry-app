import { useEffect, useState } from "react";
import { ArrowLeft, BookOpen, ExternalLink, Headphones } from "lucide-react";
import {
  creatorSlug,
  fetchPoets,
  fetchWork,
  fetchWorks,
  type CreatorRecord,
  type WorkRecord,
} from "./catalogApi";
import { poet, workForSlug, type EditorialSource } from "./editorialContent";
import ArtistPage from "./ArtistPage";

function Sources({ sources }: { sources: EditorialSource[] }) {
  return (
    <section className="editorial-panel" aria-labelledby="editorial-sources">
      <h2 id="editorial-sources">Źródła i dalsza lektura</h2>
      <ul className="editorial-sources">
        {sources.map(({ label, url }) => (
          <li key={url}>
            <a href={url} target="_blank" rel="noopener noreferrer">
              {label}
              <ExternalLink size={14} aria-hidden="true" />
            </a>
          </li>
        ))}
      </ul>
    </section>
  );
}

function LoadingPage() {
  return (
    <main className="home-content editorial-content">
      <p className="library-feedback" role="status">Wczytywanie katalogu poezji…</p>
    </main>
  );
}

function ErrorPage() {
  return (
    <main className="home-content editorial-content">
      <div className="library-feedback" role="alert">
        <p>Nie udało się wczytać danych z katalogu.</p>
        <button className="library-action" type="button" onClick={() => window.location.reload()}>
          Spróbuj ponownie
        </button>
      </div>
    </main>
  );
}

function PoetPage({ slug }: { slug: string }) {
  const [data, setData] = useState<{ creator: CreatorRecord | null; works: WorkRecord[] } | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const controller = new AbortController();

    void Promise.all([fetchPoets(controller.signal), fetchWorks(controller.signal)])
      .then(([creators, works]) => {
        if (controller.signal.aborted) return;
        const creator = creators.find((entry) => creatorSlug(entry.displayName) === slug) ?? null;
        setData({
          creator,
          works: creator ? works.filter((work) => work.authorId === creator.id) : [],
        });
      })
      .catch(() => {
        if (!controller.signal.aborted) setFailed(true);
      });

    return () => controller.abort();
  }, [slug]);

  if (failed) return <ErrorPage />;
  if (!data) return <LoadingPage />;
  if (!data.creator) return <NotFoundPage />;

  const { creator, works } = data;
  const editorial = slug === poet.slug ? poet : null;

  return (
    <main className="home-content editorial-content">
      <a className="editorial-back" href="/"><ArrowLeft size={16} aria-hidden="true" /> Ekran główny</a>
      <header className="editorial-hero">
        <p className="eyebrow">POECI</p>
        <h1>{creator.displayName}</h1>
        {editorial ? <p className="editorial-meta">Polska · {editorial.years}</p> : null}
        {editorial ? <p className="editorial-lead">{editorial.introduction}</p> : null}
      </header>

      <section className="editorial-panel">
        <h2>Życie i twórczość</h2>
        <p>{creator.biography ?? "Biografia tego twórcy nie została jeszcze opublikowana."}</p>
        {editorial ? <p>{editorial.context}</p> : null}
      </section>

      <section className="editorial-panel" aria-labelledby="editorial-works">
        <h2 id="editorial-works">Utwory w Poetry App</h2>
        {works.length > 0 ? (
          <div className="editorial-work-list">
            {works.map((work) => (
              <a className="editorial-work-link" key={work.id} href={"/utwory/" + work.slug}>
                <span className="editorial-work-icon"><BookOpen size={20} aria-hidden="true" /></span>
                <span>
                  <strong>{work.title}</strong>
                  {work.summary ? <small>{work.summary}</small> : null}
                </span>
              </a>
            ))}
          </div>
        ) : (
          <p>Brak opublikowanych utworów tego poety.</p>
        )}
      </section>

      {editorial ? <Sources sources={editorial.sources} /> : null}
      <p className="editorial-caution">
        Biografia pochodzi z katalogu Poetry App. Dodatkowe informacje literackie
        podajemy wyłącznie przy potwierdzonych źródłach. Wykonawcy nagrań nie zostali zweryfikowani.
      </p>
    </main>
  );
}

function WorkPage({ slug }: { slug: string }) {
  const [work, setWork] = useState<WorkRecord | null | undefined>(undefined);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const controller = new AbortController();

    void fetchWork(slug, controller.signal)
      .then((record) => {
        if (!controller.signal.aborted) setWork(record);
      })
      .catch(() => {
        if (!controller.signal.aborted) setFailed(true);
      });

    return () => controller.abort();
  }, [slug]);

  if (failed) return <ErrorPage />;
  if (work === undefined) return <LoadingPage />;
  if (work === null) return <NotFoundPage />;

  const editorial = workForSlug(work.slug);
  const poetPath = "/poeci/" + creatorSlug(work.authorName);

  return (
    <main className="home-content editorial-content">
      <a className="editorial-back" href={poetPath}>
        <ArrowLeft size={16} aria-hidden="true" /> {work.authorName}
      </a>
      <header className="editorial-hero">
        <p className="eyebrow">UTWORY</p>
        <h1>{work.title}</h1>
        <p className="editorial-meta">
          <a href={poetPath}>{work.authorName}</a>
        </p>
        {work.summary ? <p className="editorial-lead">{work.summary}</p> : null}
      </header>

      <section className="editorial-panel">
        <h2>Nagrania w Bibliotece</h2>
        {editorial ? <p>{editorial.recordingDescription}</p> : null}
        {work.recordings.length > 0 ? (
          <ul className="editorial-recordings">
            {work.recordings.map((recording) => (
              <li key={recording.id}>
                <a className="library-work-link" href={"/nagrania/" + recording.id}>
                  {recording.title} · Odtwórz z napisami
                </a>
                <span>{recording.mediaType === "AUDIO" ? "Audio" : recording.mediaType === "VIDEO" ? "Wideo" : "Nagranie"}</span>
              </li>
            ))}
          </ul>
        ) : (
          <p>Brak opublikowanych nagrań tego utworu.</p>
        )}
        {work.recordings.length > 0 ? (
          <a className="editorial-library-link" href="/biblioteka">
            <Headphones size={18} aria-hidden="true" /> Przeglądaj pozostałe nagrania w Bibliotece
          </a>
        ) : null}
      </section>

      {editorial ? (
        <section className="editorial-panel">
          <h2>Kontekst literacki</h2>
          <p>{editorial.about}</p>
          <p>{editorial.context}</p>
        </section>
      ) : null}
      {editorial ? <Sources sources={editorial.sources} /> : null}
      <p className="editorial-caution">
        Tytuł, autor i powiązane nagrania pochodzą z bazy danych.
        Dodatkowy kontekst literacki pochodzi z podanych źródeł.
        Transkrypcji i tożsamości wykonawców nie potwierdzono.
      </p>
    </main>
  );
}

function NotFoundPage() {
  return (
    <main className="home-content editorial-content">
      <header className="editorial-hero">
        <p className="eyebrow">POETRY APP</p>
        <h1>Nie znaleziono strony</h1>
        <p className="editorial-lead">Ten adres nie prowadzi do opublikowanego opisu.</p>
      </header>
      <a className="editorial-library-link" href="/">Wróć do strony głównej</a>
    </main>
  );
}

export default function EditorialPages({ pathname }: { pathname: string }) {
  if (pathname.startsWith("/artysci/")) {
    return <ArtistPage slug={pathname.slice("/artysci/".length)} />;
  }
  if (pathname.startsWith("/poeci/")) {
    return <PoetPage slug={pathname.slice("/poeci/".length)} />;
  }
  if (pathname.startsWith("/utwory/")) {
    return <WorkPage slug={pathname.slice("/utwory/".length)} />;
  }
  return <NotFoundPage />;
}
