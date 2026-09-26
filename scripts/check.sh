#!/bin/bash

echo "======================================"
echo "        DEV-FLOW - PROJECT CHECK"
echo "======================================"
echo ""

ERRORS=0
WARNINGS=0

# --------------------------------------
# Funciones
# --------------------------------------

ok() {
    echo "✅ $1"
}

warning() {
    echo "⚠️  $1"
    WARNINGS=$((WARNINGS + 1))
}

error() {
    echo "❌ $1"
    ERRORS=$((ERRORS + 1))
}

# --------------------------------------
# Verificar ubicación
# --------------------------------------

echo "📁 PROYECTO"
echo "--------------------------------------"
echo "Directorio: $(pwd)"
echo ""

# --------------------------------------
# Detectar estructura del proyecto
# --------------------------------------

echo "📂 ESTRUCTURA DEL PROYECTO"
echo "--------------------------------------"

PROJECT_TYPE="unknown"

# Proyecto Full Stack
if [ -d "proyectos/frontend" ] && [ -d "proyectos/backend" ]; then

    PROJECT_TYPE="fullstack"

# Proyecto Next.js o Node.js en la raíz
elif [ -f "package.json" ]; then

    if grep -q '"next"' package.json 2>/dev/null; then
        PROJECT_TYPE="nextjs"
    else
        PROJECT_TYPE="nodejs"
    fi

# Proyecto Spring Boot en la raíz
elif [ -f "pom.xml" ]; then

    PROJECT_TYPE="springboot"

# Proyecto Python
elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    PROJECT_TYPE="python"

# Proyecto C++
elif [ -f "CMakeLists.txt" ]; then
    PROJECT_TYPE="cpp"

fi

case "$PROJECT_TYPE" in

    fullstack)
        ok "Proyecto Full Stack detectado"
        echo "   ├─ docs"
        echo "   ├─ frontend → Next.js"
        echo "   └─ backend  → Spring Boot"
        ;;

    nextjs)
        ok "Proyecto Next.js detectado"
        ;;

    nodejs)
        ok "Proyecto Node.js detectado"
        ;;

    springboot)
        ok "Proyecto Spring Boot detectado"
        ;;

    *)
        warning "No se pudo identificar la estructura del proyecto"
        ;;

esac

echo ""

echo "🔍 TIPO DE PROYECTO"
echo "--------------------------------------"
echo "Detectado: $PROJECT_TYPE"
echo ""

# --------------------------------------
# Next.js / Node.js
# --------------------------------------

if [ "$PROJECT_TYPE" = "nextjs" ] || [ "$PROJECT_TYPE" = "nodejs" ]; then

    echo "📦 DEPENDENCIAS"
    echo "--------------------------------------"

    if [ -f "package.json" ]; then
        ok "package.json encontrado"
    else
        error "package.json no encontrado"
    fi

    if [ -d "node_modules" ]; then
        ok "node_modules encontrado"
    else
        error "node_modules no encontrado"
        echo "   └─ Ejecuta: npm install"
    fi

    echo ""

    # ----------------------------------
    # Variables de entorno
    # ----------------------------------

    echo "🔐 VARIABLES DE ENTORNO"
    echo "--------------------------------------"

    if [ -f ".env.local" ]; then
        ok ".env.local encontrado"
    elif [ -f ".env" ]; then
        warning ".env encontrado, pero no existe .env.local"
    else
        warning "No se encontró archivo .env"
    fi

    echo ""

    # ----------------------------------
    # TypeScript
    # ----------------------------------

    echo "🔷 TYPESCRIPT"
    echo "--------------------------------------"

    if [ -f "tsconfig.json" ]; then
        ok "tsconfig.json encontrado"
        
        if "$HOME/proyectos/dev-flow-/scripts/check-typescript.sh"; then
            ok "TypeScript: sin errores"
        else
            error "TypeScript: se encontraron errores"
        fi
    else
        warning "tsconfig.json no encontrado"
    fi

    echo ""

    # ----------------------------------
    # ESLint
    # ----------------------------------

    echo "🧹 ESLINT"
    echo "--------------------------------------"

    if node -e "const p=require('./package.json'); process.exit(p.scripts?.lint ? 0 : 1)" 2>/dev/null; then

        if "$HOME/proyectos/dev-flow-/scripts/check-eslint.sh"; then
            :
        else
            error "ESLint: se encontraron problemas"
        fi

    else
        warning "No existe script 'lint' en package.json"
    fi

    echo ""

    # ----------------------------------
    # Tests
    # ----------------------------------

    echo "🧪 TESTS"
    echo "--------------------------------------"

    if node -e "const p=require('./package.json'); process.exit(p.scripts?.test ? 0 : 1)" 2>/dev/null; then

        if "$HOME/proyectos/dev-flow-/scripts/check-tests.sh"; then
            :
        else
            error "Tests: se encontraron fallos"
        fi

    else
        warning "No existe script 'test' en package.json"
    fi

    echo ""

    # ----------------------------------
    # Build
    # ----------------------------------

    echo "🏗️ BUILD"
    echo "--------------------------------------"

    if node -e "const p=require('./package.json'); process.exit(p.scripts?.build ? 0 : 1)" 2>/dev/null; then

        if "$HOME/proyectos/dev-flow-/scripts/check-build.sh"; then
            :
        else
            error "Build: falló"
        fi

    else
        warning "No existe script 'build' en package.json"
    fi

    echo ""

fi

# --------------------------------------
# Frontend Full Stack
# --------------------------------------

if [ "$PROJECT_TYPE" = "fullstack" ]; then

    echo "⚛️ FRONTEND"
    echo "--------------------------------------"

    FRONTEND_DIR="proyectos/frontend"

    if [ ! -d "$FRONTEND_DIR" ]; then
        error "No existe el directorio frontend"
    else

        # ------------------------------
        # Dependencias
        # ------------------------------

        if [ -f "$FRONTEND_DIR/package.json" ]; then
            ok "Frontend: package.json encontrado"
        else
            error "Frontend: package.json no encontrado"
        fi

        if [ -d "$FRONTEND_DIR/node_modules" ]; then
            ok "Frontend: node_modules encontrado"
        else
            warning "Frontend: node_modules no encontrado"
            echo "   └─ Ejecuta: cd $FRONTEND_DIR && npm install"
        fi

        # ------------------------------
        # Variables de entorno
        # ------------------------------

        if [ -f "$FRONTEND_DIR/.env.local" ]; then
            ok "Frontend: .env.local encontrado"
        elif [ -f "$FRONTEND_DIR/.env" ]; then
            warning "Frontend: .env encontrado, pero no existe .env.local"
        else
            warning "Frontend: no se encontró archivo .env"
        fi

        # ------------------------------
        # TypeScript
        # ------------------------------

        if [ -f "$FRONTEND_DIR/tsconfig.json" ]; then
            (
                cd "$FRONTEND_DIR" || exit 1

                if "$HOME/proyectos/dev-flow-/scripts/check-typescript.sh"; then
                    :
                else
                    exit 1
                fi
            )

            if [ "$?" -ne 0 ]; then
                error "Frontend: TypeScript tiene errores"
            fi
        else
            warning "Frontend: tsconfig.json no encontrado"
        fi

        # ------------------------------
        # ESLint
        # ------------------------------

        if [ -f "$FRONTEND_DIR/package.json" ]; then

            if node -e "const p=require('./$FRONTEND_DIR/package.json'); process.exit(p.scripts?.lint ? 0 : 1)" 2>/dev/null; then

                (
                    cd "$FRONTEND_DIR" || exit 1
                    "$HOME/proyectos/dev-flow-/scripts/check-eslint.sh"
                )

                if [ "$?" -ne 0 ]; then
                    error "Frontend: ESLint encontró problemas"
                fi

            else
                warning "Frontend: no existe script 'lint'"
            fi

        fi

        # ------------------------------
        # Tests
        # ------------------------------

        if node -e "const p=require('./$FRONTEND_DIR/package.json'); process.exit(p.scripts?.test ? 0 : 1)" 2>/dev/null; then

            (
                cd "$FRONTEND_DIR" || exit 1
                "$HOME/proyectos/dev-flow-/scripts/check-tests.sh"
            )

            if [ "$?" -ne 0 ]; then
                error "Frontend: tests fallaron"
            fi

        else
            echo "ℹ️  Frontend: no existe script 'test'"
        fi

        # ------------------------------
        # Build
        # ------------------------------

        if node -e "const p=require('./$FRONTEND_DIR/package.json'); process.exit(p.scripts?.build ? 0 : 1)" 2>/dev/null; then

            (
                cd "$FRONTEND_DIR" || exit 1
                "$HOME/proyectos/dev-flow-/scripts/check-build.sh"
            )

            if [ "$?" -ne 0 ]; then
                error "Frontend: build falló"
            fi

        else
            warning "Frontend: no existe script 'build'"
        fi

    fi

    echo ""

fi

# --------------------------------------
# Backend Full Stack
# --------------------------------------

if [ "$PROJECT_TYPE" = "fullstack" ]; then

    echo "☕ BACKEND"
    echo "--------------------------------------"

    if "$HOME/proyectos/dev-flow-/scripts/check-backend.sh"; then
        :
    else
        error "Backend: la verificación falló"
    fi

    echo ""

fi

# --------------------------------------
# Git
# --------------------------------------

echo "🌿 GIT"
echo "--------------------------------------"

if [ -d ".git" ]; then
    ok "Repositorio Git detectado"

    if git diff --quiet && git diff --cached --quiet; then
        ok "No hay cambios pendientes"
    else
        warning "Hay cambios pendientes"
    fi
else
    warning "Este proyecto no tiene repositorio Git"
fi

echo ""

# --------------------------------------
# Puertos
# --------------------------------------

echo "🔌 PUERTOS"
echo "--------------------------------------"

"$HOME/proyectos/dev-flow-/scripts/check-ports.sh"
PORT_WARNINGS=$?

if [ "$PORT_WARNINGS" -gt 0 ]; then
    WARNINGS=$((WARNINGS + PORT_WARNINGS))
fi

echo ""

# --------------------------------------
# Resultado
# --------------------------------------

echo "======================================"
echo "             RESULTADO"
echo "======================================"

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo "✅ PROYECTO: TODO CORRECTO"
elif [ "$ERRORS" -eq 0 ]; then
    echo "⚠️  PROYECTO: $WARNINGS ADVERTENCIA(S)"
else
    echo "❌ PROYECTO: $ERRORS ERROR(ES), $WARNINGS ADVERTENCIA(S)"
fi

echo "======================================"

exit "$ERRORS"