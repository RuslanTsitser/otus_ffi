#!/bin/bash


case "${1:-prebuild}" in
    "compile")
        bash ./scripts/compile.sh
        ;;
    "ffigen")
        bash ./scripts/ffigen.sh
        ;;
    "prebuild")
        bash ./scripts/prebuild.sh
        ;;
    *)
        echo "Неизвестная опция: $1"
        exit 1
        ;;
esac
