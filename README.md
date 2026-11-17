# Plano de Exposición

Programa para dibujar el plano de la exposición de coches y ordenarlos.
Es un solo archivo, `index.html`: se abre con doble clic en cualquier navegador (Chrome, Edge, Safari…), no hay que instalar nada.

## Qué se puede hacer

- **Dibujar el recinto** a escala en metros: filas de plazas (en batería o en línea), zonas (oficina, entrada, taller, obstáculos) y rótulos.
- **Cargar el stock**: a mano con «+ Coche» o pegando la tabla desde Excel en «Importar stock» (Matrícula, Marca, Modelo, Versión, Año, Km, Precio, Combustible, Color, Estado, Notas). Si la matrícula ya existe, se actualizan los datos y el coche se queda en su plaza.
- **Colocar coches**: arrastrándolos de la lista al plano, o con el botón «Colocar». Si sueltas un coche sobre otro, se intercambian.
- **Ordenar la exposición automáticamente** por precio, marca, año, kilómetros, combustible o color, eligiendo qué filas usar. Se pueden dejar los reservados quietos y retirar los vendidos.
- **Colorear** los coches por estado, combustible, marca, precio o color real.
- **Avisos**: coches vendidos que siguen expuestos, coches que se pisan, coches fuera de plaza.
- **Guardar**: se guarda solo en el navegador. Desde «Guardar / abrir» se descarga una copia (.json) para llevarla a otro ordenador y un listado por plazas para Excel (.csv). «Imagen» saca un PNG del plano para mandarlo por WhatsApp o correo.

## Atajos

| Tecla | Acción |
| --- | --- |
| Mayús + arrastrar en el fondo | seleccionar varios |
| R | girar 90° |
| Flechas | mover 10 cm (con Mayús, 1 m) |
| Supr | retirar coche del plano / borrar plaza o zona |
| Ctrl + D | duplicar |
| Ctrl + Z / Ctrl + Y | deshacer / rehacer |
