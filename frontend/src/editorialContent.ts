// Editorial entries are intentionally limited to source-verified facts.
// They do not create database credits or imply rights to the recorded performances.
export type EditorialSource = {
  label: string;
  url: string;
};

export type EditorialWork = {
  slug: string;
  title: string;
  recordingTitle: string;
  recordingDescription: string;
  about: string;
  context: string;
  sources: EditorialSource[];
};

export const poet = {
  slug: "miron-bialoszewski",
  name: "Miron Białoszewski",
  years: "1922–1983",
  introduction:
    "Polski poeta, prozaik i twórca teatru eksperymentalnego, silnie związany z Warszawą. W swojej twórczości badał rytm mowy codziennej, wieloznaczność słów i zwyczajne doświadczenia.",
  biography:
    "W 1956 roku opublikował debiutancki tom poetycki „Obroty rzeczy”. Współtworzył Teatr na Tarczyńskiej, a następnie Teatr Osobny. W prozie i poezji wracał do codzienności miasta oraz do możliwości języka mówionego.",
  context:
    "Po przeprowadzce na warszawską Lizbońską powstały utwory związane z blokowiskiem, przedstawionym między innymi w tomie „Odczepić się” (1978) i w „Chamowie”.",
  sources: [
    {
      label: "Culture.pl — Miron Białoszewski: życie i twórczość",
      url: "https://culture.pl/pl/tworca/miron-bialoszewski",
    },
    {
      label: "Zintegrowana Platforma Edukacyjna — twórczość Mirona Białoszewskiego",
      url: "https://zpe.gov.pl/a/kto-to-jest-ja-co-to-jest-rzeczywistosc/DbmRTEX2M",
    },
  ] satisfies EditorialSource[],
};

const albumSource: EditorialSource = {
  label: "Spis utworów „Białoszewski do słuchu”, vol. 3 — „Blok”",
  url: "https://muzykanalekcji.wordpress.com/2014/07/02/polecana-plyta-miron-bialoszewskirozni-wykonawcy-bialoszewski-do-sluchu/",
};

export const works: EditorialWork[] = [
  {
    slug: "odczepic-sie",
    title: "Odczepić się",
    recordingTitle: "02 Track 02",
    recordingDescription: "Ścieżka 2 z 75 na płycie „Białoszewski do słuchu”, vol. 3 — „Blok”.",
    about:
      "Krótka pozycja z archiwalnej kolekcji nagrań poświęconej twórczości Mirona Białoszewskiego. W spisie trzeciego woluminu albumu figuruje jako drugi utwór.",
    context:
      "Tytuł „Odczepić się” nosi również tom wierszy Białoszewskiego z 1978 roku. W późniejszej twórczości poety ważną rolę odgrywa obserwacja zwykłego życia i przestrzeni wielkiego osiedla. Nie przypisujemy jednak temu konkretnemu nagraniu wykonawcy bez osobnego potwierdzenia.",
    sources: [
      albumSource,
      {
        label: "Culture.pl — biografia i bibliografia Białoszewskiego",
        url: "https://culture.pl/pl/tworca/miron-bialoszewski",
      },
    ],
  },
  {
    slug: "siodma-osma",
    title: "Siódma, ósma",
    recordingTitle: "12 Track 12",
    recordingDescription: "Ścieżka 12 z 75 na płycie „Białoszewski do słuchu”, vol. 3 — „Blok”; w spisie oznaczona jako fragment „Chamowa”.",
    about:
      "Wydawniczy spis utworów łączy „Siódma, ósma” z „Chamowem”, dziennikarsko-literackim zapisem codzienności autora po przeprowadzce na warszawską Lizbońską.",
    context:
      "W twórczości Białoszewskiego przestrzeń osiedla, okna, klatki schodowej oraz zwykły rytm dnia stają się materiałem literackim. Jest to kontekst cyklu, nie transkrypcja ani szczegółowa analiza słów z nagrania.",
    sources: [
      albumSource,
      {
        label: "ZPE — Białoszewski, Warszawa i „Chamowo”",
        url: "https://zpe.gov.pl/watek/LPFHDLRM4G/370/a/dowiedz-sie/D5EANXAN8",
      },
    ],
  },
];

export function workForRecordingTitle(title: string): EditorialWork | undefined {
  return works.find((work) => work.recordingTitle === title);
}

export function workForSlug(slug: string): EditorialWork | undefined {
  return works.find((work) => work.slug === slug);
}
