const mongoose = require('mongoose');

const identityProofSchema = mongoose.Schema({
    identityProofName: {
        type: String,
        require: true,
    }
});

module.exports = mongoose.model("identityProof",identityProofSchema);