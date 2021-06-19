const mongoose = require("mongoose");

const inviteGuestSchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    }, 
    ContactNo: {
        type: String,
        require: true
    }, 
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    }, 
    wingId: {
        type: mongoose.Types.ObjectId,
        ref: "wings"
    }, 
    flatId: {
        type: mongoose.Types.ObjectId,
        ref: "flats"
    }, 
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "member"
    },
    guestType: {
        type: mongoose.Types.ObjectId,
        ref: "GuestCategory"
    },
    purpose: {
        type: mongoose.Types.ObjectId,
        ref: "purposeRecords"
    },
    guestImage: {
        type: String,
        default: ""
    },
    entryNo: {
        type: String,
        require: true
    },
    isVisited: {
        type: Boolean,
        default: false
    },
    inDateTime: [{
        type: String,
        default: ""
    }],
    outDateTime: [{
        type: String,
        default: ""
    }],
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("inviteGuest", inviteGuestSchema);
