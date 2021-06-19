const mongoose = require('mongoose');

const dealsCategorySchema = mongoose.Schema({
    DealCategoryName: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/dealCategory/dealDefault.png"
    },
});

module.exports = mongoose.model("dealsCategory",dealsCategorySchema);
