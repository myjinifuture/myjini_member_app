const mongoose = require('mongoose');

const watchmanSchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    },
    ContactNo1: {
        type: String,
        require: true
    },
    Gender: {
        type: String,
        enum: ["male", "female","other"]
    },
    emailId: {
        type: String,
        default: ""
    },
    Address: {
        type: String,
        require: true
    },
    watchmanNo: {
        type: String,
        require: true
    },
    wingId: {
        type: mongoose.Types.ObjectId,
        ref: "wings"
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    watchmanImage: {
        type: String,
        default: ""
    },
    AadharcardNo: {
        type: String,
        default: ""
    },
    VoterId: {
        type: String,
        default: ""
    },
    DateOfBirth: {
        type: String,
        default: ""
    },
    DateOfJoin: {
        type: String,
        default: ""
    },
    RecruitType: {
        type: String,
        default: ""
    },
    AgencyName: {
        type: String,
        default: ""
    },
    EmergencyContactNo: {
        type: String,
        default: ""
    },
    VehicleNo: {
        type: String,
        default: ""
    },
    Work: {
        type: String,
        default: ""
    },
    isMapped: {
        type: Boolean,
        default: false
    },
    isOnCall: {
        type: Boolean,
        default: false
    }, 
    // identityProof: {
    //     type: mongoose.Types.ObjectId,
    //     ref: "identityProof"
    // },
    // identityImage: {
    //     type: String,
    //     default: ""
    // }
});

module.exports = mongoose.model("watchman",watchmanSchema);
