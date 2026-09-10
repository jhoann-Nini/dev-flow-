<<'EOF'
# DEV-FLOW - Base de conocimiento de errores

Este documento registra errores y problemas recurrentes encontrados
durante el desarrollo de proyectos.

El objetivo es convertir soluciones anteriores en conocimiento
reutilizable y, posteriormente, permitir que DEV-FLOW los detecte
automáticamente.

---

## ERROR-001 - Puerto ocupado

**ID:** ERROR-001
**Categoría:** ports

### Problema

Un puerto necesario para ejecutar un proyecto ya está siendo utilizado
por otro proceso o servicio.

### Ejemplo

El puerto `5432` de PostgreSQL aparece ocupado.

### Diagnóstico

```bash
ss -ltn
lsof -i :5432
```

```bash
dev ports
```

### Solución

Identificar qué proceso está utilizando el puerto y determinar si debe
detenerse o si el proyecto debe utilizar otro puerto.

---

## ERROR-002 - PostgreSQL local entra en conflicto con Docker

**ID:** ERROR-002
**Categoría:** docker

### Problema

Una instalación local de PostgreSQL utiliza el puerto 5432 y evita
que un contenedor PostgreSQL pueda utilizar ese mismo puerto.

### Diagnóstico

```bash
sudo systemctl status postgresql
```
```bash
dev ports
```

### Solución

si PostgreSQL local no es necesario, detenerlo:
```bash
sudo systemctl stop postgresql
```
Y evitar que se inicie automáticamente:

```bash
sudo systemctl disable postgresql
```

### Automatización futura

DEV-FLOW podría detectar:

PostgreSQL ejecutándose localmente.
Puerto 5432 ocupado.
Contenedor PostgreSQL intentando utilizar 5432.

---

## ERROR-003 - GitHub rechaza autenticación mediante contraseña

**ID:** ERROR-003
**Categoría:** git

### Problema

GitHub no permite utilizar la contraseña normal de la cuenta para
realizar operaciones Git mediante HTTPS.

### Síntoma

Un git push solicita usuario y contraseña y la autenticación falla.

### Solución

Utilizar un método de autenticación compatible, como GitHub CLI:

```bash
gh auth login
```
Después comprobar:
```bash
gh auth status
```

### Automatización futura

DEV-FLOW podría comprobar:
```bash
gh auth status
```

y advertir si GitHub CLI no está autenticado.

---

## ERROR-004 - TypeScript encuentra errores antes del build

**ID:** ERROR-004
**Categoría:** typescript

### Problema
El proyecto contiene errores de tipos que pueden impedir una
compilación correcta.

### Diagnóstico
```bash
npx tsc --noEmit
```
### Automatización
DEV-FLOW ejecuta esta comprobación mediante:

```bash
dev check
```
Si encuentra errores, los reporta como errores del proyecto.

---

## ERROR-005 - ESLint encuentra problemas en el código

**ID:** ERROR-005
**Categoría:** eslint

### Problema
El código contiene errores o advertencias detectadas por ESLint.

### Diagnóstico
```bash
npm run lint
```

### Automatización
DEV-FLOW ejecuta ESLint mediante:
```bash
dev check
```

Los errores deben considerarse problemas que pueden impedir la
calidad o integración del proyecto.

---

## ERROR-006 - Tests fallan

**ID:** ERROR-006
**Categoría:** tests

### Problema
Uno o más tests automatizados no pasan.

### Diagnóstico
```bash
npm run test -- --run
```

### Automatización
DEV-FLOW ejecuta los tests mediante:
```bash
dev check
```

Un test fallido se reporta como error.

---

## ERROR-007 - Build falla

**ID:** ERROR-007
**Categoría:** build

### Problema
El proyecto no puede generar correctamente su versión de producción.

### Diagnóstico
En proyectos Node.js o Next.js:
```bash
npm run build
```

### Automatización
DEV-FLOW ejecuta el build mediante:
```bash
dev check
```
Un build fallido se reporta como error.

---

## ERROR-008 - Dependencias no instaladas

**ID:** ERROR-008
**Categoría:** dependencies

### Problema
El proyecto contiene package.json, pero no existe node_modules.

### Diagnóstico
```bash
ls
```

### Solución

```bash
npm install
```
### Automatización
DEV-FLOW detecta la ausencia de node_modules mediante:
``` bash
dev check
```
---

## ERROR-009 - Variables de entorno ausentes

**ID:** ERROR-009
**Categoría:** environment

### Problema

El proyecto necesita variables de entorno para funcionar,
pero no encuentra el archivo correspondiente.

### Diagnóstico

DEV-FLOW comprueba la existencia de:

```text
.env.local
.env
```

### Automatización
```bash
dev check
```

DEV-FLOW debe verificar la existencia del archivo sin mostrar
los valores de las variables ni exponer secretos