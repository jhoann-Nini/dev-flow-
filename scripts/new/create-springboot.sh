#!/bin/bash

PROJECT_DIR="$1"

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ No se recibió la carpeta del proyecto."
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_DIR")
TEMP_DIR="/tmp/${PROJECT_NAME}-springboot"

echo "☕ Creando proyecto Spring Boot..."

curl -fL "https://start.spring.io/starter.zip?type=maven-project&language=java&bootVersion=4.0.0&baseDir=${PROJECT_NAME}&groupId=com.example&artifactId=${PROJECT_NAME}&name=${PROJECT_NAME}&description=Proyecto%20Spring%20Boot&packageName=com.example.${PROJECT_NAME}&packaging=jar&javaVersion=21&dependencies=web,data-jpa,postgresql,validation" \
    -o "/tmp/${PROJECT_NAME}.zip"

if [ $? -ne 0 ]; then
    echo "❌ No se pudo descargar el proyecto Spring Boot."
    exit 1
fi

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

if unzip -q "/tmp/${PROJECT_NAME}.zip" -d "$TEMP_DIR"; then
    echo "✓ Proyecto Spring Boot descomprimido"
else
    echo "❌ No se pudo descomprimir el proyecto Spring Boot."
    rm -rf "$TEMP_DIR"
    rm -f "/tmp/${PROJECT_NAME}.zip"
    exit 1
fi

if cp -a "$TEMP_DIR/${PROJECT_NAME}/." "$PROJECT_DIR/"; then
    echo "✓ Archivos Spring Boot copiados"
else
    echo "❌ No se pudieron copiar los archivos del proyecto Spring Boot"
    rm -rf "$TEMP_DIR"
    rm -f "/tmp/${PROJECT_NAME}.zip"
    exit 1
fi

rm -rf "$TEMP_DIR"


rm -f "/tmp/${PROJECT_NAME}.zip"

echo "🧪 Configurando H2 para tests..."

if grep -q "<artifactId>h2</artifactId>" "$PROJECT_DIR/pom.xml"; then
    echo "✓ H2 ya está configurado"
else
    sed -i '/<dependencies>/a\
        <dependency>\
            <groupId>com.h2database</groupId>\
            <artifactId>h2</artifactId>\
            <scope>test</scope>\
        </dependency>' "$PROJECT_DIR/pom.xml"

    if [ $? -eq 0 ]; then
        echo "✓ H2 agregado para tests"
    else
        echo "❌ No se pudo agregar H2"
        exit 1
    fi
fi

echo "🧪 Configurando base de datos para tests..."

mkdir -p "$PROJECT_DIR/src/test/resources"

cat > "$PROJECT_DIR/src/test/resources/application.properties" <<'EOF'
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=false
EOF

if [ $? -eq 0 ]; then
    echo "✓ H2 configurado para tests"
else
    echo "❌ No se pudo crear la configuración de H2"
    exit 1
fi

echo "🧪 Ejecutando tests iniciales..."

cd "$PROJECT_DIR" || exit 1

if ./mvnw test; then
    echo "✓ Tests iniciales: OK"
else
    echo "❌ Los tests iniciales fallaron"
    exit 1
fi

echo "✓ Maven configurado"
echo "✓ Spring Web agregado"
echo "✓ Spring Data JPA agregado"
echo "✓ PostgreSQL agregado"
echo "✓ Validation agregado"
echo "✓ Spring Boot Test incluido"

exit 0
