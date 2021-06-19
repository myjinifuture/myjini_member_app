const mongoose = require("mongoose");

const gallerySchema = mongoose.Schema({
    title: {
        type: String,
        require: true
    },
    image: [{
        type: String,
        require: true
    }],
    galleryFor: {
        isForWholeSociety: {
            type: Boolean,
            default: true
        },
        wingId: [{
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        }],
    },
    dateTime: [{
        type: String,
        default: "",
    }],
    description:{
        type: String,
        default: ""
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    adminId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
});

module.exports = mongoose.model("gallery", gallerySchema);