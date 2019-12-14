#!/bin/bash

if [ -d "./exports" ]; then
    mv "./exports" "./export_bkp" || echo "backup failed" && exit
    rm -r "./exports"
fi

mkdir exports

zip win/moonlit-hood.zip win/*
zip linux/moonlit-hood.zip linux/*

butler push win/moonlit-hood.zip kcabra/moonlit-hood:windows
butler push linux/moonlit-hood.zip kcabra/moonlit-hood:linux
butler push mac/moonlit-hood.zip kcabra/moonlit-hood:macos

exit

