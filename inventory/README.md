# Inventory Service

A Jakarta EE and MicroProfile-based REST service for inventory management in the Liberty Rest App demo.

## Features

- Provides CRUD operations for inventory management
- Tracks product inventory with inventory_id, product_id, and quantity
- Uses Jakarta EE 10.0 and MicroProfile 6.1
- Runs on Open Liberty runtime

## Running the Application

To start the application, run:

```
cd inventory
mvn liberty:run
```

This will start the Open Liberty server on port 7050 (HTTP) and 7051 (HTTPS).

## API Endpoints

| Method | URL                                               | Description                      |
|--------|---------------------------------------------------|----------------------------------|
| GET    | /api/inventories                                  | Get all inventory items          |
| GET    | /api/inventories/{id}                             | Get inventory by ID              |
| GET    | /api/inventories/product/{productId}              | Get inventory by product ID      |
| POST   | /api/inventories                                  | Create new inventory             |
| PUT    | /api/inventories/{id}                             | Update inventory                 |
| DELETE | /api/inventories/{id}                             | Delete inventory                 |
| PATCH  | /api/inventories/product/{productId}/quantity/{quantity} | Update product quantity   |

## Testing with cURL

### Get all inventory items
```
curl -X GET http://localhost:7050/inventory/api/inventories
```

### Get inventory by ID
```
curl -X GET http://localhost:7050/inventory/api/inventories/1
```

### Create new inventory
```
curl -X POST http://localhost:7050/inventory/api/inventories \
  -H "Content-Type: application/json" \
  -d '{"productId": 123, "quantity": 50}'
```

### Update inventory
```
curl -X PUT http://localhost:7050/inventory/api/inventories/1 \
  -H "Content-Type: application/json" \
  -d '{"productId": 123, "quantity": 75}'
```

### Delete inventory
```
curl -X DELETE http://localhost:7050/inventory/api/inventories/1
```

### Update product quantity
```
curl -X PATCH http://localhost:7050/inventory/api/inventories/product/123/quantity/100
```
