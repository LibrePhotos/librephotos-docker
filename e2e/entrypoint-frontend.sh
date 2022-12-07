#!/usr/bin/env bash

echo "installing frontend"
npm install --legacy-peer-deps
npm run postinstall
npm run start
