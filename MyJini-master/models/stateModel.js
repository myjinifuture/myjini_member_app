const mongoose = require('mongoose');

const stateSchema = mongoose.Schema({
    name: {
        type: String,
        require: true
    },
    isoCode: {
        type: String,
        default: ""
    },
    countryCode: {
        type: String,
        default: ""
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

module.exports = mongoose.model("state",stateSchema);
