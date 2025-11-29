"use client";
import Image from "next/image";
import { useRef, useState } from "react";

type PreviewItem = { title: string; src: string };

const previews: PreviewItem[] = [
  { title: "Onboarding", src: "/previews/onboarding.png" },
  { title: "Login", src: "/previews/login.png" },
  { title: "Swipe Matches", src: "/previews/swipe.png" },
  { title: "What's New", src: "/previews/whats-new.png" },
  { title: "Chats", src: "/previews/chats.png" },
];

function PreviewImage({ src, alt }: { src: string; alt: string }) {
  const [current, setCurrent] = useState(src);
  return (
    <Image
      src={current}
      alt={alt}
      fill
      priority
      style={{ objectFit: "cover" }}
      onError={() => setCurrent("/logo1.png")}
    />
  );
}

export default function AppPreviews() {
  const trackRef = useRef<HTMLDivElement | null>(null);
  const scrollByCard = (dir: "prev" | "next") => {
    const el = trackRef.current;
    if (!el) return;
    const first = el.querySelector<HTMLElement>(".preview-item");
    const cardWidth = first ? first.offsetWidth : 280;
    const delta = dir === "next" ? cardWidth + 16 : -(cardWidth + 16);
    el.scrollBy({ left: delta, behavior: "smooth" });
  };
  return (
    <section id="previews" className="container">
      <div className="section-title">Apps Preview</div>
      <p className="muted" style={{ margin: "4px 0 12px" }}>
        Scroll horizontally to view all screenshots, or use the buttons.
      </p>
      <div className="preview-slider">
        <div ref={trackRef} className="slider-track">
          {previews.map((p) => (
            <div key={p.title} className="pixel-card preview-item">
              <div className="phone-frame">
                <PreviewImage src={p.src} alt={p.title} />
              </div>
              <div className="muted" style={{ textAlign: "center", marginTop: 8 }}>
                {p.title}
              </div>
            </div>
          ))}
        </div>
        <div className="slider-controls">
          <button
            type="button"
            className="pixel-btn small"
            onClick={() => scrollByCard("prev")}
            aria-label="Sebelumnya"
          >
            ‹
          </button>
          <button
            type="button"
            className="pixel-btn small"
            onClick={() => scrollByCard("next")}
            aria-label="Berikutnya"
          >
            ›
          </button>
        </div>
      </div>
    </section>
  );
}
