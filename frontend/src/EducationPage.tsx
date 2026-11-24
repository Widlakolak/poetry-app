import { useEffect, useState } from "react";
import { ArrowLeft, GraduationCap, Heart } from "lucide-react";
import { fetchWorks, creatorSlug, type WorkRecord } from "./catalogApi";

type Entry = { author: string; title: string; searchTitle?: string };
type Group = { title: string; entries: Entry[] };
type Stage = { title: string; subtitle: string; groups: Group[] };
const e = (author: string, title: string, searchTitle?: string): Entry => ({ author, title, searchTitle });
const stages: Stage[] = [
  { title: "Najmłodsi", subtitle: "Pierwsze rymy, rytm i zabawa słowem.", groups: [
    { title: "Polecane", entries: [
      e("Julian Tuwim", "Lokomotywa"), e("Julian Tuwim", "Ptasie radio"), e("Julian Tuwim", "Okulary"),
      e("Julian Tuwim", "Rzepka"), e("Jan Brzechwa", "Kaczka Dziwaczka"), e("Jan Brzechwa", "Na straganie"),
      e("Danuta Wawiłow", "Kałużyści"), e("Dorota Gellner", "Wybrane wiersze"), e("Małgorzata Strzałkowska", "Wybrane wiersze")
    ] }
  ] },
  { title: "Szkoła podstawowa · klasy I–III", subtitle: "Propozycje do samodzielnego czytania i recytacji.", groups: [
    { title: "Polecane", entries: [
      e("Julian Tuwim", "Słoń Trąbalski"), e("Julian Tuwim", "Abecadło"), e("Jan Brzechwa", "Pchła Szachrajka"),
      e("Maria Konopnicka", "Przygrywka"), e("Joanna Kulmowa", "Wybrane wiersze"),
      e("Janina Porazińska", "Wybrane wiersze"), e("Michał Rusinek", "Wybrane wiersze")
    ] }
  ] },
  { title: "Szkoła podstawowa · klasy IV–VI", subtitle: "Klasyka, bajki i pierwsze interpretacje.", groups: [
    { title: "Wskazane w podstawie z 2024 r.", entries: [
      e("Maria Konopnicka", "Rota"), e("Józef Wybicki", "Mazurek Dąbrowskiego"),
      e("Ignacy Krasicki", "Wybrane bajki"), e("Adam Mickiewicz", "Pan Tadeusz (fragmenty)")
    ] },
    { title: "Wybrane wiersze wskazanych autorów – przykłady", entries: [
      e("Adam Mickiewicz", "Pani Twardowska"), e("Adam Mickiewicz", "Powrót taty"),
      e("Jan Brzechwa", "Wybrane wiersze"), e("Julian Tuwim", "Wybrane wiersze"),
      e("Konstanty Ildefons Gałczyński", "Wybrane wiersze"), e("Anna Kamieńska", "Wybrane wiersze"),
      e("Joanna Kulmowa", "Wybrane wiersze"), e("Juliusz Słowacki", "Wybrane wiersze"),
      e("Leopold Staff", "Wybrane wiersze"), e("Jan Twardowski", "Wybrane wiersze")
    ] }
  ] },
  { title: "Szkoła podstawowa · klasy VII–VIII", subtitle: "Ballady, treny i interpretacja poezji.", groups: [
    { title: "Wskazane w podstawie z 2024 r.", entries: [
      e("Jan Kochanowski", "Tren VII"), e("Jan Kochanowski", "Tren VIII"),
      e("Jan Kochanowski", "Wybór fraszek i pieśń"),
      e("Adam Mickiewicz", "Reduta Ordona"), e("Adam Mickiewicz", "Świtezianka"),
      e("Adam Mickiewicz", "Pan Tadeusz (księgi I, II, IV, X, XI, XII)")
    ] },
    { title: "Wybrane wiersze wskazanych autorów – przykłady", entries: [
      e("Krzysztof Kamil Baczyński", "Elegia o… (chłopcu polskim)"),
      e("Bolesław Leśmian", "Zamyślenie"), e("Wisława Szymborska", "Nic dwa razy"),
      e("Zbigniew Herbert", "Wybrane wiersze"), e("Czesław Miłosz", "Wybrane wiersze"),
      e("Tadeusz Różewicz", "Wybrane wiersze")
    ] }
  ] },
  { title: "Liceum i technikum", subtitle: "Epoki literackie, interpretacja i przygotowanie do matury.", groups: [
    { title: "Wskazane w podstawie z 2024 r. – zakres podstawowy", entries: [
      e("Autor nieznany", "Bogurodzica"), e("Jan Kochanowski", "Pieśń IX (księga I)"),
      e("Jan Kochanowski", "Pieśń V (księga II)"), e("Jan Kochanowski", "Tren IX"),
      e("Jan Kochanowski", "Tren X"), e("Jan Kochanowski", "Tren XI"),
      e("Ignacy Krasicki", "Hymn do miłości ojczyzny"), e("Adam Mickiewicz", "Oda do młodości"),
      e("Adam Mickiewicz", "Romantyczność"), e("Adam Mickiewicz", "Sonety krymskie (wybór)"),
      e("Juliusz Słowacki", "Testament mój")
    ] },
    { title: "Wybrane wiersze wskazanych autorów – przykłady", entries: [
      e("Cyprian Kamil Norwid", "Fortepian Szopena"), e("Zbigniew Herbert", "Przesłanie Pana Cogito"),
      e("Wisława Szymborska", "Kot w pustym mieszkaniu"), e("Maria Pawlikowska-Jasnorzewska", "Dom na modrzewiu"),
      e("Miron Białoszewski", "Odczepić się"), e("Krzysztof Kamil Baczyński", "Wybrane wiersze"),
      e("Józef Czechowicz", "Wybrane wiersze"), e("Bolesław Leśmian", "Wybrane wiersze"),
      e("Czesław Miłosz", "Wybrane wiersze"), e("Halina Poświatowska", "Wybrane wiersze"),
      e("Kazimierz Przerwa-Tetmajer", "Wybrane wiersze"), e("Tadeusz Różewicz", "Wybrane wiersze"),
      e("Leopold Staff", "Wybrane wiersze"), e("Julian Tuwim", "Wybrane wiersze")
    ] }
  ] },
  { title: "Warte poznania", subtitle: "Poezja polska i światowa dla zainteresowanych.", groups: [
    { title: "Polecane", entries: [
      e("T. S. Eliot", "The Love Song of J. Alfred Prufrock"), e("Edgar Allan Poe", "Kruk"),
      e("Rainer Maria Rilke", "Pantera"), e("Halina Poświatowska", "Wybrane wiersze"),
      e("Agnieszka Osiecka", "Wybrane teksty"), e("Jacek Kaczmarski", "Wybrane teksty")
    ] }
  ] }
];

export function FavoritesPage() {
  return <main className="home-content editorial-content">
    <a className="editorial-back" href="/"><ArrowLeft size={17} aria-hidden="true" /> Ekran główny</a>
    <header className="editorial-hero"><p className="eyebrow">TWOJA KOLEKCJA</p><h1>Ulubione</h1></header>
    <section className="editorial-panel"><Heart size={32} aria-hidden="true" />
      <h2>Słowa, do których chcesz wracać</h2>
      <p>Poetry App jest obecnie w wersji MVP. Funkcja zapisywania ulubionych utworów jest w trakcie rozwoju.</p>
    </section>
  </main>;
}

export function EducationPage() {
  const [works, setWorks] = useState<WorkRecord[]>([]);
  const [catalogStatus, setCatalogStatus] = useState<"loading" | "ready" | "error">("loading");
  useEffect(() => {
    const controller = new AbortController();
    void fetchWorks(controller.signal).then((items) => {
      if (!controller.signal.aborted) { setWorks(items); setCatalogStatus("ready"); }
    }).catch(() => { if (!controller.signal.aborted) setCatalogStatus("error"); });
    return () => controller.abort();
  }, []);
  function match(entry: Entry) {
    const matches = works.filter((work) => creatorSlug(work.authorName) === creatorSlug(entry.author)
      && creatorSlug(work.title) === creatorSlug(entry.searchTitle ?? entry.title));
    const recorded = matches.filter((work) => work.recordings.length > 0);
    return recorded.length === 1 ? recorded[0] : matches.length === 1 ? matches[0] : undefined;
  }
  return <main className="home-content editorial-content education-page">
    <a className="editorial-back" href="/"><ArrowLeft size={17} aria-hidden="true" /> Ekran główny</a>
    <header className="editorial-hero"><p className="eyebrow">POEZJA I EDUKACJA</p><h1>Edukacja</h1>
      <p>Odkrywaj poezję na każdym etapie życia.</p></header>
    <section className="editorial-panel">
      <p>To wybór poezji, nie pełny wykaz lektur ani lista na każdą klasę. Od września 2026 r. nowa podstawa wchodzi stopniowo od klas I i IV; wymagania zależą od rocznika. Poniższe wskazania szkolne opierają się na podstawie z 2024 r., a propozycje nie są obowiązkowe.</p>
      <p><a href="https://zpe.gov.pl/podstawa-programowa/szkola-podstawowa/jezyk-polski" target="_blank" rel="noreferrer">Podstawa IV–VIII</a> · <a href="https://zpe.gov.pl/podstawa-programowa/szkola-ponadpodstawowa/jezyk-polski" target="_blank" rel="noreferrer">Liceum i technikum</a> · <a href="https://www.gov.pl/web/edukacja/nowe-podstawy-programowe-wychowania-przedszkolnego-i-ksztalcenia-ogolnego-dla-szkoly-podstawowej-wraz-ze-zmianami-w-ramowych-planach-nauczania-dla-publicznych-szkol-podstawowych--rozporzadzenia-podpisane" target="_blank" rel="noreferrer">Zmiany MEN od 2026 r.</a></p>
      {catalogStatus === "error" ? <p role="status">Katalog jest chwilowo niedostępny. Lista propozycji pozostaje dostępna.</p> : null}
      {catalogStatus === "loading" ? <p role="status">Sprawdzamy dostępność nagrań…</p> : null}
    </section>
    {stages.map((stage) => <details className="editorial-panel education-stage" key={stage.title}>
      <summary><GraduationCap size={20} aria-hidden="true" /><span><strong>{stage.title}</strong><small>{stage.subtitle}</small></span></summary>
      {stage.groups.map((group) => <section key={group.title}>
        <h3>{group.title}</h3>
        <ul className="education-list">{group.entries.map((entry) => {
          const work = match(entry);
          return <li key={entry.author + entry.title}><span><strong>{entry.title}</strong><small>{entry.author}</small></span>
            {work?.recordings.length ? <a href={work.recordings.length === 1 ? "/nagrania/" + work.recordings[0].id : "/utwory/" + work.slug}>Słuchaj</a>
              : work ? <a href={"/utwory/" + work.slug}>O utworze</a> : null}</li>;
        })}</ul>
      </section>)}
    </details>)}
  </main>;
}
