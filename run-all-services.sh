#!/bin/bash

# Build all projects
echo "Building User Service..."
cd user && mvn clean package && cd ..

echo "Building Inventory Service..."
cd inventory && mvn clean package && cd ..

echo "Building Order Service..."
cd order && mvn clean package && cd ..

echo "Building Catalog Service..."
cd catalog && mvn clean package && cd ..

echo "Building Payment Service..."
cd payment && mvn clean package && cd ..

echo "Building Shopping Cart Service..."
cd shoppingcart && mvn clean package && cd ..

# Start all services using docker-compose
echo "Starting all services with Docker Compose..."
docker-compose up -d

echo "All services are running:"
echo "- User Service: http://localhost:6050/user"
echo "- Inventory Service: http://localhost:7050/inventory"
echo "- Order Service: http://localhost:8050/order"
echo "- Catalog Service: http://localhost:5050/catalog"
echo "- Payment Service: http://localhost:9050/payment"
echo "- Shopping Cart Service: http://localhost:4050/shoppingcart"
