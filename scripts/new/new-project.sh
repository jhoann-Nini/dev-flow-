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
echo "5. Full Stack (Next.js + Spring Boot)"
echo "6. Personalizado"
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
        TYPE_NAME="Full Stack (Next.js + Spring Boot)"
        ;;
    6)
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
BASE_DIR="$PROJECTS_DIR"

echo ""
echo "Ubicación:"
echo ""
echo "1. ~/proyectos"
echo "2. Elegir carpeta dentro de ~/proyectos"
echo "3. Ruta personalizada"
echo ""

read -r -p "> " LOCATION_OPTION

case "$LOCATION_OPTION" in
    1)
        BASE_DIR="$PROJECTS_DIR"
        ;;

    2)
        echo ""
        echo "Carpetas disponibles:"
        echo ""

        FOLDERS=()

        while IFS= read -r FOLDER; do
            FOLDERS+=("$FOLDER")
        done < <(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)

        if [ "${#FOLDERS[@]}" -eq 0 ]; then
            echo "❌ No hay carpetas disponibles dentro de ~/proyectos."
            exit 1
        fi

        for i in "${!FOLDERS[@]}"; do
            echo "$((i + 1)). ${FOLDERS[$i]}"
        done

        echo ""

        read -r -p "> " FOLDER_OPTION

        if ! [[ "$FOLDER_OPTION" =~ ^[0-9]+$ ]] || [ "$FOLDER_OPTION" -lt 1 ] || [ "$FOLDER_OPTION" -gt "${#FOLDERS[@]}" ]; then
            echo "❌ Opción de carpeta no válida."
            exit 1
        fi

        BASE_DIR="$PROJECTS_DIR/${FOLDERS[$((FOLDER_OPTION - 1))]}"
        ;;

    3)
        echo ""
        read -r -p "Ruta donde crear el proyecto: " BASE_DIR

        BASE_DIR="${BASE_DIR/#\~/$HOME}"

        if [ ! -d "$BASE_DIR" ]; then
            echo "❌ La ruta no existe:"
            echo "   $BASE_DIR"
            exit 1
        fi
        ;;

    *)
        echo "❌ Opción de ubicación no válida."
        exit 1
        ;;
esac

PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"

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

# Verificar que no existan repositorios Git anidados
if find "$PROJECT_DIR" -type d -name ".git" -print -quit | grep -q .; then
    echo ""
    echo "❌ Se encontró un repositorio Git dentro del proyecto."
    echo "   No se continuará para evitar repositorios Git anidados."
    exit 1
fi

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

if [ "$PROJECT_TYPE" -eq 2 ]; then
    if "$DEV_FLOW_DIR/scripts/new/create-springboot.sh" "$PROJECT_DIR"; then
        echo "✓ Spring Boot creado"
    else
        echo "❌ Error creando proyecto Spring Boot"
        exit 1
    fi
fi

if [ "$PROJECT_TYPE" -eq 5 ]; then
    "$DEV_FLOW_DIR/scripts/new/create-fullstack.sh" "$PROJECT_DIR"
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
    if cp "$DEV_FLOW_DIR/templates/nextjs/next.config.ts" "$PROJECT_DIR/next.config.ts"; then
        echo "✓ configuración Next.js creada"
    else
        echo "❌ No se pudo crear configuración Next.js"
        exit 1
    fi
fi

if [ "$PROJECT_TYPE" -eq 1 ]; then
    if cp "$DEV_FLOW_DIR/templates/nextjs/docker/Dockerfile" "$PROJECT_DIR/Dockerfile"; then
        echo "✓ Dockerfile creado"
    else
        echo "❌ No se pudo crear Dockerfile"
        exit 1
    fi

    if cp "$DEV_FLOW_DIR/templates/nextjs/docker/.dockerignore" "$PROJECT_DIR/.dockerignore"; then
        echo "✓ .dockerignore creado"
    else
        echo "❌ No se pudo crear .dockerignore"
        exit 1
    fi
fi

if [ "$PROJECT_TYPE" -eq 1 ]; then
    mkdir -p "$PROJECT_DIR/.github/workflows"

    if cp "$DEV_FLOW_DIR/templates/nextjs/github/workflows/ci.yml" "$PROJECT_DIR/.github/workflows/ci.yml"; then
        echo "✓ GitHub Actions configurado"
    else
        echo "❌ No se pudo crear workflow de GitHub Actions"
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

# Verificar repositorios Git anidados antes del commit
NESTED_GIT=$(find "$PROJECT_DIR" -mindepth 2 -type d -name ".git" -print)

if [ -n "$NESTED_GIT" ]; then
    echo ""
    echo "❌ Se encontraron repositorios Git anidados:"
    echo "$NESTED_GIT"
    echo ""
    echo "No se creará el commit inicial."
    exit 1
fi

git add .

if git commit -m "chore: initial project setup"; then
    echo "✓ Commit inicial creado"
else
    echo "❌ No se pudo crear el commit inicial"
    exit 1
fi

echo ""
echo "======================================"
echo "   PROYECTO CREADO CORRECTAMENTE"
echo "======================================"
echo ""
echo "Proyecto: $PROJECT_NAME"
echo "Tipo:     $TYPE_NAME"
echo "Ubicación:"
echo "  $PROJECT_DIR"
echo ""
echo "Siguiente paso:"
echo ""
echo "  cd $PROJECT_DIR"
echo "  dev doctor"
echo "  dev check"
echo ""
echo "======================================"
