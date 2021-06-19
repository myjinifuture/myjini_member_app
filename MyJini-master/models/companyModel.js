const mongoose = require('mongoose');

const companyCategorySchema = mongoose.Schema({
    companyType: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/company/companyDefault.jpg"
    },
});

module.exports = mongoose.model("companyCategory",companyCategorySchema);