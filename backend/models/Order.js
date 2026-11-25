const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  workshopId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  projectId: { type: mongoose.Schema.Types.ObjectId, ref: 'Project', required: true },
  agreedPrice: { type: Number, required: true },
  orderStatus: {
    type: String,
    enum: ['quoting', 'accepted', 'cutting', 'sewing', 'ready', 'delivered'],
    default: 'quoting'
  },
  finalEvidence: {
    afterPhotoUrl: String,
    deliveryNotes: String,
    deliveredAt: Date
  },
  showInLookbook: { type: Boolean, default: false },
  estimatedDeliveryDate: Date,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Order', orderSchema);