const mongoose = require("mongoose");

const bannerSchema = mongoose.Schema({
    title: {
        type: String,
    },
    image: {
        type: String,
        require: true
    },
    dateTime: [{
        type: String,
        default: "",
    }],
    type:{
        type: String,
        enum: ["top", "bottom"]
    },
    isActive: {
        type: Boolean,
        default: true,
    },
});

module.exports = mongoose.model("banners", bannerSchema);