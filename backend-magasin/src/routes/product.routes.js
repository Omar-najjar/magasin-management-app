const express = require('express');
const router = express.Router();

const productController = require('../controllers/product.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// Toutes les routes protégées 🔒
router.post('/', verifyToken, productController.createProduct);
router.get('/', verifyToken, productController.getAllProducts);
router.put('/:id', verifyToken, productController.updateProduct);
router.delete('/:id', verifyToken, productController.deleteProduct);
router.get('/search', verifyToken, productController.searchProducts);

module.exports = router;