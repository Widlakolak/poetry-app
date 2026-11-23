import { ArrowLeft, BookOpen, ExternalLink, Headphones } from "lucide-react";
import { poet, workForSlug, works, type EditorialSource } from "./editorialContent";

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

function PoetPage() {
  return (
    <main className="home-content editorial-content">
      <a className="editorial-back" href="/"><ArrowLeft size={16} aria-hidden="true" /> Ekran główny</a>
      <header className="editorial-hero">
        <p className="eyebrow">POECI</p>
        <h1>{poet.name}</h1>
        <p className="editorial-meta">Polska · {poet.years}</p>
        <p className="editorial-lead">{poet.introduction}</p>
      </header>

      <section className="editorial-panel">
        <h2>Życie i twórczość</h2>
        <p>{poet.biography}</p>
        <p>{poet.context}</p>
      </section>

      <section className="editorial-panel" aria-labelledby="editorial-works">
        <h2 id="editorial-works">Utwory w Poetry App</h2>
        <div className="editorial-work-list">
          {works.map((work) => (
            <a className="editorial-work-link" key={work.slug} href={`/utwory/${work.slug}`}>
              <span className="editorial-work-icon"><BookOpen size={20} aria-hidden="true" /></span>
              <span>
                <strong>{work.title}</strong>
                <small>{work.recordingDescription}</small>
              </span>
            </a>
          ))}
        </div>
      </section>

      <Sources sources={poet.sources} />
      <p className="editorial-caution">Biografia i opisy są opracowaniem redakcyjnym. Informacje o lektorach poszczególnych nagrań wymagają osobnego potwierdzenia.</p>
    </main>
  );
}

function WorkPage({ slug }: { slug: string }) {
  const work = workForSlug(slug);
  if (!work) return <NotFoundPage />;

  return (
    <main className="home-content editorial-content">
      <a className="editorial-back" href="/poeci/miron-bialoszewski"><ArrowLeft size={16} aria-hidden="true" /> Miron Białoszewski</a>
      <header className="editorial-hero">
        <p className="eyebrow">UTWORY</p>
        <h1>{work.title}</h1>
        <p className="editorial-meta"><a href="/poeci/miron-bialoszewski">Miron Białoszewski</a></p>
        <p className="editorial-lead">{work.about}</p>
      </header>

      <section className="editorial-panel">
        <h2>O nagraniu</h2>
        <p>{work.recordingDescription}</p>
        <p className="editorial-recording">Nazwa w katalogu: <strong>{work.recordingTitle}</strong></p>
        <a className="editorial-library-link" href="/biblioteka">
          <Headphones size={18} aria-hidden="true" /> Przejdź do biblioteki, aby odtworzyć
        </a>
      </section>

      <section className="editorial-panel">
        <h2>Kontekst</h2>
        <p>{work.context}</p>
      </section>
      <Sources sources={work.sources} />
      <p className="editorial-caution">
        Opis opiera się na potwierdzonym numerze ścieżki i źródłach bibliograficznych. Nie jest transkrypcją nagrania; wykonawca nie został jeszcze zweryfikowany.
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
  if (pathname === `/poeci/${poet.slug}`) return <PoetPage />;
  if (pathname.startsWith("/utwory/")) {
    return <WorkPage slug={pathname.slice("/utwory/".length)} />;
  }
  return <NotFoundPage />;
}
