-- Plano de Exposición: instalación de la base de datos en Supabase
-- 1) Cambia CAMBIA-ESTA-CLAVE (abajo) por la clave que daréis a los compañeros que pueden editar.
-- 2) Pega todo esto en Supabase > SQL Editor > New query y pulsa «Run».
-- Se puede ejecutar más de una vez sin problema (para cambiar la clave, edítala y vuelve a ejecutarlo).

create extension if not exists pgcrypto with schema extensions;

-- Cada plaza, zona, rótulo y coche es una fila. La fila '__meta' guarda nombre y medidas del recinto.
create table if not exists public.objetos (
  plano      text        not null default 'principal',
  id         text        not null,
  data       jsonb,
  updated_at timestamptz not null default now(),
  updated_by text,
  primary key (plano, id)
);

create table if not exists public.ajustes (
  clave text primary key,
  valor text not null
);

alter table public.objetos enable row level security;
alter table public.ajustes enable row level security;

-- Cualquiera con el enlace puede VER el plano. Nadie puede escribir directamente:
-- solo a través de las funciones de abajo, que piden la clave del equipo.
drop policy if exists "leer plano" on public.objetos;
create policy "leer plano" on public.objetos for select to anon, authenticated using (true);
-- (la tabla ajustes no tiene ninguna política: nadie puede leerla desde la web)

insert into public.ajustes (clave, valor)
values ('clave_equipo', extensions.crypt('CAMBIA-ESTA-CLAVE', extensions.gen_salt('bf')))
on conflict (clave) do update set valor = excluded.valor;

create or replace function public.comprobar_clave(p_clave text)
returns boolean language sql stable security definer set search_path = public, extensions as $$
  select exists (select 1 from public.ajustes where clave = 'clave_equipo' and valor = extensions.crypt(coalesce(p_clave, ''), valor));
$$;

-- Guarda solo lo que ha cambiado: {"id": {...objeto...} | null}
create or replace function public.guardar_cambios(p_clave text, p_cambios jsonb, p_autor text default null)
returns void language plpgsql security definer set search_path = public, extensions as $$
declare k text; v jsonb;
begin
  if not public.comprobar_clave(p_clave) then
    raise exception 'clave incorrecta' using errcode = '28P01';
  end if;
  for k, v in select * from jsonb_each(p_cambios) loop
    insert into public.objetos (plano, id, data, updated_at, updated_by)
    values ('principal', k, case when jsonb_typeof(v) = 'null' then null else v end, now(), left(p_autor, 60))
    on conflict (plano, id) do update
      set data = excluded.data, updated_at = now(), updated_by = excluded.updated_by;
  end loop;
end $$;

-- Sustituye el plano entero (plano nuevo, abrir una copia, cargar el ejemplo)
create or replace function public.reemplazar_plano(p_clave text, p_cambios jsonb, p_autor text default null)
returns void language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.comprobar_clave(p_clave) then
    raise exception 'clave incorrecta' using errcode = '28P01';
  end if;
  update public.objetos set data = null, updated_at = now(), updated_by = left(p_autor, 60)
   where plano = 'principal' and data is not null and not (p_cambios ? id);
  perform public.guardar_cambios(p_clave, p_cambios, p_autor);
end $$;

revoke all on function public.comprobar_clave(text) from public;
revoke all on function public.guardar_cambios(text, jsonb, text) from public;
revoke all on function public.reemplazar_plano(text, jsonb, text) from public;
grant execute on function public.comprobar_clave(text) to anon, authenticated;
grant execute on function public.guardar_cambios(text, jsonb, text) to anon, authenticated;
grant execute on function public.reemplazar_plano(text, jsonb, text) to anon, authenticated;

-- Avisar en tiempo real a todos los navegadores abiertos cuando algo cambia
do $$ begin
  alter publication supabase_realtime add table public.objetos;
exception when duplicate_object then null; end $$;
