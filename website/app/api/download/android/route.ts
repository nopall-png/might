import { NextResponse } from 'next/server';
import { promises as fs } from 'fs';
import { createReadStream } from 'fs';
import { Readable } from 'stream';
import path from 'path';

// Use Node.js runtime so we can access filesystem
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';
// Resolve APK path from Next.js public folder (works on Vercel)
const APK_PATH = path.resolve(process.cwd(), 'public', 'app-release.apk');

export async function GET() {
  try {
    const stat = await fs.stat(APK_PATH);
    const nodeStream = createReadStream(APK_PATH);
    const webStream = Readable.toWeb(nodeStream);

    return new NextResponse(webStream as any, {
      headers: {
        'Content-Type': 'application/vnd.android.package-archive',
        'Content-Length': stat.size.toString(),
        'Content-Disposition': 'attachment; filename="app-release.apk"',
        'Cache-Control': 'no-cache',
      },
    });
  } catch (err: any) {
    const message = err?.code === 'ENOENT'
      ? 'APK file not found. Build a release first.'
      : 'Failed to read APK file.';

    return new NextResponse(JSON.stringify({ error: message }), {
      status: err?.code === 'ENOENT' ? 404 : 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}
