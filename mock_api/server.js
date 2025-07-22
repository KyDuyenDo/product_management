const express = require("express")
const cors = require("cors")
const fs = require("fs-extra")
const path = require("path")

const app = express()
const PORT = process.env.PORT || 3000

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

const products = require("./data/products.json")
const categories = require("./data/categories.json")

const saveProducts = () => {
  fs.writeFileSync(path.join(__dirname, "data/products.json"), JSON.stringify(products, null, 2))
}

const getNextProductId = () => {
  return products.length > 0 ? Math.max(...products.map((p) => p.id)) + 1 : 1
}

const findProductById = (id) => {
  return products.find((p) => p.id === Number.parseInt(id))
}

const validateProduct = (product) => {
  const errors = []
  if (!product.name || product.name.trim() === "") {
    errors.push("Product name is required")
  }
  if (!product.description || product.description.trim() === "") {
    errors.push("Product detail is required")
  }
  if (!product.price || isNaN(product.price) || product.price <= 0) {
    errors.push("Valid price is required")
  }
  if (!product.stock || isNaN(product.stock) || product.stock < 0) {
    errors.push("Valid stock quantity is required")
  }
  if (!product.category_id || !categories.find((c) => c.id === Number.parseInt(product.category_id))) {
    errors.push("Valid category is required")
  }
  return errors
}

app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`)
  next()
})

// GET /categories - Get all categories
app.get("/categories", (req, res) => {
  setTimeout(() => {
    res.json(categories)
  }, 200)
})

// GET /products - Get all products with optional filtering
app.get("/products", (req, res) => {
  setTimeout(() => {
    let filteredProducts = [...products]
    if (req.query.q) {
      const query = req.query.q.toLowerCase()
      filteredProducts = filteredProducts.filter(
        (product) =>
          product.name.toLowerCase().includes(query) || product.description.toLowerCase().includes(query),
      )
    }
    if (req.query.categoryId) {
      const categoryId = Number.parseInt(req.query.categoryId)
      filteredProducts = filteredProducts.filter((product) => product.category_id === categoryId)
    }

    res.json({
      products: filteredProducts,
      pagination: {
        total: filteredProducts.length,
      },
    })
  }, 300)
})

// GET /products/:id - Get product by ID
app.get("/products/:id", (req, res) => {
  setTimeout(() => {
    const product = findProductById(req.params.id)
    if (!product) {
      return res.status(404).json({
        error: "Product not found",
        message: `Product with ID ${req.params.id} does not exist`,
      })
    }
    res.json(product)
  }, 200)
})

// POST /products - Create new product
app.post("/products", (req, res) => {
  setTimeout(() => {
    const errors = validateProduct(req.body)
    if (errors.length > 0) {
      return res.status(400).json({
        error: "Validation failed",
        messages: errors,
      })
    }

    const category = categories.find((c) => c.id === Number.parseInt(req.body.category_id))
    const newProduct = {
      id: getNextProductId(),
      name: req.body.name.trim(),
      description: req.body.description.trim(),
      price: Number.parseFloat(req.body.price),
      stock: Number.parseInt(req.body.stock),
      category_id: Number.parseInt(req.body.category_id),
      category_name: category.name,
      stock_status: Number.parseInt(req.body.stock) > 0 ? "In Stock" : "Out of Stock",
      thumbnail: req.body.thumbnail || "https://via.placeholder.com/300",
      images: req.body.images || [],
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }

    products.push(newProduct)
    saveProducts()
    res.status(201).json(newProduct)
  }, 500)
})

// PUT /products/:id - Update product
app.put("/products/:id", (req, res) => {
  setTimeout(() => {
    const product = findProductById(req.params.id)
    if (!product) {
      return res.status(404).json({
        error: "Product not found",
        message: `Product with ID ${req.params.id} does not exist`,
      })
    }

    const errors = validateProduct(req.body)
    if (errors.length > 0) {
      return res.status(400).json({
        error: "Validation failed",
        messages: errors,
      })
    }

    const category = categories.find((c) => c.id === Number.parseInt(req.body.category_id))
    
    product.name = req.body.name.trim()
    product.description = req.body.description.trim()
    product.price = Number.parseFloat(req.body.price)
    product.stock = Number.parseInt(req.body.stock)
    product.category_id = Number.parseInt(req.body.category_id)
    product.category_name = category.name
    product.stock_status = Number.parseInt(req.body.stock) > 0 ? "In Stock" : "Out of Stock"
    
    if (req.body.thumbnail) {
      product.thumbnail = req.body.thumbnail
    }
    if (req.body.images) {
      product.images = req.body.images
    }
    
    product.updated_at = new Date().toISOString()

    saveProducts()
    res.json(product)
  }, 400)
})

// DELETE /products/:id - Delete product
app.delete("/products/:id", (req, res) => {
  setTimeout(() => {
    const productIndex = products.findIndex((p) => p.id === Number.parseInt(req.params.id))
    if (productIndex === -1) {
      return res.status(404).json({
        error: "Product not found",
        message: `Product with ID ${req.params.id} does not exist`,
      })
    }

    products.splice(productIndex, 1)
    saveProducts()
    res.status(204).send()
  }, 300)
})

app.use((error, req, res, next) => {
  console.error("Error:", error)
  res.status(500).json({
    error: "Internal server error",
    message: "Something went wrong on the server",
  })
})

app.use("*", (req, res) => {
  res.status(404).json({
    error: "Not found",
    message: `Route ${req.method} ${req.originalUrl} not found`,
  })
})

app.listen(PORT, () => {
  console.log(`Mock server running on http://localhost:${PORT}`)
})

module.exports = app