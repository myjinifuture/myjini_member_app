const mongoose = require('mongoose');

const advertisePaymentSchema = mongoose.Schema({
    advertiseId: {
        type: mongoose.Types.ObjectId,
        ref: "advertisement"
    },
    vendorId: {
        type: mongoose.Types.ObjectId,
        ref: "vendor"
    },
    signature: {
        type: String,
        require: true
    },
    paymentId: {
        type: String,
        require: true
    },
    amount: {
        type: Number,
        require: 0
    },
    orderId: {
        type: String,
        require: true
    },
    invoiceNo: {
        type: String,
        require: true
    },
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("advertisePayment",advertisePaymentSchema);
