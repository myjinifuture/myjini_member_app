const mongoose = require('mongoose');

const parkingSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    wingId: {
        type: mongoose.Types.ObjectId,
        ref: "wings"
    },
    parkingSlotNo: {
        type: String,
        require: true
    },
    vehicles: [{
        type: String,
    }],
    flatId: [{
        type: mongoose.Types.ObjectId,
        ref: "flats"
    }], 
});

module.exports = mongoose.model("parkingRecords",parkingSchema);
