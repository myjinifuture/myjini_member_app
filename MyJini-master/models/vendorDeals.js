const mongoose = require('mongoose');

const vendorDealsSchema = mongoose.Schema({
    vendorId: {
        type: mongoose.Types.ObjectId,
        ref: "vendor"
    },
    DealCategoryId: {
        type: mongoose.Types.ObjectId,
        ref: "dealsCategory"
    },
    DealName: {
        type: String,
        default: ""
    },
    Description: {
        type: String,
        default: ""
    },
    DealNo: {
        type: String,
        default: ""
    },
    DealLink: {
        type: String,
        default: ""
    },
    OfferType: {
        type: Boolean,
        default: false
    },
    OfferPrice: {
        type: Number,
        default: 0
    },
    ActualPrice: {
        type: Number,
        default: 0
    },
    Image: [{
        type: String,
        default: ""
    }],
    TermsAndCondition: {
        type: String,
        default: ""
    },
    isActive: {
        type: Boolean,
        default: false
    },
    isPaid: {
        type: Boolean,
        default: false
    },
    // status: {
    //     type: String,
    //     enum: {
    //         values: ['Pending','Approved','Rejected','Closed'],
    //         message: 'Status Field Accept only Pending or Approved or Rejected or Closed'
    //     },
    //     default: "Pending"
    // },
    Keywords: [{
        type: String
    }],
    StartDate: [{
        type: String,
        default: ""
    }],
    ExpiryDate: [{
        type: String,
        default: ""
    }],
    weekSchedule: {
        Monday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Tuesday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Wednesday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Thursday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Friday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Saturday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
        Sunday: {
            Active: {
                type: Boolean,
                default: true
            },
            StartTime: {
                type: String,
                default: ""
            },
            EndTime: {
                type: String,
                default: ""
            }
        },
    },
    dateTime: [{
        type: String,
        default: ""
    }], 
});

module.exports = mongoose.model("vendorDeals",vendorDealsSchema);