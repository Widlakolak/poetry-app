// Production catalog metadata is loaded from PostgreSQL via read-only API.
// Editorial source notes are kept separately; media associations use UUIDs.
export type CreatorRecord = {
  id: string;
  displayName: string;
  biography: string | null;
};

export type MediaRecord = {
  id: string;
  title: string;
  mediaType: string;
  sourceType: string;
  sourceUrl: string | null;
};

export type TranscriptSegment = {
  sequenceNumber: number;
  text: string;
  startMs: number | null;
  endMs: number | null;
};

export type TranscriptRecord = {
  mediaId: string;
  languageCode: string | null;
  fullText: string | null;
  status: "NOT_AVAILABLE" | "DRAFT" | "VERIFIED";
  startOffsetMs: number;
  segments: TranscriptSegment[];
};

export type RecordingRecord = {
  id: string;
  title: string;
  mediaType: string;
  sourceType: string;
};

export type WorkRecord = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  authorId: string;
  authorName: string;
  recordings: RecordingRecord[];
};

type CatalogPage<T> = {
  content: T[];
  page: number;
  totalPages: number;
};

function isObject(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function isMedia(value: unknown): value is MediaRecord {
  return isObject(value)
    && typeof value.id === "string"
    && typeof value.title === "string"
    && typeof value.mediaType === "string"
    && typeof value.sourceType === "string"
    && (value.sourceUrl === null || typeof value.sourceUrl === "string");
}

function isTranscript(value: unknown): value is TranscriptRecord {
  return isObject(value)
    && typeof value.mediaId === "string"
    && (value.languageCode === null || typeof value.languageCode === "string")
    && (value.fullText === null || typeof value.fullText === "string")
    && ["NOT_AVAILABLE", "DRAFT", "VERIFIED"].includes(String(value.status))
    && typeof value.startOffsetMs === "number" && Number.isSafeInteger(value.startOffsetMs)
    && value.startOffsetMs >= 0
    && Array.isArray(value.segments)
    && value.segments.every((segment: unknown) =>
      isObject(segment)
      && Number.isSafeInteger(segment.sequenceNumber) && (segment.sequenceNumber as number) >= 0
      && typeof segment.text === "string"
      && (segment.startMs === null || (Number.isSafeInteger(segment.startMs) && (segment.startMs as number) >= 0))
      && (segment.endMs === null || (Number.isSafeInteger(segment.endMs) && (segment.endMs as number) >= 0)));
}

function isRecording(value: unknown): value is RecordingRecord {
  return isObject(value)
    && typeof value.id === "string"
    && typeof value.title === "string"
    && typeof value.mediaType === "string"
    && typeof value.sourceType === "string";
}

function isCreator(value: unknown): value is CreatorRecord {
  return isObject(value)
    && typeof value.id === "string"
    && typeof value.displayName === "string"
    && (value.biography === null || typeof value.biography === "string");
}

function isWork(value: unknown): value is WorkRecord {
  return isObject(value)
    && typeof value.id === "string"
    && typeof value.slug === "string"
    && typeof value.title === "string"
    && (value.summary === null || typeof value.summary === "string")
    && typeof value.authorId === "string"
    && typeof value.authorName === "string"
    && Array.isArray(value.recordings)
    && value.recordings.every(isRecording);
}

function isPage<T>(
  value: unknown,
  isItem: (candidate: unknown) => candidate is T,
): value is CatalogPage<T> {
  return isObject(value)
    && Array.isArray(value.content)
    && value.content.every(isItem)
    && typeof value.page === "number"
    && Number.isInteger(value.page)
    && value.page >= 0
    && typeof value.totalPages === "number"
    && Number.isInteger(value.totalPages)
    && value.totalPages >= 0;
}

async function loadJson(url: string, signal: AbortSignal): Promise<unknown> {
  const response = await fetch(url, { signal });
  if (!response.ok) throw new Error("Catalog request failed: " + response.status);
  return (await response.json()) as unknown;
}

async function loadAllPages<T>(
  baseUrl: string,
  isItem: (candidate: unknown) => candidate is T,
  signal: AbortSignal,
): Promise<T[]> {
  const items: T[] = [];
  let page = 0;
  while (true) {
    const separator = baseUrl.includes("?") ? "&" : "?";
    const payload = await loadJson(baseUrl + separator + "page=" + page + "&size=100", signal);
    if (!isPage(payload, isItem) || payload.page !== page) {
      throw new Error("Invalid catalog page response");
    }
    items.push(...payload.content);
    if (page + 1 >= payload.totalPages) return items;
    page += 1;
  }
}

export function fetchMedia(signal: AbortSignal): Promise<MediaRecord[]> {
  return loadAllPages("/api/v1/media", isMedia, signal);
}

export async function fetchMediaById(id: string, signal: AbortSignal): Promise<MediaRecord | null> {
  const response = await fetch("/api/v1/media/" + encodeURIComponent(id), { signal });
  if (response.status === 404) return null;
  if (!response.ok) throw new Error("Media request failed: " + response.status);
  const payload: unknown = await response.json();
  if (!isMedia(payload) || payload.id !== id) throw new Error("Invalid media response");
  return payload;
}

export async function fetchTranscript(id: string, signal: AbortSignal): Promise<TranscriptRecord | null> {
  const response = await fetch("/api/v1/media/" + encodeURIComponent(id) + "/transcript", { signal });
  if (response.status === 404) return null;
  if (!response.ok) throw new Error("Transcript request failed: " + response.status);
  const payload: unknown = await response.json();
  if (!isTranscript(payload) || payload.mediaId !== id) throw new Error("Invalid transcript response");
  return payload;
}

export function fetchPoets(signal: AbortSignal): Promise<CreatorRecord[]> {
  return loadAllPages("/api/v1/creators?role=POET", isCreator, signal);
}

export function fetchArtists(signal: AbortSignal): Promise<CreatorRecord[]> {
  return loadAllPages("/api/v1/creators?role=ARTIST", isCreator, signal);
}

export function fetchArtistRecordings(
  creatorId: string,
  signal: AbortSignal,
): Promise<RecordingRecord[]> {
  return loadAllPages(
    "/api/v1/creators/" + encodeURIComponent(creatorId) + "/media?role=ARTIST",
    isRecording,
    signal,
  );
}

export function fetchWorks(signal: AbortSignal): Promise<WorkRecord[]> {
  return loadAllPages("/api/v1/works", isWork, signal);
}

export async function fetchWork(slug: string, signal: AbortSignal): Promise<WorkRecord | null> {
  const response = await fetch("/api/v1/works/" + encodeURIComponent(slug), { signal });
  if (response.status === 404) return null;
  if (!response.ok) throw new Error("Work request failed: " + response.status);
  const payload: unknown = await response.json();
  if (!isWork(payload) || payload.slug !== slug) {
    throw new Error("Invalid work response");
  }
  return payload;
}

// The creator API has no slug yet. Derive current readable links from the
// confirmed catalog display name, never from media filenames or IDs.
export function creatorSlug(displayName: string): string {
  return displayName
    .replace(/ł/g, "l")
    .replace(/Ł/g, "L")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}
