const mongoose = require('mongoose');

const societyRulesSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    Title: {
        type: String,
        default: ""
    },
    ruleFor: {
        isForWholeSociety: {
            type: Boolean,
            default: true
        },
        wingId: [{
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        }],
    },
    Description: {
        type: String,
        default: ""
    },
    FileAttachment: {
        type: String,
        default: ""
    },
    dateTime: [
        {
            type: String,
            default: ""
        },
    ]
});

module.exports = mongoose.model("societyRules",societyRulesSchema);