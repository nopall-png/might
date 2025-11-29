"use client";
import Link from 'next/link';
import Image from 'next/image';
import { useState } from 'react';

export default function NavBar() {
  const [open, setOpen] = useState(false);
  return (
    <nav className="pixel-bar">
      <div className="container" style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
        <Link href="/" style={{ color: 'white', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 12 }}>
          <Image src="/logo1.png" alt="MIGHT logo" width={36} height={36} priority />
          <span style={{ fontSize: 'clamp(18px, 2.6vw, 26px)', lineHeight: 1 }}>MIGHT</span>
        </Link>
        <div style={{ flex: 1 }} />
        <button
          type="button"
          aria-label="Toggle menu"
          onClick={() => setOpen(!open)}
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'transparent',
            border: 'none',
            color: 'white',
            cursor: 'pointer',
          }}
        >
          ☰
        </button>
        <div style={{ display: open ? 'flex' : 'none', gap: 16, marginLeft: 16 }}>
          <Link href="#features" style={{ color: 'white' }}>Features</Link>
          <Link href="#use-cases" style={{ color: 'white' }}>Use Cases</Link>
          <Link href="#download" style={{ color: 'white' }}>Download</Link>
        </div>
      </div>
    </nav>
  );
}
