import { useEffect, useState } from "react";
import { UsersRound } from "lucide-react";
import { creatorSlug, fetchArtists, type CreatorRecord } from "./catalogApi";

export default function ArtistsPreview() {
  const [artists, setArtists] = useState<CreatorRecord[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");

  useEffect(() => {
    const controller = new AbortController();
    void fetchArtists(controller.signal)
      .then((records) => {
        if (controller.signal.aborted) return;
        setArtists(records);
        setStatus("ready");
      })
      .catch(() => {
        if (!controller.signal.aborted) setStatus("error");
      });

    return () => controller.abort();
  }, []);

  if (status !== "ready" || artists.length === 0) {
    const message = status === "loading"
      ? "Wczytywanie katalogu artystów…"
      : status === "error"
        ? "Nie udało się wczytać katalogu artystów."
        : "Nie ma jeszcze opublikowanych interpretacji z przypisanym wykonawcą.";

    return (
      <div className="collection-placeholder">
        <div className="empty-collection">
          <span className="empty-collection-mark" aria-hidden="true">
            <UsersRound size={21} strokeWidth={1.6} />
          </span>
          <p role="status">{message}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="poet-preview-list">
      {artists.map((artist) => (
        <a className="poet-preview" href={"/artysci/" + creatorSlug(artist.displayName)} key={artist.id}>
          <span className="poet-preview-mark" aria-hidden="true">
            <UsersRound size={23} strokeWidth={1.5} />
          </span>
          <span>
            <strong>{artist.displayName}</strong>
            <small>Zobacz interpretacje w bibliotece</small>
          </span>
        </a>
      ))}
    </div>
  );
}
