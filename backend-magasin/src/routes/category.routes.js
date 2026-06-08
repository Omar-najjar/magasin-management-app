const express = require('express');
const router = express.Router();

const categoryController = require('../controllers/category.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// CRUD catégories
router.post('/', verifyToken, categoryController.createCategory);
router.get('/', verifyToken, categoryController.getAllCategories);
router.put('/:id', verifyToken, categoryController.updateCategory);
router.delete('/:id', verifyToken, categoryController.deleteCategory);

module.exports = router;