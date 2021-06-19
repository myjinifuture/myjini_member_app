const mongoose = require('mongoose');

const dealsKeywordSchema = mongoose.Schema({
    DealKeywordName: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("dealsKeywords",dealsKeywordSchema);
