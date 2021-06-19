const mongoose = require('mongoose');

const adminSchema = mongoose.Schema({
    Name: {
        type: String,
        require: true
    },
    ContactNo: {
        type: String,
        require: true
    },
    emailId: {
        type: String,
        default: ""
    },
    alternateContactNo: {
        type: String,
        default: ""
    }
});

module.exports = mongoose.model("admin",adminSchema);