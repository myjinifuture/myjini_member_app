const mongoose = require('mongoose');

const watchmanTokenSchema = mongoose.Schema({
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman"
    },
    mobileNo: {
        type: String,
        require: true
    },
    fcmToken: {
        type: String,
        require: true
    },
    playerId: {
        type: String,
        require: true
    },
    IMEI: {
        type: String,
        default: ""
    },
    DeviceType: {
        type: String,
        enum: ["Android", "IOS"],
        default: "Android"
    }
});

module.exports = mongoose.model("watchmanToken",watchmanTokenSchema);
