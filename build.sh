#!/bin/sh
# Wraps page.html (the body-only source that is also published as the claude.ai artifact) into index.html for GitHub Pages.
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><meta name="theme-color" content="#1b1c1b"></head><body>\n'
  cat page.html
  printf '\n</body></html>\n'
} > index.html
echo "built index.html"
