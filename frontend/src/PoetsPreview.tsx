import { useEffect, useState } from "react";
import { BookOpen } from "lucide-react";
import { creatorSlug, fetchPoets, type CreatorRecord } from "./catalogApi";

export default function PoetsPreview() {
  const [poets, setPoets] = useState<CreatorRecord[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");

  useEffect(() => {
    const controller = new AbortController();

    void fetchPoets(controller.signal)
      .then((records) => {
        if (controller.signal.aborted) return;
        setPoets(records);
        setStatus("ready");
      })
      .catch(() => {
        if (!controller.signal.aborted) setStatus("error");
      });

    return () => controller.abort();
  }, []);

  if (status !== "ready" || poets.length === 0) {
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
          <p role="status">{message}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="poet-preview-list">
      {poets.map((entry) => (
        <a className="poet-preview" href={"/poeci/" + creatorSlug(entry.displayName)} key={entry.id}>
          <span className="poet-preview-mark" aria-hidden="true">
            <BookOpen size={23} strokeWidth={1.5} />
          </span>
          <span>
            <strong>{entry.displayName}</strong>
            <small>Poznaj twórczość i utwory w bibliotece</small>
          </span>
        </a>
      ))}
    </div>
  );
}
