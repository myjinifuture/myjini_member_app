const mongoose = require('mongoose');

const reminderCategorySchema = mongoose.Schema({
    ReminderName: {
        type: String,
        require: true
    },
    image: {
        type: String,
        default: "uploads/reminderCategory/defaultReminderCategory.png"
    }
});

module.exports = mongoose.model("reminderCategory",reminderCategorySchema);
