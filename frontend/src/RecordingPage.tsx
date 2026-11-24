import { useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, BookOpen, Captions, CaptionsOff, Music2 } from "lucide-react";
import { fetchMediaById, fetchTranscripts, fetchWorks, type MediaRecord, type TranscriptRecord, type WorkRecord } from "./catalogApi";
import { playbackSource } from "./playbackSource";
import TimedYouTubeEmbed from "./TimedYouTubeEmbed";

type LoadedRecording = {
  media: MediaRecord;
  transcripts: TranscriptRecord[];
  works: WorkRecord[];
};

function activeLineAt(
  transcript: TranscriptRecord,
  currentMs: number,
  durationMs: number,
): number {
  const segments = transcript.segments;
  if (segments.length === 0 || durationMs <= 0) return -1;

  const preciselyTimed = segments.every((segment) =>
    segment.startMs !== null && segment.endMs !== null);
  if (preciselyTimed) {
    for (let i = segments.length - 1; i >= 0; i--) {
      const segment = segments[i];
      if (segment.startMs !== null && segment.endMs !== null
          && currentMs >= segment.startMs && currentMs < segment.endMs) return i;
    }
    return -1;
  }

  // PoetryStream exported order and initial offset, but no per-line times.
  // Show an explicitly labeled approximate progression, never claim precise cues.
  const start = transcript.startOffsetMs;
  if (durationMs <= start || currentMs < start) return -1;
  const portion = Math.min(0.999999, Math.max(0, (currentMs - start) / (durationMs - start)));
  return Math.min(segments.length - 1, Math.floor(portion * segments.length));
}

function SynchronizedText({
  transcript,
  currentMs,
  durationMs,
}: {
  transcript: TranscriptRecord;
  currentMs: number;
  durationMs: number;
}) {
  const listRef = useRef<HTMLDivElement>(null);
  const activeLine = useMemo(
    () => activeLineAt(transcript, currentMs, durationMs),
    [transcript, currentMs, durationMs],
  );
  const isPreciselyTimed = transcript.segments.length > 0 && transcript.segments.every(
    (part) => part.startMs !== null && part.endMs !== null,
  );

  useEffect(() => {
    if (activeLine < 0) return;
    const container = listRef.current;
    const element = container?.querySelector<HTMLElement>('[data-line="' + activeLine + '"]');
    if (!container || !element) return;

    const center = element.offsetTop - container.offsetTop
      - container.clientHeight / 2 + element.clientHeight / 2;
    container.scrollTo({
      top: Math.max(0, center),
      behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "instant" : "smooth",
    });
  }, [activeLine, transcript]);

  const lines = transcript.segments.length > 0
    ? transcript.segments.map((segment) => segment.text)
    : (transcript.fullText ?? "").split(/\r?\n/).filter(Boolean);

  return (
    <section className="transcript-section" aria-label="Tekst nagrania" lang={transcript.languageCode ?? undefined}>
      <h2>{transcript.languageCode === "en" ? "Poem text" : "Tekst wiersza"}</h2>
      {transcript.translatorName ? <p className="transcript-note">Tłum. {transcript.translatorName}</p> : null}
      <p className="transcript-note">
        {durationMs <= 0 || transcript.segments.length === 0
          ? "Tekst do czytania — synchronizacja nie jest obecnie dostępna."
          : isPreciselyTimed
          ? (transcript.status === "VERIFIED"
              ? "Zweryfikowane znaczniki czasu"
              : "Znaczniki czasu — transkrypcja robocza")
          : "Synchronizacja orientacyjna — oryginalne nagranie nie ma dokładnych znaczników czasu."}
      </p>
      <div ref={listRef} className="transcript-lines" aria-live="off">
        {lines.map((text, index) => (
          <p
            key={index}
            data-line={index}
            className={"transcript-line" + (index === activeLine ? " transcript-line-active" : "")}
            aria-current={index === activeLine ? "true" : undefined}
          >
            {text}
          </p>
        ))}
      </div>
    </section>
  );
}

export default function RecordingPage({ id }: { id: string }) {
  const [loaded, setLoaded] = useState<LoadedRecording | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "not-found" | "error">("loading");
  const [retry, setRetry] = useState(0);
  const [showCaptions, setShowCaptions] = useState(true);
  const [language, setLanguage] = useState<"pl" | "en">("pl");
  const [captionError, setCaptionError] = useState(false);
  const [currentMs, setCurrentMs] = useState(0);
  const [durationMs, setDurationMs] = useState(0);
  const [playError, setPlayError] = useState(false);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");
    setLoaded(null);
    setPlayError(false);
    setCaptionError(false);
    setCurrentMs(0);
    setDurationMs(0);

    void Promise.all([
      fetchMediaById(id, controller.signal),
      fetchTranscripts(id, controller.signal).catch(() => {
        if (!controller.signal.aborted) setCaptionError(true);
        return [] as TranscriptRecord[];
      }),
      fetchWorks(controller.signal).catch(() => [] as WorkRecord[]),
    ]).then(([media, transcripts, works]) => {
      if (controller.signal.aborted) return;
      if (!media) { setStatus("not-found"); return; }
      setLoaded({ media, transcripts, works: works.filter((work) =>
        work.recordings.some((recording) => recording.id === id)) });
      setLanguage(transcripts.some((t) => t.languageCode === "pl") ? "pl" : "en");
      setStatus("ready");
    }).catch(() => {
      if (!controller.signal.aborted) setStatus("error");
    });
    return () => controller.abort();
  }, [id, retry]);

  if (status === "loading") return <main className="home-content editorial-content" role="status">Wczytywanie nagrania…</main>;
  if (status === "not-found") return <main className="home-content editorial-content"><h1>Nie znaleziono nagrania.</h1><a href="/biblioteka">Biblioteka</a></main>;
  if (status === "error" || !loaded) {
    return (
      <main className="home-content editorial-content">
        <p role="alert">Nie udało się wczytać nagrania.</p>
        <button className="library-action" onClick={() => setRetry((value) => value + 1)}>Spróbuj ponownie</button>
      </main>
    );
  }

  const source = playbackSource(loaded.media);
  const tracks = loaded.transcripts.filter((track) => track.status !== "NOT_AVAILABLE"
    && Boolean(track.fullText || track.segments.length));
  const selectedTranscript = tracks.find((track) => track.languageCode === language)
    ?? tracks.find((track) => track.languageCode !== "pl" && track.languageCode !== "en");
  const captionsAvailable = selectedTranscript !== undefined;
  const hasLanguage = (code: string) => tracks.some((track) => track.languageCode === code);

  const mediaControls = source?.kind === "audio" ? (
    <audio
      key={loaded.media.id}
      controls
      controlsList="nodownload"
      preload="metadata"
      src={source.src}
      aria-label={"Odtwarzanie: " + loaded.media.title}
      onTimeUpdate={(event) => setCurrentMs(Math.floor(event.currentTarget.currentTime * 1000))}
      onSeeked={(event) => setCurrentMs(Math.floor(event.currentTarget.currentTime * 1000))}
      onLoadedMetadata={(event) => setDurationMs(
        Number.isFinite(event.currentTarget.duration) ? Math.floor(event.currentTarget.duration * 1000) : 0)}
      onDurationChange={(event) => setDurationMs(
        Number.isFinite(event.currentTarget.duration) ? Math.floor(event.currentTarget.duration * 1000) : 0)}
      onError={() => setPlayError(true)}
    >
      Twoja przeglądarka nie obsługuje nagrań audio.
    </audio>
  ) : source?.kind === "video" ? (
    <video
      key={loaded.media.id}
      controls
      controlsList="nodownload"
      playsInline
      preload="metadata"
      src={source.src}
      aria-label={"Odtwarzanie: " + loaded.media.title}
      onTimeUpdate={(event) => setCurrentMs(Math.floor(event.currentTarget.currentTime * 1000))}
      onSeeked={(event) => setCurrentMs(Math.floor(event.currentTarget.currentTime * 1000))}
      onLoadedMetadata={(event) => setDurationMs(
        Number.isFinite(event.currentTarget.duration) ? Math.floor(event.currentTarget.duration * 1000) : 0)}
      onDurationChange={(event) => setDurationMs(
        Number.isFinite(event.currentTarget.duration) ? Math.floor(event.currentTarget.duration * 1000) : 0)}
      onError={() => setPlayError(true)}
    >
      Twoja przeglądarka nie obsługuje nagrań wideo.
    </video>
  ) : source?.kind === "youtube" ? (
    <TimedYouTubeEmbed videoId={source.videoId} title={loaded.media.title} onTime={setCurrentMs} onDuration={setDurationMs} />
  ) : (
    <p className="library-unavailable">To nagranie nie ma obsługiwanego źródła.</p>
  );

  return (
    <main className="home-content editorial-content recording-detail">
      <a className="editorial-back" href="/">
        <ArrowLeft size={17} aria-hidden="true" /> Ekran główny
      </a>
      <header className="editorial-hero">
        <p className="eyebrow">ODKRYWAJ NAGRANIA</p>
        <h1>{loaded.media.title}</h1>
        <p className="editorial-meta">{loaded.media.mediaType === "VIDEO" ? "Wideo" : "Audio"}</p>
        {loaded.works.map((work) => (
          <a className="recording-work-link" href={"/utwory/" + work.slug} key={work.id}>
            <BookOpen size={16} aria-hidden="true" /> {work.title} · {work.authorName}
          </a>
        ))}
      </header>
      <section className="editorial-panel recording-player-panel" aria-label="Odtwarzacz">
        <div className="recording-player-top">
          <h2><Music2 size={19} aria-hidden="true" /> Odtwarzaj</h2>
          <button
            className="library-action"
            type="button"
            disabled={tracks.length === 0}
            onClick={() => setShowCaptions((value) => !value)}
            aria-pressed={tracks.length > 0 && showCaptions}
          >
            {showCaptions ? <CaptionsOff size={17} aria-hidden="true" /> : <Captions size={17} aria-hidden="true" />}
            {showCaptions ? "Wyłącz napisy" : "Włącz napisy"}
          </button>
        </div>
        <div className="recording-player-media">{mediaControls}</div>
        <div className="caption-language-picker" role="group" aria-label="Język napisów">
          {(["pl", "en"] as const).map((code) => {
            const available = hasLanguage(code);
            const label = code === "pl" ? "Polski" : "English";
            return <button key={code} className="caption-flag" type="button" disabled={!available}
              title={label + (available ? "" : " — napisy niedostępne")}
              aria-label={label + (available ? "" : " — napisy niedostępne")}
              aria-pressed={available && language === code} onClick={() => setLanguage(code)}>
              <LanguageFlag language={code} />
            </button>;
          })}
        </div>
        {playError ? <p className="library-error" role="alert">Nie udało się odtworzyć źródła nagrania.</p> : null}
        {captionError ? <p className="transcript-note" role="alert">Nie udało się wczytać napisów. <button className="library-action" onClick={() => setRetry((value) => value + 1)}>Spróbuj ponownie</button></p>
          : !captionsAvailable ? <p className="transcript-note">Dla tego nagrania nie ma jeszcze dostępnych napisów.</p> : null}
      </section>
      {captionsAvailable && showCaptions && selectedTranscript ? (
        <SynchronizedText key={selectedTranscript.languageCode ?? "und"} transcript={selectedTranscript} currentMs={currentMs} durationMs={durationMs} />
      ) : null}
    </main>
  );
}

// SVG flags render consistently even on Windows, where flag emoji may be letters.
function LanguageFlag({ language }: { language: "pl" | "en" }) {
  return language === "pl" ? <svg viewBox="0 0 60 36" aria-hidden="true" focusable="false">
    <rect width="60" height="18" fill="#fff" /><rect y="18" width="60" height="18" fill="#dc143c" />
  </svg> : <svg viewBox="0 0 60 36" aria-hidden="true" focusable="false">
    <rect width="60" height="36" fill="#012169" />
    <path d="M0 0L60 36M60 0L0 36" stroke="#fff" strokeWidth="7" />
    <path d="M0 0L60 36M60 0L0 36" stroke="#c8102e" strokeWidth="3" />
    <path d="M30 0V36M0 18H60" stroke="#fff" strokeWidth="12" />
    <path d="M30 0V36M0 18H60" stroke="#c8102e" strokeWidth="7" />
  </svg>;
}
