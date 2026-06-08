// Import JWT
const jwt = require('jsonwebtoken');

// Clé secrète (plus tard → .env)
const SECRET = "secretkey";

// Middleware pour protéger les routes
exports.verifyToken = (req, res, next) => {

    // Récupérer le token depuis le header
    const authHeader = req.headers['authorization'];

    // Vérifier si le token existe
    if (!authHeader) {
        return res.status(403).json({ message: "Token requis" });
    }

    // Format: Bearer TOKEN
    const token = authHeader.split(' ')[1];

    // Vérifier validité du token
    jwt.verify(token, SECRET, (err, user) => {

        if (err) {
            return res.status(401).json({ message: "Token invalide" });
        }

        // Ajouter user dans req (utile plus tard)
        req.user = user;

        // Continuer vers la route
        next();
    });
};