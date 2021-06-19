const mongoose = require('mongoose');

const callingSchema = mongoose.Schema({
    Caller: {
        callerMemberId: {
            type: mongoose.Types.ObjectId,
            ref: "members"
        },
        watchmanId: {
            type: mongoose.Types.ObjectId,
            ref: "watchman"
        },
        wingId: {
            type: mongoose.Types.ObjectId,
            ref: "wings"
        },
        flatId: {
            type: mongoose.Types.ObjectId,
            ref: "flats"
        },
    },
    Receiver: {
        receiverMemberId: {
            type: mongoose.Types.ObjectId,
            ref: "members"
        },
        watchmanId: {
            type: mongoose.Types.ObjectId,
            ref: "watchman"
        },
        wingId: {
            type: mongoose.Types.ObjectId,
            ref: "wings"
        },
        flatId: {
            type: mongoose.Types.ObjectId,
            ref: "flats"
        },
    },
    contactNo: {
        type: String,
        require: true
    },
    AddedBy: {
        type: String,
        default: "Member"
    },
    callStatus: {
        type: Number,
        default: 0
    }, 
    callFor: {
        type: Number,
        default: 0
    },
    isVideoCall: {
        type: Boolean,
        default: true
    }
});

module.exports = mongoose.model("calling",callingSchema)