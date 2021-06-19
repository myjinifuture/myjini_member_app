const mongoose = require('mongoose');

const areaSchema = mongoose.Schema({
    Title: {
        type: String,
        require: true
    },
    stateCode: {
        type: String,
        require: true
    },
    city: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("area",areaSchema);
