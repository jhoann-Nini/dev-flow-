#!/bin/bash

echo "======================================"
echo "        DEV-FLOW - SYSTEM DOCTOR"
echo "======================================"
echo ""

ERRORS=0

check_command() {
    local name=$1
    local command=$2

    if command -v "$command" &> /dev/null; then
        echo "✅ $name: OK"
    else
        echo "❌ $name: NO INSTALADO"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "🔍 HERRAMIENTAS"
echo "--------------------------------------"

check_command "Git" git
check_command "Node.js" node
check_command "NPM" npm
check_command "Docker" docker
check_command "GitHub CLI" gh

echo ""

echo "🔍 VERSIONES"
echo "--------------------------------------"

if command -v git &> /dev/null; then
    echo "Git:       $(git --version)"
fi

if command -v node &> /dev/null; then
    echo "Node.js:   $(node --version)"
fi

if command -v npm &> /dev/null; then
    echo "NPM:       $(npm --version)"
fi

if command -v docker &> /dev/null; then
    echo "Docker:    $(docker --version)"
fi

if command -v gh &> /dev/null; then
    echo "GitHub:    $(gh --version | head -n 1)"
fi

echo ""

echo "🔍 DOCKER"
echo "--------------------------------------"

if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo "✅ Docker Engine: FUNCIONANDO"
    else
        echo "⚠️  Docker Engine: NO RESPONDE"

        ERROR_ID=$("$HOME/proyectos/dev-flow-/scripts/error-map.sh" "docker")

        echo "   └─ Error relacionado: $ERROR_ID"
        echo "   └─ Solución: dev error docker"

        ERRORS=$((ERRORS + 1))
    fi
fi

echo ""

echo "🔍 GIT"
echo "--------------------------------------"

if [ -d ".git" ]; then
    echo "✅ Repositorio Git: DETECTADO"

    if git diff --quiet && git diff --cached --quiet; then
        echo "✅ Cambios locales: LIMPIOS"
    else
        echo "⚠️  Cambios locales: DETECTADOS"
    fi
else
    echo "ℹ️  Repositorio Git: NO DETECTADO"
fi

echo ""

echo "======================================"

if [ "$ERRORS" -eq 0 ]; then
    echo "✅ SISTEMA: TODO CORRECTO"
else
    echo "❌ SISTEMA: $ERRORS PROBLEMA(S) DETECTADO(S)"
fi

echo "======================================"

exit "$ERRORS"
