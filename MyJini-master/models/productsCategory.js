const mongoose = require('mongoose');

const productsCategorySchema = mongoose.Schema({
    productsCategoryName: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/productCategory/productDefault.png"
    } 
});

module.exports = mongoose.model("productCategory",productsCategorySchema);