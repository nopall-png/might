import FeatureCard from "../components/FeatureCard";
import AppPreviews from "../components/AppPreviews";
import path from 'path';
import { promises as fs } from 'fs';

export default async function Page() {
  let apkSizeLabel: string | null = null;
  try {
    const apkPath = path.resolve(process.cwd(), 'public', 'app-release.apk');
    const stat = await fs.stat(apkPath);
    const sizeMB = stat.size / (1024 * 1024);
    apkSizeLabel = `${sizeMB.toFixed(1)} MB`;
  } catch {}
  return (
    <main>

      <section className="hero">
        <div className="container">
          <h1 className="hero-title">MIGHT – Meet and Fight</h1>
          <p className="muted">Meet Your Match, Own the Fight</p>
          <div style={{ marginTop: 20, display: 'flex', gap: 12, justifyContent: 'center' }}>
            <a className="pixel-btn" href="/app-release.apk" download>Download App</a>
            <a className="pixel-btn" href="#features">View Features</a>
          </div>
        </div>
      </section>

      {/* App preview gallery */}
      <AppPreviews />

      <section id="features" className="container">
        <div className="section-title">Key Features</div>
        <div className="grid">
          <FeatureCard
            title="Pixelated Profile"
            desc="Retro-styled headers, cards, and controls for consistent visuals."
          />
          <FeatureCard
            title="Opponent Matching"
            desc="Effortless matching to find sparring partners at the right level."
          />
          <FeatureCard
            title="Integrated Chat"
            desc="Plan matches and discuss strategies directly and securely."
          />
          <FeatureCard
            title="Responsive Navigation"
            desc="A gradient app bar that stays readable across screen sizes."
          />
          <FeatureCard
            title="Smooth Transitions"
            desc="Slide + fade transitions for onboarding and page navigation."
          />
          <FeatureCard
            title="Profile Customization"
            desc="Edit avatar, bio, and experience level with ease."
          />
        </div>
      </section>

      <section id="use-cases" className="container">
        <div className="section-title">Use Cases</div>
        <div className="pixel-card">
          <p className="muted">
            MIGHT helps the fighting community: (1) find suitable sparring opponents,
            (2) build reputation through a unique pixelated profile, (3) communicate
            directly with opponents via chat, and (4) stay up-to-date with new features.
          </p>
        </div>
      </section>

      <section id="download" className="container" style={{ textAlign: 'center' }}>
        <div className="section-title">Download the App</div>
        <p className="muted">Choose your platform to get started.</p>
        <div style={{ display: 'flex', gap: 12, justifyContent: 'center', marginTop: 12, alignItems: 'center' }}>
          {/* Replace these links with your public app URLs when available */}
          <a className="pixel-btn" href="/app-release.apk" download aria-label="Download Android">Android</a>
          {apkSizeLabel && (
            <span className="muted" aria-hidden="true">({apkSizeLabel})</span>
          )}
        </div>
      </section>

      <footer className="footer">
        © 2025 MIGHT. Built with Flutter
      </footer>
    </main>
  );
}
