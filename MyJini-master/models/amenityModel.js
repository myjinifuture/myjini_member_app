const mongoose = require('mongoose');

const amenitySchema = mongoose.Schema({
    amenityName: {
        type: String,
        require: true
    },
    images: [{
        type: String,
        require: true
    }],
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    location: {
        wingId: {
            type: mongoose.Types.ObjectId,
            ref: "societyWing"
        },
        flatId: {
            type: mongoose.Types.ObjectId,
            ref: "FlatDetails"
        },
        lat: {
            type: Number,
            default: 0
        },
        long: {
            type: Number,
            default: 0
        },
        completeAddress:{
            type: String,
            default: ""
        },
    },
    isPaid: {
        type: Boolean,
        default: false
    },
    Amount: {
        type: Number,
        default: 0
    },
    fromTime: {
        type: String,
        default: ""
    },
    toTime: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
});

module.exports = mongoose.model("amenity",amenitySchema);