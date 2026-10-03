#!/bin/sh
# Wraps page.html (the body-only source that is also published as the claude.ai artifact) into index.html for GitHub Pages.
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><meta name="theme-color" content="#1b1c1b">'
  # "Add to Home Screen": opens full-screen like an app, with its own icon
  printf '<link rel="manifest" href="manifest.webmanifest"><link rel="apple-touch-icon" href="icons/icon-180.png"><link rel="icon" href="icons/icon-192.png"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-title" content="Wall Try-On"><meta name="apple-mobile-web-app-status-bar-style" content="default"></head><body>\n'
  cat page.html
  printf '\n</body></html>\n'
} > index.html
echo "built index.html"
