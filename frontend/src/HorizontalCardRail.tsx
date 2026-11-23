import { useEffect, useId, useRef, useState, type KeyboardEvent, type ReactNode } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";

export type RailItem = {
  key: string;
  content: ReactNode;
};

type HorizontalCardRailProps = {
  labelledBy: string;
  label: string;
  items: RailItem[];
};

export default function HorizontalCardRail({ labelledBy, label, items }: HorizontalCardRailProps) {
  const trackRef = useRef<HTMLUListElement>(null);
  const trackId = useId();
  const [position, setPosition] = useState({
    overflow: false,
    previous: false,
    next: false,
  });

  useEffect(() => {
    const track = trackRef.current;
    if (!track) return;

    function updatePosition() {
      if (!track) return;
      const maxScroll = Math.max(0, track.scrollWidth - track.clientWidth);
      const nextPosition = {
        overflow: maxScroll > 2,
        previous: track.scrollLeft > 2,
        next: track.scrollLeft < maxScroll - 2,
      };
      setPosition((current) =>
        current.overflow === nextPosition.overflow &&
        current.previous === nextPosition.previous &&
        current.next === nextPosition.next
          ? current : nextPosition
      );
    }

    updatePosition();
    track.addEventListener("scroll", updatePosition, { passive: true });

    const resizeObserver = new ResizeObserver(updatePosition);
    resizeObserver.observe(track);

    return () => {
      track.removeEventListener("scroll", updatePosition);
      resizeObserver.disconnect();
    };
  }, [items.length]);

  function scrollOneCard(direction: -1 | 1) {
    const track = trackRef.current;
    if (!track) return;

    const card = track.querySelector<HTMLElement>(".catalog-rail-item");
    const gap = Number.parseFloat(window.getComputedStyle(track).columnGap) || 0;
    const step = card ? card.getBoundingClientRect().width + gap : track.clientWidth;

    track.scrollBy({
      left: direction * step,
      behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "instant" : "smooth",
    });
  }

  function onTrackKeyDown(event: KeyboardEvent<HTMLUListElement>) {
    // Keep keyboard interaction inside links, buttons and media players intact.
    if (event.target !== event.currentTarget) return;

    if (event.key === "ArrowRight") {
      event.preventDefault();
      scrollOneCard(1);
    } else if (event.key === "ArrowLeft") {
      event.preventDefault();
      scrollOneCard(-1);
    } else if (event.key === "Home") {
      event.preventDefault();
      trackRef.current?.scrollTo({ left: 0, behavior: "auto" });
    } else if (event.key === "End") {
      event.preventDefault();
      const track = trackRef.current;
      if (track) track.scrollTo({ left: track.scrollWidth, behavior: "auto" });
    }
  }

  return (
    <div className="catalog-rail">
      {position.overflow ? (
        <div className="catalog-rail-controls" role="group" aria-label={"Przewijanie: " + label}>
          <button
            className="catalog-rail-arrow"
            type="button"
            disabled={!position.previous}
            onClick={() => scrollOneCard(-1)}
            aria-controls={trackId}
            aria-label={"Przewiń w lewo: " + label}
          >
            <ChevronLeft size={18} strokeWidth={1.8} aria-hidden="true" />
          </button>
          <button
            className="catalog-rail-arrow"
            type="button"
            disabled={!position.next}
            onClick={() => scrollOneCard(1)}
            aria-controls={trackId}
            aria-label={"Przewiń w prawo: " + label}
          >
            <ChevronRight size={18} strokeWidth={1.8} aria-hidden="true" />
          </button>
        </div>
      ) : null}
      <ul
        id={trackId}
        ref={trackRef}
        className="catalog-rail-track"
        aria-labelledby={labelledBy}
        tabIndex={position.overflow ? 0 : -1}
        onKeyDown={onTrackKeyDown}
      >
        {items.map((item) => (
          <li className="catalog-rail-item" key={item.key}>{item.content}</li>
        ))}
      </ul>
    </div>
  );
}
