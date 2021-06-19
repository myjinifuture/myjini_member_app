const mongoose = require('mongoose');

const vendorEntrySchema = mongoose.Schema({
    vendorId: {
        type: mongoose.Types.ObjectId,
        ref: "vendor"
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    purposeId: {
        type: mongoose.Types.ObjectId,
        ref: "purposeRecords"
    },
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "staffRecord",
        require: true
    },
    inDateTime: [{
        type: String,
        default: ""
    }],
    outDateTime: [{
        type: String,
        default: ""
    }],
    vehicleNo: {
        type: String,
        default: ""
    } 
});

module.exports = mongoose.model("vendorEntry",vendorEntrySchema);