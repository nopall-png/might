import { NextResponse } from 'next/server';

// Redirect to static file served from Next.js public folder (CDN-friendly)
export const runtime = 'edge';

export async function GET() {
  return NextResponse.redirect('/app-release.apk', 302);
}
