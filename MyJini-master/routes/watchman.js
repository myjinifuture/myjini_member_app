require("dotenv").config();
const path = require("path");
const express = require("express");
const config = require("../config");
const router = express.Router();
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const moment = require('moment-timezone');
const request = require('request');
let csc = require('country-state-city').default;
const multer = require("multer");
const OneSignal = require('onesignal-node');
const client = new OneSignal.Client(process.env.APP_ID, process.env.API_KEY);
const userClient = new OneSignal.UserClient(process.env.USER_AUTH_KEY);

const stateSchema = require('../models/stateModel');
const citySchema = require('../models/cityModel');
const societySchema = require('../models/societyModel');
const societyCategorySchema = require('../models/societyCategory');
const wingSchema = require('../models/wingModel');
const flatSchema = require('../models/flatsModel');
const professionSchema = require('../models/professionModel');
const memberSchema = require('../models/memberModel');
const memberTokenSchema = require('../models/memberToken');
const staffSchema = require('../models/staffModel');
const watchmanSchema = require('../models/watchmanModel');
const watchmanTokenSchema = require('../models/watchmanToken');
const guestEntrySchema = require('../models/guestEntry');
const staffEntrySchema = require('../models/staffEntry');
const vendorEntrySchema = require('../models/vendorEntry');
const vendorSchema = require('../models/vendorModel');
const notificationSchema = require('../models/notificationContent');
const inviteGuestSchema = require('../models/inviteGuestModel');
const unknownVisitorSchema = require('../models/unknownVisitor');
const watchmanEntrySchema = require('../models/watchmanEntry');

const { json } = require("express");

let watchmanImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/watchman");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let watchmanImg = multer({ storage: watchmanImgUploader });

let visitorImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/visitor");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let visitorImg = multer({ storage: visitorImgUploader });

let staffImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/staff");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let staffImg = multer({ storage: staffImgUploader });

//Register watchman-----------MONIL---------29/03/2021
router.post("/watchmanSignUp", watchmanImg.fields([
    { name: "watchmanImage" , maxCount: 1 },
    { name: "identityImage" , maxCount: 1 },
]) , async function(req,res,next){
    try {
        const {
            name,
            mobileNo1,
            address,
            societyCode,
            deviceType,
            identityProof,
            Gender,
        } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await watchmanSchema.aggregate([
            {
                $match: {
                    mobileNo1: mobileNo1
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Mobile Number already exist" });
        }

        const watchmanImageIs = req.files.watchmanImage;
        const staffIdentityIs = req.files.identityImage;

        let societyIs;

        if(societyCode != undefined){
            
            societyIs = await societySchema.aggregate([
                {
                    $match: { societyCode: societyCode }
                },
                {
                    $project: {
                        societyCode: 1
                    }
                }
            ]);

            if(societyIs.length == 1){
                let watchmanRecord = await new watchmanSchema({
                    name: name, 
                    mobileNo1: mobileNo1, 
                    address: address,
                    deviceType: deviceType,
                    societyId: societyIs[0]._id,
                    watchmanNo: getWatchmanNumber(),
                    Gender: Gender,
                    watchmanImage: watchmanImageIs != undefined ? watchmanImageIs[0].path : "", 
                    identityProof: identityProof, 
                    identityImage: staffIdentityIs != undefined ? staffIdentityIs[0].path : "",
                });
                
                if(watchmanRecord != null){
                    watchmanRecord.save();
                    res.status(200).json({ IsSuccess: true , Data: [watchmanRecord] , Message: "Watchman Register Successfully" });
                }else{
                    res.status(200).json({ IsSuccess: true , Data: [] , Message: "Watchman Registration Failed" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "societyCode is not valid" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Enter valid Society Code" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Watchman Login-----------MONIL---------29/03/2021
router.post("/login",async function(req,res,next){
    try {
        const { mobileNo1 , playerId , IMEI , DeviceType } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(!DeviceType){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide Valid Device Type like Android or IOS" })
        }

        let getWatchman = await watchmanSchema.aggregate([
            {
                $match: {
                    $and: [
                        { ContactNo1: mobileNo1 }
                    ]
                }
            }
        ]);

        if(getWatchman.length == 1){
            res.status(200).json({ IsSuccess: true , Data: getWatchman , Message: "Watchman loggedIn" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Watchman Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Update Watchman PlayerId -----------------MONIL---------------28/04/2021
router.post("/updateWatchmanPlayerId",async function(req,res,next){
    try {
        const { watchmanId , mobileNo1 , playerId , IMEI , DeviceType } = req.body;
        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkToken = await watchmanTokenSchema.aggregate([
            {
                $match: {
                    IMEI: String(IMEI)
                }
            }
        ]);

        if(checkToken.length == 0){
            let addNewToken = await new watchmanTokenSchema({
                watchmanId: watchmanId,
                mobileNo: String(mobileNo1),
                playerId: String(playerId),
                IMEI: String(IMEI),
                DeviceType: String(DeviceType)
            });

            if(addNewToken != null){
                try {
                    await addNewToken.save();   
                } catch (error) {
                    res.status(500).json({ IsSuccss: false , Message: error.message });
                }
            }

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `New Watchman Token Added` });
        }else{
            let update = {
                watchmanId: watchmanId,
                mobileNo: String(mobileNo1),
                playerId: String(playerId),
                DeviceType: String(DeviceType)
            }
            let updateWatchmanToken = await watchmanTokenSchema.findByIdAndUpdate(checkToken[0]._id,update);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Watchman Token Updated` });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Add Staff By Watchman--------------MONIL------------16/04/2021
router.post("/addStaffByWatchman", staffImg.single("staffImage") ,async function(req,res,next){
    try {
        const {
            Name, 
            ContactNo1,
            Address,
            staffCategory,
            societyId,
            Gender,
            watchmanId,
            AadharcardNo,
            VoterId,
            DateOfBirth,
            DateOfJoin,
            RecruitType,
            AgencyName,
            EmergencyContactNo,
            VehicleNo,
            Work,
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkWatchman = await watchmanSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(watchmanId) },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);

        if(checkWatchman.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Watchman found for watchmanId ${watchmanId} & societyId ${societyId}` });
        }

        const file = req.file;

        let checkExist = await  staffSchema.aggregate([
            {
                $match: {
                    $and: [
                        { Name: Name },            
                        { ContactNo1: ContactNo1 },            
                        { Gender: Gender },
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff With this details already exist" });
        }

        let addStaffIs = await new staffSchema({
            Name: Name,
            ContactNo1: ContactNo1,
            Gender: Gender,
            Address: Address,
            staffCategory: staffCategory,
            societyId: societyId,
            watchmanId: watchmanId,
            entryNo: getStaffNumber(),
            staffImage: file != undefined ? file.path : "", 
            AadharcardNo: AadharcardNo,
            VoterId: VoterId,
            DateOfBirth: DateOfBirth,
            DateOfJoin: DateOfJoin != undefined ? DateOfJoin : getCurrentDate(),
            RecruitType: RecruitType,
            AgencyName: AgencyName,
            EmergencyContactNo: EmergencyContactNo,
            VehicleNo: VehicleNo,
            Work: Work
        });

        if(addStaffIs != null){
            addStaffIs.save();
            res.status(200).json({ IsSuccess: true , Data: [addStaffIs] , Message: "Staff Added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Not Added" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Entry Number Type
async function getEntryNoCategory(societyId,entryNo){

    let staffNo = "STAFF-" + String(entryNo);
    let guestNo = "GUEST-" + String(entryNo);
    let vendorNo = "VENDOR-" + String(entryNo);
    let watchmanNo = "WATCHMEN-" + String(entryNo);

    let searchInStaff = await staffSchema.aggregate([
        {
            $match: {
                $and: [
                    { societyId: mongoose.Types.ObjectId(societyId) },
                    { entryNo: staffNo }
                ]
            }
        }
    ]);

    if(searchInStaff.length == 1){
        return 0;
    }

    let searchInGuest = await inviteGuestSchema.aggregate([
        {
            $match: {
                $and: [
                    { societyId: mongoose.Types.ObjectId(societyId) },
                    { entryNo: guestNo }
                ]
            }
        }
    ]);

    if(searchInGuest.length == 1){
        return 1;
    }

    let searchInVendor = await vendorSchema.aggregate([
        {
            $match: {
                $and: [
                    { societyId: mongoose.Types.ObjectId(societyId) },
                    { entryNo: vendorNo }
                ]
            }
        }
    ]);

    if(searchInVendor.length == 1){
        return 2;
    }

    let searchInWatchman = await watchmanSchema.aggregate([
        {
            $match: {
                $and: [
                    { societyId: mongoose.Types.ObjectId(societyId) },
                    { watchmanNo: watchmanNo }
                ]
            }
        }
    ]);

    if(searchInWatchman.length == 1){
        return 3;
    }
};

//Add Visitor Entry------------------MONIL------------29/03/2021
router.post("/addVisitorEntry", visitorImg.fields([
    { name: "guestImage" , maxCount: 1 },
    { name: "companyImage" , maxCount: 1 },
]) , async function(req,res,next){
    try {
        const { 
            Name, 
            ContactNo,
            societyId,
            wingId,
            flatId,
            memberId,
            vehicleNo,
            addedBy,
            watchmanId,
            isMask,
            isSanitize,
            Temperature,
            purposeId,
            CompanyName, 
            entryNo,
            guestType,
            isVerified,
        } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getWatchman = await watchmanSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(watchmanId)
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo1: 1,
                    watchmanImage: 1,
                    watchmanNo: 1,
                    wingId: 1
                }
            }
        ]);

        if(getWatchman.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Watchamen found for watchmanId : ${watchmanId}` });
        }

        let isGuest = false;
        let isStaff = false;
        let isVendor = false;
        let isWatchman = false;
        let entryNoIs;
        
        if(entryNo != undefined){
            
            let entryType = await getEntryNoCategory(societyId,entryNo);
            
            if(entryType == 0){
                isStaff = true;
                entryNoIs = "STAFF-" + entryNo;
            }else if(entryType == 1){
                isGuest = true;
                entryNoIs = "GUEST-" + entryNo;
            }else if(entryType == 2){
                isVendor = true;
                entryNoIs = "VENDOR-" + entryNo;
            }else if(entryType == 3){
                isWatchman = true,
                entryNoIs = "WATCHMEN-" + entryNo;
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Guest , Staff or Vendor found for ${entryNo}` });
            }

        };

        let guestImageIs = req.files.guestImage;
        let companyImageIs = req.files.companyImage;

        if(entryNo == undefined || entryNo == null || entryNo == "" || ( isGuest == false && isStaff == false && isVendor == false && isWatchman == false) ){

            //Add New Guest Entry By watchmen
            let getMember = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(memberId)
                    }
                }
            ]);
    
            if(getMember.length == 0){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Member Found for memberId ${memberId}` });
            }
            
            let addVisitor = await new guestEntrySchema({
                Name: Name,
                ContactNo: ContactNo,
                societyId: societyId,
                wingId: wingId,
                flatId: flatId,
                guestType: guestType,
                memberId: memberId,
                vehicleNo: vehicleNo,
                addedBy: addedBy,
                watchmanId: watchmanId,
                inDateTime: getCurrentDateTime(),
                entryNo: getGuestNumber(),
                purposeId: purposeId,
                CompanyName: CompanyName,
                isMask: isMask,
                isSanitize: isSanitize,
                Temperature: Temperature,
                guestImage: guestImageIs != undefined || null ? guestImageIs[0].path : "",
                companyImage: companyImageIs != undefined ? companyImageIs[0].path : "",
            });

            if(addVisitor != null){
                try {
                    await addVisitor.save();
                } catch (error) { 
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                if(isVerified == String(true)){
                    return res.status(200).json({ IsSuccess: true , Category: "Guest" , Data: [addVisitor] , Message: "Visitor Added" });
                }
                
                let getMemberIds = await getFlatMember([flatId]);
                
                let title = `Notification - Visitor Entry`;
                let body = `Your Guest ${Name} arrived at gate`;
                let notiData = {
                    EntryNo: addVisitor.entryNo,
                    Name: addVisitor.Name,
                    CompanyName: addVisitor.CompanyName,
                    VisitorContactNo: addVisitor.ContactNo,
                    guestImage: addVisitor.guestImage,
                    companyImage: addVisitor.companyImage,
                    watchmanId: addVisitor.watchmanId,
                    watchmanContact: getWatchman[0].ContactNo1,
                    watchmanWingId: getWatchman[0].wingId,
                    EntryId: addVisitor._id,
                    Message: `Your Guest ${Name} arrived at gate`,
                    notificationType: "Visitor",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };
                
                if(getMemberIds.length > 0){
                    // let memberToken = await getMemberFcmTokens(getMemberIds);
                    let memberToken = await getMemberPlayerId(getMemberIds);
                    
                    if(memberToken.length > 0){
                        memberToken.forEach(tokenIs => {
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "Phone-Ring.wav"
                                };
                                
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"Visitor",tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "5db6c5b1-b85d-475c-98ea-eb7512df8125"
                                };
                                
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"Visitor",tokenIs.DeviceType);
                            }
                        });
                    }
                }

                return res.status(200).json({ IsSuccess: true , Category: "Guest" , Data: [addVisitor] , Message: "Visitor Added" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Visitor Not Added" });
            }
        }else if(isGuest == true && isVendor == false && isStaff == false && isWatchman == false){
            //Exist Guest Entry (Using barcode)
            console.log("=========================Exist Guest Entry (Using barcode)================================");
            let guestIs = await inviteGuestSchema.aggregate([
                {
                    $match: {
                        entryNo: entryNoIs
                    }
                }
            ]);

            if(guestIs.length == 1){
                let guestId = guestIs[0]._id;
                let flatIdIs = guestIs[0].flatId;

                let memberIds = await getFlatMember([flatIdIs]);

                let guestCheckIn = await guestEntrySchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { entryNo: entryNoIs },
                                { "inDateTime.0": getCurrentDate() },
                                { outDateTime: { $size: 0 } }
                            ]
                        }
                    }
                ]);

                if(guestCheckIn.length == 1){
                    let updateGuestOutTime = {
                        outDateTime: getCurrentDateTime()
                    };

                    let guestCheckOut = await guestEntrySchema.findByIdAndUpdate(guestCheckIn[0]._id,updateGuestOutTime);

                    let title = `Notification - GuestLeave`;
                    let body = `Your Visitor ${guestIs[0].Name} has left society`;
                    let notiData = {
                        EntryNo: entryNoIs,
                        Name: guestIs[0].Name,
                        guestImage: guestIs[0].guestImage,
                        VisitorContactNo: guestIs[0].ContactNo,
                        Message: `Your Visitor ${guestIs[0].Name} with entryNo ${entryNoIs} has left society`,
                        notificationType: "GuestLeave",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    if(memberIds.length > 0){
                        // let memberToken = await getMemberFcmTokens(memberIds);
                        let memberToken = await getMemberPlayerId(memberIds);

                        memberToken.forEach( tokenIs => {
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "notification-_2_.wav"
                                };
                                
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"GuestLeave",tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                };
                                
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"GuestLeave",tokenIs.DeviceType);
                            }
                            // if(tokenIs.DeviceType == "Android"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VisitorLeave","Android");
                            // }else if(tokenIs.DeviceType == "IOS"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VisitorLeave","IOS");
                            // }else{
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VisitorLeave","Android");
                            // }
                        });
                    }

                    return res.status(200).json({ IsSuccess: true , Category: "Guest" , Data: 1 , Message: `Guest with entryNo ${entryNoIs} outTime Marked` });
                }

                let checkAlreadyVisited = await inviteGuestSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { entryNo: entryNoIs },
                                { isVisited: true }
                            ]
                        }
                    }
                ]);

                if(checkAlreadyVisited.length == 1){
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Guest Already Visited" });
                }

                let addVisitor = await new guestEntrySchema({
                    Name: guestIs[0].Name,
                    ContactNo: guestIs[0].ContactNo,
                    societyId: guestIs[0].societyId,
                    wingId: guestIs[0].wingId,
                    flatId: guestIs[0].flatId,
                    memberId: guestIs[0].memberId,
                    vehicleNo: vehicleNo,
                    addedBy: "Member",
                    watchmanId: watchmanId,
                    inDateTime: getCurrentDateTime(),
                    entryNo: guestIs[0].entryNo,
                    purposeId: guestIs[0].purposeId,
                    isMask: true,
                    isSanitize: true,
                    Temperature: true,
                });

                if(addVisitor != null){
                    try {
                        await addVisitor.save();
                    } catch (error) { 
                        return res.status(500).json({ IsSuccess: false , Message: error.message });
                    }
                    let update = {
                        isVisited: true,
                        inDateTime: getCurrentDateTime()
                    }

                    let updateEntry = {
                        status: "1"
                    }

                    let updateInviteGuest = await inviteGuestSchema.findByIdAndUpdate(guestIs[0]._id,update);
                    let updateEntryStatus = await guestEntrySchema.findByIdAndUpdate(addVisitor._id,updateEntry);

                    if(isVerified == String(true)){
                        return res.status(200).json({ IsSuccess: true , Category: "Guest" , Data: [addVisitor] , Message: "Visitor Added" });
                    }

                    let title = `Notification - Guest Entry`;
                    let body = `Your Guest ${guestIs[0].Name} is arrived at gate, NotificationType : Guest`;
                    let notiData = {
                        EntryNo: addVisitor.entryNo,
                        Name: addVisitor.Name,
                        CompanyName: addVisitor.CompanyName,
                        guestImage: addVisitor.guestImage,
                        VisitorContactNo: addVisitor.ContactNo,
                        companyImage: addVisitor.companyImage,
                        watchmanId: addVisitor.watchmanId,
                        EntryId: addVisitor._id,
                        Message: "You Have one visitor request",
                        notificationType: "Guest",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    if(memberIds.length > 0){
                        // let memberToken = await getMemberFcmTokens(memberIds);
                        let memberToken = await getMemberPlayerId(memberIds);

                        memberToken.forEach( tokenIs => {
                            
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "Phone-Ring.wav"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"Guest","IOS");
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "5db6c5b1-b85d-475c-98ea-eb7512df8125"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"Guest","Android");
                            }
                            // if(tokenIs.DeviceType == "Android"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"Visitor","Android");
                            // }else if(tokenIs.DeviceType == "IOS"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"Visitor","IOS");
                            // }else{
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"Visitor","Android");
                            // }
                        });
                    }
                    
                    return res.status(200).json({ IsSuccess: true , Category: "Guest" , Data: [addVisitor] , Message: "Visitor Added" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Visitor Not Added" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Your code is expire or your code is invalid` });
            }
        }else if(isGuest == false && isStaff == true && isVendor == false && isWatchman == false){
            //Staff Entry (Using Barcode)
            console.log("========================Staff Entry============================");
            let staffDataIs = await staffSchema.aggregate([
                {
                    $match: {
                        entryNo: entryNoIs
                    }
                }
            ]);

            if(staffDataIs.length == 1){

                let staffWorkLocation = staffDataIs[0].workingLocation;

                let flatIds = [];

                staffWorkLocation.forEach(workLocations=>{
                    flatIds.push(workLocations.flatId);
                });

                let staffIdIs = staffDataIs[0]._id;
                let staffCheckIn = await staffEntrySchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { staffId: mongoose.Types.ObjectId(staffIdIs) },
                                { "inDateTime.0": getCurrentDate() },
                                { outDateTime: { $size: 0 } }
                            ]
                        }
                    }
                ]);

                if(staffCheckIn.length == 1){
                    console.log("========================================Staff Duty Out========================================");
                    let updateOutTime = {
                        outDateTime: getCurrentDateTime()
                    }
                    let staffCheckOut = await staffEntrySchema.findByIdAndUpdate(staffCheckIn[0]._id,updateOutTime);

                    let title = `Notification - Staff Leave`;
                    let body = `Your Staff ${staffDataIs[0].Name} has left society`;
                    let notiData = {
                        EntryNo: entryNoIs,
                        Name: staffDataIs[0].Name,
                        VisitorContactNo: staffDataIs[0].ContactNo1,
                        guestImage: staffDataIs[0].staffImage,
                        watchmanId: watchmanId,
                        EntryId: staffCheckIn[0]._id,
                        Message: `Your Staff ${staffDataIs[0].Name} has left society`,
                        notificationType: "StaffLeave",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    let memberIds = await getFlatMember(flatIds);
                    
                    let memberToken = await getMemberPlayerId(memberIds);

                    memberToken.forEach( tokenIs => {
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": body
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiData,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "notification-_2_.wav"
                            };
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffLeave","IOS");
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": body
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiData,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                            };
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffLeave","Android");
                        }
                        // if(tokenIs.DeviceType == "Android"){
                        //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffLeave","Android");
                        // }else if(tokenIs.DeviceType == "IOS"){
                        //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffLeave","IOS");
                        // }else{
                        //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffLeave","Android");
                        // }
                    });

                    return res.status(200).json({ IsSuccess: true , Category: "Staff" , Data: 1 , Message: `Staff With EntryNo ${entryNoIs} Out Time Marked` });
                }

                let addStaffEntry = await new staffEntrySchema({
                    staffId: staffDataIs[0]._id,
                    societyId: staffDataIs[0].societyId,
                    vehicleNo: vehicleNo,
                    watchmanId: watchmanId,
                    inDateTime: getCurrentDateTime()
                }); 

                if(addStaffEntry != null){
                    try {
                        await addStaffEntry.save();
                    } catch (error) { 
                        return res.status(500).json({ IsSuccess: false , Message: error.message });
                    }

                    if(isVerified == true){
                        return res.status(200).json({ IsSuccess: true , Category: "Staff" , Data: [addStaffEntry] , Message: "Staff Entry Added" });
                    }

                    let title = `Notification - Staff Entry`;
                    let body = `Your Staff ${staffDataIs[0].Name} has entered the society`;
                    let notiData = {
                        EntryNo: entryNoIs,
                        Name: staffDataIs[0].Name,
                        VisitorContactNo: staffDataIs[0].ContactNo1,
                        guestImage: staffDataIs[0].staffImage,
                        watchmanId: watchmanId,
                        EntryId: addStaffEntry._id,
                        Message: "Your staff come to society",
                        notificationType: "StaffEntry",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    let memberIds = await getFlatMember(flatIds);
                    
                    // let memberToken = await getMemberFcmTokens(memberIds);
                    let memberToken = await getMemberPlayerId(memberIds);

                    if(staffDataIs[0].staffCategory == "Maid"){
                        memberToken.forEach( tokenIs => {
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "maidinentry.wav"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffEntry","IOS");
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "c20ebb60-4b1d-460b-b24b-5af5be2c78b6"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            }
                            // if(tokenIs.DeviceType == "Android"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            // }else if(tokenIs.DeviceType == "IOS"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","IOS");
                            // }else{
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            // }
                        });
                    }else{
                        memberToken.forEach( tokenIs => {
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "notification-_2_.wav"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffEntry","IOS");
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": body
                                    },
                                    headings: {"en": `${title}`, "es": "Spanish Title"},
                                    data: notiData,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            }
                            // if(tokenIs.DeviceType == "Android"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            // }else if(tokenIs.DeviceType == "IOS"){
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","IOS");
                            // }else{
                            //     sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"StaffEntry","Android");
                            // }
                        });
                    }

                    return res.status(200).json({ IsSuccess: true , Category: "Staff" , Data: [addStaffEntry] , Message: "Staff Entry Added" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Entry Not Added" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Your code is expire or your code is invalid` });
            }
            
        }else if(isGuest == false && isStaff == false && isVendor == false && isWatchman == true){

            //Watchman Entry (Using Barcode)
            console.log("============================Watchman Entry===============================");

            let watchmanDataIs = await watchmanSchema.aggregate([
                {
                    $match: {
                        watchmanNo: entryNoIs
                    }
                }
            ]);

            if(watchmanDataIs.length == 1){

                let watchmanCheckIn = await watchmanEntrySchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { enterWatchmanId: mongoose.Types.ObjectId(watchmanDataIs[0]._id) },
                                { "inDateTime.0": getCurrentDate() },
                                { outDateTime: { $size: 0 } }
                            ]
                        }
                    }
                ]);

                if(watchmanCheckIn.length == 1){
                    let updateWatchmanOutTime = {
                        outDateTime: getCurrentDateTime()
                    };

                    let watchmanCheckOut = await watchmanEntrySchema.findByIdAndUpdate(watchmanCheckIn[0]._id,updateWatchmanOutTime);

                    let title = `Your Watchman ${watchmanDataIs[0].Name} has left society`;
                    let body = `Watchman EntryNo: ${entryNoIs} , NotificationType : WatchmanLeave `;
                    let notiData = {
                        EntryNo: watchmanDataIs[0].watchmanNo,
                        Name: watchmanDataIs[0].Name,
                        VisitorContactNo: watchmanDataIs[0].ContactNo1,
                        watchmanImage: watchmanDataIs[0].watchmanImage,
                        watchmanId: watchmanId,
                        EntryId: watchmanCheckIn[0]._id,
                        Message: `Your Watchman ${watchmanDataIs[0].Name} has left society`,
                        notificationType: "WatchmanLeave",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    let adminIds = await getSocietyAdmin(societyId);

                    if(adminIds.length > 0){
                        let adminToken = await getMemberPlayerId(adminIds);

                        if(adminToken.length > 0){
                            adminToken.forEach( tokenIs => {
                                if(tokenIs.DeviceType == "IOS"){
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": body
                                        },
                                        headings: {"en": `${title}`, "es": "Spanish Title"},
                                        data: notiData,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        ios_sound: "notification-_2_.wav"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"WatchmanLeave","IOS");
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": body
                                        },
                                        headings: {"en": `${title}`, "es": "Spanish Title"},
                                        data: notiData,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"WatchmanLeave","Android");
                                }
                            });
                        }
                    }

                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Category: "Watchman",
                        Data: 1, 
                        Message: `Watchman with entryNo ${entryNoIs} outTime marked` 
                    });
                }

                let addWatchmanEntry = await new watchmanEntrySchema({
                    enterWatchmanId: watchmanDataIs[0]._id,
                    societyId: societyId,
                    watchmanId: watchmanId,
                    inDateTime: getCurrentDateTime(),
                    vehicleNo: vehicleNo
                });

                if(addWatchmanEntry != null){
                    try {
                        await addWatchmanEntry.save();
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: false , Message: error.message });
                    }

                    let title = `Your Watchman ${watchmanDataIs[0].Name} has enter to society society`;
                    let body = `Watchman EntryNo: ${entryNoIs} , NotificationType : WatchmanEntry `;
                    let notiData = {
                        EntryNo: watchmanDataIs[0].watchmanNo,
                        Name: watchmanDataIs[0].Name,
                        VisitorContactNo: watchmanDataIs[0].ContactNo1,
                        watchmanImage: watchmanDataIs[0].watchmanImage,
                        watchmanId: watchmanId,
                        EntryId: addWatchmanEntry._id,
                        Message: `Your Watchman ${watchmanDataIs[0].Name} has enter to society society`,
                        notificationType: "WatchmanEntry",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    let adminIds = await getSocietyAdmin(societyId);

                    if(adminIds.length > 0){
                        let adminToken = await getMemberPlayerId(adminIds);
                        if(adminToken.length > 0){
                            adminToken.forEach( tokenIs => {
                                if(tokenIs.DeviceType == "IOS"){
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": body
                                        },
                                        headings: {"en": `${title}`, "es": "Spanish Title"},
                                        data: notiData,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        ios_sound: "notification-_2_.wav"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"WatchmanEntry","IOS");
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": body
                                        },
                                        headings: {"en": `${title}`, "es": "Spanish Title"},
                                        data: notiData,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"WatchmanEntry","Android");
                                }
                            });
                        }
                    }

                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Category: "Watchman",
                        Data: [addWatchmanEntry], 
                        Message: `Watchman with entryNo ${entryNoIs} inTime marked` 
                    });
                }
            }else{
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [],
                    Message: `Your code is expire or your code is invalid`
                });
            }

        }else if(isGuest == false && isStaff == false && isWatchman == false && isVendor == true){

            //Vendor Entry (Using Barcode)

            let vendorDataIs = await vendorSchema.aggregate([
                {
                    $match: {
                        entryNo: entryNoIs
                    }
                }
            ]);

            if(vendorDataIs.length == 1){

                let vendorIdIs = vendorDataIs[0]._id;

                let vendorCheckIn = await vendorEntrySchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { vendorId: mongoose.Types.ObjectId() },
                                { "inDateTime.0": getCurrentDate() },
                                { outDateTime: { $size: 0 } }
                            ]
                        }
                    }
                ]);

                if(vendorCheckIn.length == 1){
                    let updateVendorOutTime = {
                        outDateTime: getCurrentDateTime()
                    };

                    let vendorCheckOut = await vendorEntrySchema.findByIdAndUpdate(vendorCheckIn[0]._id,updateVendorOutTime);

                    let title = `Vendor with EntryNo ${addVendorEntry.entryNo} has left society`;
                    let body = `Your Vendor ${vendorDataIs[0].Name} has left society , NotificationType : VendorLeave `;
                    let notiData = {
                        EntryNo: vendorDataIs[0].entryNo,
                        Name: vendorDataIs[0].Name,
                        VisitorContactNo: vendorDataIs[0].ContactNo,
                        guestImage: vendorDataIs[0].vendorImage,
                        watchmanId: watchmanId,
                        EntryId: addVendorEntry._id,
                        Message: `Your Vendor ${vendorDataIs[0].Name} has left society`,
                        notificationType: "VendorLeave",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };
                    let notiMemberIs = vendorDataIs[0].ContactPerson;

                    let memberToken = await getSingleMemberFcmTokens(notiMemberIs);

                    memberToken.forEach( tokenIs => {
                        if(tokenIs.DeviceType == "Android"){
                            sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VendorLeave","Android");
                        }else if(tokenIs.DeviceType == "IOS"){
                            sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VendorLeave","IOS");
                        }else{
                            sendNormalNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VendorLeave","Android");
                        }
                    });

                    return res.status(200).json({ IsSuccess: true , Category: "Vendor" , Data: 1 , Message: `Vendor with entryNo ${entryNoIs} outTime marked` });
                }

                let addVendorEntry = await new vendorEntrySchema({
                    vendorId: vendorDataIs[0]._id,
                    societyId: societyId,
                    inDateTime: getCurrentDateTime(),
                    watchmanId: watchmanId,
                    vehicleNo: vehicleNo
                });

                if(addVendorEntry != null){
                    try {
                        await addVendorEntry.save();
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: true , Data: [] , Message: error.message })
                    }

                    let title = `NotificationType : VendorEntry`;
                    let body = `Your Vendor ${vendorDataIs[0].Name} has entered the society `;
                    
                    let notiMemberIs = vendorDataIs[0].ContactPerson;

                    let memberToken = await getSingleMemberFcmTokens(notiMemberIs);

                    memberToken.forEach( tokenIs => {
                        if(tokenIs.muteNotificationAudio == false){
                            let notiData = {
                                EntryNo: vendorDataIs[0].entryNo,
                                Name: vendorDataIs[0].Name,
                                VisitorContactNo: vendorDataIs[0].ContactNo,
                                guestImage: vendorDataIs[0].vendorImage,
                                watchmanId: watchmanId,
                                EntryId: addVendorEntry._id,
                                Message: "Your vendor come to society",
                                muteNotificationAudio: true,
                                notificationType: "VendorEntry",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            };
                            sendNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VendorEntry",tokenIs.DeviceType);
                        }else{
                            let notiData = {
                                EntryNo: vendorDataIs[0].entryNo,
                                Name: vendorDataIs[0].Name,
                                VisitorContactNo: vendorDataIs[0].ContactNo,
                                guestImage: vendorDataIs[0].vendorImage,
                                watchmanId: watchmanId,
                                EntryId: addVendorEntry._id,
                                Message: "Your vendor come to society",
                                muteNotificationAudio: false,
                                notificationType: "VendorEntry",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            };
                            sendNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"VendorEntry",tokenIs.DeviceType);
                        }
                    });
                    return res.status(200).json({ IsSuccess: true , Category: "Vendor" , Data: [addVendorEntry] , Message: "Vendor Entry Added" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Vendor Entry Not Added" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Your code is expire or your code is invalid` });
            }

        } else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please provide valid entryNo" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Add Guest Vehicles-------------------------------MONIL----------14/04/2021
router.post("/addGuestVehicle",async function(req,res,next){
    try {
        const { guestEntryId , vehicleNo } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkGuestEntry = await guestEntrySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(guestEntryId)
                }
            }
        ]);

        if(checkGuestEntry.length == 1){
            let update = {
                vehicleNo: vehicleNo
            }

            let addGuestVehicle = await guestEntrySchema.findByIdAndUpdate(guestEntryId,update);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Guest Vehicle ${vehicleNo} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Guest found for id ${guestEntryId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Send Notification to Parent Member of flat--------MONIL--------08/04/2021
router.post("/sendNotificationForVisitorEntry",async function(req,res,next){
    try {
        const { wingId , flatId , societyId , watchmanId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getFlat = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { _id: mongoose.Types.ObjectId(flatId) },
                        { parentMember: { $exists: true } }
                    ]
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $project: {
                    flatNo: 1,
                    parentMember: 1,
                    "WingData.wingName": 1
                }
            }
        ]);

        if(getFlat.length == 1){

            let memberIs = getFlat[0].parentMember;

            let memberData = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(memberIs)
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        Image: 1,
                    }
                }
            ]);

            if(memberData.length == 0){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Parent Member Exist to this flat" });
            }

            let addUnknownVisitor = await new unknownVisitorSchema({
                societyId: societyId,
                wingId: wingId,
                flatId: flatId,
                responseMemberId: memberIs,
                watchmanId: watchmanId,
                entryNo: getGuestNumber()
            });

            if(addUnknownVisitor != null){
                addUnknownVisitor.save();

                let title = `Visitor Entry`;
                let body = `You Have New Visitor Entry , EntryNo ${addUnknownVisitor.entryNo}`;
                let notiData = {
                    Message: "Visitor has arrived , Watchman wants to have Video Call with you",
                    EntryId: addUnknownVisitor._id,
                    EntryNo: addUnknownVisitor.entryNo,
                    MemberName: memberData[0].Name,
                    MemberContactNo: memberData[0].ContactNo,
                    MemberImage: memberData[0].Image,
                    Wing: getFlat[0].WingData[0].wingName,
                    Flat: getFlat[0].flatNo,
                    notificationType: "UnknownVisitor",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                let memberToken = await getSingleMemberPlayerId(memberIs);
                
                memberToken.forEach( tokenIs => {
                    if(tokenIs.muteNotificationAudio == false){
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": body
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiData,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "Phone-Ring.wav"
                            };
                            
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"UnknownVisitor","IOS");
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": body
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiData,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "5db6c5b1-b85d-475c-98ea-eb7512df8125"
                            };
                            
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"UnknownVisitor","IOS");
                        }
                        // sendNotification(tokenIs.fcmToken,notiData,title,body,true,false,tokenIs.memberId,watchmanId,"UnknownVisitor",tokenIs.DeviceType);
                    }
                }); 
                return res.status(200).json({ IsSuccess: true , EntryData: [addUnknownVisitor] , Data: [notiData] , Message: "Notification Send To Parent Member of Flat" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [notiData] , Message: "Notification Send To Parent Member of Flat" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No flat or parent member found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Get Visitor entry--------------MONIL----------------31/03/2021
router.post("/getAllVisitorEntry",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllVisitors = await guestEntrySchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { status: "1" }
                    ]
                }
            },
            {
                $lookup: {
                    from: "guestcategories",
                    localField: "guestType",
                    foreignField: "_id",
                    as: "GuestCategory"
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "flatId",
                    foreignField: "_id",
                    as: "FlatData"
                }
            },
            {
                $lookup: {
                    from: "purposerecords",
                    localField: "purposeId",
                    foreignField: "_id",
                    as: "PurposeIs"
                }
            },

        ]);

        if(getAllVisitors.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getAllVisitors.length , Data: getAllVisitors , Message: "Visitors Entry Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Visitors Entry Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Get All Society Staff------MONIL-------------31/03/2021
router.post("/getAllStaff",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaff = await staffSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "workingLocation.wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "workingLocation.flatId",
                    foreignField: "_id",
                    as: "FlatData"
                }
            },
        ]);

        if(getStaff.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getStaff , Message: "Staff Data found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Data found" });
        }
    } catch (error) {   
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Visitor OutTime-------------------MONIL----------31/03/2021
router.post("/updateOutTime",async function(req,res,next){
    try {
        const { entryId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await guestEntrySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(entryId)
                }
            }
        ]);

        if(checkExist.length == 1){

            let checkOutTime = checkExist[0].outDateTime;

            if(checkOutTime.length >0){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Out Time Already marked to : ${checkOutTime}` })
            }

            let updateIs = {
                outDateTime: getCurrentDateTime()
            }
            
            let inTimeIs = checkExist[0].inDateTime;
            let outTime = updateIs.outDateTime;

            // console.log(inTimeIs);
            // console.log(outTime);

            // let a = moment(inTimeIs[0], inTimeIs[1]).format('YYYY-MM-DD HH:mm');
            // console.log(a);
            let updateVisitorOutTime = await guestEntrySchema.findByIdAndUpdate(entryId,updateIs);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Out Time marked to : ${updateIs.outDateTime}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Visitor Found for entryId : ${entryId}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Add Staff EntryNo---------------------------MONIL---------------------09/04/2021
//type - 0 - Staff
//type - 1 - Watchman
router.post("/addStaffEntryNo",async function(req,res,next){
    try {
        const { staffId , entryNo , societyId , type } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(type == 0){
            let checkExistEntryNo = await staffSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { entryNo: entryNo }
                        ]
                    }
                }
            ]);
    
            if(checkExistEntryNo.length == 1){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `This QR Code is already mapped` });
            }

            let getstaff = await staffSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(staffId)
                    }
                }
            ]);

            if(getstaff.length == 1){
                let update = {
                    entryNo: entryNo,
                    isMapped: true
                }
    
                let updateStaffEntryNo = await staffSchema.findByIdAndUpdate(staffId,update);
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff Entry No ${entryNo} Mapped` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Staff found for staffId: ${staffId}` });
            }
        }else if(type == 1){
            let getNumber = entryNo.split("-");
            let watchmanNoIs = "WATCHMEN-" + getNumber[1]
            let checkExistEntryNo = await watchmanSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { watchmanNo: entryNo }
                        ]
                    }
                }
            ]);
    
            if(checkExistEntryNo.length == 1){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `This QR Code is already mapped` });
            } 
            let getWatchman = await watchmanSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(staffId)
                    }
                }
            ]);

            if(getWatchman.length == 1){
                
                let update = {
                    watchmanNo: watchmanNoIs,
                    isMapped: true
                }
                let updateWatchmanEntryNo = await watchmanSchema.findByIdAndUpdate(staffId,update);
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Watchman EntryNo ${update.watchmanNo} Mapped` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `Please Provide type 0 for staff and 1 for watchman` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

//Unmapped society Staff----------------------MONIL--------------------24/04/2021
router.post("/unMappedStaff",async function(req,res,next){
    try {
        const { societyId , staffIdList , type } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let updateIs = {
            entryNo: "STAFF-000000",
            isMapped: false
        }

        if(staffIdList != undefined && staffIdList.length > 0){
            console.log("here");
            staffIdList.forEach(async function(staffId){
                let unMappedStaff = await staffSchema.findByIdAndUpdate(staffId,updateIs);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff Ids ${staffIdList} UnMapped` });
        }else{
            if(societyId != undefined && societyId != null && societyId != ""){

                    let getStaff = await staffSchema.aggregate([
                        {
                            $match: {
                                societyId: mongoose.Types.ObjectId(societyId)
                            }
                        },
                        {
                            $project: {
                                entryNo: 1
                            }
                        }
                    ]);

                    if(getStaff.length > 0){
                        getStaff.forEach(async function(staff){
                            let staffId = staff._id;
                            let unMappedStaff = await staffSchema.findByIdAndUpdate(staffId,updateIs);
                        });
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Society Staffs UnMapped` });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Society Staffs Found` });
                    }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Please Pass Correct SocietyId` });
            }         
        }
    } catch (error) {
        res.status(500).json({ IsSuccss: false , Message: error.message });
    }
});

async function deleteFile(path){

    fs.unlink(path, function(err) {
        // if (err) {
        //     throw err
        // } else {
        //     console.log("Successfully deleted the file.")
        // }
        console.log("Successfully deleted the file.")
    });
}

//Send Notification via oneSignal
var sendOneSignalNotification = function(data,receiver_type,sender_type,receiverId,senderId,notification_Category,deviceType) {
    var headers;
    if(receiver_type == true){
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic MDE5YmRjNmMtMWI1ZS00MDY0LWJjNmYtZjRlN2ZkY2ZkY2U3"
          };
    }else if(receiver_type == false){
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic MjM3NjdjMjctOWVmMS00Mzg3LTk0MzYtZGEzZjRmZWFkMjQz"
          };
    }else{
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic MDE5YmRjNmMtMWI1ZS00MDY0LWJjNmYtZjRlN2ZkY2ZkY2U3"
          };
    }
    
    var options = {
      host: "onesignal.com",
      port: 443,
      path: "/api/v1/notifications",
      method: "POST",
      headers: headers
    };
    
    var https = require('https');
    var req = https.request(options, function(res) {  
      res.on('data', function(data) {
        console.log("Response:");
        console.log(JSON.parse(data));
      });
    });
    
    req.on('error', function(e) {
      console.log("ERROR:");
      console.log(e);
    });
    
    req.write(JSON.stringify(data));
    req.end();
};

//Get Society Admins---------------MONIL---------24/05/2021
async function getSocietyAdmin(societyId){
    let societyIdIs = String(societyId);

    let adminIds = [];

    let getAdmin = await memberSchema.aggregate([
        {
            $match: {
                society: {
                    $elemMatch: {
                        societyId: mongoose.Types.ObjectId(societyIdIs),
                        isAdmin: 1
                    }
                }
            }
        },
        {
            $group: {
                _id: "$_id"
            }
        }
    ]);

    if(getAdmin.length > 0){
        getAdmin.forEach(id=>{
            adminIds.push(id._id);
        });
    }

    return adminIds;
}

//Get member tokens 
async function getSingleMemberFcmTokens(memberId){
    let memberIdIs = String(memberId);
    let memberToken = await memberTokenSchema.aggregate([
        {
            $match: {
                memberId: mongoose.Types.ObjectId(memberIdIs),
                fcmToken: { $exists: true }
            }
        },
        {
            $project: {
                memberId: 1,
                fcmToken: 1,
                DeviceType: 1
            }
        }
    ]);
    return memberToken;
};

async function getWatchmanToken(watchmanId){
    let watchmanIdIs = String(watchmanId);
    let getFcmToken = await watchmanTokenSchema.aggregate([
        {
            $match: {
                watchmanId: mongoose.Types.ObjectId(watchmanIdIs),
                fcmToken: { $exists: true }
            }
        }
    ]);

    return getFcmToken;
};

//Get member tokens 
async function getMemberFcmTokens(memberIdList){
    // console.log(memberIdList);
    let tokenAre = [];
    for(let i=0;i<memberIdList.length;i++){
    
        let memberIdIs = String(memberIdList[i]);

        let memberToken = await memberTokenSchema.aggregate([
            {
                $match: {
                    memberId: mongoose.Types.ObjectId(memberIdIs),
                    fcmToken: { $exists: true }
                }
            },
            {
                $project: {
                    memberId: 1,
                    fcmToken: 1,
                    DeviceType: 1
                }
            }
        ]);
        memberToken.forEach(dataIs=>{
            tokenAre.push(dataIs);
        });
    }
    
    return tokenAre;
};

async function getFlatMember(flatIdList){
    let flatMemberIds = [];
    for(let i=0;i<flatIdList.length;i++){
        let flatId = String(flatIdList[i]);
        let getMemberId = await flatSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(flatId)
                }
            }
        ]);

        if(getMemberId.length > 0){
            let members = getMemberId[0].memberIds;
            if(members.length >0){
                members.forEach(idIs => {
                    flatMemberIds.push(idIs);
                })
            }
        }
        
    }
    return flatMemberIds;
}

//Get Single member PlayerId 
async function getSingleMemberPlayerId(memberId){
    let memberIdIs = String(memberId);

    let memberToken = await memberTokenSchema.aggregate([
        {
            $match: {
                $and: [
                    { memberId: mongoose.Types.ObjectId(memberIdIs) },
                    { playerId: { $exists: true } },
                    { muteNotificationAudio: false }
                ]
            }
        },
        {
            $project: {
                memberId: 1,
                playerId: 1,
                DeviceType: 1,
                muteNotificationAudio: 1
            }
        }
    ]);
    return memberToken;
};

//Get multiple member PlayerIds 
async function getMemberPlayerId(memberIdList,senderId){
    // console.log(memberIdList);
    let PlayerId = [];
    for(let i=0;i<memberIdList.length;i++){
    
        let memberIdIs = String(memberIdList[i]);

        if(senderId != null && senderId != undefined && senderId != ""){
            
            if(memberIdIs != String(senderId)){
                
                let memberToken = await memberTokenSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { memberId: mongoose.Types.ObjectId(memberIdIs) },
                                { playerId: { $exists: true } },
                                { muteNotificationAudio: false }
                            ]
                        }
                    }
                ]);
                memberToken.forEach(dataIs=>{
                    PlayerId.push(dataIs);
                });
            }
        }else{
            let memberToken = await memberTokenSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { memberId: mongoose.Types.ObjectId(memberIdIs) },
                            { playerId: { $exists: true } },
                            { muteNotificationAudio: false }
                        ]
                    }
                }
            ]);
            memberToken.forEach(dataIs=>{
                PlayerId.push(dataIs);
            });
        }
    }
    
    return PlayerId;
};

//Get Single Watchman PlayerId
async function getSingleWatchmanPlayerId(watchmanId){
    let watchmanIdIs = String(watchmanId);
    let getFcmToken = await watchmanTokenSchema.aggregate([
        {
            $match: {
                watchmanId: mongoose.Types.ObjectId(watchmanIdIs),
                playerId: { $exists: true }
            }
        }
    ]);

    return getFcmToken;
};

//Get Multiple watchman PlayerIds
async function getWatchmanPlayerId(watchmanIdList){
    let watchmanTokenList = [];
    for(let i=0;i<watchmanIdList.length;i++){
        let watchmanIdIs = String(watchmanIdList[i]);
        let getFcmToken = await watchmanTokenSchema.aggregate([
            {
                $match: {
                    watchmanId: mongoose.Types.ObjectId(watchmanIdIs),
                    playerId: { $exists: true }
                }
            }
        ]);

        getFcmToken.forEach(dataIs=>{
            watchmanTokenList.push(dataIs)
        });
    };

    return watchmanTokenList;
};

function getWatchmanNumber(){
    let generateNo = "WATCHMEN-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getStaffNumber(){
    let generateNo = "STAFF-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getGuestNumber(){
    let generateNo = "GUEST-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getCurrentDateTime(){
    let date = moment()
            .tz("Asia/Calcutta")
            .format("DD/MM/YYYY,h:mm:ss a")
            .split(",")[0];

    let time = moment()
            .tz("Asia/Calcutta")
            .format("DD/MM/YYYY,h:mm:ss a")
            .split(",")[1];

    return [date,time];
}

function getCurrentDate(){
    let date = moment()
            .tz("Asia/Calcutta")
            .format("DD/MM/YYYY,h:mm:ss a")
            .split(",")[0];

    return date;
}

module.exports = router;