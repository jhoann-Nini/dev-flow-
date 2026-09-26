#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="${1:-.}"

echo "======================================"
echo "        DEV-FLOW - TESTS CHECK"
echo "======================================"
echo ""

if [ ! -f "$FRONTEND_DIR/package.json" ]; then
    echo "⚠️  No se encontró package.json"
    exit 1
fi

if ! (cd "$FRONTEND_DIR" && node -e "const p=require('./package.json'); process.exit(p.scripts?.test ? 0 : 1)" 2>/dev/null); then
    echo "⚠️  No existe script 'test' en package.json"
    exit 1
fi

echo "🧪 Ejecutando tests..."
echo ""

if (cd "$FRONTEND_DIR" && npm run test -- --run); then
    echo ""
    echo "✅ Tests: TODOS PASAN"
else
    echo ""
    echo "❌ Tests: SE ENCONTRARON FALLOS"

    ERROR_ID=$("$SCRIPT_DIR/error-map.sh" "tests")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error tests"

    exit 1
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0