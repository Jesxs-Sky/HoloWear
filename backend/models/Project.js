const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true, trim: true },
  status: {
    type: String,
    enum: ['draft', 'completed'],
    default: 'draft'
  },
  arScan: {
    garmentType: String,        // e.g., 'Jacket', 'Pants', 'Shirt'
    detectedMaterial: String,   // e.g., 'Denim', 'Cotton', 'Linen'
    wearPercentage: Number,     // 0 - 100
    measurements: {
      widthCm: Number,
      lengthCm: Number
    },
    originalPhotoUrl: String    // Cloud URL only
  },
  designs3D: [{
    title: String,
    threadColor: {
      type: String,
      enum: ['Indigo', 'Olive', 'Ochre', 'Red']
    },
    modelGlbUrl: String,        // Compressed .glb URL only
    cuttingCoordinates: Object,
    isSelected: { type: Boolean, default: false }
  }],
  zeroWasteScraps: [{
    areaCm2: Number,
    material: String,
    suggestedPattern: String,   // e.g., 'Patches', 'Pocket', 'Pouch'
    isUsed: { type: Boolean, default: false }
  }],
  quote: {
    hoursInvested: Number,
    hourlyRate: Number,
    extraSuppliesCost: Number,
    profitMarginPct: Number,
    suggestedPrice: Number
  },
  qrPassport: {
    qrHash: { type: String, unique: true, sparse: true },
    recycledFabricPercentage: { type: Number, default: 0 },
    waterSavedLiters: Number,
    co2AvoidedKg: Number,
    isPublished: { type: Boolean, default: false },
    issuedAt: Date
  },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Project', projectSchema);