const mongoose = require('mongoose');

const pollingOptionsSchema = mongoose.Schema({
    pollQuestionId: {
        type: mongoose.Types.ObjectId,
        ref: "pollQuestion",
        require: true
    },
    pollOption: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("pollingOptions",pollingOptionsSchema);