const mongoose = require('mongoose');

const complainSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "member",
    },
    attachment: {
        type: String,
        default: ""
    },
    complainCategory: {
        type: mongoose.Types.ObjectId,
        ref: "complainCategory",
        require: true,
    },
    complainCategoryName: {
        type: String,
        require: true
    },
    complainNo: {
        type: String,
        require: true
    },
    complainStatus: {
        type: Number,
        default: "",
    },
    title: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("ComplainRecords",complainSchema)