#!/bin/bash

echo "🚀 Запуск Minikube..."
minikube start --driver=docker

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
echo "🖥️  Имя сервера: $HOSTNAME"
echo "🌐 IP-адрес: $IP"
echo "📦 Запуск приложения через Deployment..."

# Удаляем старый Deployment
kubectl delete deployment chess-app --ignore-not-found

# Создаём новый Deployment
kubectl create deployment chess-app --image=88tima/chess

# Ждём, пока Pod перейдёт в статус "Running"
echo "⏳ Ожидание запуска Pod'а..."
kubectl wait --for=condition=ready pod -l app=chess-app --timeout=120s

# Получаем имя Pod'а
POD_NAME=$(kubectl get pod -l app=chess-app -o jsonpath='{.items[0].metadata.name}')

echo "📄 Вывод программы с самого начала:"
kubectl logs -f "$POD_NAME"
