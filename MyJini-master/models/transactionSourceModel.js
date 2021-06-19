const mongoose = require('mongoose');

const transactionSchema = mongoose.Schema({
    sourceName: {
        type: String,
        require: true
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
});

module.exports = mongoose.model("transactionSource",transactionSchema);
