const mongoose = require('mongoose');

const lookbookSchema = new mongoose.Schema({
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  workshopId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  title: { type: String, required: true, trim: true },
  beforeImageUrl: { type: String, required: true },
  afterImageUrl: { type: String, required: true },
  impactMetrics: {
    waterSavedLiters: Number,
    recycledFabricPercentage: Number
  },
  isFeatured: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Lookbook', lookbookSchema);