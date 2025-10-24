#!/bin/bash

echo "🚀 Запуск Minikube..."
minikube start --driver=docker

HOSTNAME=$(hostname)
echo "🖥️  Имя сервера: $HOSTNAME"

while true; do
  echo "📦 Запуск интерактивного приложения..."
  kubectl delete pod chess-console --ignore-not-found
  kubectl run chess-console \
    --image=88tima/chess \
    --restart=Never \
    --stdin --tty --rm

  echo ""
  read -p "⚠️  Приложение завершено. Перезапустить? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "✅ Выход."
    break
  fi
done
