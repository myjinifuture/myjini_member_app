const mongoose = require('mongoose');

const memberSOSContactSchema = mongoose.Schema({
    memberId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    contactNo: {
        type: String,
        default: ""
    },
    contactPerson: {
        type: String,
        default: ""
    },
});

module.exports = mongoose.model("memberSOSContacts",memberSOSContactSchema);
