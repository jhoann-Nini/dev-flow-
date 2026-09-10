#!/bin/bash

echo "======================================"
echo "        DEV-FLOW - BUILD CHECK"
echo "======================================"
echo ""

if [ ! -f "package.json" ]; then
    echo "⚠️  No se encontró package.json"
    exit 1
fi

if ! node -e "const p=require('./package.json'); process.exit(p.scripts?.build ? 0 : 1)" 2>/dev/null; then
    echo "⚠️  No existe script 'build' en package.json"
    exit 1
fi

echo "🏗️ Ejecutando build..."
echo ""

if npm run build; then
    echo ""
    echo "✅ Build: CORRECTO"
else
    echo ""
    echo "❌ Build: FALLÓ"

    ERROR_ID=$("$HOME/proyectos/dev-flow-/scripts/error-map.sh" "build")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error build"

    exit 1
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0