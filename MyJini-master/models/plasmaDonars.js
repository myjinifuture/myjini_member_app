const mongoose = require('mongoose');

const plasmaDonarsSchema = mongoose.Schema({
    DonarName: {
        type: String,
        require: true
    },
    MobileNo: {
        type: String,
        default: ""
    },
    City: {
        type: String,
        default: ""
    },
    State: {
        type: String,
        default: ""
    },
    Gender: {
        type: String,
        enum: {
            values: ['male','female','other'],
            message: 'Please Enter valid gender like male , female , other'
        },
        trim: true
    },
    DOB: {
        type: String,
        default: ""
    },
    CovidHistory: {
        type: Boolean,
        default: true
    },
    CovidPositiveDate: {
        type: String,
        default: ""
    },
    Weight: {
        type: Number,
        default: ""
    },
    BloodGroup: {
        type: String,
        default: ""
    },
    PlasmaDonationBefore: {
        type: Boolean,
        default: false
    },
    LastPlasmaDonationDate: {
        type: String,
        default: ""
    },
    IsVaccinated: {
        type: Boolean,
        default: false
    },
    DateOfVaccination: {
        type: String,
        default: ""
    },
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("plasmaDonars",plasmaDonarsSchema);