# Obras — Control financiero por obra

App web instalable (PWA) para llevar ingresos, egresos, proveedores, presupuesto y utilidad **por obra/proyecto**. Funciona en el celular como app nativa y offline. Un solo `index.html`, sin servidor ni paso de build.

## Qué hace

- **Obras**: total contratado, cobrado, pagado, por cobrar y utilidad por obra, con % de avance.
- **Carpetas** para agrupar obras (ej. "Obras de junio"), colapsables y archivables.
- **Partidas** por proveedor con presupuesto y **diferencial** (sobregiro alertado).
- **Margen proyectado**: "si todo sale a presupuesto, tu utilidad/margen final será X".
- **Movimientos** con etapa (anticipo/avance/finiquito), efectivo vs transferencia y **fotos/recibos** adjuntos.
- **Calendario**: pestañas **Por pagar** (proveedores) y **Por cobrar** (clientes), con recurrencia; al marcar pagado/cobrado se genera el movimiento.
- **Flujo de caja proyectado** a 8 semanas, con alerta si el saldo se vuelve negativo.
- **Clientes** como entidad reutilizable.
- **Respaldo**: exportar/importar todo en JSON.
- **PIN** de bloqueo, **búsqueda global**, **bitácora** por obra, modo oscuro.
- **Exportar**: CSV global (Reportes), CSV por obra y nota PDF por movimiento.

## Archivos del repositorio

Todos van en la **raíz** del repo:

```
index.html                  # La app completa (React + IndexedDB + gráficas)
manifest.json               # Configuración PWA (nombre, iconos, colores)
sw.js                       # Service worker (cache + modo offline)
icon-192.png                # Ícono 192x192
icon-512.png                # Ícono 512x512
icon-maskable-512.png       # Ícono maskable (Android)
apple-touch-icon.png        # Ícono para iPhone (home screen)
.nojekyll                   # Vacío. Le dice a GitHub Pages que sirva todo tal cual
README.md                   # Este archivo
```

## Desplegar en GitHub Pages

1. Crea un repositorio (ej. `obras`) y sube **todos** los archivos de arriba a la raíz.
2. En el repo: **Settings → Pages**.
3. En *Build and deployment → Source* elige **Deploy from a branch**.
4. Branch: **main** y carpeta **/ (root)** → **Save**.
5. Espera 1–2 minutos. Tu app queda en:
   `https://TU_USUARIO.github.io/obras/`

> Las rutas son relativas, así que funciona igual en `usuario.github.io/obras/` o en un dominio propio sin cambiar nada.

## Instalar en iPhone

1. Abre la URL **en Safari** (debe ser Safari).
2. Toca el botón **Compartir** (cuadro con flecha hacia arriba).
3. **Agregar a inicio**.
4. Ábrela desde el ícono: pantalla completa y, tras la primera carga, funciona sin internet.

## Actualizar la app ya instalada

- `sw.js` tiene una constante `VERSION` (ahora `obras-v2`). Cada vez que cambies el código, **súbela** (ej. `obras-v3`): la app detecta la nueva versión y muestra un aviso **"Actualizar"**.
- Si vienes de una versión anterior con datos de ejemplo, entra a **Más → "Reiniciar a cero"** una vez para arrancar limpio (conserva cuentas, categorías y proveedores).

## Notas

- **Primera carga:** necesita internet porque baja React, Tailwind, Chart.js y jsPDF de CDN; luego se cachean y la app funciona offline.
- **Tus datos** se guardan en el dispositivo (IndexedDB). No salen de tu teléfono. Baja un **respaldo JSON** seguido desde Más.
- En **Más**: cargar datos de ejemplo, reiniciar a cero (conserva catálogos) o borrar todo.

## Fase 2 (pendiente)

Sincronizar entre dispositivos con **Supabase** (Auth + Row Level Security). El código ya está preparado: solo se reemplaza el módulo `db` dentro de `index.html`; la interfaz ya es `async` y la UI no toca IndexedDB directamente.
