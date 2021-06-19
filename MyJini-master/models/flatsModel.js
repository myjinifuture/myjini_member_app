const mongoose = require('mongoose');

const flatSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    wingId: {
        type: mongoose.Types.ObjectId,
        ref: "wings"
    },
    flatNo: {
        type: String,
        require: true
    },
    floorNo: {
        type: String,
        require: true
    },
    residenceType: {
        type: Number,
        default: 0
    },
    memberIds: [{
        type: mongoose.Types.ObjectId,
        ref: "members"
    }],
    parentMember: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    parkingSlotNo: [{
        type: String,
        default: ""
    }] 
});

module.exports = mongoose.model("flats",flatSchema);
