const mongoose = require('mongoose');

const reminderSchema = mongoose.Schema({
    ReminderCategoryId: {
        type: mongoose.Types.ObjectId,
        ref: "reminderCategory"
    },
    ReminderName: {
        type: String,
        require: true
    },
    Title: {
        type: String,
        default: ""
    },
    Note: {
        type: String,
        default: ""
    },
    ScheduleType: {
        type: Number,
        default: 0
    },
    Hourly: {
        ScheduleDate: {
            type: String,
        },
        every_hours: {
            type: String,
        },
    },
    Today: {
        ScheduleDate: {
            type: String,
        },
        ScheduledTime: {
            type: String,
        },
    },
    Tomorrow: {
        ScheduleDate: {
            type: String,
        },
        ScheduledTime: {
            type: String,
        },
    },
    SpecificDate: {
        ScheduleDate: {
            type: String,
        },
        ScheduledTime: {
            type: String,
        },
    },
    Daily: {
        ScheduledTime: {
            type: String,
        },
    }, 
    Weekly: {
        ScheduledTime: {
            type: String,
        },
    },
    Monthly: {
        ScheduledTime: {
            type: String,
        },
    },
    dateTime: [{
        type: String,
        default: ""
    }]
});

module.exports = mongoose.model("reminders",reminderSchema);
