#!/bin/bash

echo "======================================"
echo "       DEV-FLOW - BACKEND CHECK"
echo "======================================"
echo ""

BACKEND_DIR="proyectos/backend"

# Verificar directorio
if [ ! -d "$BACKEND_DIR" ]; then
    echo "❌ Backend: no existe el directorio"
    echo "   └─ Esperado: $BACKEND_DIR"
    exit 1
fi

echo "📦 Verificando estructura del backend..."
echo ""

# Verificar pom.xml
if [ -f "$BACKEND_DIR/pom.xml" ]; then
    echo "✅ Backend: pom.xml encontrado"
else
    echo "❌ Backend: pom.xml no encontrado"
    exit 1
fi

# Verificar Maven Wrapper
if [ -f "$BACKEND_DIR/mvnw" ]; then
    echo "✅ Backend: Maven Wrapper encontrado"
else
    echo "❌ Backend: mvnw no encontrado"
    exit 1
fi

# Verificar código fuente
if [ -d "$BACKEND_DIR/src/main" ]; then
    echo "✅ Backend: src/main encontrado"
else
    echo "❌ Backend: src/main no encontrado"
    exit 1
fi

# Verificar tests
if [ -d "$BACKEND_DIR/src/test" ]; then
    echo "✅ Backend: src/test encontrado"
else
    echo "⚠️  Backend: src/test no encontrado"
fi

echo ""
echo "🧪 Ejecutando tests del backend..."
echo ""

cd "$BACKEND_DIR" || exit 1

if ./mvnw test; then
    echo ""
    echo "✅ Backend: TESTS CORRECTOS"
else
    echo ""
    echo "❌ Backend: LOS TESTS FALLARON"
    exit 1
fi

echo ""
echo "======================================"
echo "       VERIFICACIÓN TERMINADA"
echo "======================================"

exit 0
