import { ExternalLink } from "lucide-react";
import { youtubeWatchUrl } from "./youtubeSource";

export default function YouTubeEmbed({ videoId, title }: { videoId: string; title: string }) {
  const watchUrl = youtubeWatchUrl(videoId);
  if (!watchUrl) return null;

  return (
    <div className="youtube-player">
      <iframe
        title={"YouTube — " + title}
        src={"https://www.youtube-nocookie.com/embed/" + videoId}
        loading="eager"
        referrerPolicy="strict-origin-when-cross-origin"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowFullScreen
      />
      <p className="youtube-player-note">
        Gdy odtwarzanie tutaj jest niedostępne,{" "}
        <a href={watchUrl} target="_blank" rel="noopener noreferrer">
          obejrzyj w YouTube <ExternalLink size={13} aria-hidden="true" />
        </a>.
      </p>
    </div>
  );
}
