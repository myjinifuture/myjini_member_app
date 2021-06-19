const mongoose = require('mongoose');

const watchmanEntrySchema = mongoose.Schema({
    enterWatchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman",
        require: true
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman",
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

module.exports = mongoose.model("watchmanEntry",watchmanEntrySchema);