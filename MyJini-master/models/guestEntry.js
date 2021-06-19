const mongoose = require('mongoose');

const guestEntrySchema = mongoose.Schema({
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
        ref: "members"
    }, 
    addedBy: {
        type: String,
        default: "Member"
    },
    entryNo: {
        type: String,
        require: true
    },
    validFrom: {
        type: String,
        default: ""
    },
    validTo: {
        type: String,
        default: ""
    },
    purposeId: {
        type: mongoose.Types.ObjectId,
        ref: "purposeRecords"
    },
    guestType: {
        type: mongoose.Types.ObjectId,
        ref: "GuestCategory"
    },
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman"
    },
    guestImage: {
        type: String,
        default: ""
    },
    companyImage: {
        type: String,
        default: ""
    },
    isMask: {
        type: Boolean,
        default: false
    },
    isSanitize: {
        type: Boolean,
        default: false
    },
    Temperature: {
        type: String,
        default: ""
    },
    numberOfGuest: {
        type: String,
        default: ""
    },
    emailId: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
    status: {
        type: String,
        default: "0"
    },
    inDateTime: [{
        type: String,
        default: ""
    }],
    outDateTime: [{
        type: String,
        default: ""
    }],
    vehicleNo: {
        type: String,
        default: ""
    },
    CompanyName: {
        type: String,
        default: ""
    }
});

module.exports = mongoose.model("GuestEntry",guestEntrySchema);