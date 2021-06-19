const mongoose = require('mongoose');

const staffCategorySchema = mongoose.Schema({
    staffCategoryName: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("staffCategory",staffCategorySchema);