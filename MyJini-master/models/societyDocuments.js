const mongoose = require('mongoose');

const societyDocsSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    Title: {
        type: String,
        default: ""
    },
    docFor: {
        isForWholeSociety: {
            type: Boolean,
            default: true
        },
        wingId: [{
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        }],
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

module.exports = mongoose.model("societyDocs",societyDocsSchema);