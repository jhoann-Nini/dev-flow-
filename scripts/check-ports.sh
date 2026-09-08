#!/bin/bash

echo "======================================"
echo "       DEV-FLOW - PORT CHECK"
echo "======================================"
echo ""

PORTS=(3000 5432 8080 8081 5173)

for PORT in "${PORTS[@]}"; do

    if ss -ltn "( sport = :$PORT )" | grep -q ":$PORT"; then
        echo "⚠️  Puerto $PORT: OCUPADO"

        PROCESS=$(lsof -i :"$PORT" -sTCP:LISTEN 2>/dev/null | tail -n +2 | awk '{print $1}' | head -n 1)

        if [ -n "$PROCESS" ]; then
            echo "   └─ Proceso: $PROCESS"
        fi
    else
        echo "✅ Puerto $PORT: LIBRE"
    fi

done

echo ""
echo "======================================"
echo "          VERIFICACIÓN TERMINADA"
echo "======================================"
