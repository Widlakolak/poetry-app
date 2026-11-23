# Poetry App
### Cyfrowa przestrzeń do słuchania, czytania i odkrywania poezji

## O projekcie

Poetry App to projekt aplikacji cyfrowej, której celem jest przybliżanie poezji współczesnym odbiorcom poprzez nagrania aktorskie, materiały wideo i teksty literackie.

Projekt zakłada połączenie tradycyjnej formy literackiej z prostym, nowoczesnym sposobem korzystania z treści. Użytkownik będzie mógł nie tylko słuchać interpretacji wierszy, lecz także śledzić ich tekst podczas odtwarzania i odkrywać twórczość poetów oraz aktorów.

Istotnym założeniem jest stworzenie spokojnego środowiska odbioru literatury. Aplikacja nie ma konkurować z użytkownikiem o uwagę za pomocą nadmiaru bodźców wizualnych. Jej interfejs ma sprzyjać skupieniu na słowie, głosie i interpretacji.

## Misja

Misją Poetry App jest zwiększanie dostępności poezji i wspieranie jej obecności w codziennym życiu poprzez połączenie literatury, interpretacji aktorskiej i technologii cyfrowych.

Projekt ma służyć zarówno osobom, które już interesują się literaturą, jak i tym, które dopiero szukają przystępnego sposobu na rozpoczęcie przygody z poezją.

## Główne założenia

- **Poezja dostępna na co dzień** - możliwość słuchania i czytania utworów w wygodnej formie cyfrowej.
- **Interpretacja aktorska** - wykorzystanie głosu, emocji i indywidualnego sposobu odczytania tekstu jako integralnej części doświadczenia literackiego.
- **Połączenie dźwięku i słowa** - prezentowanie tekstu wiersza podczas odtwarzania nagrania.
- **Odkrywanie twórców** - stworzenie przestrzeni do poznawania poetów, aktorów i ich interpretacji.
- **Spokojny interfejs** - ograniczenie zbędnych elementów wizualnych, intensywnych kolorów i rozpraszających mechanizmów.
- **Dostępność cyfrowa** - rozwijanie aplikacji z myślą o wygodzie korzystania na telefonach i innych urządzeniach.

## Dla kogo powstaje aplikacja?

Potencjalnymi odbiorcami Poetry App są:

- osoby zainteresowane poezją, literaturą i kulturą;
- uczniowie i studenci;
- nauczyciele oraz osoby prowadzące zajęcia edukacyjne;
- miłośnicy słuchowisk i interpretacji aktorskich;
- aktorzy, poeci i inni twórcy;
- biblioteki, instytucje kultury oraz organizatorzy inicjatyw edukacyjnych.

W kolejnych etapach projekt może stać się narzędziem wspierającym działania edukacyjne i popularyzatorskie, w zależności od potrzeb odbiorców i partnerów.

## Jak będzie działać Poetry App?

Głównym elementem aplikacji będzie ekran z wybranymi materiałami literackimi. Użytkownik znajdzie na nim między innymi:

- **Wiersz na dziś** - wyróżnione nagranie audio lub wideo;
- **Poeci** - przestrzeń do odkrywania twórczości literackiej;
- **Artyści** - materiały związane z interpretacjami aktorskimi;
- **Wybrane dla Ciebie** - kolekcję polecanych materiałów.

Aplikacja będzie zawierać również nawigację umożliwiającą przejście do biblioteki materiałów i wyszukiwania.

Jednym z ważnych kierunków rozwoju jest wyświetlanie tekstu zsynchronizowanego z nagraniem. Dzięki temu odbiorca będzie mógł jednocześnie słuchać interpretacji i śledzić kolejne wersy utworu.

## Kierunek wizualny

Projekt czerpie inspirację z minimalistycznego podejścia do technologii, reprezentowanego między innymi przez urządzenia Mudita Kompakt.

Założeniem jest ograniczenie wizualnego hałasu i stworzenie interfejsu, który nie odciąga uwagi od treści. Projekt będzie wykorzystywał stonowaną paletę barw, czytelną typografię, wyraźną hierarchię informacji i proste elementy nawigacyjne.

Inspiracja dotyczy filozofii projektowania i charakteru interfejsu, a nie kopiowania wyglądu urządzeń lub identyfikacji wizualnej innych marek.

## Etapy rozwoju

### Etap 1 - Minimalna wersja aplikacji

- przygotowanie mobilnego interfejsu;
- prezentacja dostarczonych nagrań audio i wideo;
- podstawowe odtwarzanie materiałów;
- biblioteka i wyszukiwanie;
- przygotowanie architektury do przechowywania metadanych i tekstów.

### Etap 2 - Tekst towarzyszący nagraniu

- prezentowanie tekstu podczas odtwarzania;
- synchronizacja fragmentów tekstu z nagraniem;
- możliwość poprawiania transkrypcji;
- rozwijanie opisów materiałów i informacji o twórcach.

### Etap 3 - Rozwój funkcji edukacyjnych i kulturalnych

- rozbudowa katalogu literackiego;
- rozwój prezentacji poetów i aktorów;
- przygotowanie możliwości wykorzystania aplikacji podczas zajęć edukacyjnych;
- poszukiwanie partnerstw z twórcami i instytucjami kultury.

Kolejne etapy będą zależały od rezultatów prac nad pierwszą wersją, potrzeb odbiorców oraz dostępnych zasobów.

## Technologia i utrzymanie

Projekt zakłada wykorzystanie otwartych i powszechnie stosowanych technologii, w tym Java, Spring Boot, React i TypeScript.

Planowana architektura umożliwi oddzielenie interfejsu użytkownika od warstwy odpowiedzialnej za katalog materiałów, metadane i teksty. Pliki multimedialne będą przechowywane niezależnie od kodu aplikacji.

Automatyzacja budowania i wdrażania ma ułatwić utrzymanie projektu, aktualizowanie oprogramowania i dodawanie nowych materiałów bez konieczności przebudowy całej aplikacji.

Projekt jest rozwijany z myślą o lekkiej infrastrukturze serwerowej i kontrolowaniu kosztów utrzymania.

## Status projektu

Poetry App znajduje się na etapie przygotowania nowej wersji MVP. Obecny etap obejmuje doprecyzowanie założeń, projekt interfejsu i architektury oraz przygotowanie podstaw do dalszego rozwoju.

Opisane funkcje i etapy rozwoju przedstawiają założenia projektu, a nie deklarację, że wszystkie elementy zostały już wdrożone.

## Kierunek długofalowy

Poetry App ma rozwijać się jako cyfrowa przestrzeń łącząca literaturę, interpretację aktorską i edukację. Jej dalszy rozwój może obejmować współpracę z twórcami, bibliotekami, szkołami i instytucjami kultury.

Najważniejszym celem pozostaje stworzenie prostego narzędzia, które pozwala skupić się na poezji i ułatwia kontakt z literaturą w codziennym życiu.


## Deployment (QNAP)

The deployment uses a separate Compose project and the existing Docker network shared with the current Nginx and Cloudflare Tunnel. It does not define another reverse proxy, tunnel, or host port mapping.

### Files on the NAS

Keep the deployment files in:

`/share/CACHEDEV1_DATA/Container/poetryapp`

The Compose file uses a relative bind mount for PostgreSQL data, so the persistent database directory is:

`/share/CACHEDEV1_DATA/Container/poetryapp/postgres-data`

Media and import directories are not mounted into these containers at this stage. The current backend does not implement media streaming or import processing.

### Initial configuration

1. Copy `.env.example` to `.env`.
2. Set a long random `POSTGRES_PASSWORD`. Do not commit `.env` or share its contents.
3. Keep `CORS_ALLOWED_ORIGINS` aligned with the public origin configured later in the shared Nginx/Cloudflare setup.
4. Ensure the existing Docker network `poetrystream_shared-net` exists before starting this Compose project.

### Validate and start

Run these commands from the Poetry App deployment directory:

```sh
docker compose --env-file .env -f compose.yaml config
docker compose --env-file .env -f compose.yaml pull
docker compose --env-file .env -f compose.yaml up -d
docker compose --env-file .env -f compose.yaml ps
```

The PostgreSQL service is reachable only on the private Compose database network. The backend joins that network and the existing shared network; the frontend joins only the shared network. No service publishes a host port.

The images are published to GitHub Container Registry by the workflow after changes are merged to `main`. If the packages are private, authenticate the NAS Docker client to `ghcr.io` with a GitHub token that has `read:packages` permission before pulling.

### Important deployment boundary

This Compose project does not change the existing Nginx configuration, Cloudflare Tunnel routes, PoetryStream, or WorkDone. Public routing must be prepared as a separate, reviewed step. In particular, the existing WorkDone Discord interaction endpoint must remain reachable when its hostname is reused for the Poetry App frontend.

Do not run `docker compose down -v` on this project; the PostgreSQL volume contains persistent application data.


### Stage 5: import one local MP4 from QNAP

The running backend uses two additional bind mounts:
- `./incoming:/data/incoming:ro` — source files, never modified by the importer.
- `./media:/data/media:rw` — persistent imported files (outside images and Git).

The backend image runs as UID 100 / GID 101. Check host permissions and QNAP ACLs
before deployment. Do not change directory ownership recursively. Initially, the
configurable per-file safety limit is 2 GiB (`MEDIA_MAX_FILE_SIZE_BYTES`).
The import copies in 64 KiB chunks, not into heap memory.

After merging this stage, pulling published images, and reviewing the Compose diff:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp
docker compose --env-file .env -f compose.yaml config --quiet
docker compose --env-file .env -f compose.yaml pull
docker compose --env-file .env -f compose.yaml up -d
docker compose --env-file .env -f compose.yaml run --rm --no-deps poetryapp-backend \
  --spring.main.web-application-type=none \
  "--app.import.filename=Bialoszewski Sen Peszek.mp4" \
  "--app.import.title=Białoszewski - Sen Peszek"
```

The database must already be running and healthy. The command adds a published
catalog entry and copies the source MP4 into `media`, using a random storage key;
it never deletes the original `incoming` file. Check the result using
`GET /api/v1/media`. SHA-256 uniqueness keeps retries idempotent. Only files
with an MP4 `ftyp` header are accepted in this stage; the actual codecs and
playback are validated in the streaming stage, not assumed by the importer.

**Boundaries:** there is no public import endpoint, no video playback/Range
endpoint yet, no media directory exposed by Nginx, and no automatic scanning.
Do not run the command until the PR has passed CI, been merged, and the new
backend image has been published and deployed. Do not use `docker compose down -v`.
