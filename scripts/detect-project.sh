#!/bin/bash

echo "======================================"
echo "     DEV-FLOW - PROJECT DETECTOR"
echo "======================================"
echo ""

PROJECT_TYPE="unknown"

if [ -f "package.json" ]; then
    if grep -q '"next"' package.json 2>/dev/null; then
        PROJECT_TYPE="nextjs"
    else
        PROJECT_TYPE="nodejs"
    fi

elif [ -f "pom.xml" ]; then
    PROJECT_TYPE="springboot"

elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    PROJECT_TYPE="python"

elif [ -f "CMakeLists.txt" ]; then
    PROJECT_TYPE="cpp"
fi

echo "📁 Directorio:"
echo "   $(pwd)"
echo ""

echo "🔍 Tipo de proyecto:"
echo "   $PROJECT_TYPE"
echo ""

case "$PROJECT_TYPE" in
    nextjs)
        echo "⚡ Framework detectado: Next.js"
        ;;
    nodejs)
        echo "🟢 Entorno detectado: Node.js"
        ;;
    springboot)
        echo "☕ Build system detectado: Maven / Spring Boot"
        ;;
    python)
        echo "🐍 Entorno detectado: Python"
        ;;
    cpp)
        echo "⚙️  Build system detectado: CMake / C++"
        ;;
    unknown)
        echo "⚠️  No se pudo identificar el tipo de proyecto."
        ;;
esac

echo ""
echo "======================================"
echo "       DETECCIÓN TERMINADA"
echo "======================================"
