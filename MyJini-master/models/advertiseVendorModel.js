const mongoose = require('mongoose');

const advertiseVendorSchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    },
    Mobile: {
        type: String,
        require: true
    },
    Email: {
        type: String,
        default: ""
    },
    Address: {
        type: String,
        default: ""
    },
    Pincode: {
        type: String,
        default: ""
    },
    Area: {
        type: String,
        default: ""
    },
    CompanyName: {
        type: String,
        default: ""
    },
    WebsiteURL: {
        type: String,
        default: ""
    },
    YoutubeURL: {
        type: String,
        default: ""
    },
    GSTNo: {
        type: String,
        default: ""
    },
    State: {
        type: String,
        default: ""
    },
    City: {
        type: String,
        default: ""
    },
    ReferalCode: {
        type: String,
        default: ""
    },
    Location: {
        lat: {
            type: Number,
            default: 0
        },
        long: {
            type: Number,
            default: 0
        },
        completeAddress: {
            type: String,
            default: ""
        }
    },
});

module.exports = mongoose.model("advertiseVendor",advertiseVendorSchema);