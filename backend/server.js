const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middlewares (Configuraciones base)
app.use(cors());
app.use(express.json());

// Conexión a MongoDB (Docker)
const uri = process.env.MONGO_URI;
mongoose.connect(uri)
  .then(() => console.log('¡Conectado exitosamente a MongoDB (Docker)!'))
  .catch(err => console.error('Error conectando a MongoDB:', err));

// Ruta de prueba inicial
app.get('/', (req, res) => {
  res.send('Servidor backend de HoloWear en línea');
});

// Importa y usa las rutas de proyectos
app.use('/api/projects', require('./routes/projectRoutes'));

// Iniciar el servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor de desarrollo corriendo en el puerto ${PORT}`);
});