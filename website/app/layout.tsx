import type { Metadata } from 'next';
import './globals.css';
import { Press_Start_2P } from 'next/font/google';

const pressStart = Press_Start_2P({ subsets: ['latin'], weight: '400' });

export const metadata: Metadata = {
  title: 'MIGHT – Meet and Fight',
  description:
    'MIGHT helps fighters connect, schedule matches, and track results — all in a retro, pixel‑styled app. Build your profile, find opponents, and grow your record.',
  icons: {
    icon: '/logo1.png',
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={pressStart.className}>{children}</body>
    </html>
  );
}
