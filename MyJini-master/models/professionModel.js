const mongoose = require('mongoose');

const professionSchema = mongoose.Schema({
    ProfessionName: {
        type: String,
        require: true
    }
});

module.exports = mongoose.model("profession",professionSchema);
