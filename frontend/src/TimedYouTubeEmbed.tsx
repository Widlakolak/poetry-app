import { useEffect, useRef, useState } from "react";
import { youtubeWatchUrl } from "./youtubeSource";

type Player = { getCurrentTime(): number; getDuration(): number; destroy(): void };
type YouTubeApi = { Player: new (element: HTMLElement, options: { events: {
  onReady: () => void; onError: () => void;
} }) => Player };
type YouTubeWindow = Window & { YT?: YouTubeApi };

// Only the dedicated recording page loads the official IFrame API.
export default function TimedYouTubeEmbed({ videoId, title, onTime, onDuration }: {
  videoId: string; title: string; onTime: (ms: number) => void; onDuration: (ms: number) => void;
}) {
  const host = useRef<HTMLDivElement>(null);
  const [syncFailed, setSyncFailed] = useState(false);
  useEffect(() => {
    const container = host.current;
    if (!container) return;
    setSyncFailed(false);
    const iframe = document.createElement("iframe");
    iframe.title = "YouTube — " + title;
    iframe.src = "https://www.youtube-nocookie.com/embed/" + videoId
      + "?enablejsapi=1&playsinline=1&origin=" + encodeURIComponent(window.location.origin);
    iframe.referrerPolicy = "strict-origin-when-cross-origin";
    iframe.allow = "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture; web-share";
    iframe.allowFullscreen = true;
    container.appendChild(iframe);

    let player: Player | undefined;
    let ready = false;
    let disposed = false;
    let failure = false;
    let elapsed = 0;
    const apiWindow = window as YouTubeWindow;
    if (!apiWindow.YT?.Player && !document.querySelector('script[src="https://www.youtube.com/iframe_api"]')) {
      const script = document.createElement("script");
      script.src = "https://www.youtube.com/iframe_api";
      script.async = true;
      document.head.appendChild(script);
    }
    function fail() {
      if (disposed) return;
      failure = true;
      ready = false;
      setSyncFailed(true);
      onTime(0);
      onDuration(0);
    }
    const interval = window.setInterval(() => {
      if (disposed || failure) return;
      elapsed += 250;
      if (!player && apiWindow.YT?.Player) {
        try {
          player = new apiWindow.YT.Player(iframe, { events: {
            onReady: () => { if (!disposed) { ready = true; failure = false; setSyncFailed(false); } },
            onError: fail,
          } });
        } catch { fail(); }
      }
      if (!ready) {
        if (elapsed >= 20000) fail();
        return;
      }
      try {
        const time = player?.getCurrentTime();
        const duration = player?.getDuration();
        if (typeof time === "number" && Number.isFinite(time)) onTime(Math.max(0, Math.floor(time * 1000)));
        if (typeof duration === "number" && Number.isFinite(duration)) onDuration(Math.max(0, Math.floor(duration * 1000)));
      } catch { fail(); }
    }, 250);
    return () => {
      disposed = true;
      window.clearInterval(interval);
      try { player?.destroy(); } catch { /* The iframe may already have been removed. */ }
      container.replaceChildren();
    };
  }, [videoId, title, onTime, onDuration]);

  const watchUrl = youtubeWatchUrl(videoId);
  return <div className="youtube-player">
    <div ref={host} className="timed-youtube-frame" />
    {syncFailed ? <p className="transcript-note" role="status">Synchronizacja z YouTube jest niedostępna. Tekst można nadal czytać ręcznie.</p> : null}
    {watchUrl ? <p className="youtube-player-note">Problemy z odtwarzaniem? <a href={watchUrl} target="_blank" rel="noopener noreferrer">Obejrzyj w YouTube</a>.</p> : null}
  </div>;
}
