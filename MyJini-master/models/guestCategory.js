const mongoose = require('mongoose');

const guestCategorySchema = mongoose.Schema({
    guestType: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/guestCategories/guestDefault.jpg"
    },
});

module.exports = mongoose.model("GuestCategory",guestCategorySchema);