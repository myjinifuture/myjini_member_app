const mongoose = require('mongoose');

const vendorSchema = mongoose.Schema({
    vendorCategoryId: {
        type: mongoose.Types.ObjectId,
        ref: "vendorCategory"
    },
    ServiceName: {
        type: String,
        require: true
    },
    Name: {
        type: String,
        require: true
    },
    Address: {
        type: String,
        default: ""
    },
    Pincode: {
        type: String,
        default: ""
    },
    GoogleMap: {
        lat: {
            type: Number
        },
        long: {
            type: Number
        },
        mapLink: {
            type: String
        }, 
    },
    ContactNo: {
        type: String,
        require: true
    },
    CompanyName: {
        type: String,
        default: ""
    },
    CompanyLogo: {
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
    EmergencyContactNo: {
        type: String,
        default: ""
    },
    ContactPerson: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    About: {
        type: String,
        default: ""
    },
    GSTNo: {
        type: String,
        default: ""
    },
    PAN: {
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
    emailId: {
        type: String,
        default: ""
    },
    entryNo: {
        type: String
    },
    vendorImage: {
        type: String,
        default: ""
    },
    vendorBelongsTo: {
        type: String,
        enum: {
            values: ['society', 'other','deals'],
            message: 'vendor Belongs To either society Or other'
        },
        trim: true
    },
    BusinessName: {
        type: String
    },
    BusinessCategory: {
        type: String
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    ReferalCode: {
        type: String,
        default: ""
    },
});

module.exports = mongoose.model("vendor",vendorSchema);