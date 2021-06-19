const mongoose = require('mongoose');

const advertisementSchema = mongoose.Schema({
    Title: {
        type: String,
        default: ""
    },
    Description: {
        type: String,
        default: ""
    },
    Image: [{
        type: String,
        default: ""
    }],
    vendorId: {
        type: mongoose.Types.ObjectId,
        ref: "vendor"
    },
    // PackageId: {
    //     type: mongoose.Types.ObjectId,
    //     ref: "adspackage"
    // },
    ExpiryDate: [{
        type: String,
        default: ""
    }],
    // advertiseFor: {
    //     type: String,
    //     enum: {
    //         values: ['society', 'area', 'city'],
    //         message: 'Advertise For is either society , area , city'
    //     },
    //     trim: true
    // },
    // societyIdList: [{
    //     type: mongoose.Types.ObjectId,
    //     ref: "society"
    // }],
    // areaIdList: [{
    //     type: mongoose.Types.ObjectId,
    //     ref: "area"
    // }],
    // cityList: [{
    //     type: String,
    // }],
    ContactNo: {
        type: String,
        default: ""
    },
    GoogleMap: {
        lat: {
            type: Number,
            default: 0
        },
        long: {
            type: Number,
            default: 0
        },
        mapLink: {
            type: String,
            default: ""
        }
    },
    PaymentMode: {
        type: String,
        default: ""
    },
    isPaid: {
        type: Boolean,
        default: false
    },
    // ReferenceNo: {
    //     type: String,
    //     default: ""
    // },
    dateTime: [{
        type: String,
        default: ""
    }],
    WebsiteURL: {
        type: String,
        default: ""
    },
    EmailId: {
        type: String,
        default: ""
    },
    VideoLink: {
        type: String,
        default: ""
    },
    AdPosition: {
        type: String,
        enum: {
            values: ['TOP', 'BOTTOM', 'BOTH'],
            message: 'Advertise Position is either TOP , BOTTOM , BOTH'
        },
        trim: true
    },
    Price: {
        type: String,
        default: ""
    },
    advertiseNo: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("advertisement",advertisementSchema);
