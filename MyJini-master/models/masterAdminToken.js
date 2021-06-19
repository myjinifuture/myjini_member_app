const mongoose = require('mongoose');

const adminTokenSchema = mongoose.Schema({
    adminId: {
        type: mongoose.Types.ObjectId,
        ref: "admin"
    },
    ContactNo: {
        type: String,
        require: true
    },
    fcmToken: {
        type: String,
        require: true
    },
    DeviceType: {
        type: String,
        enum: ["Android", "IOS"]
    }
});

module.exports = mongoose.model("adminToken",adminTokenSchema);
