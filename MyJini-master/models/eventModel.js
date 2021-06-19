const mongoose = require('mongoose');

const eventsSchema = mongoose.Schema({
    Title: {
        type: String,
        require: true
    },
    Description: {
        type: String,
        default: ""
    },
    images: [{
        type: String,
        default: ""
    }],
    EventType: {
        type: String,
        default: ""
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    wingIdList: [{
        type: mongoose.Types.ObjectId,
        ref: "wings"
    }],
    organisedBy: {
        type: String,
        default: ""
    },
    venue: {
        type: String,
        default: ""
    },
    date: {
        type: String,
        default: ""
    },
    addTimeStamp: [{
        type: String,
        default: ""
    }]
});

module.exports = mongoose.model("events",eventsSchema);