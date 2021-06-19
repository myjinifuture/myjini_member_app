const mongoose = require('mongoose');

const societyCategorySchema = mongoose.Schema({
    categoryName: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("societyCategory",societyCategorySchema);