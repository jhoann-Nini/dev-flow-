#!/bin/bash
DEV_FLOW_DIR="$HOME/proyectos/dev-flow-"

PROJECT_DIR="$1"

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ No se recibió el directorio del proyecto."
    exit 1
fi

echo "🚀 Creando estructura Full Stack..."

mkdir -p "$PROJECT_DIR/frontend"
mkdir -p "$PROJECT_DIR/backend"
mkdir -p "$PROJECT_DIR/docs"

echo "✓ frontend creado"
echo "✓ backend creado"
echo "✓ docs creado"

echo ""
echo "⚛️ Creando frontend Next.js..."

if "$DEV_FLOW_DIR/scripts/new/create-nextjs.sh" "$PROJECT_DIR/frontend"; then
    echo "✓ Frontend Next.js creado"
else
    echo "❌ Error creando frontend Next.js"
    exit 1
fi

echo ""
echo "☕ Creando backend Spring Boot..."

if "$DEV_FLOW_DIR/scripts/new/create-springboot.sh" "$PROJECT_DIR/backend"; then
    echo "✓ Backend Spring Boot creado"
else
    echo "❌ Error creando backend Spring Boot"
    exit 1
fi
