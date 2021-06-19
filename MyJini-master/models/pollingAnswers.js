const mongoose = require('mongoose');

const pollAnswerSchema = mongoose.Schema({
    pollQuestionId: {
        type: mongoose.Types.ObjectId,
        ref: "pollQuestion"
    },
    pollOptionId: {
        type: mongoose.Types.ObjectId,
        ref: "pollingOptions"
    },
    responseByMembers: {
        type: mongoose.Types.ObjectId,
        ref: "member"
    },
    dateTime: [{
        type: String,
        require: true
    }]
});

module.exports = mongoose.model("pollAnswer",pollAnswerSchema);