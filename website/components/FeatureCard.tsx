export default function FeatureCard({ title, desc }: { title: string; desc: string }) {
  return (
    <div className="pixel-card">
      <div style={{ fontSize: 14, marginBottom: 10 }}>{title}</div>
      <p className="muted" style={{ margin: 0 }}>{desc}</p>
    </div>
  );
}

