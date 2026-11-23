import { useEffect, useState } from "react";
import { BookOpen } from "lucide-react";
import { creatorSlug, fetchPoets, type CreatorRecord } from "./catalogApi";
import HorizontalCardRail from "./HorizontalCardRail";

export default function PoetsPreview() {
  const [creators, setCreators] = useState<CreatorRecord[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [retry, setRetry] = useState(0);

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");

    void fetchPoets(controller.signal)
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
      ? "Wczytywanie katalogu poetów…"
      : status === "error"
        ? "Nie udało się wczytać katalogu poetów."
        : "Katalog poetów pojawi się, gdy dostępne będą dane twórców.";

    return (
      <div className="collection-placeholder">
        <div className="empty-collection">
          <span className="empty-collection-mark" aria-hidden="true">
            <BookOpen size={21} strokeWidth={1.6} />
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
      labelledBy="poets-title"
      label="Poeci"
      items={creators.map((creator) => ({
        key: creator.id,
        content: (
          <a className="catalog-person-card" href={"/poeci/" + creatorSlug(creator.displayName)}>
            <span className="catalog-person-mark" aria-hidden="true">
              <BookOpen size={26} strokeWidth={1.5} />
            </span>
            <span className="catalog-person-role">POETA</span>
            <strong>{creator.displayName}</strong>
            <small>Poznaj twórczość i nagrania</small>
          </a>
        ),
      }))}
    />
  );
}
