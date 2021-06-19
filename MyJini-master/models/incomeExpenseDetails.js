const mongoose = require('mongoose');

const incomeExpenseDetailsSchema = mongoose.Schema({
    sourceId: {
        type: mongoose.Types.ObjectId,
        ref: "incomeSource"
    },
    societyId: {
        type: mongoose.Types.ObjectId,
        ref: "society"
    },
    paymentType: {
        type: String,
        require: true
    },
    type: {
        type: String,
        enum: ["Income","Expense"]
    },
    refNo: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
    credit: {
        type: Number,
        default: 0
    },
    debit: {
        type: Number,
        default: 0
    }, 
    previousBalance: {
        type: Number,
        default: 0
    },
    currentBalance: {
        type: Number,
        default: 0
    },
    dateTime: [{
        type: String,
        default: ""
    }],
});

module.exports = mongoose.model("transactionRecords",incomeExpenseDetailsSchema);
