const mongoose = require('mongoose');

const notificationSchema = mongoose.Schema({
    title: {
        type: String,
        require: true
    },
    body: {
        type: String,
        require: true
    },
    dateTime: [{
        type: String,
        default: ""
    }],
    memberId : {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    sendByMember: {
        type: mongoose.Types.ObjectId,
        ref: "members"
    },
    watchmenId : {
        type: mongoose.Types.ObjectId,
        ref: "watchman"
    },
    sendByWatchman: {
        type: mongoose.Types.ObjectId,
        ref: "watchman"
    },
    notificationType: {
        type: String,
        enum: [
            "Visitor", 
            "Guest",
            "GuestLeave",
            "VisitorLeave", 
            "SOS", 
            "VideoCalling", 
            "VoiceCall", 
            "VisitorAccepted", 
            "VisitorRejected",
            "MemberVerify",
            "SendComplainToAdmin",
            "complainSolvedByAdmin",
            "complainRejectedByAdmin",
            "SocietyVerification",
            "NoticeBoard",
            "AddGallery",
            "AddEvent",
            "AddPoll",
            "StaffEntry",
            "StaffLeave",
            "VendorEntry",
            "VendorLeave",
            "WatchmanEntry",
            "WatchmanLeave",
            "NewAmenity",
            "AdvertisePayment",
            "AddDocument",
            "AddStaff",
            "JoinSociety",
            "UnknownVisitor",
            "AssignAdminRole",
            "RevokeAdminRole",
            "RejectVideoCallingBySender",
            "RejectVideoCallingByReceiver",
            "RejectVoiceCallBySender",
            "RejectVoiceCallByReceiver",
            "BroadcastMessageFromMyJini",
            "BroadcastMessageFromSociety",
            "InstantWatchmanMessage"
        ]
    }
});

module.exports = mongoose.model("notificationContents",notificationSchema);