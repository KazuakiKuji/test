#!/bin/bash
git config core.hooksPath .githooks
chmod +x .githooks/*
echo "フックのセットアップが完了しました"
