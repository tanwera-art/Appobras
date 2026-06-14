-- ============================================================================
-- OBRAS · Esquema Supabase (Fase 2)  ·  Pega TODO esto en SQL Editor y Run.
-- Crea las 11 tablas, activa seguridad por usuario (RLS) y deja cada quien
-- viendo solo sus propios datos. El id lo genera la app (texto).
-- ============================================================================

create table if not exists proyectos (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, cliente text, cliente_id text, carpeta_id text,
  color text, estatus text,
  total_contratado numeric, honorarios numeric, indirectos numeric, iva numeric,
  notas text, creado_en text
);

create table if not exists partidas (
  id text primary key,
  user_id uuid not null default auth.uid(),
  proyecto_id text, proveedor_id text, categoria_id text,
  concepto text, presupuesto numeric
);

create table if not exists movimientos (
  id text primary key,
  user_id uuid not null default auth.uid(),
  fecha text, tipo text, monto numeric, metodo_pago text, cuenta_id text,
  proyecto_id text, partida_id text, proveedor_id text, categoria_id text,
  etapa text, descripcion text, estatus text, creado_en text
);

create table if not exists proveedores (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, telefono text, contacto text, email text, notas text
);

create table if not exists categorias (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, tipo text, color text, icono text
);

create table if not exists cuentas (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, tipo text, saldo_inicial numeric
);

create table if not exists pagos_programados (
  id text primary key,
  user_id uuid not null default auth.uid(),
  proyecto_id text, partida_id text, proveedor_id text,
  monto numeric, fecha_vencimiento text, recurrencia text, estatus text, movimiento_id text
);

create table if not exists cobros_programados (
  id text primary key,
  user_id uuid not null default auth.uid(),
  proyecto_id text, cliente_id text, etapa text,
  monto numeric, fecha_vencimiento text, recurrencia text, estatus text, movimiento_id text
);

create table if not exists carpetas (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, color text, archivada boolean, creado_en text
);

create table if not exists clientes (
  id text primary key,
  user_id uuid not null default auth.uid(),
  nombre text, telefono text, email text, notas text
);

-- OJO: "dataUrl" va entre comillas para conservar la mayúscula (la app usa esa llave).
create table if not exists adjuntos (
  id text primary key,
  user_id uuid not null default auth.uid(),
  movimiento_id text, "dataUrl" text, nombre text, creado_en text
);

-- ---------------------------------------------------------------------------
-- Seguridad: activar RLS y una política por tabla (cada quien ve SOLO lo suyo)
-- ---------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'proyectos','partidas','movimientos','proveedores','categorias','cuentas',
    'pagos_programados','cobros_programados','carpetas','clientes','adjuntos'
  ]
  loop
    execute format('alter table %I enable row level security;', t);
    execute format('drop policy if exists own_rows on %I;', t);
    execute format(
      'create policy own_rows on %I for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);',
      t
    );
  end loop;
end $$;
