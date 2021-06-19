const mongoose = require('mongoose');

const adsPackageSchema = mongoose.Schema({
    packageName: {
        type: String,
        require: true
    },
    price: {
        type: Number,
        require: true
    },
    duration: {
        type: Number,
        default: 1
    }
});

module.exports = mongoose.model("adspackage",adsPackageSchema);
