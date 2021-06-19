const mongoose = require('mongoose');

const societyEmergencyContactsSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    Name: {
        type: String,
        require: true
    },
    ContactPerson: {
        type: String,
        default: ""
    },
    ContactNo: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/socEmergencyContact/soc-emergency-default.jpg"
    },
    alternateContactNo: {
        type: String,
        default: ""
    }
});

module.exports = mongoose.model("societyEmergencyContacts",societyEmergencyContactsSchema);