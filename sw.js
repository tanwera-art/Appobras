/* Service Worker — Obras
   Estrategia:
   - Precache del "app shell" local (index.html, manifest, iconos).
   - CDN (React, Tailwind, Chart.js, Babel): cache-first en runtime.
     Así, tras la primera carga con internet, la app funciona offline.
   Rutas RELATIVAS a propósito: funciona igual en
   usuario.github.io/repo/ o en un dominio propio sin cambiar nada.
*/

const VERSION = "obras-v2";
const SHELL_CACHE = `shell-${VERSION}`;
const RUNTIME_CACHE = `runtime-${VERSION}`;

// Recursos locales que SÍ precacheamos (existen en tu repo).
const SHELL_ASSETS = [
  "./",
  "./index.html",
  "./manifest.json",
  "./icon-192.png",
  "./icon-512.png",
  "./icon-maskable-512.png",
  "./apple-touch-icon.png",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(SHELL_CACHE).then((cache) =>
      // addAll es atómico; si un archivo falla, falla la instalación.
      // Por eso solo metemos recursos locales que sabemos que existen.
      cache.addAll(SHELL_ASSETS)
    ).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((k) => k !== SHELL_CACHE && k !== RUNTIME_CACHE)
          .map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (event) => {
  const req = event.request;
  if (req.method !== "GET") return;

  const url = new URL(req.url);

  // Navegaciones (abrir la app): network-first con fallback al shell cacheado.
  if (req.mode === "navigate") {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(SHELL_CACHE).then((c) => c.put("./index.html", copy));
          return res;
        })
        .catch(() => caches.match("./index.html"))
    );
    return;
  }

  // CDN y demás GET: cache-first, y guardamos la copia para offline.
  event.respondWith(
    caches.match(req).then((cached) => {
      if (cached) return cached;
      return fetch(req)
        .then((res) => {
          // Solo cacheamos respuestas válidas (incluye opaque de CDN).
          if (res && (res.ok || res.type === "opaque")) {
            const copy = res.clone();
            caches.open(RUNTIME_CACHE).then((c) => c.put(req, copy));
          }
          return res;
        })
        .catch(() => cached);
    })
  );
});
