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
# Detectar tipo de proyecto
# --------------------------------------

PROJECT_TYPE="unknown"

if [ -f "package.json" ]; then
    if grep -q '"next"' package.json 2>/dev/null; then
        PROJECT_TYPE="nextjs"
    else
        PROJECT_TYPE="nodejs"
    fi

elif [ -f "pom.xml" ]; then
    PROJECT_TYPE="springboot"

elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    PROJECT_TYPE="python"

elif [ -f "CMakeLists.txt" ]; then
    PROJECT_TYPE="cpp"
fi

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

        if npx tsc --noEmit --pretty false; then
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

        LINT_OUTPUT=$(mktemp)

        npm run lint -- --no-warn-ignored > "$LINT_OUTPUT" 2>&1
        LINT_EXIT=$?

        cat "$LINT_OUTPUT"

        LINT_SUMMARY=$(grep -E '✖ [0-9]+ problem' "$LINT_OUTPUT" | tail -n 1)

        LINT_ERRORS=0
        LINT_WARNINGS=0

        if [ -n "$LINT_SUMMARY" ]; then
            LINT_ERRORS=$(echo "$LINT_SUMMARY" | sed -E 's/.*\(([0-9]+) errors?.*/\1/')
            LINT_WARNINGS=$(echo "$LINT_SUMMARY" | sed -E 's/.*,[[:space:]]*([0-9]+) warnings?\).*/\1/')
        fi

        if [ "$LINT_ERRORS" -gt 0 ]; then
            error "ESLint: $LINT_ERRORS error(es)"
        fi

        if [ "$LINT_WARNINGS" -gt 0 ]; then
            warning "ESLint: $LINT_WARNINGS warning(s)"
        fi

        if [ "$LINT_ERRORS" -eq 0 ] && [ "$LINT_WARNINGS" -eq 0 ]; then
            ok "ESLint: sin problemas"
        fi

        rm -f "$LINT_OUTPUT"

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

        if npm run test -- --run; then
            ok "Tests: todos pasan"
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

        if npm run build; then
            ok "Build: correcto"
        else
            error "Build: falló"
        fi

    else
        warning "No existe script 'build' en package.json"
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