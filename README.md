# Sistema de Gestión de Biblioteca Escolar

Aplicación Java Swing autónoma con almacenamiento local H2 y sincronización secundaria con Oracle.

## Ejecutar

La aplicación no necesita Oracle para iniciar. Al abrirla:

1. Crea automáticamente una base H2 persistente en `%USERPROFILE%\.biblioteca-escolar`.
2. En una instalación local vacía, carga una sola vez los 26 libros, 47 usuarios y 93 préstamos de muestra desde `informacion_biblioteca.txt`.
3. Permite consultar y registrar libros, usuarios, préstamos, devoluciones e historiales aunque Oracle esté desconectado.

La base H2 admite que más de una instancia local use la misma carpeta de datos. Si el inicio falla, ahora se muestra en pantalla el tipo y el mensaje del error en lugar de cerrar silenciosamente.

**Recomendado en Windows:** haz doble clic en `Ejecutar Biblioteca.bat`; este lanza el JAR que ya incluye H2 y Oracle JDBC. Para ejecutar con el botón verde de IntelliJ, agrega `pom.xml` como proyecto Maven y pulsa **Reload All Maven Projects** antes de ejecutar `src/Main.java`. Si IntelliJ ejecuta el módulo Java sin importar Maven, no encontrará el driver H2 aunque este figure en `pom.xml`.

También puedes iniciar el JAR autónomo con:

```text
java -jar target/gestionbiblioteca-1.0.0.jar
```

Para guardar la base local en otra carpeta, define `BIBLIOTECA_LOCAL_DIR`.

## Sincronización Oracle

Oracle es opcional. El botón **Sincronizar con Oracle** envía usuarios, libros y movimientos guardados localmente. La aplicación también lo intenta al iniciar y vuelve a probar cada minuto. Si Oracle no está disponible, las operaciones continúan en la base local y se reintenta después. Los cambios locales se sincronizan hacia Oracle; los cambios hechos directamente en Oracle no se descargan a la base local.

Configura estas variables de entorno para tu instancia:

- `BIBLIOTECA_DB_URL` (por defecto `jdbc:oracle:thin:@localhost:1521:XE`)
- `BIBLIOTECA_DB_USER`
- `BIBLIOTECA_DB_PASSWORD`

El usuario Oracle necesita acceso de lectura/escritura y permiso para alterar la tabla `PRESTAMOS` y crear el índice de sincronización. La aplicación agrega automáticamente las columnas `ORIGEN_ID` e `ID_LOCAL` y el índice único que hacen idempotente la transferencia de préstamos y devoluciones. El esquema remoto debe tener previamente las tablas de `database/schema.sql` y la columna `ESTUDIANTES.ROL`; para un esquema previo, ejecuta `database/migracion_rol_estudiante.sql`.

La primera sincronización crea en Oracle los registros locales que no existan y aplica los préstamos/devoluciones sin duplicarlos. Si Oracle no tiene existencias suficientes para un préstamo pendiente, la sincronización informa el conflicto y deja los datos locales intactos.

## Archivos de datos y reportes

- `database/informacion_biblioteca.txt`: catálogo, usuarios, roles y préstamos proporcionados.
- `database/datos_demostracion.sql`: carga equivalente directamente en Oracle, si se requiere.
- Los botones de exportación guardan en TXT la tabla visible.

Los préstamos del listado no contienen fechas originales; por eso la muestra local los marca como activos con la fecha de carga, sin inventar devoluciones históricas.

## Crear el JAR

Maven genera `target/gestionbiblioteca-1.0.0.jar` con las dependencias H2 y Oracle JDBC incluidas. Usa la ventana Maven de IntelliJ (**Lifecycle → package**) o ejecuta `mvn package`.
