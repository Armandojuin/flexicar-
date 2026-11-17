# Cómo publicar el plano como web pública

Igual que JuinLoks: **Supabase** guarda los datos y **GitHub Pages** publica la web.
Resultado: una dirección como `https://armandojuin.github.io/flexicar-/` que cualquiera puede abrir sin cuenta.
Todos ven el mismo plano en tiempo real. Para **editar** hace falta la **clave del equipo**.

## Paso 1 · Base de datos (Supabase)

Puedes usar **el mismo proyecto de JuinLoks** (no se mezclan: son tablas distintas) o crear uno nuevo con **New project**.

1. En Supabase, abre **SQL Editor → New query**.
2. Copia todo el contenido de `supabase/instalar.sql` y pégalo.
3. **Cambia `CAMBIA-ESTA-CLAVE`** por la clave que daréis a los compañeros que pueden editar.
4. Pulsa **Run**. Debe aparecer *Success*.
5. Si has creado un proyecto nuevo, copia de **Project Settings → API** el **Project URL** y la clave **anon public** (o **publishable**). Si usas el de JuinLoks, son los mismos que tienes en su `config.js`.

## Paso 2 · Conectar la web

1. En este repositorio de GitHub, abre `config.js` y pulsa el **lápiz** para editarlo.
2. Pon los dos datos del paso 1 entre las comillas y pulsa **Commit changes**.

## Paso 3 · Publicar (GitHub Pages)

GitHub Pages gratis solo funciona con repositorios públicos. Lo público es el código, no los datos: el plano está en Supabase y para cambiarlo hace falta la clave del equipo.

1. En el repositorio, abre **Settings → General**, baja hasta **Danger Zone → Change visibility** y elige **Public**.
2. Abre **Settings → Pages**. En **Source** elige **Deploy from a branch**. En **Branch** elige la rama donde está la web (`main` si ya la has fusionado; si no, `claude/wizardly-ptolemy-bnoqmt`) y `/ (root)`. Pulsa **Save**.
3. Espera 1 o 2 minutos y recarga. Arriba aparece la dirección de la web.
4. Mándala a tus compañeros y, a los que vayan a editar, la clave del equipo.

## Uso

- Quien abra la web ve el plano. Para cambiarlo, pulsa **«Solo lectura · Editar con clave»** arriba, escribe su nombre y la clave. El navegador la recuerda.
- Los cambios se guardan solos y les aparecen a los demás al momento.

## Preguntas frecuentes

**¿Cómo cambio la clave del equipo?** Edita la clave en `supabase/instalar.sql` y vuelve a ejecutarlo en el SQL Editor.

**La web dice «Sin conexión».** En el plan gratuito, Supabase pausa el proyecto tras una semana sin uso. Entra en supabase.com y pulsa **Restore project**.

**¿Cómo actualizo la web si hay cambios?** Sustituye `index.html`. **No reemplaces `config.js`.**

**Copias de seguridad:** en la web, «Guardar / abrir» → «Descargar copia».
