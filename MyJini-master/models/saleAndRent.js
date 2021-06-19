const mongoose = require('mongoose');

const saleAndRentSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    }, 
    wingId: {
        type: mongoose.Types.ObjectId,
        ref: "wings"
    },
    flatId: {
        type: mongoose.Types.ObjectId,
        ref: "flats"
    },
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    isFor: {
        type: String,
        enum: {
            values: ['SALE', 'RENT'],
            message: 'THIS FIELD CONTAINS ONLY SALE OR RENT TEXT'
        },
        trim: true
    },
    status: {
        type: Number,
        default: 0
    },
    description: {
        type: String,
        default: ""
    },
    dateTime: [{
        type: String,
        default: ""
    }]
});

module.exports = mongoose.model("saleAndRent",saleAndRentSchema);