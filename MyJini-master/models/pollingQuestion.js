const mongoose = require('mongoose');

const pollQuestionSchema = mongoose.Schema({
    pollQuestion: {
        type: String,
        require: true
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    pollFor: {
        isForWholeSociety: {
            type: Boolean,
            default: true
        },
        wingId: [{
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        }],
    },
    pollNo: {
        type: String,
        require: true
    },
    isActive: {
        type: Boolean,
        default: true
    },
    dateTime: [{
        type: String,
        require: true
    }]
});

module.exports = mongoose.model("pollQuestion",pollQuestionSchema);