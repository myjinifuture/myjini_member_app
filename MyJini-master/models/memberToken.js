const mongoose = require('mongoose');

const memberTokenSchema = mongoose.Schema({
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    mobileNo: {
        type: String,
        require: true
    },
    // fcmToken: {
    //     type: String,
    //     require: true
    // },
    playerId: {
        type: String,
        require: true
    },
    DeviceType: {
        type: String,
        enum: ["Android", "IOS"],
        default: "Android"
    },
    DeviceName: {
        type: String,
        default: ""
    },
    muteNotificationAudio: {
        type: Boolean,
        default: false
    },
    IMEI: {
        type: String,
        default: ""
    },
    isAdmin: {
        type: Number,
        default: 0
    },
    isActive: {
        type: Boolean,
        default: true
    }
});

module.exports = mongoose.model("memberToken",memberTokenSchema);
