const mongoose = require('mongoose');

const noticeBoardSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    noticeFor: {
        isForWholeSociety: {
            type: Boolean,
            default: true
        },
        wingId: [{
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        }],
    },
    Title: {
        type: String,
        default: ""
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

module.exports = mongoose.model("noticeBoard",noticeBoardSchema);