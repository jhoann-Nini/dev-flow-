#!/bin/bash

echo "======================================"
echo "        DEV-FLOW - TESTS CHECK"
echo "======================================"
echo ""

if [ ! -f "package.json" ]; then
    echo "⚠️  No se encontró package.json"
    exit 1
fi

if ! node -e "const p=require('./package.json'); process.exit(p.scripts?.test ? 0 : 1)" 2>/dev/null; then
    echo "⚠️  No existe script 'test' en package.json"
    exit 1
fi

echo "🧪 Ejecutando tests..."
echo ""

if npm run test -- --run; then
    echo ""
    echo "✅ Tests: TODOS PASAN"
else
    echo ""
    echo "❌ Tests: SE ENCONTRARON FALLOS"

    ERROR_ID=$("$HOME/proyectos/dev-flow-/scripts/error-map.sh" "tests")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error tests"

    exit 1
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0