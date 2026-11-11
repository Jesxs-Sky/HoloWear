const express = require('express');
const router = express.Router();
const { createProject } = require('../controllers/projectController');

// Cuando la app envíe un POST a esta ruta, se ejecutará el controlador
router.post('/create', createProject);

module.exports = router;