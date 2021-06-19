const mongoose = require('mongoose');

const staffEntrySchema = mongoose.Schema({
    staffId: {
        type: mongoose.Types.ObjectId,
        ref: "staffRecord",
        require: true
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
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

module.exports = mongoose.model("staffEntry",staffEntrySchema);