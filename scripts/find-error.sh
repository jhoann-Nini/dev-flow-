#!/bin/bash

ERRORS_FILE="$HOME/proyectos/dev-flow-/docs/errors.md"

CATEGORY="$1"

if [ -z "$CATEGORY" ]; then
    echo "Uso:"
    echo "  dev error <categoría>"
    echo ""
    echo "Ejemplo:"
    echo "  dev error ports"
    exit 1
fi

if [ ! -f "$ERRORS_FILE" ]; then
    echo "❌ No se encontró la base de conocimiento:"
    echo "   $ERRORS_FILE"
    exit 1
fi

echo "======================================"
echo "       DEV-FLOW - ERROR SEARCH"
echo "======================================"
echo ""

echo "🔎 Categoría buscada:"
echo "   $CATEGORY"
echo ""

FOUND=0
PRINTING=0

while IFS= read -r LINE; do

    # Detectar el inicio de un nuevo error
    if [[ "$LINE" == "## ERROR-"* ]]; then
        PRINTING=0
        CURRENT_ERROR="$LINE"
    fi

    # Detectar la categoría
    if [[ "$LINE" == "**Categoría:** $CATEGORY" ]]; then
        FOUND=1
        PRINTING=1

        echo "✅ Error encontrado:"
        echo ""
        echo "$CURRENT_ERROR"
    fi

    # Mostrar el contenido del error encontrado
    if [ "$PRINTING" -eq 1 ]; then
        echo "$LINE"
    fi

done < "$ERRORS_FILE"

echo ""

if [ "$FOUND" -eq 0 ]; then
    echo "⚠️ No se encontró ningún error para la categoría:"
    echo "   $CATEGORY"
    echo ""
    echo "======================================"
    exit 1
fi

echo "======================================"

exit 0