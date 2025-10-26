#!/bin/bash

echo "🚀 Запуск Minikube..."
minikube start --driver=docker

HOSTNAME=$(hostname)
echo "🖥️  Имя сервера: $HOSTNAME"

echo "📦 Запуск приложения через Deployment "

# Удаляем старый Deployment, если существует
kubectl delete deployment chess-app --ignore-not-found

# Создаём новый Deployment
kubectl create deployment chess-app --image=88tima/chess

# Убедимся, что используется свежая версия образа
kubectl set image deployment/chess-app chess-app=88tima/chess --record

echo "✅ Приложение запущено."
