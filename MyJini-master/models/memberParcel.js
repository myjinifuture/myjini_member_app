const mongoose = require('mongoose');

const memberParcelSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "member",
    },
    parcelFrom: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
    date: {
        type: String,
        default: ""
    },
    dateTime: [{
        type: String,
        default: ""
    }]
});

module.exports = mongoose.model("memberParcel",memberParcelSchema);