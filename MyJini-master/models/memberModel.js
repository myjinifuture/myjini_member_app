const mongoose = require('mongoose');
const mongoosePaginate  = require('mongoose-paginate-v2')

const memberSchema = mongoose.Schema({
    ProfessionId: {
        type: mongoose.Types.ObjectId,
        ref: "profession"
    },
    parentId: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    Name: {
        type: String,
        require: true
    },
    ContactNo: {
        type: String,
        require: true
    },  
    society: [{
        societyId: {
            type: mongoose.Types.ObjectId,
            ref: "society"
        },
        wingId: {
            type: mongoose.Types.ObjectId,
            ref: "wings"
        }, 
        flatId: {
            type: mongoose.Types.ObjectId,
            ref: "flats"
        },
        isVerify: {
            type: Boolean,
            default: false
        },
        ResidenceType : {
            type: Number,
            default: 3
        },
        isAdmin: {
            type: Number,
            default: 0,
            enum: [0,1]
        },
    }],
    MemberNo: {
        type: String,
        default: ""
    },
    Address: {
        type: String,
        default: ""
    },
    Image: {
        type: String,
        default: ""
    },
    Vehicles: [{
        vehicleType: {
            type: String,
            enum: ["Bike", "Car"]
        },
        vehicleNo: {
            type: String,
            default: ""
        },
    }],
    WorkType: {
        type: String,
        default: ""
    },
    DateOfRentAggrement: {
        type: String,
        default: ""
    },
    CompanyName: {
        type: String,
        default: ""
    },
    Designation: {
        type: String,
        default: ""
    },
    DOB: {
        type: String,
        default: ""
    },
    BusinessDescription: {
        type: String,
        default: ""
    },
    Gender: {
        type: String,
        enum: ["male", "female","other"]
    },
    Private: {
        EmailId: {
            type: Boolean,
            default: false
        },
        ContactNo: {
            type: Boolean,
            default: false
        },
        DOB: {
            type: Boolean,
            default: false
        },
        AnniversaryDate: {
            type: Boolean,
            default: false
        }
    },
    Relation: {
        type: String,
        default: ""
    },
    BloodGroup: {
        type: String,
        default: ""
    },
    EmailId: {
        type: String,
        default: ""
    },
    NoOfFamilyMember: {
        type: String,
        default: ""
    },
    AnniversaryDate: {
        type: String,
        default: ""
    },
    isActive: {
        type: Boolean,
        default: false
    },
    Township: {
        type: String,
        default: ""
    },
    OfficeEmail: {
        type: String,
        default: ""
    },
    OfficeContact: {
        type: String,
        default: ""
    },
    OfficeAlternateNo: {
        type: String,
        default: ""
    },
    OfficeAddress: {
        type: String,
        default: ""
    },
    isOnCall: {
        type: Boolean,
        default: false
    }, 
});

memberSchema.index({ 
    MemberNo: 'text', 
    WorkType: 'text', 
    Gender: 'text', 
    Name: 'text', 
    ContactNo: 'text', 
    OfficeAddress: 'text', 
    CompanyName: 'text', 
    OfficeAlternateNo: 'text', 
    OfficeContact: 'text', 
    OfficeEmail: 'text', 
    Designation: 'text', 
    EmailId: 'text', 
    BloodGroup: 'text', 
    Township: 'text',
})

module.exports = mongoose.model("members",memberSchema);