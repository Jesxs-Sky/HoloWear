const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  fullName: { type: String, required: true, trim: true },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  passwordHash: { type: String, required: true },
  role: {
    type: String,
    enum: ['creator', 'workshop', 'client', 'admin'],
    default: 'creator'
  },
  phone: { type: String, trim: true },
  city: { type: String, required: true, trim: true },
  workshopProfile: {
    workshopName: String,
    description: String,
    address: String,
    coordinates: {
      lat: Number,
      lng: Number
    },
    specialties: [String], // e.g., ['Denim', 'Patchwork', 'Embroidery']
    isAvailable: { type: Boolean, default: true },
    rating: { type: Number, default: 5.0 }
  },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', userSchema);