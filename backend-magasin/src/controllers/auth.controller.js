const db = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const SECRET = "secretkey"; // plus tard .env

exports.login = (req, res) => {
    const { email, password } = req.body;

    const query = `SELECT * FROM users WHERE email=?`;

    db.query(query, [email], async(err, results) => {
        if (err) return res.status(500).json(err);

        if (results.length === 0) {
            return res.status(401).json({ message: 'User not found' });
        }

        const user = results[0];

        // ⚠️ pour test (password non hashé)
        if (password !== user.password) {
            return res.status(401).json({ message: 'Invalid password' });
        }

        // JWT
        const token = jwt.sign({ id: user.id, email: user.email },
            SECRET, { expiresIn: '1d' }
        );

        res.json({
            message: 'Login success',
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
            },
        });
    });
};