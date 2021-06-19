const mongoose = require('mongoose');

const complainCategorySchema = mongoose.Schema({
    complainName: {
        type: String,
        require: true,
    }
});

module.exports = mongoose.model("complainCategory",complainCategorySchema)