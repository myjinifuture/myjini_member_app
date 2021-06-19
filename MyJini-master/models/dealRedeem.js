const mongoose = require('mongoose');

const dealsRedeemSchema = mongoose.Schema({
    dealId: {
        type: mongoose.Types.ObjectId,
        ref: "vendorDeals",
        require: true
    },
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "members",
        require: true
    },
    OfferType: {
        type: Boolean,
        require: true
    },
    OfferPrice: {
        type: Number,
        require: true
    },
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("dealsRedeem",dealsRedeemSchema);
