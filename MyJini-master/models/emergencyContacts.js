const mongoose = require('mongoose');

const emergencyContactsSchema = mongoose.Schema({
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    contactName: {
        type: String,
        default: ""
    },
    contactNo: {
        type: String,
        default: ""
    },
    image: {
        type: String,
        default: "uploads/emergencyContactImg/emergencyDefault.png"
    },
});

module.exports = mongoose.model("EmergencyContacts",emergencyContactsSchema)