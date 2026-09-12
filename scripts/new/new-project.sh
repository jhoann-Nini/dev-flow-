#!/bin/bash
DEV_FLOW_DIR="$HOME/proyectos/dev-flow-"

echo ""
echo "╔══════════════════════════════════╗"
echo "║          DEV-FLOW                ║"
echo "║       NUEVO PROYECTO             ║"
echo "╚══════════════════════════════════╝"
echo ""

echo "Nombre:"
read -r -p "> " PROJECT_NAME

echo ""

echo "Tipo:"
echo ""
echo "1. Next.js"
echo "2. Spring Boot"
echo "3. Python"
echo "4. C++"
echo "5. Proyecto personalizado"
echo ""

read -r -p "> " PROJECT_TYPE

echo ""

case "$PROJECT_TYPE" in
    1)
        TYPE_NAME="Next.js"
        ;;
    2)
        TYPE_NAME="Spring Boot"
        ;;
    3)
        TYPE_NAME="Python"
        ;;
    4)
        TYPE_NAME="C++"
        ;;
    5)
        TYPE_NAME="Personalizado"
        ;;
    *)
        echo "❌ Opción no válida."
        exit 1
        ;;
esac

if [ -z "$PROJECT_NAME" ]; then
    echo "❌ El nombre del proyecto no puede estar vacío."
    exit 1
fi

echo "======================================"
echo ""
echo "Proyecto seleccionado:"
echo "Nombre: $PROJECT_NAME"
echo "Tipo:   $TYPE_NAME"
echo ""
echo "======================================"

PROJECTS_DIR="$HOME/proyectos"
PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [ -d "$PROJECT_DIR" ]; then
    echo ""
    echo "❌ Ya existe un proyecto con ese nombre:"
    echo "   $PROJECT_DIR"
    exit 1
fi

mkdir -p "$PROJECT_DIR"

echo ""
echo "✓ Carpeta creada"
echo "  $PROJECT_DIR"

cd "$PROJECT_DIR" || exit 1

git init

git branch -m main

echo "✓ Git inicializado"
echo "✓ Rama inicial: main"

if [ "$PROJECT_TYPE" -eq 1 ]; then
    if "$DEV_FLOW_DIR/scripts/new/create-nextjs.sh" "$PROJECT_DIR"; then
        echo "✓ Next.js creado"
    else
        echo "❌ Error creando proyecto Next.js"
        exit 1
    fi
fi

if cp "$DEV_FLOW_DIR/templates/common/.gitignore" "$PROJECT_DIR/.gitignore"; then
    echo "✓ .gitignore creado"
else
    echo "❌ No se pudo crear .gitignore"
    exit 1
fi

if cp "$DEV_FLOW_DIR/templates/common/README.md" "$PROJECT_DIR/README.md"; then
    echo "✓ README creado"
else
    echo "❌ No se pudo crear README"
    exit 1
fi

if cp "$DEV_FLOW_DIR/templates/common/.env.example" "$PROJECT_DIR/.env.example"; then
    echo "✓ .env.example creado"
else
    echo "❌ No se pudo crear .env.example"
    exit 1
fi

if cp "$DEV_FLOW_DIR/templates/common/.editorconfig" "$PROJECT_DIR/.editorconfig"; then
    echo "✓ EditorConfig creado"
else
    echo "❌ No se pudo crear EditorConfig"
    exit 1
fi

if [ "$PROJECT_TYPE" -eq 1 ]; then
    if cp "$DEV_FLOW_DIR/templates/nextjs/eslint.config.mjs" "$PROJECT_DIR/eslint.config.mjs"; then
        echo "✓ configuración ESLint creada"
    else
        echo "❌ No se pudo crear configuración ESLint"
        exit 1
    fi
fi

if [ "$PROJECT_TYPE" -eq 1 ]; then
    if cp "$DEV_FLOW_DIR/templates/common/.prettierrc" "$PROJECT_DIR/.prettierrc"; then
        echo "✓ Prettier configurado"
    else
        echo "❌ Error configurando Prettier"
        exit 1
    fi

    mkdir -p "$PROJECT_DIR/tests"

    if cp "$DEV_FLOW_DIR/templates/nextjs/vitest.config.ts" "$PROJECT_DIR/vitest.config.ts"; then
        echo "✓ configuración Vitest creada"
    else
        echo "❌ Error creando configuración Vitest"
        exit 1
    fi

    if [ -f "$DEV_FLOW_DIR/templates/nextjs/vitest.dependencies" ]; then
    DEPENDENCIES=$(tr '\n' ' ' < "$DEV_FLOW_DIR/templates/nextjs/vitest.dependencies")

        if npm install -D $DEPENDENCIES; then
            npm pkg set scripts.test="vitest"
            echo "✓ tests preparados"
        else
            echo "❌ No se pudieron instalar las dependencias de tests."
            exit 1
        fi
    fi

    if cp "$DEV_FLOW_DIR/templates/nextjs/tests/example.test.ts" "$PROJECT_DIR/tests/example.test.ts"; then
        echo "✓ prueba inicial creada"
    else
        echo "❌ Error creando prueba inicial"
        exit 1
    fi
fi

echo ""

git add .

if git commit -m "chore: initial project setup"; then
    echo "✓ Commit inicial creado"
else
    echo "❌ No se pudo crear el commit inicial"
    exit 1
fi
