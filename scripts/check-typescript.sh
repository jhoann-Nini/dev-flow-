#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "      DEV-FLOW - TYPESCRIPT CHECK"
echo "======================================"
echo ""

FRONTEND_DIR="${1:-.}"

if [ ! -f "$FRONTEND_DIR/tsconfig.json" ]; then
    echo "⚠️  No se encontró tsconfig.json"
    exit 1
fi

echo "🔷 Ejecutando TypeScript..."
echo ""

if (cd "$FRONTEND_DIR" && npx tsc --noEmit --pretty false); then
    echo "✅ TypeScript: SIN ERRORES"
else
    echo ""
    echo "❌ TypeScript: SE ENCONTRARON ERRORES"

    ERROR_ID=$("$SCRIPT_DIR/error-map.sh" "typescript")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error typescript"

    exit 1
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0