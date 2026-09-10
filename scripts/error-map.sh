#!/bin/bash

CATEGORY="$1"

case "$CATEGORY" in
    ports)
        echo "ERROR-001"
        ;;
    docker)
        echo "ERROR-002"
        ;;
    git)
        echo "ERROR-003"
        ;;
    typescript)
        echo "ERROR-004"
        ;;
    eslint)
        echo "ERROR-005"
        ;;
    tests)
        echo "ERROR-006"
        ;;
    build)
        echo "ERROR-007"
        ;;
    dependencies)
        echo "ERROR-008"
        ;;
    environment)
        echo "ERROR-009"
        ;;
    *)
        echo "ERROR-NOT-FOUND"
        exit 1
        ;;
esac