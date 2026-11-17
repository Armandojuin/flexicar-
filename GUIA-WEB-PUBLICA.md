# Cómo publicar el plano como web pública

Resultado: una dirección normal (por ejemplo `https://expo-flexicar.netlify.app`) que cualquiera puede abrir sin cuenta.
Todos ven el mismo plano en tiempo real. Para **editar** hace falta la **clave del equipo**.

## 1. Crear la base de datos (gratis, unos 5 minutos)

1. Entra en <https://supabase.com> y crea una cuenta gratuita.
2. Pulsa **New project**. Ponle un nombre (por ejemplo `plano-exposicion`), una contraseña de base de datos (guárdala, pero no es la del equipo) y la región **Europe (Frankfurt o Paris)**.
3. Cuando termine de crearse, ve a **SQL Editor** → **New query**.
4. Abre el archivo `supabase/instalar.sql` de este repositorio y copia todo su contenido en el editor.
5. **Cambia `CAMBIA-ESTA-CLAVE`** por la clave que daréis a los compañeros que pueden editar.
6. Pulsa **Run**. Debe salir «Success. No rows returned».

## 2. Conectar la web con la base de datos

En Supabase ve a **Project Settings → API** y copia:
- **Project URL** (algo como `https://abcdxyz.supabase.co`)
- La clave **anon public** (un texto largo que empieza por `eyJ…`)

Esta clave está pensada para ir dentro de una web pública. Lo que protege el plano es la clave del equipo, que no está en la web.

Abre `index.html` con el Bloc de notas y cambia la línea:

```js
const NUBE = {url:'', clave:''};
```

por (con tus datos):

```js
const NUBE = {url:'https://abcdxyz.supabase.co', clave:'eyJ...'};
```

(o pásale los dos datos a Claude y lo hace él).

## 3. Publicar la web

1. Crea una carpeta en el escritorio, por ejemplo `plano-web`, y mete dentro el `index.html` ya conectado.
2. Entra en <https://app.netlify.com/drop> y arrastra la carpeta a la página.
3. Crea una cuenta gratuita cuando te lo pida para que la web no caduque. En **Site configuration → Change site name** puedes ponerle un nombre fácil.
4. Manda la dirección a tus compañeros y, a los que vayan a editar, la clave del equipo.

Para actualizar la web más adelante, vuelve a arrastrar la carpeta en **Deploys** del mismo sitio. Los datos del plano no se pierden: están en Supabase, no en la web.

## Bueno saber

- **Cambiar la clave del equipo**: edita la clave en `supabase/instalar.sql` y vuelve a ejecutarlo en el SQL Editor. Quien tuviera la antigua tendrá que escribir la nueva.
- **Proyecto en pausa**: en el plan gratis, Supabase pausa el proyecto si pasa una semana sin que nadie abra la web. Se reactiva desde el panel de Supabase con un clic.
- **Copias de seguridad**: desde la web, «Guardar / abrir» → «Descargar copia».
