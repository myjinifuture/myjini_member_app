const mongoose = require('mongoose');

const eventRegistrationSchema = mongoose.Schema({
    eventId: {
        type: mongoose.Types.ObjectId,
        ref: "events"
    },
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    response: {
        type: Boolean
    },
    noOfPerson: {
        type: Number,
        default: 0
    },
    dateTime: [{
        type: String,
        default: ""
    }]
})

module.exports = mongoose.model("eventRegistration",eventRegistrationSchema);