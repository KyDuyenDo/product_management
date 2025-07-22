
# Product Management Mock Server

RESTful API mock server for product management with Flutter app integration.

## 🚀 Quick Start

```bash
npm install
npm run dev
```

Server runs on `http://localhost:3000`

---

## 📦 API Endpoints

### 🔹 Products

- `GET /products` – Get all products with pagination  
  - `?q=search` – Search by name/description  
  - `?categoryId=1` – Filter by category  

- `GET /products/:id` – Get product by ID  
- `POST /products` – Create new product  
- `PUT /products/:id` – Update product  
- `DELETE /products/:id` – Delete product  

### 🔹 Categories

- `GET /categories` – Get all categories

---

## 📥 Request Examples

```bash
# Get products with search and pagination
curl "http://localhost:3000/products?q=iPhone&categoryId=1"

# Create product
curl -X POST http://localhost:3000/products   -H "Content-Type: application/json"   -d '{
    "name": "iPhone 15 Pro",
    "description": "Latest iPhone model",
    "price": 999.99,
    "stock": 50,
    "category_id": 1,
    "thumbnail": "https://example.com/image.jpg",
    "images": ["https://example.com/image1.jpg"]
  }'

# Update product
curl -X PUT http://localhost:3000/products/1   -H "Content-Type: application/json"   -d '{
    "name": "Updated iPhone",
    "description": "Updated description",
    "price": 1099.99,
    "stock": 30,
    "category_id": 1
  }'

# Delete product
curl -X DELETE http://localhost:3000/products/1
```

---

## 📤 Response Format

### 🟩 Get Products Response

```json
{
  "products": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "description": "Latest iPhone model",
      "price": 999.99,
      "stock": 50,
      "category_id": 1,
      "category_name": "Electronics",
      "stock_status": "In Stock",
      "thumbnail": "https://via.placeholder.com/300",
      "images": [],
      "created_at": "2024-01-15T10:30:00.000Z",
      "updated_at": "2024-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 50,
  }
}
```

### 🟨 Single Product Response

```json
{
  "id": 1,
  "name": "iPhone 15 Pro",
  "description": "Latest iPhone model",
  "price": 999.99,
  "stock": 50,
  "category_id": 1,
  "category_name": "Electronics",
  "stock_status": "In Stock",
  "thumbnail": "https://via.placeholder.com/300",
  "images": [],
  "created_at": "2024-01-15T10:30:00.000Z",
  "updated_at": "2024-01-15T10:30:00.000Z"
}
```

### 🟦 Categories Response

```json
[
  { "id": 1, "name": "Electronics" },
  { "id": 2, "name": "Clothing" }
]
```

---

## ✅ Validation Rules

### Product Creation/Update

- **name**: Required, non-empty string  
- **description**: Required, non-empty string  
- **price**: Required, positive number  
- **stock**: Required, non-negative integer  
- **category_id**: Required, must exist in categories  
- **thumbnail**: Optional, defaults to placeholder  
- **images**: Optional, array of image URLs  

---

## ❌ Error Responses

### 400 – Validation Error

```json
{
  "error": "Validation failed",
  "messages": [
    "Product name is required",
    "Valid price is required"
  ]
}
```

### 404 – Not Found Error

```json
{
  "error": "Product not found",
  "message": "Product with ID 999 does not exist"
}
```

### 500 – Server Error

```json
{
  "error": "Internal server error",
  "message": "Something went wrong on the server"
}
```

---

## 🛠 Features

- ✅ **Pagination**  
- ✅ **Search**  
- ✅ **Filtering**  
- ✅ **Validation**  
- ✅ **Auto-generated IDs**  
- ✅ **Stock Status**  
- ✅ **Category Names**  
- ✅ **Timestamps**  
- ✅ **CORS** enabled  
- ✅ **Request Logging**

---

## ⚡️ Response Times

| Endpoint           | Time     |
|--------------------|----------|
| Categories         | ~200ms   |
| Get Products       | ~300ms   |
| Get Product by ID  | ~200ms   |
| Create Product     | ~500ms   |
| Update Product     | ~400ms   |
| Delete Product     | ~300ms   |

---

## 💾 Data Persistence

- Products stored in `./data/products.json`  
- Categories stored in `./data/categories.json`  
- Auto-saved on create/update/delete

---

## 👨‍💻 Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

---

## ⚙️ Environment Variables

- `PORT` – Server port (default: 3000)

---

## 📁 Directory Structure

```
mock-server/
├── server.js            # Main server file
├── package.json         # Dependencies
├── data/                # JSON data storage
│   ├── products.json    # Products data
│   └── categories.json  # Categories data
└── README.md            # Documentation
```

---

## 🌐 Network Configuration

- **Local Development**: `http://localhost:3000`  
- **Android Emulator**: `http://10.0.2.2:3000`  
- **iOS Simulator**: `http://localhost:3000`  
- **Physical Device**: `http://YOUR_IP_ADDRESS:3000`
