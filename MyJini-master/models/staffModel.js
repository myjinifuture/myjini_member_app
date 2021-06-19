const mongoose = require('mongoose');

const staffSchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    },
    ContactNo1: {
        type: String,
        require: true,
    },
    ContactNo2: {
        type: String,
        default: "",
    },
    emailId: {
        type: String,
        default: "",
    },
    Gender: {
        type: String,
        enum: ["male", "female","other"]
    },
    staffCategory: {
        type: String,
        default: "",
    },
    Address: {
        type: String,
        default: ""
    },
    entryNo: {
        type: String,
        require: true
    },
    isMapped: {
        type: Boolean,
        default: false
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society",
        require: true
    },
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman",
        require: true
    },
    workingLocation: [
        {
            wingId: {
                type: mongoose.Types.ObjectId,
                ref: "wings"
            },
            flatId: {
                type: mongoose.Types.ObjectId,
                ref: "flats"
            },
        }
    ],
    isForSociety: {
        type: Boolean,
        default: false
    },
    staffImage: {
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
    // identityProof: {
    //     type: mongoose.Types.ObjectId,
    //     ref: "identityProof"
    // },
    // identityImage: {
    //     type: String,
    //     default: ""
    // }
});

module.exports = mongoose.model("staffRecord",staffSchema);