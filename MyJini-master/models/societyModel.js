const mongoose = require('mongoose');

const societySchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    },
    societyImage: [{
        type: String,
        default: ""
    }],
    IsActive: {
        type: Boolean,
        default: false
    },
    IsVerify: {
        type: Boolean,
        default: false
    },
    Location: {
        lat: {
            type: Number,
            default: ""
        },
        long: {
            type: Number,
            default: ""
        },
        mapLink: {
            type: String,
            require: true
        },
    },
    Address: {
        type: String,
        default: ""
    },
    JoinDate: [{
        type: String,
        default: ""
    }],
    societyCode: {
        type: String,
        require: true
    },
    UPIID: {
        type: String,
        default: ""
    },
    InstaMojoKey: {
        type: String,
        default: ""
    },
    AccountHolderName: {
        type: String,
        default: ""
    },
    IFSCCode: {
        type: String,
        default: ""
    },
    AccountNo: {
        type: String,
        default: ""
    },
    IsWing: {
        type: Boolean,
        default: true
    },
    openingBalance: {
        type: Number,
        default: 0
    },
    currentBalance: {
        type: Number,
        default: 0
    },
    InstaMojoToken: {
        type: String,
        default: ""
    },
    BankName: {
        type: String,
        default: ""
    },
    BankAddress: {
        type: String,
        default: ""
    },
    ContactPerson: {
        type: String,
        default: ""
    },
    ContactMobile: {
        type: String,
        default: ""
    },
    Email: {
        type: String,
        default: ""
    },
    SocietyType: {
        type: mongoose.Types.ObjectId,
        ref: "societyCategory"
    },
    SocietyTypeIs: {
        type: String,
        default: ""
    },
    NoOfWing: {
        type: Number,
        default: 0
    },
    countryCode: {
        type: String,
        default: "IN"
    },
    stateCode: {
        type: String,
        require: true
    },
    city: {
        type: String,
        require: true
    },
    areaId: {
        type: mongoose.Types.ObjectId,
        ref: "area"
    },
});

module.exports = mongoose.model("society",societySchema);