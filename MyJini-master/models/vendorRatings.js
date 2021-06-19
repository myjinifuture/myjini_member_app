const mongoose = require('mongoose');

const vendorRatingSchema = mongoose.Schema({
    vendorId: {
        type: mongoose.Types.ObjectId,
        ref: "vendor"
    },
    rating: {
        type: Number,
        default: 0 
    },
    review: {
        type: String,
        default: ""
    },
    ratingMemberId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    dateTime: [{
        type: String,
        default: ""
    }]
});

module.exports = mongoose.model("vendorRatings",vendorRatingSchema);