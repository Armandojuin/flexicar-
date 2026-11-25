-- Expo · fotos de los coches (portada y reporte de daños)
-- Pégalo en Supabase > SQL Editor > New query y pulsa «Run». Solo hace falta una vez
-- (y se puede repetir sin problema). Usa la misma clave del equipo que ya tenéis.

create table if not exists public.fotos (
  id         text primary key,
  plano      text not null default 'principal',
  car_id     text not null,
  tipo       text not null check (tipo in ('portada', 'danio')),
  imagen     text not null,          -- foto reducida (JPEG en base64)
  miniatura  text,                   -- versión pequeña para las listas
  nota       text,
  created_at timestamptz not null default now(),
  autor      text
);
create index if not exists fotos_car on public.fotos (car_id);

alter table public.fotos enable row level security;
drop policy if exists "ver fotos" on public.fotos;
create policy "ver fotos" on public.fotos for select to anon, authenticated using (true);
-- sin políticas de escritura: solo se sube o borra con las funciones de abajo, que piden la clave del equipo

create or replace function public.guardar_foto(p_clave text, p_id text, p_car text, p_tipo text, p_imagen text, p_miniatura text, p_nota text default null, p_autor text default null)
returns void language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.comprobar_clave(p_clave) then raise exception 'clave incorrecta' using errcode = '28P01'; end if;
  if p_tipo not in ('portada', 'danio') then raise exception 'tipo de foto no válido'; end if;
  if length(p_imagen) > 3000000 then raise exception 'foto demasiado grande'; end if;
  if p_tipo = 'portada' then delete from public.fotos where car_id = p_car and tipo = 'portada'; end if;
  insert into public.fotos (id, car_id, tipo, imagen, miniatura, nota, autor)
  values (p_id, p_car, p_tipo, p_imagen, p_miniatura, left(p_nota, 500), left(p_autor, 60));
end $$;

create or replace function public.nota_foto(p_clave text, p_id text, p_nota text)
returns void language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.comprobar_clave(p_clave) then raise exception 'clave incorrecta' using errcode = '28P01'; end if;
  update public.fotos set nota = left(p_nota, 500) where id = p_id;
end $$;

create or replace function public.borrar_foto(p_clave text, p_id text)
returns void language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.comprobar_clave(p_clave) then raise exception 'clave incorrecta' using errcode = '28P01'; end if;
  delete from public.fotos where id = p_id;
end $$;

revoke all on function public.guardar_foto(text, text, text, text, text, text, text, text) from public;
revoke all on function public.nota_foto(text, text, text) from public;
revoke all on function public.borrar_foto(text, text) from public;
grant execute on function public.guardar_foto(text, text, text, text, text, text, text, text) to anon, authenticated;
grant execute on function public.nota_foto(text, text, text) to anon, authenticated;
grant execute on function public.borrar_foto(text, text) to anon, authenticated;
