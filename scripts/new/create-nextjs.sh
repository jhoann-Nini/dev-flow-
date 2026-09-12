#!/bin/bash

PROJECT_DIR="$1"

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ No se recibió el directorio del proyecto."
    exit 1
fi

echo "⚡ Creando proyecto Next.js..."

cd "$PROJECT_DIR" || exit 1

npx create-next-app@latest . \
    --typescript \
    --eslint \
    --tailwind \
    --app \
    --src-dir \
    --import-alias "@/*" \
    --use-npm
