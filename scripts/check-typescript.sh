#!/bin/bash

echo "======================================"
echo "      DEV-FLOW - TYPESCRIPT CHECK"
echo "======================================"
echo ""

if [ ! -f "tsconfig.json" ]; then
    echo "⚠️  No se encontró tsconfig.json"
    exit 1
fi

echo "🔷 Ejecutando TypeScript..."
echo ""

if npx tsc --noEmit --pretty false; then
    echo "✅ TypeScript: SIN ERRORES"
else
    echo ""
    echo "❌ TypeScript: SE ENCONTRARON ERRORES"

    ERROR_ID=$("$HOME/proyectos/dev-flow-/scripts/error-map.sh" "typescript")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error typescript"

    exit 1
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0