// Minimal redirect handler to static file in public
export async function GET(request: Request) {
  const origin = new URL(request.url).origin;
  const target = new URL('/might.apk', origin).toString();
  return new Response(null, {
    status: 302,
    headers: { Location: target },
  });
}
