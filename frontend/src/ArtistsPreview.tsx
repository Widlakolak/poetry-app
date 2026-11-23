import { useEffect, useState } from "react";
import { UsersRound } from "lucide-react";
import { creatorSlug, fetchArtists, type CreatorRecord } from "./catalogApi";
import HorizontalCardRail from "./HorizontalCardRail";

export default function ArtistsPreview() {
  const [creators, setCreators] = useState<CreatorRecord[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [retry, setRetry] = useState(0);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");

    void fetchArtists(controller.signal)
      .then((records) => {
        if (controller.signal.aborted) return;
        setCreators(records);
        setStatus("ready");
      })
      .catch(() => {
        if (!controller.signal.aborted) setStatus("error");
      });

    return () => controller.abort();
  }, [retry]);

  if (status !== "ready" || creators.length === 0) {
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
          <div>
            <p role="status">{message}</p>
            {status === "error" ? (
              <button className="library-action collection-retry" type="button" onClick={() => setRetry((value) => value + 1)}>
                Spróbuj ponownie
              </button>
            ) : null}
          </div>
        </div>
      </div>
    );
  }

  return (
    <HorizontalCardRail
      labelledBy="artists-title"
      label="Artyści"
      items={creators.map((creator) => ({
        key: creator.id,
        content: (
          <a className="catalog-person-card" href={"/artysci/" + creatorSlug(creator.displayName)}>
            <span className="catalog-person-mark" aria-hidden="true">
              <UsersRound size={26} strokeWidth={1.5} />
            </span>
            <span className="catalog-person-role">WYKONAWCA</span>
            <strong>{creator.displayName}</strong>
            <small>Poznaj interpretacje i nagrania</small>
          </a>
        ),
      }))}
    />
  );
}
