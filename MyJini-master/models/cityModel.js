const mongoose = require('mongoose');

const citySchema = mongoose.Schema({
    name: {
        type: String,
        require: true
    },
    stateCode: {
        type: String,
        require: true
    },
    countryCode: {
        type: String,
        require: true
    },
    latitude: {
        type: String,
        default: ""
    },
    longitude: {
        type: String,
        default: ""
    }, 
});

module.exports = mongoose.model("city",citySchema);
