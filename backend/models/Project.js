const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
    name: { 
        type: String, 
        required: true,
        trim: true
    },
    status: { 
        type: String, 
        enum: ['Borrador', 'Terminado'], 
        default: 'Borrador' 
    },
    recycledFabricPercentage: { 
        type: Number, 
        default: 0 
    },
    createdAt: { 
        type: Date, 
        default: Date.now 
    }
});

module.exports = mongoose.model('Project', projectSchema);