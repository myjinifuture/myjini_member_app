const mongoose = require('mongoose');

const advertisePriceSchema = mongoose.Schema({
    Price: {
        type: Number,
        require: true
    }
});

module.exports = mongoose.model("advertisePrice",advertisePriceSchema);