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

### Etap 4 - Napisy zsynchronizowane z odtwarzaniem

- wyświetlanie zatwierdzonego tekstu wiersza lub transkrypcji jako napisów podczas odtwarzania MP3 i MP4;
- powiązanie fragmentów tekstu ze znacznikami czasu, aby aktualny wers lub wypowiedź pojawiała się dokładnie w odpowiednim momencie;
- automatyczne przewijanie i dyskretne podświetlanie aktualnego fragmentu (opcjonalny tryb karaoke), z możliwością wyłączenia napisów;
- utrzymanie synchronizacji po pauzie i przewijaniu nagrania;
- przygotowanie lub korekta transkrypcji i czasów przed publikacją; ewentualna automatyczna transkrypcja może wspomagać przygotowanie materiału, ale nie jest wymagana podczas każdego odtworzenia;
- udostępnianie napisów tylko wtedy, gdy istnieje zweryfikowany tekst i odpowiednie prawa do jego publikacji.

Napisy „w czasie rzeczywistym” oznaczają tutaj synchronizację z bieżącym czasem odtwarzania, a nie kosztowne rozpoznawanie mowy na żywo przy każdym odsłuchaniu. Etap będzie realizowany po zatwierdzeniu zakresu i przygotowaniu wiarygodnych tekstów nagrań.

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

The Compose deployment mounts `incoming` read-only and `media` read-write into the backend. The import command and MP4 streaming endpoint use those mounts.

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

### Stage 6: MP4 streaming with HTTP Range

The backend serves **published local MP4** files from the existing `media`
mount via `GET /api/v1/media/{id}/stream`. Files remain outside Docker
images and Git; the public API never exposes a storage key or file path.
Only records marked `PUBLISHED` with `LOCAL_FILE` and `VIDEO` can stream.
Unknown/unpublished records, unavailable files, and invalid storage keys
return 404.

Spring MVC's built-in Resource handling supports HTTP byte-range requests.
The endpoint uses a `FileSystemResource`, not an `InputStreamResource`, so a
video player can seek without copying the entire file into Java heap memory.
The frontend player will be connected in the next, separate stage.

After reviewing and merging this stage, let GitHub Actions publish the backend
image; then update **only the Poetry App backend** on QNAP:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp
docker compose --env-file .env -f compose.yaml pull poetryapp-backend
docker compose --env-file .env -f compose.yaml up -d --no-deps poetryapp-backend
```

Once the backend is ready, verify the imported video's byte ranges through
the existing public domain (without downloading the whole 572 MB):

```sh
curl -sS -o /dev/null -D - \
  -H 'Range: bytes=0-1023' \
  https://workdone.qzz.io/api/v1/media/576a370b-2fb0-4ade-8e80-9d99a1fa5313/stream
```

Expected: `206 Partial Content`, `Content-Range: bytes 0-1023/TOTAL`,
`Content-Type: video/mp4` and `Accept-Ranges: bytes`. Also test a
request near the end of the file and an unknown UUID (404).

No new mounts, Nginx configuration, Cloudflare Tunnel, database migrations,
or frontend changes are needed in this stage. Nginx continues to reverse-proxy
`/api/` to `poetryapp-backend` and retains the WorkDone Discord endpoint
exception. Avoid manually modifying file permissions.


### Stage 7: play the first imported MP4 in the existing home screen

The `Wiersz na dziś` card keeps its original cover and layout. It fetches the
published catalog from `GET /api/v1/media?size=100` and selects the known,
actually imported local-video title `Białoszewski - Sen Peszek`. The Play
button stays disabled if this item cannot be found or the API request fails.
No media UUID, storage key, filesystem path, or media file is compiled into the
frontend image. The featured artwork is replaced with a native HTML5 video
element only when the user presses Play. A close button returns to the same
cover. Native controls provide play/pause, seek, volume and fullscreen when
supported by the browser.

Video source: `/api/v1/media/{id}/stream`, same origin as the existing catalog,
using the Stage 6 HTTP Range backend. The browser requests byte ranges; no
JavaScript blob download, transcoding, or extra media service is introduced.

After merging and a successful GHCR publish, update **only the Poetry App
frontend** on QNAP:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp
docker compose --env-file .env -f compose.yaml pull poetryapp-frontend
docker compose --env-file .env -f compose.yaml up -d --no-deps poetryapp-frontend
docker compose --env-file .env -f compose.yaml ps
```

Then open `https://workdone.qzz.io/` in a normal browser:
1. The existing home layout and section order must stay unchanged.
2. The first card must show `GOTOWE DO ODTWORZENIA` and an enabled Play button.
3. Press Play: the actual imported film should play with native controls.
4. Seek to a later position and verify playback continues.
5. Close the player: the original cover returns.
6. Reload the page and verify playback is not automatically started.

If the browser reports a playback failure, inspect its Network tab for the
`/api/v1/media/{id}/stream` request, including status code and response
headers. The previous Stage 6 server-side test confirmed
`206 Partial Content` over Cloudflare for this film, but client codec and
seek behavior still need a browser test.

No changes to Compose, Nginx, Cloudflare Tunnel, PostgreSQL, or WorkDone are
part of Stage 7. Future catalog/search, audio, favorites and transcript
features remain separate stages.


### Stage 8: Browse the published media library

The existing bottom navigation now opens the **Biblioteka** view. Its list is
loaded from the existing, read-only `GET /api/v1/media?page=N&size=20`
endpoint. It displays only real published items returned by the API, without
seed content or filesystem paths. The page provides previous/next pagination,
a clear empty state, and retry when the API is unavailable.

A published `VIDEO / LOCAL_FILE` item can play directly in the library using
the existing `/api/v1/media/{id}/stream` endpoint and native HTML5 controls.
Switching items or leaving the library unmounts the previous video, stopping
playback. Other source types are listed without a misleading Play button until
their playback support has been implemented.

The **Wiersz na dziś**, **Poeci**, **Artyści** and **Wybrane dla Ciebie**
home-screen sections and their layout remain unchanged. Search, favorites,
audio import/streaming, and YouTube playback are not enabled in this stage.

After CI success, merge the PR, confirm the GHCR frontend publish is successful,
then update *only* the Poetry App frontend:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp
docker compose --env-file .env -f compose.yaml pull poetryapp-frontend
docker compose --env-file .env -f compose.yaml up -d --no-deps poetryapp-frontend
docker compose --env-file .env -f compose.yaml ps
```

Manually verify on `https://workdone.qzz.io/`:
1. The home screen and featured MP4 still play as before.
2. Tap **Biblioteka** to see the actual published film.
3. Play and seek in the library; close the player.
4. Return to **Ekran główny**; its layout remains unchanged.
5. The navigation buttons for unimplemented features stay disabled.
6. When more than 20 items exist, next/previous should page through them;
   with one item both pagination controls stay disabled.

Only the frontend and README change. No new backend, database, Nginx,
Cloudflare Tunnel, Compose, or Docker mount configuration is required.


### Stage 9: Import and play local MP3 audio

The existing one-off importer now accepts **MP3** files in addition to MP4.
It identifies the format by the source extension and performs a lightweight
MP3/MPEG Layer III frame-header check, including files beginning with an
ID3v2 tag. It still validates paths and file limits, copies in small chunks,
calculates SHA-256, prevents duplicate records, and preserves the original
file in read-only `incoming`. New MP3 objects use UUID storage keys with
`.mp3`, `AUDIO / LOCAL_FILE`, and `audio/mpeg` metadata.

The existing `GET /api/v1/media/{id}/stream` route supports published
local MP3 files with `Content-Type: audio/mpeg` and byte ranges. Existing
MP4 behavior stays unchanged. The frontend library now shows an audio Play
button and native HTML5 audio controls; it does not fabricate artists,
poets, titles or transcripts.

**Do not import automatically.** First inspect the real MP3 files on QNAP,
verify the desired title and permission to publish each recording, and
then manually launch a one-off import. Provide the chosen file and display
title as shell variables:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp

# Set these variables to the confirmed exact filename and display title.
MP3_FILENAME='exact-filename.mp3'
DISPLAY_TITLE='Confirmed recording title'

docker compose --env-file .env -f compose.yaml run --rm --no-deps poetryapp-backend \
  --spring.main.web-application-type=none \
  "--app.import.filename=$MP3_FILENAME" \
  "--app.import.title=$DISPLAY_TITLE"
```

The above values are illustrative and **must be replaced** after checking the
source content; no automatic naming or bulk import is implemented.

Deploy in this order after CI, merge and successful GHCR image publishing:

```sh
cd /share/CACHEDEV1_DATA/Container/poetryapp
docker compose --env-file .env -f compose.yaml pull poetryapp-backend poetryapp-frontend
docker compose --env-file .env -f compose.yaml up -d --no-deps poetryapp-backend poetryapp-frontend
docker compose --env-file .env -f compose.yaml ps
```

Once both services are ready, import one confirmed MP3 and check
`GET /api/v1/media`. For the returned audio ID, test a small HTTP range
request instead of fetching the full MP3:

```sh
curl -sS -o /dev/null -D - -H 'Range: bytes=0-1023' \
  "https://workdone.qzz.io/api/v1/media/ACTUAL_AUDIO_UUID/stream"
```

Expected: `206 Partial Content`, `Content-Type: audio/mpeg`,
`Accept-Ranges: bytes`. Finally verify audio play, pause, seeking and
switching between audio and existing video in the **Biblioteka** tab. Recheck
the home-screen MP4 player.

The initial MP3 validation is not a full audio decoder. Files with
unusual tag padding or unsupported frame headers may require inspection
rather than forced import. WAV, YouTube and automatic folder scanning are
not included. No new migrations, mounts, services or routing changes are
required; do not change QNAP permissions or use `docker compose down -v`.
