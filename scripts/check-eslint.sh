#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="${1:-.}"

echo "======================================"
echo "        DEV-FLOW - ESLINT CHECK"
echo "======================================"
echo ""

if [ ! -f "$FRONTEND_DIR/package.json" ]; then
    echo "⚠️  No se encontró package.json"
    exit 1
fi

if ! (cd "$FRONTEND_DIR" && node -e "const p=require('./package.json'); process.exit(p.scripts?.lint ? 0 : 1)" 2>/dev/null); then
    echo "⚠️  No existe script 'lint' en package.json"
    exit 1
fi

echo "🧹 Ejecutando ESLint..."
echo ""

LINT_OUTPUT=$(mktemp)

(cd "$FRONTEND_DIR" && npm run lint -- --no-warn-ignored) > "$LINT_OUTPUT" 2>&1
LINT_EXIT=$?

cat "$LINT_OUTPUT"

LINT_SUMMARY=$(grep -E '✖ [0-9]+ problem' "$LINT_OUTPUT" | tail -n 1)

LINT_ERRORS=0
LINT_WARNINGS=0

if [ -n "$LINT_SUMMARY" ]; then
    LINT_ERRORS=$(echo "$LINT_SUMMARY" | sed -E 's/.*\(([0-9]+) errors?.*/\1/')
    LINT_WARNINGS=$(echo "$LINT_SUMMARY" | sed -E 's/.*,[[:space:]]*([0-9]+) warnings?\).*/\1/')
fi

rm -f "$LINT_OUTPUT"

echo ""

if [ "$LINT_ERRORS" -gt 0 ]; then
    echo "❌ ESLint: $LINT_ERRORS error(es)"

    ERROR_ID=$("$SCRIPT_DIR/error-map.sh" "eslint")

    echo "   └─ Error relacionado: $ERROR_ID"
    echo "   └─ Solución: dev error eslint"

    exit 1
fi

if [ "$LINT_WARNINGS" -gt 0 ]; then
    echo "⚠️  ESLint: $LINT_WARNINGS warning(s)"
else
    echo "✅ ESLint: SIN PROBLEMAS"
fi

echo ""
echo "======================================"
echo "        VERIFICACIÓN TERMINADA"
echo "======================================"

exit "$LINT_EXIT"