const db = require('../config/db');

// CREATE CATEGORY
exports.createCategory = (req, res) => {
    const { name } = req.body;

    const query = `INSERT INTO categories (name) VALUES (?)`;

    db.query(query, [name], (err, result) => {
        if (err) return res.status(500).json(err);

        res.json({ message: "Catégorie ajoutée" });
    });
};

// GET ALL
exports.getAllCategories = (req, res) => {
    const query = `SELECT * FROM categories`;

    db.query(query, (err, results) => {
        if (err) return res.status(500).json(err);

        res.json(results);
    });
};

// UPDATE
exports.updateCategory = (req, res) => {
    const { id } = req.params;
    const { name } = req.body;

    const query = `UPDATE categories SET name=? WHERE id=?`;

    db.query(query, [name, id], (err) => {
        if (err) return res.status(500).json(err);

        res.json({ message: "Catégorie modifiée" });
    });
};

// DELETE
exports.deleteCategory = (req, res) => {
    const { id } = req.params;

    const query = `DELETE FROM categories WHERE id=?`;

    db.query(query, [id], (err) => {
        if (err) return res.status(500).json(err);

        res.json({ message: "Catégorie supprimée" });
    });
};