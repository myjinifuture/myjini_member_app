const mongoose = require('mongoose');

const wingSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    wingName: {
        type: String,
        require: true
    },
    totalFloor: {
        type: Number,
        default: 0
    },
    maxFlatPerFloor: {
        type: Number,
        default: 0
    }, 
    isSetUp: {
        type: Boolean,
        default: false
    }
});

module.exports = mongoose.model("wings",wingSchema);
