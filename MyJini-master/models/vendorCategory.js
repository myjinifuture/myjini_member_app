const mongoose = require('mongoose');

const vendorCategorySchema = mongoose.Schema({
    vendorCategoryName: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/vendorCategory/vendorCategory.png"
    } 
});

module.exports = mongoose.model("vendorCategory",vendorCategorySchema);