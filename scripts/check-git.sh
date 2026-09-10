#!/bin/bash

echo "======================================"
echo "        DEV-FLOW - GIT CHECK"
echo "======================================"
echo ""

if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI no está instalado"
    exit 1
fi

if gh auth status &> /dev/null; then
    echo "✅ GitHub CLI: AUTENTICADO"
else
    echo "⚠️  GitHub CLI: NO AUTENTICADO"

    ERROR_ID=$("$HOME/proyectos/dev-flow-/scripts/error-map.sh" "git")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error git"

    exit 1
fi

echo ""
echo "======================================"
echo "          VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0