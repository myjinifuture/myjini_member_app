const mongoose = require('mongoose');

const purposeCategorySchema = mongoose.Schema({
    purposeName: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("purposeRecords",purposeCategorySchema);