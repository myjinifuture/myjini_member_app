const mongoose = require('mongoose');
const mongoosePaginate  = require('mongoose-paginate-v2')

const shareTemplatSchema = mongoose.Schema({
    title: String
});

module.exports = mongoose.model("shareTemplats",shareTemplatSchema);