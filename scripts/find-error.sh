#!/bin/bash

ERRORS_FILE="$HOME/proyectos/dev-flow-/docs/errors.md"
MAP_SCRIPT="$HOME/proyectos/dev-flow-/scripts/error-map.sh"

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

if [ ! -x "$MAP_SCRIPT" ]; then
    echo "❌ No se encontró el mapa de errores:"
    echo "   $MAP_SCRIPT"
    exit 1
fi

ERROR_ID=$("$MAP_SCRIPT" "$CATEGORY")

if [ "$ERROR_ID" = "ERROR-NOT-FOUND" ]; then
    echo "⚠️ No se encontró ningún error para la categoría:"
    echo "   $CATEGORY"
    exit 1
fi

echo "======================================"
echo "       DEV-FLOW - ERROR SEARCH"
echo "======================================"
echo ""

echo "🔎 Categoría:"
echo "   $CATEGORY"
echo ""

echo "🆔 Error asociado:"
echo "   $ERROR_ID"
echo ""

FOUND=0
PRINTING=0

while IFS= read -r LINE; do

    if [[ "$LINE" == "## $ERROR_ID "* ]]; then
        FOUND=1
        PRINTING=1

        echo "✅ Error encontrado:"
        echo ""
    elif [[ "$LINE" == "## ERROR-"* ]] && [ "$PRINTING" -eq 1 ]; then
        PRINTING=0
    fi

    if [ "$PRINTING" -eq 1 ]; then
        echo "$LINE"
    fi

done < "$ERRORS_FILE"

echo ""

if [ "$FOUND" -eq 0 ]; then
    echo "⚠️ El error $ERROR_ID no se encontró en la base de conocimiento."
    echo ""
    echo "======================================"
    exit 1
fi

echo "======================================"

exit 0