const Project = require('../models/Project');

// Función para crear un nuevo proyecto textil
exports.createProject = async (req, res) => {
    try {
        const newProject = new Project(req.body);
        await newProject.save();
        res.status(201).json({ success: true, data: newProject, message: '¡Proyecto creado con éxito!' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};