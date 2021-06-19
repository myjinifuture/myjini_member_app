const mongoose = require('mongoose');

const unknownVisitorSchema = mongoose.Schema({
    // unknownVisitorName: {
    //     type: String,
    //     default: ""
    // },
    // visitorContact: {
    //     type: String,
    //     default: ""
    // },
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
    responseMemberId: {
        type: mongoose.Types.ObjectId,
        ref: "member"
    },
    watchmanId: {
        type: mongoose.Types.ObjectId,
        ref: "watchman"
    },
    entryNo: {
        type: String,
        require: true
    },
    // image: {
    //     type: String,
    //     default: ""
    // } 
});

module.exports = mongoose.model("unknownVisitor",unknownVisitorSchema);