const db = require('../config/db');

// CREATE PRODUCT
exports.createProduct = (req, res) => {
    const { name, purchase_price, sale_price, category_id } = req.body;

    const profit = sale_price - purchase_price;

    const query = `
    INSERT INTO products (name, purchase_price, sale_price, profit, category_id)
    VALUES (?, ?, ?, ?, ?)
  `;

    db.query(
        query, [name, purchase_price, sale_price, profit, category_id],
        (err, result) => {
            if (err) {
                return res.status(500).json(err);
            }
            res.status(201).json({ message: 'Produit ajouté', id: result.insertId });
        }
    );
};

// GET ALL PRODUCTS
exports.getAllProducts = (req, res) => {

    // JOIN pour récupérer le nom de catégorie
    const query = `
    SELECT 
      p.*,
      c.name AS category_name
    FROM products p
    LEFT JOIN categories c
    ON p.category_id = c.id
  `;

    db.query(query, (err, results) => {
        if (err) return res.status(500).json(err);

        res.json(results);
    });
};

// UPDATE PRODUCT

exports.updateProduct = (req, res) => {
    const { id } = req.params;
    const { name, purchase_price, sale_price, category_id } = req.body;

    const profit = sale_price - purchase_price;

    const query = `
    UPDATE products 
    SET name=?, purchase_price=?, sale_price=?, profit=?, category_id=? 
    WHERE id=?
  `;

    db.query(
        query, [name, purchase_price, sale_price, profit, category_id, id],
        (err, result) => {
            if (err) return res.status(500).json(err);

            res.json({ message: 'Produit mis à jour' });
        }
    );
};

// DELETE PRODUCT
exports.deleteProduct = (req, res) => {
    const { id } = req.params;

    const query = `DELETE FROM products WHERE id=?`;

    db.query(query, [id], (err) => {
        if (err) return res.status(500).json(err);

        res.json({ message: 'Produit supprimé' });
    });
};

// SEARCH PRODUCTS
exports.searchProducts = (req, res) => {
    const { name } = req.query;

    const query = `
    SELECT * FROM products
    WHERE name LIKE ?
  `;

    db.query(query, [`%${name}%`], (err, results) => {
        if (err) return res.status(500).json(err);

        res.json(results);
    });
};