const mongoose = require('mongoose');

const staffRatingSchema = mongoose.Schema({
    staffId: {
        type: mongoose.Types.ObjectId,
        ref: "staffRecord"
    },
    rating: {
        type: Number,
        min: 0, 
        max: 5,
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

module.exports = mongoose.model("staffRatings",staffRatingSchema);