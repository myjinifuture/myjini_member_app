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
const fs = require('fs');
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
const staffCategorySchema = require('../models/staffCategory');
const guestCategorySchema = require('../models/guestCategory');
const guestEntrySchema = require('../models/guestEntry');
const watchmanSchema = require('../models/watchmanModel');
const watchmanTokenSchema = require('../models/watchmanToken');
const vendorSchema = require('../models/vendorModel');
const vendorCategorySchema = require('../models/vendorCategory');
const notificationSchema = require('../models/notificationContent');
const callingSchema = require('../models/CallingModel');
const advertisementSchema = require('../models/advertisementModel');
const adsPackageSchema = require('../models/adsPackage');
const areaSchema = require('../models/areaModel');
const staffEntrySchema = require('../models/staffEntry');
const pollingQuestionSchema = require('../models/pollingQuestion');
const pollingOptionsSchema = require('../models/pollingOptions');
const pollingAnswersSchema = require('../models/pollingAnswers');
const complainCategorySchema = require('../models/complainCategory');
const complainSchema = require('../models/complainModel');
const inviteGuestSchema = require('../models/inviteGuestModel');
const reminderCategorySchema = require('../models/reminderCategory');
const reminderSchema = require('../models/reminderModel');
const advertisePaymentSchema = require('../models/advertisePayments');
const unknownVisitorSchema = require('../models/unknownVisitor');
const plasmaDonarsSchema = require('../models/plasmaDonars');
const eventRegistrationSchema = require('../models/eventRegistration');
const societyEmergencyContactsSchema = require('../models/societyEmergencyContacts');
const memberSOSContactSchema = require('../models/memberSOSContacts');
const staffRatingSchema = require('../models/staffRatings');
const vendorRatingSchema = require('../models/vendorRatings');
const emergencyContactsSchema = require('../models/emergencyContacts');
const memberParcelSchema = require('../models/memberParcel');
const saleAndRentSchema = require('../models/saleAndRent');

const cron = require('node-cron');
const schedule = require('node-schedule');
const cronTime = require('cron-time-generator');
const alarm = require('alarm');

const { json } = require("express");
const { send } = require("process");
const { token } = require("morgan");
const e = require("express");
const { watch } = require("../models/stateModel");
const { isDate } = require("moment-timezone");
const emergencyContacts = require("../models/emergencyContacts");
const { resolveSoa } = require("dns");
// const { routes } = require("../app");

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

let memberImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/member");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let memberImg = multer({ storage: memberImgUploader });

let guestImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/guestEntry");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let guestImg = multer({ storage: guestImgUploader });

let vendorImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/vendor");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let vendorImg = multer({ storage: vendorImgUploader });

let advertiseImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/advertise");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let advertiseImg = multer({ storage: advertiseImgUploader });

let complainAttachmentUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/complainAttachment");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});

let complainAttachmentIs = multer({ storage: complainAttachmentUploader });

let reminderCategoryUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/reminderCategory");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});

let reminderCategoryIs = multer({ storage: reminderCategoryUploader });

//Get Society-----------------MONIL------29/03/2021
router.post("/getSocietyDetails",async function(req,res,next){
    try {
        const { societyCode , memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let updateMember = await memberSchema.findByIdAndUpdate(memberId,{ isOnCall: false });

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    societyCode: societyCode
                }
            },
            {
                $lookup: {
                    from: "states",
                    localField: "stateCode",
                    foreignField: "isoCode",
                    as: "State"
                }
            },
            {
                $project: {
                    "State.__v": 0,
                    "State.latitude": 0,
                    "State.longitude": 0
                }
            }
        ]);

        let getWings; 
        let getFlats;

        if(getSociety.length > 0){
            let societyId = getSociety[0]._id;

            getWings = await wingSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $project: {
                        wingName: 1
                    }
                }
            ]);

            if(getWings.length > 0){
                let wingIdIs = [];

                getWings.forEach(function(wing){
                    wingIdIs.push(wing._id)
                });
                
                getFlats = await flatSchema.aggregate([
                    {
                        $match: {
                            wingId: { $in: wingIdIs }
                        }
                    },
                    {
                        $project: {
                            flatNo: 1,
                            floorNo: 1,
                            wingId: 1
                        }
                    }
                ]);

                // console.log(getFlats);

                if(getFlats.length == 0){
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Wings only created, Please complete your society setup" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please complete your society setup" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

        let sendData = {
            Society : getSociety,
            Wings : getWings,
            Flats : getFlats,
        }
        return res.status(200).json({
            IsSuccess: true,
            Data: sendData,
            Message: "Society Wings and Flats Found"
        });
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Register Member-------------MONIL------28/03/2021
// ResidenceType - 0 Owner
// ResidenceType - 1 Closed
// ResidenceType - 2 Rent
// ResidenceType - 3 Dead
// ResidenceType - 4 Shop
router.post("/addMember",async function(req,res,next){
    try {
        const {
            Name,
            MobileNo,
            ResidenceType,
            Gender,
            societyCode,
            wingId,
            flatId,
            deviceType,
            NoOfFamilyMember,
            playerId
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkSociety = await societySchema.aggregate([
            {
                $match: {
                    societyCode: societyCode
                }
            }
        ]);

        if(checkSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No society found for societyCode ${societyCode}` });
        }

        let checkExistMember = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { ContactNo: MobileNo },
                        { society: { $elemMatch: { societyId: mongoose.Types.ObjectId(checkSociety[0]._id) } } }
                    ]
                }
            }
        ]);

        if(checkExistMember.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Member already register join to ${societyCode}` });
        }

        let societyId = checkSociety[0]._id;

        let checkMembersOfSociety = await memberSchema.aggregate([
            {
                $match: {
                    society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } }
                }
            }
        ]);

        let isAdmin = 0;
        let isVerify = false;

        if(checkMembersOfSociety.length == 0){
            isAdmin = 1,
            isVerify = true
        }

        let checkFlat = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { _id: mongoose.Types.ObjectId(flatId) },
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
                    memberIds: 1,
                    "WingData.wingName": 1,
                    parentMember: 1
                }
            }
        ]);

        if(checkFlat.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Flat found for flatId ${flatId}` });
        }
        let flatMember = checkFlat[0].memberIds;

        let checkMemberNumber = await memberSchema.aggregate([
            {
                $match: {
                    ContactNo: MobileNo
                }
            }
        ]);

        let societyAdminList = await getSocietyAdmin(societyId);

        let adminIds = [];

        societyAdminList.forEach(admin=>{
            adminIds.push(admin._id);
        });

        let memberTokens = await getMemberPlayerId(adminIds);

        if(checkMemberNumber.length == 1){

            let existMemberIdIs = checkMemberNumber[0]._id;

            let updateIs = {
                $push: {
                    society: {
                        societyId: societyId,
                        wingId: wingId,
                        flatId: flatId,
                        ResidenceType: Number(ResidenceType),
                        isAdmin: isAdmin,
                        isVerify: isVerify,
                    },
                }
            };

            let updateFlatIs;
                if(flatMember.length > 0){
                    // updateFlatIs = {
                    //     $push: {
                    //         memberIds: existMemberIdIs
                    //     } 
                    // }
                    let parentMemberId = checkFlat[0].parentMember;

                    let parentMemberToken = await getSingleMemberPlayerId(parentMemberId)

                    let titleIs = `${Name} Wants To Join As Your Family Member`;
                    let bodyIs = `Please approve if He/She is belongs to your family`;

                    let notiDataIs = {
                        notificationType : "JoinSociety",
                        MemberName: checkMemberNumber[0].Name,
                        MemberContactNo: checkMemberNumber[0].ContactNo,
                        MemberGender: checkMemberNumber[0].Gender,
                        WingNo: checkFlat[0].WingData[0].wingName,
                        FlatNo: checkFlat[0].flatNo,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    if(parentMemberToken.length > 0){
                        parentMemberToken.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "notification-_2_.wav"
                                };                    
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","IOS");
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                };                    
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","Android");
                            }
                            
                        });
                    }

                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Data: checkMemberNumber, 
                        Message: `Please Wait For Parent Member of ${notiDataIs.WingNo}-${notiDataIs.FlatNo} to Approval` 
                    });
                    
                }else{
                    updateFlatIs = {
                        $push: {
                            memberIds: existMemberIdIs,
                        },
                        residenceType: ResidenceType,
                        parentMember: existMemberIdIs 
                    }
                }
                
            let memberToFlat = await flatSchema.findByIdAndUpdate(flatId,updateFlatIs);

            let updateMemberSociety = await memberSchema.findByIdAndUpdate(existMemberIdIs,updateIs);

            let getMember = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(existMemberIdIs)
                    }
                }
            ]);

            if(memberTokens.length > 0){
                let titleIs = `New Member Join To The Society`;
                let bodyIs = `New Member Join To Wing ${checkFlat[0].WingData[0].wingName} & FlatNo is ${checkFlat[0].flatNo}`;

                let notiDataIs = {
                    notificationType : "JoinSociety",
                    MemberName: getMember[0].Name,
                    MemberContactNo: getMember[0].ContactNo,
                    MemberGender: getMember[0].Gender,
                    WingNo: checkFlat[0].WingData[0].wingName,
                    FlatNo: checkFlat[0].flatNo,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.DeviceType == "IOS"){
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            ios_sound: "notification-_2_.wav"
                        };                    
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","IOS");
                    }else{
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                        };                    
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","Android");
                    }
                });
            }
            return res.status(200).json({ IsSuccess: true , Data: getMember , Message: `Exist Member Added to new society ${societyCode}` });
        }else if(checkMemberNumber.length == 0){
            let addMember = await new memberSchema({
                Name: Name.toUpperCase(),
                ContactNo: MobileNo,
                Gender: Gender,
                society: {
                    societyId: societyId,
                    wingId: wingId,
                    flatId: flatId,
                    ResidenceType: Number(ResidenceType),
                    isAdmin: isAdmin,
                    isVerify: isVerify
                },
                DeviceType: deviceType,
                NoOfFamilyMember: NoOfFamilyMember,
                MemberNo: getMemberCodeNumber(),
            });
    
            if(addMember != null){
                try {
                    await addMember.save();    
                } catch (error) {
                    res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                let updateIs;
                if(flatMember.length > 0){
                    // updateIs = {
                    //     $push: {
                    //         memberIds: addMember._id
                    //     } 
                    // }
                    let parentMemberId = checkFlat[0].parentMember;

                    let parentMemberToken = await getSingleMemberPlayerId(parentMemberId)

                    let titleIs = `${Name} Wants To Join As Your Family Member`;
                    let bodyIs = `Please approve if He/She is belongs to your family`;

                    let notiDataIs = {
                        notificationType : "JoinSociety",
                        MemberName: Name,
                        MemberContactNo: MobileNo,
                        MemberGender: Gender,
                        WingNo: checkFlat[0].WingData[0].wingName,
                        FlatNo: checkFlat[0].flatNo,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    if(parentMemberToken.length > 0){
                        parentMemberToken.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    ios_sound: "notification-_2_.wav"
                                };                    
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","IOS");
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                                };                    
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","Android");
                            }
                        });
                    }

                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Data: [addMember], 
                        Message: `Please Wait For Parent Member of ${notiDataIs.WingNo}-${notiDataIs.FlatNo}  Approval` 
                    });
                }else{
                    updateIs = {
                        residenceType: ResidenceType,
                        $push: {
                            memberIds: addMember._id,
                        },
                        parentMember: addMember._id 
                    }
                }
                
                let memberToFlat = await flatSchema.findByIdAndUpdate(flatId,updateIs);

                if(memberTokens.length > 0){
                    let titleIs = `New Member Join To The Society`;
                    let bodyIs = `New Member Join To Wing ${checkFlat[0].WingData[0].wingName} & FlatNo is ${checkFlat[0].flatNo}`;
    
                    let notiDataIs = {
                        notificationType : "JoinSociety",
                        MemberName: Name.toUpperCase(),
                        MemberContactNo: MobileNo,
                        MemberGender: Gender,
                        WingNo: checkFlat[0].WingData[0].wingName,
                        FlatNo: checkFlat[0].flatNo,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
    
                    memberTokens.forEach(tokenIs=>{
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "notification-_2_.wav"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","IOS");
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety","Android");
                        }
                    });
                }
                res.status(200).json({ IsSuccess: true , Data: [addMember] , Message: "Member Added" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "Member Not Added" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Member Already exist with this Contact Number" });
        }
 
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Pending Approval Family Member List----------------MONIL--------------07/05/2021
router.post("/getMyFamilyMembers",async function(req,res,next){
    const { societyId , wingId , flatId , memberId } = req.body;

    let authToken = req.headers['authorization'];
        
    if(authToken != config.tokenIs || authToken == null || authToken == undefined){
        return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
    }

    let getMember = await memberSchema.aggregate([
        {
            $unwind: "$society"
        },
        {
            $match: {
                $and: [
                    { "society.societyId": mongoose.Types.ObjectId(societyId) },
                    { "society.wingId": mongoose.Types.ObjectId(wingId) },
                    { "society.flatId": mongoose.Types.ObjectId(flatId) },
                    { isVerify: false }
                ]
            }
        }
    ]);

    if(getMember.length > 0){
        return res.status(200).json({ IsSuccess: true , Data: getMember , Message: "Pending For Approval Family Member Found" });
    }else{
        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Pending For Approval Family Member Found" });
    }
});

//Approval Of Family Member----------------MONIL--------------07/05/2021
router.post("/approvalOfFamilyMember",async function(req,res,next){
    const { societyId , wingId , flatId , memberId , isVerify } = req.body;

    let authToken = req.headers['authorization'];
        
    if(authToken != config.tokenIs || authToken == null || authToken == undefined){
        return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
    }

    let getMember = await memberSchema.aggregate([
        {
            $match: {
                $and: [
                    { _id: mongoose.Types.ObjectId(memberId) },
                    { 
                        society: {
                            $elemMatch: {
                                societyId: mongoose.Types.ObjectId(societyId),
                                wingId: mongoose.Types.ObjectId(wingId),
                                flatId: mongoose.Types.ObjectId(flatId),
                                isVerify: false
                            }
                        } 
                    },
                ]
            }
        }
    ]);

    if(getMember.length == 1){
        if(isVerify == true){
            let updateMember = await memberSchema.updateOne(
                { _id : mongoose.Types.ObjectId(memberId) },
                { 
                    $set: { 
                        "society.$[i].isVerify" : true, 
                        "society.$[i].isAdmin" : 0, 
                        "society.$[i].societyId" : societyId, 
                        "society.$[i].wingId" : wingId, 
                        "society.$[i].flatId" : flatId, 
                    } 
                },
                {
                    multi: true,
                    arrayFilters: [ 
                        { 
                            "i.societyId": mongoose.Types.ObjectId(societyId)
                        } 
                    ]
                }
            )
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Your Family Member Approved" });
        }else if(isVerify == false){
            let memberSociety = getMember[0].society;

            if(memberSociety.length == 1){
                let removeMember = await memberSchema.findByIdAndDelete(memberId);
                let removeFromFlat = await flatSchema.updateMany(
                    {},
                    { 
                        $pull: { 
                            memberIds: mongoose.Types.ObjectId(memberId) 
                        }
                    },
                    { multi: true }
                );

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Member and its flat removed with id ${flatId}` });
            }else{
                let removeMemberProperty = await memberSchema.updateOne(
                    {
                        _id: mongoose.Types.ObjectId(memberId)
                    },
                    { 
                        $pull: { 
                            society: {
                                societyId: societyId,
                                wingId: wingId,
                                flatId: flatId
                            }
                        }
                    },
                    { multi: true }
                );

                let removeFromFlat = await flatSchema.updateOne(
                    {
                        _id: mongoose.Types.ObjectId(flatId)
                    },
                    { 
                        $pull: { 
                            memberId: mongoose.Types.ObjectId(memberId) 
                        }
                    },
                    { multi: true }
                );

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `From Member properties flat removed with id ${flatId}` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "Please Pass true or false to isVerify field" });
        }
    }else{
        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Pending For Approval Family Member Found" });
    }
});

//Get Member Role--------------MONIL----------01/04/2021
router.post("/getMemberRole",async function(req,res,next){
    try {
        const { memberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMember = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(memberId) },
                        {  "society.societyId": mongoose.Types.ObjectId(societyId) }
                    ]
                }
            },
            {
                $project: {
                    Name: 1,
                    society: 1,
                    ContactNo: 1,
                    MemberNo: 1,
                    Image: 1,
                }
            }
        ]);

        if(getMember.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getMember , Message: `Member Role Found` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Member Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Check Member Society--------MONIL------------28/03/2021
router.post("/getMemberSociety",async function(req,res,next){
    try {
        const { MobileNo } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberSociety = await memberSchema.aggregate([
            {
                $match: {
                    ContactNo: MobileNo
                }
            },
            {
                $unwind: "$society"
            },
            {
                $lookup: {
                    from: "societies",
                    localField: "society.societyId",
                    foreignField: "_id",
                    as: "SocietyData"
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "society.wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "society.flatId",
                    foreignField: "_id",
                    as: "FlatData"
                }
            },
            {
                $project: {
                    MemberNo: 1,
                    Gender: 1,
                    Name: 1,
                    ContactNo: 1,
                    "SocietyData.Name": 1,
                    "SocietyData._id": 1,
                    "SocietyData.ContactPerson": 1,
                    "SocietyData.ContactMobile": 1,
                    "SocietyData.Email": 1,
                    "SocietyData.NoOfWing": 1,
                    "SocietyData.stateCode": 1,
                    "SocietyData.city": 1,
                    "SocietyData.IsActive": 1,  
                    "SocietyData.Address": 1,  
                    "SocietyData.societyCode": 1,  
                    "SocietyData.Address": 1,  
                    "WingData.wingName": 1,
                    "FlatData.flatNo": 1,
                    "FlatData.residenceType": 1,
                }
            }
        ]);

        if(getMemberSociety.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getMemberSociety.length , Data: getMemberSociety , Message: "Member Society Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Society Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Member Login----------------MONIL------------28/03/2021
router.post("/login",async function(req,res,next){
    try {
        const { MobileNo , playerId , DeviceType , societyId , IMEI } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        
        // if(!DeviceType){
        //     return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide Valid Device Type like Android or IOS" })
        // }

        let getMember;

        if(societyId != undefined && societyId != ""){
            getMember = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { ContactNo: MobileNo },
                            { "society.isVerify": true },
                            { "society.societyId" : mongoose.Types.ObjectId(societyId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "societies",
                        localField: "society.societyId",
                        foreignField: "_id",
                        as: "SocietyData"
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
            ]);
        }else{
            getMember = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { ContactNo: MobileNo }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "societies",
                        localField: "society.societyId",
                        foreignField: "_id",
                        as: "SocietyData"
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
            ]);
        }
        
        if(getMember.length == 1){
            let memberId = getMember[0]._id;
            let isAdmin = getMember[0].society.isAdmin;
            // let checkMemberToken = await memberTokenSchema.aggregate([
            //     {
            //         $match: {
            //             IMEI: String(IMEI)
            //         }
            //     }
            // ]);
            
            // if(checkMemberToken.length == 0){
            //     let addMemberToken = await new memberTokenSchema({
            //         memberId: memberId,
            //         mobileNo: String(MobileNo),
            //         playerId: String(playerId),
            //         DeviceType: String(DeviceType),
            //         IMEI: String(IMEI),
            //         isAdmin: Number(isAdmin)
            //     });
            //     if(addMemberToken != null){
            //         addMemberToken.save();
            //     }
            // }else{
            //     let update = {
            //         memberId: memberId,
            //         mobileNo: MobileNo,
            //         playerId: String(playerId),
            //         DeviceType: DeviceType
            //     }
            //     let tokenId = checkMemberToken[0]._id;
            //     let updateMemberToken = await memberTokenSchema.findByIdAndUpdate(tokenId,update);

            // }

            let updateMember = await memberSchema.findByIdAndUpdate(memberId,{ DeviceType: DeviceType });
            res.status(200).json({ IsSuccess: true , Data: getMember , Message: "Member LoggedIn" });

        }else{
            res.status(200).json({ IsSuccess: true , Data: getMember , Message: `Wait for admin approval if you are register`});
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Member Token------------MONIL----------26/04/2021
router.post("/updateMemberPlayerId",async function(req,res,next){
    try {
        const { MobileNo , playerId , DeviceType , IMEI , memberId , isAdmin } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkMemberToken = await memberTokenSchema.aggregate([
            {
                $match: {
                    IMEI: String(IMEI)
                }
            }
        ]);
        
        if(checkMemberToken.length == 0){
            let addMemberToken = await new memberTokenSchema({
                memberId: memberId,
                mobileNo: String(MobileNo),
                playerId: String(playerId),
                DeviceType: String(DeviceType),
                IMEI: String(IMEI),
                isAdmin: Number(isAdmin)
            });
            if(addMemberToken != null){
                try {
                    addMemberToken.save();
                } catch (error) {
                    res.status(500).json({ IsSuccess: false , Message: error.message });
                }
            }

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Member PlayerId Added` });
        }else{
            let update = {
                memberId: memberId,
                mobileNo: MobileNo,
                playerId: String(playerId),
                DeviceType: DeviceType
            }
            let tokenId = checkMemberToken[0]._id;
            let updateMemberToken = await memberTokenSchema.findByIdAndUpdate(tokenId,update);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Member PlayerId Updated` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add new Flat/Villa-------------MONIL-----------08/04/2021
// 0 Owner
// 1 Closed
// 2 Rent
// 3 Dead
// 4 Shop
router.post("/joinToSociety",async function(req,res,next){
    try {

        const { memberId , societyId , wingId , flatId , residenceType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkMember = await memberSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId)
                }
            },
            {
                $project: {
                    MemberNo: 1,
                    society: 1,
                    Name: 1,
                    ContactNo: 1,
                    Gender: 1
                }
            }
        ]);

        if(checkMember.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Found" });
        }

        let checkFlat = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(flatId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { societyId: mongoose.Types.ObjectId(societyId) }
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
            }
        ]);

        if(checkFlat.length == 0){
            return res.status(200).json({
                IsSuccess: true,
                Data: [],
                Message: `No Flat found for flatId ${flatId} , wingId ${wingId} & societyId ${societyId}`
            });
        }

        let checkSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(checkSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

        let memberSociety = checkMember[0].society;

        if(memberSociety.length > 0){
            let checkAlreadyJoin = await memberSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(memberId) },
                            { society: { $elemMatch: {
                                societyId: mongoose.Types.ObjectId(societyId),
                                wingId: mongoose.Types.ObjectId(wingId),
                                flatId: mongoose.Types.ObjectId(flatId),
                            } } }
                        ]
                    }
                }
            ]);

            if(checkAlreadyJoin.length == 1){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Member Already Join to this flat of society" });
            }

            let updateFlat = {
                residenceType: Number(residenceType),
                $push: {
                    memberIds: memberId
                }
            };

            let checkSocietyMember = await memberSchema.aggregate([
                {
                    $match: {
                        society: {
                            $elemMatch: {
                                societyId: mongoose.Types.ObjectId(societyId)
                            }
                        }
                    }
                }
            ]);

            if(checkSocietyMember.length == 0){
                //Member Join As a Admin To The Society
                let update = {
                    $push: {
                        society: {
                            societyId: societyId,
                            wingId: wingId,
                            flatId: flatId,
                            ResidenceType: Number(residenceType),
                            isVerify: true,
                            isAdmin: 1,
                        }
                    }
                }

                let updateMember = await memberSchema.findByIdAndUpdate(memberId,update);
                let updateFlatIs = await flatSchema.findByIdAndUpdate(flatId,updateFlat);

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Join as admin to the society" });
            }else{
                //Member Join To The Society

                let update = {
                    $push: {
                        society: {
                            societyId: societyId,
                            wingId: wingId,
                            flatId: flatId,
                            ResidenceType: Number(residenceType),
                            isVerify: true,
                            isAdmin: 0,
                        }
                    }
                }

                let updateMember = await memberSchema.findByIdAndUpdate(memberId,update);
                let updateFlatIs = await flatSchema.findByIdAndUpdate(flatId,updateFlat);

                let societyAdminList = await getSocietyAdmin(societyId);

                let adminIds = [];

                societyAdminList.forEach(admin=>{
                    adminIds.push(admin._id);
                });

                let memberTokens = await getMemberPlayerId(adminIds);

                if(memberTokens.length > 0){
                    let titleIs = `New Member Join To The Society`;
                    let bodyIs = `New Member Join To Wing ${checkFlat[0].WingData[0].wingName} & FlatNo is ${checkFlat[0].flatNo}`;

                    let notiDataIs = {
                        notificationType : "JoinSociety",
                        MemberName: checkMember[0].Name,
                        MemberContactNo: checkMember[0].ContactNo,
                        MemberGender: checkMember[0].Gender,
                        WingNo: checkFlat[0].WingData[0].wingName,
                        FlatNo: checkFlat[0].flatNo,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    memberTokens.forEach(tokenIs=>{
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "notification-_2_.wav"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety",tokenIs.DeviceType);
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety",tokenIs.DeviceType);
                        }
                        // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,null,"JoinSociety");
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Join to the society" });
            }
        }else{
            
            let updateFlat = {
                residenceType: Number(residenceType),
                $push: {
                    memberIds: memberId
                }
            };

            let checkSocietyMember = await memberSchema.aggregate([
                {
                    $match: {
                        society: {
                            $elemMatch: {
                                societyId: mongoose.Types.ObjectId(societyId)
                            }
                        }
                    }
                }
            ]);

            if(checkSocietyMember.length == 0){
                //Member Join As Admin To The Society
                let update = {
                    $push: {
                        society: {
                            societyId: societyId,
                            wingId: wingId,
                            flatId: flatId,
                            ResidenceType: Number(residenceType),
                            isVerify: true,
                            isAdmin: 1,
                        }
                    }
                }

                let updateMember = await memberSchema.findByIdAndUpdate(memberId,update);
                let updateFlatIs = await flatSchema.findByIdAndUpdate(flatId,updateFlat);

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Join as admin to the society" });
            }else{
                //Member Join To The Society

                let update = {
                    $push: {
                        society: {
                            societyId: societyId,
                            wingId: wingId,
                            flatId: flatId,
                            ResidenceType: Number(residenceType),
                            isVerify: true,
                            isAdmin: 0,
                        }
                    }
                }
                
                let updateMember = await memberSchema.findByIdAndUpdate(memberId,update);
                let updateFlatIs = await flatSchema.findByIdAndUpdate(flatId,updateFlat);

                let societyAdminList = await getSocietyAdmin(societyId);

                let adminIds = [];

                societyAdminList.forEach(admin=>{
                    adminIds.push(admin._id);
                });

                let memberTokens = await getMemberPlayerId(adminIds);

                if(memberTokens.length > 0){
                    let titleIs = `New Member Join To The Society`;
                    let bodyIs = `New Member Join To Wing ${checkFlat[0].WingData[0].wingName} & FlatNo is ${checkFlat[0].flatNo}`;

                    let notiDataIs = {
                        notificationType : "JoinSociety",
                        MemberName: checkMember[0].Name,
                        MemberContactNo: checkMember[0].ContactNo,
                        MemberGender: checkMember[0].Gender,
                        WingNo: checkFlat[0].WingData[0].wingName,
                        FlatNo: checkFlat[0].flatNo,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    memberTokens.forEach(tokenIs=>{
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "notification-_2_.wav"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety",tokenIs.DeviceType);
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                            };                    
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,null,"JoinSociety",tokenIs.DeviceType);
                        }
                        // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,null,"JoinSociety");
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Join to the society" });
            }
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Member Profile----------MONIL-----------04/04/2021
router.post("/updateMemberProfile", memberImg.single("Image") ,async function(req,res,next){
    try {
        const {
            Address,
            WorkType,
            DateOfRentAggrement,
            CompanyName,
            Designation,
            DOB,
            BusinessDescription,
            Relation,
            BloodGroup,
            EmailId,
            NoOfFamilyMember,
            Township,
            OfficeEmail,
            OfficeContact,
            OfficeAlternateNo,
            OfficeAddress,
            Name,
            memberId,
            AnniversaryDate
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let checkMember = await memberSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId)
                }
            }
        ]);

        if(checkMember.length == 1){
            let update = {
                Address : Address == undefined || "" ?  checkMember[0].Address : Address,
                WorkType: WorkType == undefined || "" ?  checkMember[0].WorkType : WorkType,
                DateOfRentAggrement: DateOfRentAggrement == undefined || "" ?  checkMember[0].DateOfRentAggrement : DateOfRentAggrement,
                CompanyName: CompanyName == undefined || "" ?  checkMember[0].CompanyName : CompanyName,
                Designation: Designation == undefined || "" ?  checkMember[0].Designation : Designation,
                DOB: DOB == undefined || "" ?  checkMember[0].DOB : DOB,
                BusinessDescription: BusinessDescription == undefined || "" ?  checkMember[0].BusinessDescription : BusinessDescription,
                Relation: Relation == undefined || "" ?  checkMember[0].Relation : Relation,
                BloodGroup: BloodGroup == undefined || "" ?  checkMember[0].BloodGroup : BloodGroup,
                EmailId: EmailId == undefined || "" ?  checkMember[0].EmailId : EmailId,
                NoOfFamilyMember: NoOfFamilyMember == undefined || "" ?  checkMember[0].NoOfFamilyMember : NoOfFamilyMember,
                Township: Township == undefined || "" ?  checkMember[0].Township : Township,
                OfficeEmail: OfficeEmail == undefined || "" ?  checkMember[0].OfficeEmail : OfficeEmail,
                OfficeContact: OfficeContact == undefined || "" ?  checkMember[0].OfficeContact : OfficeContact,
                OfficeAlternateNo: OfficeAlternateNo == undefined || "" ?  checkMember[0].OfficeAlternateNo : OfficeAlternateNo,
                OfficeAddress: OfficeAddress == undefined || "" ?  checkMember[0].OfficeAddress : OfficeAddress,
                Name: Name == undefined || "" ?  checkMember[0].Name : Name,
                Image: file == undefined || "" ? checkMember[0].Image : file.path,
                AnniversaryDate: AnniversaryDate != undefined ? AnniversaryDate : ""
            }

            let updateMemberDataIs = await memberSchema.findByIdAndUpdate(memberId,update);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Data Updated" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Member Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Member Profile-Image------------MONIL---------30/04/2021
router.post("/updateMemberProfileImage",async function(req,res,next){
    try {
        const { memberId , Image } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const path = 'uploads/member/'+'member_profile_'+Date.now()+'.png'
            
        const base64Data = Image.replace(/^data:([A-Za-z-+/]+);base64,/, '');
    
        fs.writeFileSync(path, base64Data,  {encoding: 'base64'});

        let getMember = await memberSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId)
                }
            }
        ]);

        if(getMember.length == 1){
            let deletePreviousProfile = await deleteFile(getMember[0].Image);
            let update = {
                Image: path
            }

            let memberUpdate = await memberSchema.findByIdAndUpdate(memberId,update);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Profile Updated" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Member Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Family Member--------------MONIL-----------28/03/2021
router.post("/addFamilyMember",async function(req,res,next){
    try {
        const { Name , ContactNo , Gender , parentId , Relation , societyId , wingId , flatId , Address } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let existParent = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(parentId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.wingId": mongoose.Types.ObjectId(wingId) },
                        { "society.flatId": mongoose.Types.ObjectId(flatId) },
                    ]
                }
            },
            {
                $project: {
                    MemberNo: 1,
                    Name: 1,
                    ContactNo: 1,
                    society: 1,
                }
            }
        ]);

        if(existParent.length == 1){
            let addMember = await new memberSchema({
                Name: Name,
                ContactNo: ContactNo,
                Gender: Gender,
                parentId: parentId,
                Relation: Relation,
                society: {
                    societyId: societyId,
                    wingId: wingId,
                    flatId: flatId,
                    ResidenceType: existParent[0].society.ResidenceType,
                    isAdmin: 0
                },
                Address: Address,
                MemberNo: getMemberCodeNumber(),
            });
            if(addMember != null){
                addMember.save();
                let updateInFlat = {
                    $push: {
                        memberIds: addMember._id
                    }
                }
                let updateInFlatIs = await flatSchema.findByIdAndUpdate(flatId,updateInFlat);
                res.status(200).json({ IsSuccess: true , Data: [addMember] , Message: "Family Member Added" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "Family member not added" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Parent Member Not Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Family Members-----------MONIL-------------28/03/2021
router.post("/getFamilyMembers",async function(req,res,next){
    try {
        const { societyId , wingId , flatId } = req.body;

        let getFlat = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { _id: mongoose.Types.ObjectId(flatId) }
                    ]
                }
            }
        ]);

        if(getFlat.length == 1){
            let memberIds = getFlat[0].memberIds;
            if(memberIds.length > 0){
                let familyMembers = await memberSchema.aggregate([
                    {
                        $match: {
                            _id: { $in: memberIds } 
                        }
                    },
                    {
                        $lookup: {
                            from: "membertokens",
                            localField: "_id",
                            foreignField: "memberId",
                            as: "fcmTokens"
                        }
                    }
                ]);
                if(familyMembers.length > 0){
                    return res.status(200).json({ IsSuccess: true , Count: familyMembers.length , Data: familyMembers , Message: "Family member found" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Family member found" });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Family member found" });
            }
        }else{
            res.status(200).json({ IsSuccess: true, Data: [] , Message: "No Flat Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Member Resources---------MONIL--------------28/03/2021
router.post("/addStaff", staffImg.single("staffImage") ,async function(req,res,next){
    try {

        const {
            wingId,
            flatId,
            Name, 
            ContactNo1,
            Address,
            staffCategory,
            societyId,
            Gender,
            watchmanId,
            // identityProof,
            // workLocation,
            AadharcardNo,
            VoterId,
            DateOfBirth,
            DateOfJoin,
            RecruitType,
            AgencyName,
            EmergencyContactNo,
            VehicleNo,
            isForSociety,
            Work
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        const file = req.file;

        let flatInfo = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(flatId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                    ]
                }
            }
        ]);

        let checkExist = await  staffSchema.aggregate([
            {
                $match: {
                    $and: [
                        { Name: Name.toUpperCase() },            
                        { ContactNo1: ContactNo1 },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);
        
        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff With this details already exist in society" });
        }

        if(staffCategory == "Watchmen"){

            let checkExist = await watchmanSchema.aggregate([
                {
                    $match: {
                        ContactNo1: ContactNo1
                    }
                }
            ]);

            if(checkExist.length == 1){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Watchman Already exist with ${ContactNo1} this number` });
            }

            let addWatchmen = await new watchmanSchema({
                Name: Name.toUpperCase(),
                ContactNo1: ContactNo1,
                Gender: Gender,
                Address: Address,
                watchmanNo: getWatchmanNumber(),
                societyId: societyId,
                wingId: wingId,
                AadharcardNo: AadharcardNo,
                VoterId: VoterId,
                DateOfBirth: DateOfBirth,
                DateOfJoin: DateOfJoin != undefined ? DateOfJoin : getCurrentDate(),
                RecruitType: RecruitType,
                AgencyName: AgencyName,
                EmergencyContactNo: EmergencyContactNo,
                VehicleNo: VehicleNo,
                Work: Work,
                isForSociety: isForSociety,
            });
            if(addWatchmen != null){
                addWatchmen.save();
                return res.status(200).json({ IsSuccess: true , Data: [addWatchmen] , Message: "Watchmen Added" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [addWatchmen] , Message: "No Watchmen Added" });
            }
        }else{

            let addStaffIs = await new staffSchema({
                Name: Name,
                ContactNo1: ContactNo1,
                Gender: Gender,
                Address: Address,
                staffCategory: staffCategory,
                societyId: societyId,
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
                Work: Work,
                isForSociety: isForSociety,
            });
    
            if(addStaffIs != null){
                addStaffIs.save();
                res.status(200).json({ IsSuccess: true , Data: [addStaffIs] , Message: "Staff Added" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Not Added" });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Staff Work Location---------MONIL-----07/04/2021
router.post("/addStaffWorkLocation",async function(req,res,next){
    try {
        const { workLocation , staffId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaff = await staffSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(staffId)
                }
            }
        ]);

        if(getStaff.length == 1){
            let updateIs = {
                $push: {
                    workingLocation: workLocation
                }
            }

            let updateStaffWorkLocationIs = await staffSchema.findByIdAndUpdate(staffId,updateIs);

            let flatIdList = [];
            workLocation.forEach(flat=>{
                flatIdList.push(flat.flatId);
            });

            // console.log(flatIdList)
            let getMembers = await getMemberOfFlat(flatIdList);

            let memberTokens = await getMemberPlayerId(getMembers);

            // console.log(memberTokens);

            if(memberTokens.length > 0){
                let titleIs = `New Staff Added to your flat`;
                let bodyIs = `StaffName: ${getStaff[0].Name} , StaffContactNo: ${getStaff[0].ContactNo1}`;

                let notiDataIs = {
                    notificationType: "AddStaff",
                    Message: `New Staff Added to your flat`,
                    StaffName: getStaff[0].Name,
                    StaffContactNo: getStaff[0].ContactNo1,
                    StaffAddress: getStaff[0].Address,
                    StaffentryNo: getStaff[0].entryNo,
                    StaffImage: getStaff[0].staffImage,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }
                let watchmanId = getStaff[0].watchmanId;
                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.muteNotificationAudio == false){
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "notification-_2_.wav"
                            };                    
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"AddStaff",tokenIs.DeviceType);
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                            };                    
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"AddStaff",tokenIs.DeviceType);
                        }
                    }
                    
                    // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,watchmanId,"AddStaff",tokenIs.DeviceType)
                });
            }
    
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Staff Worklocation Added" });

        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Staff Data-----------MONIL-------------29/03/2021

//Get Member Resources--------MONIL--------------29/03/2021
router.post("/getMemberResources",async function(req,res,next){
    try {
        const { societyId , flatId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaffOfFlat = await staffSchema.aggregate([
            {
                $match: {
                    $and: [
                        { 
                            workingLocation: {
                                $elemMatch: {
                                    wingId: mongoose.Types.ObjectId(wingId),
                                    flatId: mongoose.Types.ObjectId(flatId)
                                }
                            } 
                        },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { isForSociety: false }
                    ]
                }
            },
            {
                $lookup: {
                    from: "staffcategories",
                    localField: "staffCategoryId",
                    foreignField: "_id",
                    as: "StaffCategory"
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
            {
                $lookup: {
                    from: "identityproofs",
                    localField: "identityProof",
                    foreignField: "_id",
                    as: "IdentityProofs"
                }
            },
            {
                $project: {
                    __v: 0,
                    staffCategoryId: 0,
                    workingLocation: 0,
                    identityProof: 0,
                    "StaffCategory.__v": 0,
                    "WingData.totalFloor": 0,
                    "WingData.maxFlatPerFloor": 0,
                    "WingData.societyId": 0,
                    "WingData.__v": 0,
                    "FlatData.parkingSlotNo": 0,
                    "FlatData.societyId": 0,
                    "FlatData.wingId": 0,
                    "FlatData.__v": 0,
                    "IdentityProofs.__v": 0,
                }
            }
        ]);

        if(getStaffOfFlat.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getStaffOfFlat , Message: "Staff Data Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Data Not Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Staff Entry------------------MONIL----------------06/05/2021
router.post("/getMemberStaffEntry",async function(req,res,next){
    try {
        const { flatId , societyId , wingId , staffId , isMaid , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let wingLookup = {
            from: "wings",
            localField: "workingLocation.wingId",
            foreignField: "_id",
            as: "WingData"
        }

        let flatLookup = {
            from: "flats",
            localField: "workingLocation.flatId",
            foreignField: "_id",
            as: "FlatData"
        }

        let entryLookup = {
            from: "staffentries",
            localField: "_id",
            foreignField: "staffId",
            as: "EntryData"
        }

        let projectData = {
            Name: 1,
            ContactNo1: 1,
            Gender: 1,
            staffCategory: 1,
            staffImage: 1,
            "EntryData.inDateTime": 1,
            "EntryData.outDateTime": 1,
            "EntryData.vehicleNo": 1,
            "WingData.wingName": 1,
            "FlatData.flatNo": 1,
        }

        let staffCategoryQuery;

        if(isMaid == true){
            staffCategoryQuery = "Maid"
        }else{
            staffCategoryQuery = { $ne: "Maid" }
        }
        
        if(staffId != undefined && staffId != null && staffId != "" && societyId != undefined && societyId != null && societyId != ""){
            let getStaffEntry = await staffSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(staffId) },
                            { staffCategory: staffCategoryQuery },
                            { societyId: mongoose.Types.ObjectId(societyId) }
                        ]
                    }
                },
                {
                    $lookup: wingLookup
                },
                {
                    $lookup: flatLookup
                },
                {
                    $lookup: entryLookup
                },
                {
                    $unwind: "$EntryData"
                },
                {
                    $project: projectData
                }
            ]);

            if(getStaffEntry.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getStaffEntry.length, 
                    Data: getStaffEntry, 
                    Message: "Staff Entry Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Entry Found" });
            }
        }else{
            if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
                let dates = generateDateList(fromDate,toDate);

                let getStaffEntry = await staffSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { staffCategory: staffCategoryQuery },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                {
                                    workingLocation: {
                                        $elemMatch: {
                                            wingId: mongoose.Types.ObjectId(wingId),
                                            flatId: mongoose.Types.ObjectId(flatId)
                                        }
                                    }
                                },
                            ]
                        }
                    },
                    {
                        $lookup: wingLookup
                    },
                    {
                        $lookup: flatLookup
                    },
                    {
                        $lookup: entryLookup
                    },
                    {
                        $unwind: "$EntryData"
                    },
                    {
                        $match: {
                            "EntryData.inDateTime.0": { $in: dates }
                        }
                    },
                    {
                        $project: projectData
                    }
                ]);
    
                if(getStaffEntry.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getStaffEntry.length, 
                        Data: getStaffEntry, 
                        Message: `Staff Entry Found For Date ${fromDate} to ${toDate}` 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Entry Found" });
                }
            }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
                let getStaffEntry = await staffSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { staffCategory: staffCategoryQuery },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                {
                                    workingLocation: {
                                        $elemMatch: {
                                            wingId: mongoose.Types.ObjectId(wingId),
                                            flatId: mongoose.Types.ObjectId(flatId)
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        $lookup: wingLookup
                    },
                    {
                        $lookup: flatLookup
                    },
                    {
                        $lookup: entryLookup
                    },
                    {
                        $unwind: "$EntryData"
                    },
                    {
                        $match: {
                            "EntryData.inDateTime.0": toDate
                        }
                    },
                    {
                        $project: projectData
                    }
                ]);
    
                if(getStaffEntry.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getStaffEntry.length, 
                        Data: getStaffEntry, 
                        Message: `Staff Entry Found For Date ${toDate}` 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Entry Found" });
                }
            }else{
                let getStaffEntry = await staffSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { staffCategory: staffCategoryQuery },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                {
                                    workingLocation: {
                                        $elemMatch: {
                                            wingId: mongoose.Types.ObjectId(wingId),
                                            flatId: mongoose.Types.ObjectId(flatId)
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    {
                        $lookup: wingLookup
                    },
                    {
                        $lookup: flatLookup
                    },
                    {
                        $lookup: entryLookup
                    },
                    {
                        $unwind: "$EntryData"
                    },
                    {
                        $project: projectData
                    }
                ]);
    
                if(getStaffEntry.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getStaffEntry.length, 
                        Data: getStaffEntry, 
                        Message: `Staff Entry Found` 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Entry Found" });
                }
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Vehicle-----------------MONIL---------------28/03/2021
router.post("/addMemberVehicles",async function(req,res,next){
    try {
        const { memberId , vehiclesNoList } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistMember = await memberSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId)
                }
            }
        ]);

        if(checkExistMember.length == 1){
            vehiclesNoList.forEach(async function(Vehicle){
                let update = {
                    $push: {
                        Vehicles: {
                            vehicleType: Vehicle.vehicleType,
                            vehicleNo: Vehicle.vehicleNo,
                        }
                    }
                }
                let updateMemberVehicles = await memberSchema.findByIdAndUpdate(memberId,update);
            });
            
            res.status(200).json({ IsSuccess: true , Data: vehiclesNoList , Message: `Vehicles No ${vehiclesNoList} Added` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Member found for memberId ${memberId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Vehicles------------------MONIL--------29/03/2021
router.post("/getMemberVehicles",async function(req,res,next){
    try {
        const { memberId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistMember = await memberSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId),
                    Vehicles: { $exists: true }
                }
            },
            {
                $project: {
                    Vehicles: 1
                }
            }
        ]);

        if(checkExistMember.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: checkExistMember , Message: "Member Vehicles Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No MemberFound for memberId ${memberId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Member Vehicles---MONIL------------------03/04/2021
router.post("/deleteMemberVehicles",async function(req,res,next){
    try {
        const { memberId , vehicleNo } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistVehicleNo = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(memberId) },
                        { Vehicles: { $elemMatch: { vehicleNo: vehicleNo } } }
                    ]
                }
            }
        ]);

        if(checkExistVehicleNo.length == 1){
            let deleteVehicle = await memberSchema.updateOne({_id: mongoose.Types.ObjectId(memberId)},
                                        { $pull: { Vehicles: { vehicleNo: vehicleNo } }},
                                        { multi: true }
                                    );
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Your Vehicle ${vehicleNo} Removed`});
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Vehicle found for VehicleNo ${vehicleNo}`});
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Invite Guest -------------MONIL---------------29/03/2021
router.post("/inviteGuest", guestImg.single("guestImage") , async function(req,res,next){
    try {
        const { 
            Name, 
            ContactNo, 
            societyId, 
            wingId, 
            flatId, 
            memberId,
            guestType,
            purpose
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let addGuest = await new inviteGuestSchema({
            Name: Name.toUpperCase(),
            ContactNo: ContactNo,
            societyId: societyId,
            wingId: wingId,
            flatId: flatId,
            memberId: memberId,
            guestType: guestType,
            purpose: purpose,
            entryNo: getInviteGuestNumber(),
            guestImage: file != undefined ? file.path : "",
            dateTime: getCurrentDateTime(),
        });

        if(addGuest != null){
            try {
                await addGuest.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            res.status(200).json({ IsSuccess: true , Data: [addGuest] , Message: `Guest Invited with entryNo ${addGuest.entryNo}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Guest Not Invited" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Invited Guest list---------------MONIL---------10/04/2021
router.post("/getInvitedGuestList",async function(req,res,next){
    try {
        const { memberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberInvitedGuestList = await inviteGuestSchema.aggregate([
            {
                $match: {
                    $and: [
                        { memberId: mongoose.Types.ObjectId(memberId) },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { isVisited: false }
                    ]
                }
            },
            {
                $lookup: {
                    from: "societies",
                    localField: "societyId",
                    foreignField: "_id",
                    as: "SocietyData"
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingId",
                    foreignField: "_id",
                    as: "wingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "flatId",
                    foreignField: "_id",
                    as: "flatData"
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo: 1,
                    entryNo: 1,
                    purpose: 1,
                    guestImage: 1,
                    isVisited: 1,
                    inDateTime: 1,
                    outDateTime: 1,
                    dateTime: 1,
                    "SocietyData.Name": 1,
                    "SocietyData.Location": 1,
                    "SocietyData.Address": 1,
                    "SocietyData.societyCode": 1,
                    "wingData.wingName": 1,
                    "flatData.flatNo": 1,
                }
            }
        ]);        

        if(getMemberInvitedGuestList.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getMemberInvitedGuestList , Message: "Member Invited Guest Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Invited Guest Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
})

//Get Member Visitor List -----------MONIL-------29/03/2021
// status - 0 - Guest Invited
// status - 1 - Guest Entry Rejected By Admin
// status - 2 - Guest Entry Rejected By Watchman 
// status - 3 - Guest Visited
router.post("/getMemberVisitor",async function(req,res,next){
    try {
        const { memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVisitors = await guestEntrySchema.aggregate([
            {
                $match: {
                    memberId: mongoose.Types.ObjectId(memberId)
                }
            },
            {
                $lookup: {
                    from: "guestcategories",
                    localField: "guestType",
                    foreignField: "_id",
                    as: "GuestTypeIs"
                }
            },
            {
                $lookup: {
                    from: "societies",
                    localField: "societyId",
                    foreignField: "_id",
                    as: "SocietyData"
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingId",
                    foreignField: "_id",
                    as: "wingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "flatId",
                    foreignField: "_id",
                    as: "flatData"
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo: 1,
                    entryNo: 1,
                    purpose: 1,
                    guestImage: 1,
                    isVisited: 1,
                    inDateTime: 1,
                    outDateTime: 1,
                    dateTime: 1,
                    "SocietyData.Name": 1,
                    "SocietyData.Location": 1,
                    "SocietyData.Address": 1,
                    "SocietyData.societyCode": 1,
                    "wingData.wingName": 1,
                    "flatData.flatNo": 1,
                }
            }
        ]);

        if(getVisitors.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getVisitors , Message: "Member Visitors Found" })
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Visitors Found" })
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Visited Guest List
router.post("/getMemberVisitor_V1",async function(req,res,next){
    try {
        const { flatId , societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVisitors = await guestEntrySchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { flatId: mongoose.Types.ObjectId(flatId) },
                        { status: "1" }
                    ]
                }
            },
            {
                $lookup: {
                    from: "guestcategories",
                    localField: "guestType",
                    foreignField: "_id",
                    as: "GuestTypeIs"
                }
            },
            {
                $lookup: {
                    from: "societies",
                    localField: "societyId",
                    foreignField: "_id",
                    as: "SocietyData"
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingId",
                    foreignField: "_id",
                    as: "wingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "flatId",
                    foreignField: "_id",
                    as: "flatData"
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo: 1,
                    entryNo: 1,
                    purpose: 1,
                    guestImage: 1,
                    isVisited: 1,
                    inDateTime: 1,
                    outDateTime: 1,
                    dateTime: 1,
                    "SocietyData.Name": 1,
                    "SocietyData.Location": 1,
                    "SocietyData.Address": 1,
                    "SocietyData.societyCode": 1,
                    "wingData.wingName": 1,
                    "flatData.flatNo": 1,
                }
            }
        ]);

        if(getVisitors.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getVisitors.length , Data: getVisitors , Message: "Member Visitors Found" })
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Visitors Found" })
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Society Vendor-----------------MONIL---------------31/03/2021
router.post("/addVendor", vendorImg.single("vendorImage") ,async function(req,res,next){
    try {
        const { 
                vendorCategoryId, 
                Name,
                Address,
                ContactNo,
                EmergencyContactNo,
                ContactPerson,
                About,
                GSTNo,
                PAN,
                StateCode,
                City,
                emailId,
                societyId,
                CompanyName,
                vendorBelongsTo  
            } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkVendorCategory = await vendorCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(vendorCategoryId)
                }
            }
        ]);

        if(checkVendorCategory.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Vendor Category found for ${vendorCategoryId}` });
        }

        let checkExist = await vendorSchema.aggregate([
            {
                $match: {
                    ContactNo: ContactNo
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Vendor Already Exist With This Number" });
        }

        let addVendor;
        const file = req.file;

        if(vendorBelongsTo == "society"){
            addVendor = await new vendorSchema({
                Name: Name,
                vendorCategoryId: vendorCategoryId,
                ServiceName: checkVendorCategory[0].vendorCategoryName,
                Address: Address,
                ContactNo: ContactNo,
                EmergencyContactNo: EmergencyContactNo,
                ContactPerson: ContactPerson,
                CompanyName: CompanyName,
                About: About,
                GSTNo: GSTNo,
                PAN: PAN,
                StateCode: StateCode,
                City: City,
                emailId: emailId,
                societyId: societyId,
                vendorBelongsTo: "society",
                entryNo: getvendorCodeNumber(),
                vendorImage: file != undefined && file != null ? file.path : ""
            });
        }else if(vendorBelongsTo == "other"){
            addVendor = await new vendorSchema({
                Name: Name,
                vendorCategoryId: vendorCategoryId,
                ServiceName: checkVendorCategory[0].vendorCategoryName,
                Address: Address,
                ContactNo: ContactNo,
                CompanyName: CompanyName,
                EmergencyContactNo: EmergencyContactNo,
                ContactPerson: ContactPerson,
                About: About,
                GSTNo: GSTNo,
                PAN: PAN,
                StateCode: StateCode,
                City: City,
                emailId: emailId,
                vendorBelongsTo: "other",
                entryNo: getvendorCodeNumber(),
                vendorImage: file != undefined && file != null ? file.path : ""
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Please Send society/other to vendorBelongsTo field` });
        } 

        if(addVendor != null){
            try {
                await addVendor.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            res.status(200).json({ IsSuccess: true , Data: [addVendor] , Message: "Vendor Added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Vendor---------------------MONIL---------------------20/04/2021
router.post("/getVendors",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(societyId != undefined && societyId != null && societyId != ""){
            let getVendors = await vendorSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { vendorBelongsTo: "society" }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "vendorratings",
                        let: { vendorId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$vendorId","$vendorId" ] }
                                    }
                            },
                        ],
                        as: "VendorRatings"
                    }
                },
                {
                    $addFields: {
                        TotalReviews: { $size: "$VendorRatings" }
                    }
                },
                {
                    $addFields: {
                        AverageRating: {
                            $round: [ { $toDouble: { $avg: "$VendorRatings.rating" } } , 1 ]
                        }
                    }
                }
            ]);

            if(getVendors.length > 0){
                res.status(200).json({ IsSuccess: true , Count: getVendors.length , Data: getVendors , Message: "Society Vendors Found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: getVendors , Message: "Society Vendors Found" });
            }
        }else{
            let getVendors = await vendorSchema.aggregate([
                {
                    $match: {
                        vendorBelongsTo: "other"
                    }
                }
            ]);

            if(getVendors.length > 0){
                res.status(200).json({ IsSuccess: true , Count: getVendors.length , Data: getVendors , Message: "Other Vendors Found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: getVendors , Message: "Other Vendors Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Vendor Categorywise------------------------MONIL------------11/05/2021
router.post("/getVendorCategorywise",async function(req,res,next){
    try {
        const { vendorCategoryId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVendor = await vendorSchema.aggregate([
            {
                $match: {
                    $and: [
                        { vendorCategoryId: mongoose.Types.ObjectId(vendorCategoryId) },
                        { vendorBelongsTo: "other" }
                    ]
                }
            },
            {
                $lookup: {
                    from: "vendorratings",
                    let: { vendorId: "$_id" },
                    pipeline: [
                        { 
                            $match:
                                { 
                                    $expr: { $eq: [ "$$vendorId","$vendorId" ] }
                                }
                        },
                    ],
                    as: "VendorRatings"
                }
            },
            {
                $addFields: {
                    TotalReviews: { $size: "$VendorRatings" }
                }
            },
            {
                $addFields: {
                    AverageRating: {
                        $round: [ { $toDouble: { $avg: "$VendorRatings.rating" } } , 1 ]
                    }
                }
            }
        ]);

        if(getVendor.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getVendor.length , Data: getVendor , Message: "Vendor Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: getVendor , Message: "No Vendor Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Member SOS Contacts--------------------MONIL--------------24/04/2021
router.post("/addMemberSOSContacts",async function(req,res,next){
    try {
        const { memberId, contactNo , contactPerson } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await memberSOSContactSchema.aggregate([
            {
                $match: {
                    $and: [
                        { memberId: mongoose.Types.ObjectId(memberId) },
                        { contactNo: contactNo }
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `SOS Contact ${contactNo} already Exist` });
        }

        let addSOSContacts = await new memberSOSContactSchema({
            memberId: memberId,
            contactNo: contactNo,
            contactPerson: contactPerson
        });

        if(addSOSContacts != null){
            addSOSContacts.save();
            res.status(200).json({ IsSuccess: true , Data: [addSOSContacts] , Message: `SOS Contact ${contactNo} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `SOS Contact ${contactNo} Not added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member SOS Contacts-----------------MONIL---------------------24/04/2021
router.post("/getMemberSOSContacts",async function(req,res,next){
    try {
        const { memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getContacts = await memberSOSContactSchema.aggregate([
            {
                $match: {
                    memberId: mongoose.Types.ObjectId(memberId)
                }
            }
        ]);

        if(getContacts.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: getContacts.length , Data: getContacts , Message: `SOS Contact Found` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No SOS Contact Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add SOS--------------------------MONIL-------------------------31/03/2021
//Send By => 0 => Send By Member
//Send By => 1 => Send By Watchman
router.post("/sendSOS",async function(req,res,next){
    try {
        const { senderId , receiverMemberIds , receiverWatchmanIds , message , sendBy , societyId , gmapLink } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $project: {
                    Name: 1
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society found for societyId ${societyId}` });
        }

        if(sendBy == 0){

            let senderIs = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(senderId) },
                            { "society.societyId": mongoose.Types.ObjectId(societyId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        "WingData.wingName": 1,
                        "FlatData.flatNo": 1
                    } 
                }
            ]);

            if(senderIs.length > 0){
                let memberTokens = [];
                let watchamanTokens = [];

                if(receiverMemberIds.length > 0){
                    memberTokens = await getMemberPlayerId(receiverMemberIds,senderId);
                }

                if(receiverWatchmanIds != undefined && receiverWatchmanIds != null && receiverWatchmanIds != []){
                    watchamanTokens = await getWatchmanPlayerId(receiverWatchmanIds);
                }
                
                let title = `SOS Notification from ${getSociety[0].Name} , Send By Member ${senderIs[0].Name}`;
                let bodyIs = `SOS-Category: ${message}`;  
                
                let notiDataIs = {
                    SendBy: "Member",
                    Name: senderIs[0].Name,
                    Image: senderIs[0].Image,
                    SenderFlat: senderIs[0].FlatData[0].flatNo,
                    SenderWing: senderIs[0].WingData[0].wingName,
                    ContactNo: senderIs[0].ContactNo,
                    GoogleMap: gmapLink,
                    Message: message,
                    NotificationType: "SOS",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                if(memberTokens.length > 0){
                    memberTokens.forEach( tokenIs => {

                        if(tokenIs.DeviceType == "IOS"){
                            
                            let messageIs = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "ambulance.wav"
                            };
                            
                            sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,senderId,"SOS","IOS");
                        }else{
                            let messageIs = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "d577af23-3001-4e4a-8c7b-673fa0080f23"
                            };
                            
                            sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,senderId,"SOS","Android");
                        }
                        // sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,true,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                if(watchamanTokens.length > 0){
                    let notiDataIs = {
                        SendBy: "Member",
                        Name: senderIs[0].Name,
                        SenderFlat: senderIs[0].FlatData[0].flatNo,
                        SenderWing: senderIs[0].WingData[0].wingName,
                        ContactNo: senderIs[0].ContactNo,
                        Message: message,
                        GoogleMap: gmapLink,
                        muteNotificationAudio: false,
                        NotificationType: "SOS",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
                    watchamanTokens.forEach( tokenIs => {
                        let messageIs = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${title}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "9022698e-fdde-4b49-a09e-23e13d892654"
                        };
                        sendOneSignalNotification(messageIs,false,true,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,false,true,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                res.status(200).json({ IsSuccess: true , Data: 1 , Message: "SOS notification send" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Sender Found for senderId ${senderId}` });
            }
        }else if(sendBy == 1){
            let senderIs = await watchmanSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(senderId)
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
                        Name: 1,
                        ContactNo1: 1,
                        "WingData.wingName": 1
                    } 
                }
            ]);

            if(senderIs.length == 1){
                let memberTokens = [];
                let watchamanTokens = [];

                if(receiverMemberIds.length > 0){
                    memberTokens = await getMemberPlayerId(receiverMemberIds);
                }

                if(receiverWatchmanIds != undefined && receiverWatchmanIds != null && receiverWatchmanIds != []){
                    watchamanTokens = await getWatchmanPlayerId(receiverWatchmanIds);
                }

                let title = `SOS Notification from ${getSociety[0].Name} , Send By Watchman ${senderIs[0].Name}`;
                let bodyIs = `SOS Category: ${message}`;   

                let notiDataIs = {
                    SendBy: "Watchman",
                    Name: senderIs[0].Name,
                    ContactNo: senderIs[0].ContactNo1,
                    WatchmanWing: senderIs[0].WingData[0].wingName,
                    Message: message,
                    GoogleMap: gmapLink,
                    NotificationType: "SOS",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                if(memberTokens.length > 0){
                    memberTokens.forEach( tokenIs => {
                        
                        if(tokenIs.DeviceType == "IOS"){
                            let messageIs = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: "ambulance.wav"
                            };
                            sendOneSignalNotification(messageIs,true,false,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }else{
                            let messageIs = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${title}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "d577af23-3001-4e4a-8c7b-673fa0080f23"
                            };
                            sendOneSignalNotification(messageIs,true,false,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }
                        
                        // sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,false,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                if(watchamanTokens.length > 0){
                    let notiDataIs = {
                        SendBy: "Watchman",
                        Name: senderIs[0].Name,
                        ContactNo: senderIs[0].ContactNo1,
                        WatchmanWing: senderIs[0].WingData[0].wingName,
                        Message: message,
                        GoogleMap: gmapLink,
                        muteNotificationAudio: false,
                        NotificationType: "SOS",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
                    watchamanTokens.forEach( tokenIs => {
                        let messageIs = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": title
                            },
                            headings: {"en": `SOS SEND BY WATCHMAN`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "9022698e-fdde-4b49-a09e-23e13d892654"
                        };
                        sendOneSignalNotification(messageIs,false,false,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,false,false,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                res.status(200).json({ IsSuccess: true , Data: 1 , Message: "SOS notification send" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Sender Found for senderId ${senderId}` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please send sendBy 0 for member & 1 for Watchman" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Send SOS Including Contacts-------------------------------------MONIL---------------------24/04/2021
router.post("/sendSOS_v1",async function(req,res,next){
    try {
        const { senderId , receiverMemberIds , receiverWatchmanIds , message , sendBy , societyId , isForContacts } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $project: {
                    Name: 1
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society found for societyId ${societyId}` });
        }

        if(sendBy == 0){

            let senderIs = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(senderId) },
                            { "society.societyId": mongoose.Types.ObjectId(societyId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        "WingData.wingName": 1,
                        "FlatData.flatNo": 1
                    } 
                }
            ]);

            if(senderIs.length == 1){
                let memberTokens = [];
                let watchamanTokens = [];

                if(receiverMemberIds.length > 0){
                    memberTokens = await getMemberFcmTokens(receiverMemberIds,senderId);
                }

                if(receiverWatchmanIds.length > 0){
                    watchamanTokens = await getWatchmanToken(receiverWatchmanIds);
                }

                let title = `SOS Notification from ${getSociety[0].Name} , Send By Member ${senderIs[0].Name}`;
                let bodyIs = `SOS About: ${message}`;   

                if(memberTokens.length > 0){
                    memberTokens.forEach( tokenIs => {
                        if(tokenIs.muteNotificationAudio == true){
                            let notiDataIs = {
                                SendBy: "Member",
                                Name: senderIs[0].Name,
                                SenderFlat: senderIs[0].FlatData[0].flatNo,
                                SenderWing: senderIs[0].WingData[0].wingName,
                                ContactNo: senderIs[0].ContactNo,
                                Message: message,
                                muteNotificationAudio: true,
                                NotificationType: "SOS",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }
                            sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,true,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }else{
                            let notiDataIs = {
                                SendBy: "Member",
                                Name: senderIs[0].Name,
                                SenderFlat: senderIs[0].FlatData[0].flatNo,
                                SenderWing: senderIs[0].WingData[0].wingName,
                                ContactNo: senderIs[0].ContactNo,
                                Message: message,
                                muteNotificationAudio: false,
                                NotificationType: "SOS",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }
                            sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,true,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }
                    });
                }

                if(watchamanTokens.length > 0){
                    let notiDataIs = {
                        SendBy: "Member",
                        Name: senderIs[0].Name,
                        SenderFlat: senderIs[0].FlatData[0].flatNo,
                        SenderWing: senderIs[0].WingData[0].wingName,
                        ContactNo: senderIs[0].ContactNo,
                        Message: message,
                        muteNotificationAudio: false,
                        NotificationType: "SOS",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
                    watchamanTokens.forEach( tokenIs => {
                        sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,false,true,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                res.status(200).json({ IsSuccess: true , Data: 1 , Message: "SOS notification send" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Sender Found for senderId ${senderId}` });
            }
        }else if(sendBy == 1){
            let senderIs = await watchmanSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(senderId)
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
                        Name: 1,
                        ContactNo1: 1,
                        "WingData.wingName": 1
                    } 
                }
            ]);

            if(senderIs.length == 1){
                let memberTokens = [];
                let watchamanTokens = [];

                if(receiverMemberIds.length > 0){
                    memberTokens = await getMemberFcmTokens(receiverMemberIds);
                }

                if(watchamanTokens.length > 0){
                    watchamanTokens = await getWatchmanToken(receiverWatchmanIds);
                }

                let title = `SOS Notification from ${getSociety[0].Name} , Send By Watchman ${senderIs[0].Name}`;
                let bodyIs = `SOS About: ${message}`;   

                if(memberTokens.length > 0){
                    memberTokens.forEach( tokenIs => {
                        if(tokenIs.muteNotificationAudio == true){
                            let notiDataIs = {
                                SendBy: "Watchman",
                                Name: senderIs[0].Name,
                                ContactNo: senderIs[0].ContactNo1,
                                WatchmanWing: senderIs[0].WingData[0].wingName,
                                Message: message,
                                muteNotificationAudio: true,
                                NotificationType: "SOS",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }
                            sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,false,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }else{
                            let notiDataIs = {
                                SendBy: "Watchman",
                                Name: senderIs[0].Name,
                                ContactNo: senderIs[0].ContactNo1,
                                WatchmanWing: senderIs[0].WingData[0].wingName,
                                Message: message,
                                muteNotificationAudio: false,
                                NotificationType: "SOS",
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }
                            sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,true,false,tokenIs.memberId,senderId,"SOS",tokenIs.DeviceType);
                        }
                    });
                }

                if(watchamanTokens.length > 0){
                    let notiDataIs = {
                        SendBy: "Watchman",
                        Name: senderIs[0].Name,
                        ContactNo: senderIs[0].ContactNo1,
                        WatchmanWing: senderIs[0].WingData[0].wingName,
                        Message: message,
                        muteNotificationAudio: false,
                        NotificationType: "SOS",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
                    watchamanTokens.forEach( tokenIs => {
                        console.log(tokenIs.fcmToken);
                        sendNotification(tokenIs.fcmToken,notiDataIs,title,bodyIs,false,false,tokenIs.watchmanId,senderId,"SOS",tokenIs.DeviceType);
                    });
                }

                res.status(200).json({ IsSuccess: true , Data: 1 , Message: "SOS notification send" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Sender Found for senderId ${senderId}` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please send sendBy 0 for member & 1 for Watchman" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Video Call or Video Call --------------------MONIL---------------------31/03/2021
router.post("/memberCalling",async function(req,res,next){
    try {
        const { 
            callerMemberId, 
            callerWingId,
            callerFlatId,
            receiverMemberId,
            receiverWingId,
            receiverFlatId,
            contactNo,
            AddedBy,
            societyId,
            isVideoCall,
            callFor,
            watchmanId,
            entryId,
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let callType;

        if(isVideoCall == true){
            callType = "video";
        }else{
            callType = "audio";
        };

        let updateOnCall = {
            isOnCall: true
        }
        
        if(callFor == 0){
            // Member to Member Calling

            let receiverIs = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(receiverMemberId)
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        Gender: 1,
                        MemberNo: 1,
                        Image: 1,
                        isOnCall: 1,
                        "WingData.wingName": 1,
                        "FlatData.flatNo": 1,
                    }
                }
            ]);

            if(receiverIs[0].isOnCall == true){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Receiver Is On Another Call" });
            }

            let addCall = await new callingSchema({
                Caller: {
                    callerMemberId: callerMemberId,
                    wingId: callerWingId,
                    flatId: callerFlatId,
                },
                Receiver: {
                    receiverMemberId: receiverMemberId,
                    wingId: receiverWingId,
                    flatId: receiverFlatId,
                },
                contactNo: contactNo,
                AddedBy: AddedBy != undefined || "" ? AddedBy : "Member",
                callStatus: 0,
                callFor: 0,
                isVideoCall: isVideoCall != undefined || "" ? isVideoCall : true,
            });
            
            if(addCall != null){
                try {
                    await addCall.save();

                    let callerIs = await memberSchema.aggregate([
                        {
                            $unwind: "$society"
                        },
                        {
                            $match: {
                                $and: [
                                    { _id: mongoose.Types.ObjectId(callerMemberId) },
                                    { "society.societyId": mongoose.Types.ObjectId(societyId) }
                                ]
                            },
                        },
                        {
                            $lookup: {
                                from: "wings",
                                localField: "society.wingId",
                                foreignField: "_id",
                                as: "WingData"
                            }
                        },
                        {
                            $lookup: {
                                from: "flats",
                                localField: "society.flatId",
                                foreignField: "_id",
                                as: "FlatData"
                            }
                        },
                        {
                            $project: {
                                Name: 1,
                                ContactNo: 1,
                                Gender: 1,
                                MemberNo: 1,
                                Image: 1,
                                "WingData.wingName": 1,
                                "FlatData.flatNo": 1,
                            }
                        }
                    ]);
        
                    let titleIs = `Call From ${callerIs[0].Name}`;
                    let bodyIs = `Call From ${callerIs[0].Name} and contactNo ${callerIs[0].ContactNo}`;
    
                    let notiDataIs = {
                        CallerName: callerIs[0].Name,
                        CallerContactNo: callerIs[0].ContactNo,
                        CallerImage: callerIs[0].Image,
                        CallerMemberNo: callerIs[0].MemberNo,
                        CallerWingName: callerIs[0].WingData[0].wingName,
                        CallerFlatNo: callerIs[0].FlatData[0].flatNo,
                        ReceiverName: receiverIs[0].Name,
                        ReceiverContactNo: receiverIs[0].ContactNo,
                        ReceiverImage: receiverIs[0].Image,
                        ReceiverMemberNo: receiverIs[0].MemberNo,
                        ReceiverWingName: receiverIs[0].WingData[0].wingName,
                        ReceiverFlatNo: receiverIs[0].FlatData[0].flatNo,
                        CallingId: addCall._id,
                        NotificationType: callType == "video" ? "VideoCalling" : "VoiceCall",
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };
        
                    let receiverToken = await getSingleMemberPlayerId(receiverMemberId);

                    let updateSender = await memberSchema.findByIdAndUpdate(callerMemberId,updateOnCall);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverMemberId,updateOnCall);
                    
                    receiverToken.forEach(tokenIs=>{
    
                        if(tokenIs.DeviceType == "IOS"){
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                ios_sound: callType == "video" ? "videocall.wav" : "Phone-Ring.wav"
                            };
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberId,notiDataIs.NotificationType,tokenIs.DeviceType);
                        }else{
                            let message = { 
                                app_id: process.env.APP_ID,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: callType == "video" ? "a862517e-8422-48f3-9fa0-44201356ab5e" : "5db6c5b1-b85d-475c-98ea-eb7512df8125"
                            };
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberId,notiDataIs.NotificationType,tokenIs.DeviceType);
                        }
                        
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,callerMemberId,notiDataIs.NotificationType,tokenIs.DeviceType)
                    });
        
                    if(receiverToken.length > 0){
                        return res.status(200).json({ IsSuccess: true , Data: [addCall] , Message: `${callType} call requested to receiver` });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No receiver Tokens Found` });
                    }
                } catch (error) {
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }
    
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Calling Faild" });
            }            
        }else if(callFor == 1){
            //Member To Watchman Calling
            console.log("Member To Watchman Calling");

            let receiverIs = await watchmanSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(watchmanId)
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
                        Name: 1,
                        ContactNo1: 1,
                        Gender: 1,
                        watchmanNo: 1,
                        watchmanImage: 1,
                        isOnCall: 1,
                        "WingData.wingName": 1,
                    }
                }
            ]);

            if(receiverIs[0].isOnCall == true){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Receiver Is On Another Call" });
            }

            let addCall = await new callingSchema({
                Caller: {
                    callerMemberId: callerMemberId,
                    wingId: callerWingId,
                    flatId: callerFlatId,
                },
                Receiver: {
                    watchmanId: watchmanId,
                    wingId: receiverWingId,
                },
                contactNo: contactNo,
                AddedBy: AddedBy != undefined || "" ? AddedBy : "Member",
                callStatus: 0,
                callFor: 1,
                isVideoCall: isVideoCall != undefined ? isVideoCall : true,
            });

            if(addCall != null){
                try {
                    await addCall.save();   
                } catch (error) {
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                let callerIs = await memberSchema.aggregate([
                    {
                        $unwind: "$society"
                    },
                    {
                        $match: {
                            $and: [
                                { _id: mongoose.Types.ObjectId(callerMemberId) },
                                { "society.societyId": mongoose.Types.ObjectId(societyId) }
                            ]
                        },
                    },
                    {
                        $lookup: {
                            from: "wings",
                            localField: "society.wingId",
                            foreignField: "_id",
                            as: "WingData"
                        }
                    },
                    {
                        $lookup: {
                            from: "flats",
                            localField: "society.flatId",
                            foreignField: "_id",
                            as: "FlatData"
                        }
                    },
                    {
                        $project: {
                            Name: 1,
                            ContactNo: 1,
                            Gender: 1,
                            MemberNo: 1,
                            Image: 1,
                            "WingData.wingName": 1,
                            "FlatData.flatNo": 1,
                        }
                    }
                ]);

                let titleIs = `Call From ${callerIs[0].Name}`;
                let bodyIs = `Call From ${callerIs[0].Name} and contactNo ${callerIs[0].ContactNo}`;
    
                let receiverToken = await getSingleWatchmanPlayerId(watchmanId);

                let notiDataIs = {
                    CallerName: callerIs[0].Name,
                    CallerContactNo: callerIs[0].ContactNo,
                    CallerImage: callerIs[0].Image,
                    CallerMemberNo: callerIs[0].MemberNo,
                    CallerWingName: callerIs[0].WingData[0].wingName,
                    CallerFlatNo: callerIs[0].FlatData[0].flatNo,
                    WatchmanName: receiverIs[0].Name,
                    WatchmanContactNo: receiverIs[0].ContactNo1,
                    WatchmanImage: receiverIs[0].watchmanImage,
                    WatchmanNo: receiverIs[0].watchmanNo,
                    WatchmanWingName: receiverIs[0].WingData[0].wingName,
                    VisitorEntryId: entryId != undefined ? entryId : "",
                    CallingId: addCall._id,
                    muteNotificationAudio: false,
                    NotificationType: callType == "video" ? "VideoCalling" : "VoiceCall", 
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                let updateSender = await memberSchema.findByIdAndUpdate(callerMemberId,updateOnCall);
                let updateReceiver = await watchmanSchema.findByIdAndUpdate(watchmanId,updateOnCall);
                
                receiverToken.forEach(tokenIs=>{
                    let message = { 
                        app_id: process.env.APP_ID_W,
                        contents: {
                            "en": bodyIs
                        },
                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                        data: notiDataIs,   
                        content_available: 1,
                        include_player_ids: [tokenIs.playerId],
                        android_channel_id: callType == "video" ? "753e6aa2-587a-41bc-9994-450d8193f919" : "880b4ef8-2179-4804-896a-b6e54d571308"
                        // android_channel_id: "f190e6fe-1a72-4e1f-bfb3-10b6f171caf1"
                    };
                    sendOneSignalNotification(message,false,true,tokenIs.watchmanId,callerMemberId,notiDataIs.NotificationType,tokenIs.DeviceType);
                });
    
                if(receiverToken.length > 0){
                    return res.status(200).json({ IsSuccess: true , Data: [addCall] , Message: `${callType} call requested to receiver` });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No receiver Tokens Found` });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Calling Faild" });
            } 
        }else if(callFor == 2){
            //Watchman To Member Calling
            console.log("Watchman To Member Calling");

            let receiverIs = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(receiverMemberId)
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        Gender: 1,
                        MemberNo: 1,
                        Image: 1,
                        isOnCall: 1,
                        "WingData.wingName": 1,
                        "FlatData.flatNo": 1,
                    }
                }
            ]);

            if(receiverIs[0].isOnCall == true){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Receiver Is On Another Call" });
            }

            let addCall = await new callingSchema({
                Caller: {
                    watchmanId: watchmanId,
                    wingId: callerWingId,
                },
                Receiver: {
                    receiverMemberId: receiverMemberId,
                    wingId: receiverWingId,
                    flatId: receiverFlatId,
                },
                contactNo: contactNo,
                AddedBy: AddedBy != undefined || "" ? AddedBy : "Member",
                callStatus: 0,
                callFor: 2,
                isVideoCall: isVideoCall != undefined ? isVideoCall : true,
            });

            if(addCall != null){
                try {
                    await addCall.save();    
                } catch (error) {
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                let callerIs = await watchmanSchema.aggregate([
                    {
                        $match: {
                            _id: mongoose.Types.ObjectId(watchmanId)
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
                            Name: 1,
                            ContactNo1: 1,
                            Gender: 1,
                            watchmanNo: 1,
                            watchmanImage: 1,
                            "WingData.wingName": 1,
                        }
                    }
                ]);
    
                let titleIs = `Call From Watchman - ${callerIs[0].Name}`;
                let bodyIs = `Call From ${callerIs[0].Name} and contactNo ${callerIs[0].ContactNo1}`;
    
                let receiverToken = await getSingleMemberPlayerId(receiverMemberId);

                let notiDataIs = {
                    WatchmanName: callerIs[0].Name,
                    WatchmanContactNo: callerIs[0].ContactNo1,
                    WatchmanImage: callerIs[0].watchmanImage,
                    WatchmanNo: callerIs[0].watchmanNo,
                    WatchmanWingName: callerIs[0].WingData[0].wingName,
                    ReceiverName: receiverIs[0].Name,
                    ReceiverContactNo: receiverIs[0].ContactNo,
                    ReceiverImage: receiverIs[0].Image,
                    ReceiverMemberNo: receiverIs[0].MemberNo,
                    ReceiverWingName: receiverIs[0].WingData[0].wingName,
                    ReceiverFlatNo: receiverIs[0].FlatData[0].flatNo,
                    CallingId: addCall._id,
                    NotificationType: callType == "video" ? "VideoCalling" : "VoiceCall", 
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                let updateSender = await watchmanSchema.findByIdAndUpdate(watchmanId,updateOnCall);
                let updateReceiver = await memberSchema.findByIdAndUpdate(receiverMemberId,updateOnCall);

                receiverToken.forEach(tokenIs=>{
                    if(tokenIs.DeviceType == "IOS"){                   
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            ios_sound: callType == "video" ? "videocall.wav" : "Phone-Ring.wav"
                            // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                        };
                        sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,notiDataIs.NotificationType,"IOS");
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,watchmanId,notiDataIs.NotificationType,tokenIs.DeviceType);
                    }else{
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: callType == "video" ? "a862517e-8422-48f3-9fa0-44201356ab5e" : "5db6c5b1-b85d-475c-98ea-eb7512df8125"
                            // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                        };
                        sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,notiDataIs.NotificationType,"Android");
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,watchmanId,notiDataIs.NotificationType,tokenIs.DeviceType);
                    }
                });
    
                if(receiverToken.length > 0){
                    return res.status(200).json({ IsSuccess: true , Data: [addCall] , Message: `${callType} call requested to receiver` });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No receiver Tokens Found` });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Calling Faild" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Please Provide valid number for CallFor field` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Response to Call-----------------------------MONIL--------------------31/03/2021
// Response - 0 - Pending (by default)
// Response - 1 - Accepted
// Response - 2 - Rejected
router.post("/responseToCall",async function(req,res,next){
    try {
        const { callingId , response } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkCall = await callingSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(callingId)
                }
            }
        ]);

        if(checkCall.length == 1){
            
            if(checkCall[0].callFor == 0 || checkCall[0].callFor == 1){
                if(response == 1){
                    let update = {
                        callStatus: 1
                    }

                    let updateOnCall = {
                        isOnCall: true
                    }
                    let updateCallIs = await callingSchema.findByIdAndUpdate(callingId,update);
                    let callerMemberIdIs = checkCall[0].Caller.callerMemberId;
    
                    let callerTokens = await getSingleMemberPlayerId(callerMemberIdIs);
                    
                    let titleIs = `Your Call Is Accepted`;
                    let bodyIs = `Your Call Is Accepted , Now You Can Join your Call`;

                    let notiDataIs = {
                        NotificationType: checkCall[0].isVideoCall == true ? "VideoCalling" : "VoiceCall",
                        CallResponse: 1,
                        CallResponseIs: "Accepted",
                        CallingId: callingId,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    if(checkCall[0].callFor == 1){
                        let responseWatchmanIdIs = checkCall[0].Receiver.watchmanId;

                        let receiverIdIs = checkCall[0].Receiver.watchmanId;
                        
                        let updateSender = await memberSchema.findByIdAndUpdate(callerMemberIdIs,updateOnCall);
                        let updateReceiver = await watchmanSchema.findByIdAndUpdate(receiverIdIs,updateOnCall);
                        callerTokens.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,"IOS");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,"Android");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }
                        });
                    }else{
                        let receiverMemberIdIs = checkCall[0].Receiver.receiverMemberId;

                        let updateSender = await memberSchema.findByIdAndUpdate(callerMemberIdIs,updateOnCall);
                        let updateReceiver = await memberSchema.findByIdAndUpdate(receiverMemberIdIs,updateOnCall);

                        callerTokens.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,"IOS");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }
                        });
                    }
                    
                    if(callerTokens.length > 0){
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Accepted" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Caller Tokens found" });
                    }
                }else{
                    let update = {
                        callStatus: 2
                    }

                    let updateCallIs = await callingSchema.findByIdAndUpdate(callingId,update);
                    let callerMemberIdIs = checkCall[0].Caller.callerMemberId;
    
                    let callerTokens = await getSingleMemberPlayerId(callerMemberIdIs);
                    
                    let titleIs = `Your Call Is Rejected`;
                    let bodyIs = `Your Call Is Rejected By Responser`;

                    let notiDataIs = {
                        NotificationType: checkCall[0].isVideoCall == true ? "VideoCalling" : "VoiceCall",
                        CallResponse: 2,
                        CallResponseIs: "Rejected",
                        CallingId: callingId,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    if(checkCall[0].callFor == 1){
                        let responseWatchmanIdIs = checkCall[0].Receiver.watchmanId;

                        callerTokens.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,"IOS");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }
                        });
                    }else{

                        let receiverMemberIdIs = checkCall[0].Receiver.receiverMemberId;

                        callerTokens.forEach(tokenIs=>{
                            if(tokenIs.DeviceType == "IOS"){
                                
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,"IOS");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }else{
                                let message = { 
                                    app_id: process.env.APP_ID,
                                    contents: {
                                        "en": bodyIs
                                    },
                                    headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                    data: notiDataIs,   
                                    content_available: 1,
                                    include_player_ids: [tokenIs.playerId],
                                    // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                };
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,"Android");
                                // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,callerMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                            }
                        });
                    }
                    if(callerTokens.length > 0){
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Caller Tokens found" });
                    }
                }
            }else if(checkCall[0].callFor == 2){
                if(response == 1){
                    let update = {
                        callStatus: 1
                    }

                    let updateOnCall = {
                        isOnCall: true
                    }

                    let updateCallIs = await callingSchema.findByIdAndUpdate(callingId,update);
                    let callerwatchmanIdIs = checkCall[0].Caller.watchmanId;
                    let receiverMemberIdIs = checkCall[0].Receiver.receiverMemberId;
    
                    let callerTokens = await getSingleWatchmanPlayerId(callerwatchmanIdIs);
                    
                    let titleIs = `Your Call Is Accepted`;
                    let bodyIs = `Your Call Is Accepted`;
    
                    let notiDataIs = {
                        NotificationType: checkCall[0].isVideoCall == true ? "VideoCalling" : "VoiceCall",
                        CallResponse: 1,
                        CallResponseIs: "Accepted",
                        CallingId: callingId,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    };

                    let updateSender = await watchmanSchema.findByIdAndUpdate(callerwatchmanIdIs,updateOnCall);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverMemberIdIs,updateOnCall);
    
                    callerTokens.forEach(tokenIs=>{
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            // android_channel_id: "76484b44-6a55-409c-b80e-8f9371788e45"
                        };
                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,receiverMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,receiverMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                    });
                    if(callerTokens.length > 0){
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Accepted" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Caller Tokens found" });
                    }
                }else{
                    let update = {
                        callStatus: 2
                    }

                    let updateCallIs = await callingSchema.findByIdAndUpdate(callingId,update);
                    let callerwatchmanIdIs = checkCall[0].Caller.watchmanId;
                    let receiverMemberIdIs = checkCall[0].Receiver.receiverMemberId;
    
                    let callerTokens = await getSingleWatchmanPlayerId(callerwatchmanIdIs);
                    
                    let titleIs = `Your Call Is Rejected`;
                    let bodyIs = `Your Call Is Rejected`;
    
                    let notiDataIs = {
                        NotificationType: checkCall[0].isVideoCall == true ? "VideoCalling" : "VoiceCall",
                        CallResponse: 2,
                        CallResponseIs: "Rejected",
                        CallingId: callingId,
                        muteNotificationAudio: false,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }
    
                    callerTokens.forEach(tokenIs=>{
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            // android_channel_id: "76484b44-6a55-409c-b80e-8f9371788e45"
                        };
                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,receiverMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,receiverMemberIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                    });
                    if(callerTokens.length > 0){
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Caller Tokens found" });
                    }
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Valid CallFor field ` });
            }
            
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Call found for CallingId ${callingId}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Reject Call----------------------------------MONIL---------------------15/05/2021
router.post("/rejectCall",async function(req,res,next){
    try {
        const { callingId , rejectBy } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkCall = await callingSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(callingId)
                }
            }
        ]);

        if(checkCall.length == 1){
            let update = {
                isOnCall: false
            }

            if(checkCall[0].callStatus == 0){
                //When There is no Call Response

                let updateCall = {
                    callStatus: 2
                }
                if(checkCall[0].callFor == 0){
                    //Member To Member Call Rejection
                    let senderId = checkCall[0].Caller.callerMemberId;
                    let receiverId = checkCall[0].Receiver.receiverMemberId;
    
                    let updateSender = await memberSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);

                    if(rejectBy == true){
                        //When Sender Reject The Call Send Notification to Receiver

                        let receiverTokens = await getSingleMemberPlayerId(receiverId);

                        if(receiverTokens.length > 0){
                            let titleIs = `Incoming Call Is Rejected By Sender`;
                            let bodyIs = `Sender Reject the Call`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingBySender" : "RejectVoiceCallBySender",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                muteNotificationAudio: true,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            receiverTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,true,tokenIs.memberId,senderId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,true,tokenIs.memberId,senderId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected by Sender" });
                    }else if(rejectBy == false){
                        let callerTokens = await getSingleMemberPlayerId(senderId);

                        if(callerTokens.length > 0){
                            let titleIs = `Your Call Is Rejected By Receiver`;
                            let bodyIs = `Receiver Is Busy`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingByReceiver" : "RejectVoiceCallByReceiver",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                muteNotificationAudio: true,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            callerTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){
                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,true,tokenIs.memberId,receiverId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,true,tokenIs.memberId,receiverId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected by Receiver" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Pass True / False for rejectBy Field" });
                    }
                }else if(checkCall[0].callFor == 1){
                    //Member To Watchman Calling Rejection

                    let senderId = checkCall[0].Caller.callerMemberId;
                    let receiverId = checkCall[0].Receiver.watchmanId;
    
                    let updateSender = await memberSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await watchmanSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);

                    if(rejectBy == true){
                        //When Member Reject Call While Calling Send Notification To Watchman

                        let receiverTokens = await getSingleWatchmanPlayerId(receiverId);

                        if(receiverTokens.length > 0){
                            let titleIs = `Incoming Call Is Rejected By Sender`;
                            let bodyIs = `Sender Reject the Call`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingBySender" : "RejectVoiceCallBySender",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            receiverTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){
                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,false,true,tokenIs.watchmanId,senderId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,false,true,tokenIs.watchmanId,senderId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected by Sender" });
                    }else if(rejectBy == false){
                        //When Watchman Cancel The Incoming Call From Member Send Notification to Caller Member
                        let callerTokens = await getSingleMemberPlayerId(senderId);

                        if(callerTokens.length > 0){
                            let titleIs = `Your Call Is Rejected`;
                            let bodyIs = `Receiver Is Busy`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingByReceiver" : "RejectVoiceCallByReceiver",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                muteNotificationAudio: true,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            callerTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){
                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,receiverId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,receiverId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected By Receiver" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Pass True / False for rejectBy Field" });
                    }
                }else if(checkCall[0].callFor == 2){
                    //Watchman To Member Call Rejection

                    let senderId = checkCall[0].Caller.watchmanId;
                    let receiverId = checkCall[0].Receiver.receiverMemberId;
    
                    let updateSender = await watchmanSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);

                    if(rejectBy == true){
                        //When Watchman Reject The Call While Calling Member Send Notification to Member
                        let receiverTokens = await getSingleMemberPlayerId(receiverId);

                        if(receiverTokens.length > 0){
                            let titleIs = `Incoming Call Is Rejected By Sender`;
                            let bodyIs = `Watchman Reject the Call`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingBySender" : "RejectVoiceCallBySender",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            receiverTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){
                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,senderId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,true,false,tokenIs.memberId,senderId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected by Sender" });
                    }else if(rejectBy == false){
                        let callerTokens = await getSingleWatchmanPlayerId(senderId);

                        if(callerTokens.length > 0){
                            let titleIs = `Your Call Is Rejected`;
                            let bodyIs = `Receiver Is Busy`;

                            let notiDataIs = {
                                NotificationType: checkCall[0].isVideoCall == true ? "RejectVideoCallingByReceiver" : "RejectVoiceCallByReceiver",
                                CallResponse: 2,
                                CallResponseIs: "Rejected",
                                CallingId: callingId,
                                muteNotificationAudio: true,
                                content_available: true, 
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                                view: "ghj"
                            }

                            callerTokens.forEach(tokenIs=>{
                                if(tokenIs.DeviceType == "IOS"){
                                    
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        // android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,false,true,tokenIs.watchmanId,receiverId,notiDataIs.NotificationType,"IOS");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }else{
                                    let message = { 
                                        app_id: process.env.APP_ID,
                                        contents: {
                                            "en": bodyIs
                                        },
                                        headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                        data: notiDataIs,   
                                        content_available: 1,
                                        include_player_ids: [tokenIs.playerId],
                                        android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
                                    };
                                    sendOneSignalNotification(message,false,true,tokenIs.watchmanId,receiverId,notiDataIs.NotificationType,"Android");
                                    // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,false,tokenIs.memberId,responseWatchmanIdIs,notiDataIs.NotificationType,tokenIs.DeviceType);
                                }
                            });
                        }
    
                        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected By Receiver" });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Pass True / False for rejectBy Field" });
                    }

                }else{
                    return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Proper callFor Field In Calling" });
                }
            }else if(checkCall[0].callStatus == 1){

                let updateCall = {
                    callStatus: 3
                }

                if(checkCall[0].callFor == 0){
                    let senderId = checkCall[0].Caller.callerMemberId;
                    let receiverId = checkCall[0].Receiver.receiverMemberId;
    
                    let updateSender = await memberSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);
    
                    return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected" });
                }else if(checkCall[0].callFor == 1){
                    let senderId = checkCall[0].Caller.callerMemberId;
                    let receiverId = checkCall[0].Receiver.watchmanId;
    
                    let updateSender = await memberSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await watchmanSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);
    
                    return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected" });
                }else if(checkCall[0].callFor == 2){
                    let senderId = checkCall[0].Caller.watchmanId;
                    let receiverId = checkCall[0].Receiver.receiverMemberId;
    
                    let updateSender = await watchmanSchema.findByIdAndUpdate(senderId,update);
                    let updateReceiver = await memberSchema.findByIdAndUpdate(receiverId,update);

                    let updateCallStatus = await callingSchema.findByIdAndUpdate(callingId,updateCall);
    
                    return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Call Rejected" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Proper callFor Field In Calling" });
                }
            }else if(checkCall[0].callStatus == 2){
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "Call Already Completed" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Call Already Rejected" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Call Found" });
        }
 
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Watchman-----------------------------MONIL---------------------01/04/2021
router.post("/getAllWatchman",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(checkExistSociety.length == 1){
            let getWatchman = await watchmanSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);

            if(getWatchman.length > 0){
                return res.status(200).json({ IsSuccess: true , Count: getWatchman.length ,  Data: getWatchman , Message: "Watchman Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Watchman Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society found for societyId ${societyId}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Advertisement----------------------------MONIL---------------------01/04/2021
router.post("/addAdvertisement", advertiseImg.array("Image") , async function(req,res,next){
    try {
        const {
            Title, 
            Description,
            MemberId,
            vendorId,
            PackageId,
            ExpiryDate,
            advertiseFor,
            WebsiteURL,
            EmailId,
            VideoLink,
            societyIdList,
            areaIdList,
            cityList,
            GoogleMap,
            AdPosition,
            ContactNo,
            areaId
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const imageFiles = req.files;

        let imagePaths = [];

        imageFiles.forEach(image=>{
            imagePaths.push(image.path);
        });

        let addNews;

        if(advertiseFor == "society"){
            let tempList = societyIdList.split(",");
            let societyList = [];
            tempList.forEach(t=>{
                societyList.push(t.trim())
            });
            
            addNews = await new advertisementSchema({
                Title: Title,
                Description: Description,
                GoogleMap: GoogleMap,
                ContactNo: ContactNo,
                Image: imagePaths,
                MemberId: MemberId,
                vendorId: vendorId,
                ContactNo: ContactNo,
                PackageId: PackageId,
                ExpiryDate: ExpiryDate,
                advertiseFor: "society",
                WebsiteURL: WebsiteURL,
                EmailId: EmailId,
                VideoLink: VideoLink,
                societyIdList: societyList,
                AdPosition: AdPosition,
                areaId: areaId,
                advertiseNo: getAdvertiseNumber(),
                dateTime: getCurrentDateTime(),
            });
    
        }else if(advertiseFor == "area"){

            let tempList = areaIdList.split(",");
            let areaList = [];
            tempList.forEach(t=>{
                areaList.push(t.trim())
            });

            addNews = await new advertisementSchema({
                Title: Title,
                Description: Description,
                GoogleMap: GoogleMap,
                ContactNo: ContactNo,
                Image: imagePaths,
                MemberId: MemberId,
                PackageId: PackageId,
                ExpiryDate: ExpiryDate,
                advertiseFor: "area",
                WebsiteURL: WebsiteURL,
                EmailId: EmailId,
                VideoLink: VideoLink,
                AdPosition: AdPosition,
                areaIdList: areaList,
                advertiseNo: getAdvertiseNumber(),
                dateTime: getCurrentDateTime(),
            });
        }else if(advertiseFor == "city"){

            let tempList = cityList.split(",");
            let cityListIs = [];
            tempList.forEach(t=>{
                cityListIs.push(t.trim())
            });

            addNews = await new advertisementSchema({
                Title: Title,
                Description: Description,
                GoogleMap: GoogleMap,
                ContactNo: ContactNo,
                Image: imagePaths,
                MemberId: MemberId,
                PackageId: PackageId,
                ExpiryDate: ExpiryDate,
                advertiseFor: "city",
                WebsiteURL: WebsiteURL,
                EmailId: EmailId,
                VideoLink: VideoLink,
                cityList: cityListIs,
                AdPosition: AdPosition,
                advertiseNo: getAdvertiseNumber(),
                dateTime: getCurrentDateTime(),
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Please Provide society/area/city in advertiseFor field` })
        }
        
        if(addNews != null){
            try {
                await addNews.save();    
            } catch (error) {
                res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            
            res.status(200).json({ IsSuccess: true , Data: [addNews] , Message: `Advertise added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Advertise added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

router.post("/delete",async function(req,res,next){
    let deleteId = await advertisementSchema.deleteMany();
    return res.send("sdcjkdcn");
})

//Get Advertisement---------------------------MONIL--------------------14/04/2021
router.post("/getAdvertisement",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(societyId == null || societyId == undefined || societyId == ""){
            let getAds = await advertisementSchema.aggregate([
                {
                    $match: {}
                }
            ]);

            if(getAds.length > 0){
                return res.status(200).json({ IsSuccess: true , Count: getAds.length , Data: getAds , Message: "Advertisement Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Advertisement Found" });
            }
        }else{
            let checkSociety = await societySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(societyId) },
                            { areaId: { $exists: true } }
                        ]
                    }
                }
            ]);
    
            if(checkSociety.length == 1){
                let city = checkSociety[0].city;
                let areaId = checkSociety[0].areaId;
                let getAds = await advertisementSchema.aggregate([
                    {
                        $match: {
                            $or: [
                                { 
                                    cityList: city
                                },
                                {
                                    areaIdList: mongoose.Types.ObjectId(areaId)
                                },
                                {
                                    societyIdList: mongoose.Types.ObjectId(societyId)
                                }
                            ]
                        }
                    }
                ]);
    
                if(getAds.length > 0){
                    res.status(200).json({ IsSuccess: true , Count: getAds.length , Data: getAds , Message: "Advertisement Found" });
                }else{
                    res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Advertisement Found" });
                }
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society found for id ${societyId} / Or society have no areaId field` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Staff-------------------------------------MONIL--------------------26/04/2021
router.post("/getSocietyStaff",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(checkSociety.length == 1){
            let getStaff = await staffSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { isForSociety: true }
                        ]
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo1: 1,
                        staffCategory: 1,
                        entryNo: 1,
                        isMapped: 1,
                        isForSociety: 1,
                    }
                }
            ]);

            let getWatchman = await watchmanSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
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
                    $addFields: { staffCategory: "Watchman" }
                },
                {
                    $addFields: { isForSociety: true }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo1: 1,
                        staffCategory: 1,
                        isMapped: 1,
                        watchmanNo: 1,
                        "WingData.wingName": 1,
                        isForSociety: 1
                    }
                }
            ]);

            let staffAre = [...getStaff,...getWatchman]
    
            if(staffAre.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    StaffCount: getStaff.length,
                    WatchmanCount: getWatchman.length,
                    Total: Number(getStaff.length) + Number(getWatchman.length),
                    Data: staffAre, 
                    Message: "Society Staff & Watchman Data Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Staff Data Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All members staffs--------------------------------MONIL---------------------02/04/2021
router.post("/getStaffDetails",async function(req,res,next){
    try {
        const { societyId , staffId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(checkSociety.length == 1){

            if(staffId != undefined && staffId != null && staffId != ""){
                let getStaff = await staffSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { _id: mongoose.Types.ObjectId(staffId) },
                                { isForSociety: false }
                            ]
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
                    {
                        $project: {
                            Name: 1,
                            ContactNo1: 1,
                            staffCategory: 1,
                            entryNo: 1,
                            isMapped: 1,
                            "WingData.wingName": 1,
                            "FlatData.flatNo": 1,
                        }
                    }
                ]);

                if(getStaff.length == 1){
                    return res.status(200).json({ IsSuccess: true , Data: getStaff , Message: `Staff ${getStaff[0].Name} Details Found`});
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Staff Data Found`});
                }
            }else{
                let getStaff = await staffSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { isForSociety: false }
                            ]
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
                    {
                        $project: {
                            Name: 1,
                            ContactNo1: 1,
                            staffCategory: 1,
                            entryNo: 1,
                            isMapped: 1,
                            "WingData.wingName": 1,
                            "FlatData.flatNo": 1,
                        }
                    }
                ]);
        
                if(getStaff.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getStaff.length, 
                        Data: getStaff, 
                        Message: "Staff Data Found" 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Data Found" });
                }
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Staff--------------------------MONIL----------------------07/05/2021
router.post("/getStaffCategorywise",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaff = await staffCategorySchema.aggregate([
            {
                $lookup: {
                    from: "staffrecords",
                    let: { categoryName: "$staffCategoryName" },
                    pipeline: [
                        { 
                            $match:
                                {
                                    $and: [
                                        { $expr: { $eq: [ "$$categoryName", "$staffCategory" ] } },
                                        { societyId: mongoose.Types.ObjectId(societyId) }
                                    ]
                                }
                        },
                        {
                            $lookup: {
                                from: "staffratings",
                                localField: "_id",
                                foreignField: "staffId",
                                as: "Ratings"
                            }
                        },
                        {
                            $addFields: { TotalRatings: { $size: "$Ratings" } }
                        },
                        {
                            $lookup: {
                                from: "flats",
                                let: { workArea: "$workingLocation" },
                                pipeline: [
                                    { 
                                        $match:
                                            { 
                                                $expr: { $in: [ "$_id" , "$$workArea.flatId" ] }
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
                                            "WingData._id": 1,
                                            "WingData.wingName": 1,
                                        }
                                    }
                                ],
                                as: "FlatData"
                            }
                        },
                        {
                            $addFields: { NoOfWorkingFlats: { $size: "$FlatData" } }
                        },
                        {
                            $project: {
                                Name: 1,
                                ContactNo1: 1,
                                Gender: 1,
                                entryNo: 1,
                                isForSociety: 1,
                                staffImage: 1,
                                Address: 1,
                                isMapped: 1,
                                societyId: 1,
                                "Ratings.review": 1,
                                "Ratings.dateTime": 1,
                                "Ratings.rating": 1,
                                TotalRatings: 1,
                                AverageRating: {
                                    $round: [ { $toDouble: { $avg: "$Ratings.rating" } } , 1 ]
                                },
                                FlatData: 1,
                                NoOfWorkingFlats: 1
                            }
                        }
                    ],
                    as: "StaffData"
                }
            },
            {
                $addFields: { StaffCount: { $size: "$StaffData" } }
            }
        ]);

        if(getStaff.length > 0){
            return res.status(200).json({ IsSuccess: true , category: getStaff.length, Data: getStaff , Message: "Staff Data Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: getStaff , Message: "No Staff Data Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Approve or DisApprove Visitor---------------MONIL----------------------02/04/2021
//response - 0 - Waiting for approval  
//response - 1 - Accepted  
//response - 2 - Rejected  
router.post("/responseToVisitorEntry",async function(req,res,next){
    try {
        const { entryId , response , entryNo , memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(entryNo != undefined && entryNo != null && entryNo != ""){
            let isGuest = entryNo.includes("GUEST");
            let isStaff = entryNo.includes("STAFF");
            let isVendor = entryNo.includes("VENDOR");

            if(isGuest == true){
                let guestData = await guestEntrySchema.aggregate([
                    {
                        $match: {
                            _id: mongoose.Types.ObjectId(entryId)
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
                    }
                ]);

                if(guestData.length == 1){
                    if(response == 1){
                        let update = {
                            status: 1
                        }
                        let watchmanId = guestData[0].watchmanId;
                        let memberIdIs = guestData[0].memberId;
                        let flatId = guestData[0].flatId;
                        let societyId = guestData[0].societyId;
                        let updateEntry = await guestEntrySchema.findByIdAndUpdate(entryId,update);

                        let memberOfFlat = await memberSchema.aggregate([
                            {
                                $match: {
                                    _id: mongoose.Types.ObjectId(memberId)
                                }
                            },
                            {
                                $project: {
                                    Name: 1
                                }
                            }
                        ]);

                        let memberName;

                        if(memberOfFlat.length == 1){
                            memberName = memberOfFlat[0].Name;
                        }

                        let watchmanToken = await getSingleWatchmanPlayerId(watchmanId);
                        let WingName = guestData[0].WingData[0].wingName;
                        let FlatName = guestData[0].FlatData[0].flatNo;

                        let titleIs = `Notification - Visitor Accepted`;
                        let bodyIs = `Visitor with EntryNo ${guestData[0].entryNo} is verified , Please let him/her come to society`;

                        let notiDataIs = {
                            NotificationType: "VisitorAccepted",
                            EntryNo: guestData[0].entryNo,
                            EntryId: entryId,
                            Status: "Accepted",
                            Wing: WingName,
                            Flat: FlatName,
                            memberName: memberName,
                            muteNotificationAudio: false,
                            Message: `Visitor with EntryNo ${guestData[0].entryNo} is verified , Please let him/her come to society`,
                            content_available: true, 
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                            view: "ghj" 
                        }
                        watchmanToken.forEach(tokenIs =>{
                            let message = { 
                                app_id: process.env.APP_ID_W,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "880b4ef8-2179-4804-896a-b6e54d571308"
                            };
                            sendOneSignalNotification(message,false,true,tokenIs.watchmanId,memberIdIs,"VisitorAccepted",tokenIs.DeviceType);
                            // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,memberIdIs,"VisitorAccepted",tokenIs.DeviceType);
                        });
                        return res.status(200).json({ IsSuccess: true , Data: [notiDataIs] , Message: `Visitor Entry Verify` });
                    }else if(response == 2){
                        let update = {
                            status: 2
                        }
                        let watchmanId = guestData[0].watchmanId;
                        let memberIdIs = guestData[0].memberId;
                        let updateEntry = await guestEntrySchema.findByIdAndUpdate(entryId,update);

                        let watchmanToken = await getSingleWatchmanPlayerId(watchmanId);

                        let memberOfFlat = await memberSchema.aggregate([
                            {
                                $match: {
                                    _id: mongoose.Types.ObjectId(memberId)
                                }
                            },
                            {
                                $project: {
                                    Name: 1
                                }
                            }
                        ]);

                        let memberName;

                        if(memberOfFlat.length == 1){
                            memberName = memberOfFlat[0].Name;
                        }

                        let WingName = guestData[0].WingData[0].wingName;
                        let FlatName = guestData[0].FlatData[0].flatNo;

                        let titleIs = `Notification - Visitor Rejected`;
                        let bodyIs = `Visitor with EntryNo ${guestData[0].entryNo} is Rejected , Don't let him/her come to society`;

                        let notiDataIs = {
                            NotificationType: "VisitorRejected",
                            EntryNo: guestData[0].entryNo,
                            EntryId: entryId,
                            Status: "Rejected",
                            Wing: WingName,
                            Flat: FlatName,
                            memberName: memberName,
                            muteNotificationAudio: false,
                            Message: `Guest with EntryNo ${guestData[0].entryNo} is Rejected , Don't let him/her come to society`,
                            content_available: true, 
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                            view: "ghj" 
                        }

                        watchmanToken.forEach(tokenIs =>{
                            let message = { 
                                app_id: process.env.APP_ID_W,
                                contents: {
                                    "en": bodyIs
                                },
                                headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                                data: notiDataIs,   
                                content_available: 1,
                                include_player_ids: [tokenIs.playerId],
                                android_channel_id: "880b4ef8-2179-4804-896a-b6e54d571308"
                            };
                            sendOneSignalNotification(message,false,true,tokenIs.watchmanId,memberIdIs,"VisitorRejected",tokenIs.DeviceType);
                            // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,memberIdIs,"VisitorRejected",tokenIs.DeviceType);
                        });
                        return res.status(200).json({ IsSuccess: true , Data: [notiDataIs] , Message: `Visitor Entry Rejected` });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `Please provide valid response` });
                    }
                    
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Visitor Data Found" });
                }
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Polling Question of society------------------------MONIL----------------------24/03/2021
router.post("/getAllPollingQuestion",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getPollQuestion = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "pollingoptions",
                    localField: "_id",
                    foreignField: "pollQuestionId",
                    as: "PollOptions"
                }
            },
            {
                $project: {
                    "PollOptions.pollQuestionId" : 0,
                    "PollOptions.__v" : 0,
                    __v : 0,
                }
            }
        ]);

        if(getPollQuestion != null){
            res.status(200).json({ IsSuccess: true , Count: getPollQuestion.length , Data: getPollQuestion , Message: `Poll Questions Found for societyId ${societyId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll Questions Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Answer to poll Question-----------------------MONIL-------------------24/03/2021
router.post("/answerOfPollQuestion",async function(req,res,next){
    try {
        const { pollQuestionId , pollOptionId , memberId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let pollingQuestionIs = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(pollQuestionId) },
                        { isActive: true },
                        {
                            "pollFor.wingId": {
                                $elemMatch: {
                                    $eq: mongoose.Types.ObjectId(wingId)
                                }
                            }
                        }
                    ]
                }
            },
            {
                $project: {
                    isActive: 1,
                    societyId: 1,
                }
            }
        ]);

        if(pollingQuestionIs.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Active Poll question found for pollQuestionId ${pollQuestionId}` });
        }

        let checkExist = await pollingAnswersSchema.aggregate([
            {
                $match: {
                    $and: [
                        { pollQuestionId: mongoose.Types.ObjectId(pollQuestionId) },
                        { pollOptionId: mongoose.Types.ObjectId(pollOptionId) },
                        { responseByMembers: mongoose.Types.ObjectId(memberId) },
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Your answer already submitted` });
        }

        let answerIs = await new pollingAnswersSchema({
            pollQuestionId: pollQuestionId,
            pollOptionId: pollOptionId,
            responseByMembers: memberId,
            dateTime: getCurrentDateTime(),
        });

        if(answerIs != null){
            answerIs.save();
            res.status(200).json({ IsSuccess: true , Data: [answerIs] , Message: "Your answer submitted" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Your answer not submitted" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Search Member-------------------------------MONIL---------------------04/04/2021
router.post("/searchInMember",async function(req,res,next){
    try {
        const { societyId , searchData } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const query = {
            "society.societyId": mongoose.Types.ObjectId(societyId),
            $or: [
                { 
                    MemberNo: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    WorkType: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    Gender: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    Name: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    ContactNo: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    OfficeAddress: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    CompanyName: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    OfficeAlternateNo: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    OfficeContact: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    OfficeEmail: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    Designation: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    EmailId: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    BloodGroup: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    Township: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    "WingData.wingName": {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    "FlatData.flatNo": {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
            ]
        };

        const result = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "society.wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "society.flatId",
                    foreignField: "_id",
                    as: "FlatData"
                }
            },
            {
                $match: query
            },
            {
                $project: {
                    "WingData.totalFloor": 0,
                    "WingData.maxFlatPerFloor": 0,
                    "WingData.totalFloor": 0,
                    "WingData.__v": 0,
                    "FlatData.memberIds": 0,
                    "FlatData.parkingSlotNo": 0,
                    "FlatData.societyId": 0,
                    "FlatData.wingId": 0,
                    "FlatData.__v": 0,
                }
            }
        ]);

        if(result.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: result.length , Data: result , Message: `Search results found for ${searchData}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Search results found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Complain By Member------------------------MONIL--------------04/02/2021
router.post("/addComplain", complainAttachmentIs.single("attachment") , async function(req,res,next){
    try {
        const { societyId , memberId , complainCategory , description , title , deviceType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let getComplainCategoryName = await complainCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(complainCategory)
                }
            }
        ]);

        let addComplain = await new complainSchema({
            societyId: societyId,
            memberId: memberId,
            complainCategory: complainCategory,
            complainCategoryName: getComplainCategoryName[0].complainName,
            title: title,
            description: description,
            complainNo: getComplainNumber(),
            complainStatus: 0,
            dateTime: getCurrentDateTime(),
            attachment: file != undefined ? file.path : "",
        });

        if(addComplain != null){
            addComplain.save();

            let complainMemberIs = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(memberId) },
                            { "society.societyId": mongoose.Types.ObjectId(societyId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "wings",
                        localField: "society.wingId",
                        foreignField: "_id",
                        as: "WingData"
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        localField: "society.flatId",
                        foreignField: "_id",
                        as: "FlatData"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        MemberNo: 1,
                        ContactNo: 1,
                        EmailId: 1,
                        "WingData.wingName": 1,
                        "FlatData.flatNo": 1,
                    }
                }
            ]);
            
            let adminsList = await getSocietyAdmin(societyId);

            let adminIds = [];
            adminsList.forEach(dataIs=>{
                adminIds.push(dataIs._id)
            });

            let adminTokens = await getMemberPlayerId(adminIds);
            // console.log(adminTokens);
            let titleIs = `New Complain : ${addComplain.complainNo}`;
            let bodyIs = `About Complain: ${addComplain.description}`;

            let notiDataIs = {
                notificationType: "SendComplainToAdmin",
                ComplainNo: addComplain.complainNo,
                ComplainCategory: addComplain.complainCategoryName,
                MemberName: complainMemberIs[0].Name,
                MemberMemberNo: complainMemberIs[0].MemberNo,
                MemberContactNo: complainMemberIs[0].ContactNo,
                MemberEmailId: complainMemberIs[0].EmailId,
                MemberWing: complainMemberIs[0].WingData[0].wingName,
                MemberFlat: complainMemberIs[0].FlatData[0].flatNo,
                content_available: true, 
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                view: "ghj"
            }

            adminTokens.forEach(tokenIs=>{
                if(tokenIs.muteNotificationAudio == false){
                    if(tokenIs.DeviceType == "IOS"){
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            ios_sound: "notification-_2_.wav"
                        };
                        
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,memberId,"SendComplainToAdmin",tokenIs.DeviceType);
                    }else{
                        let message = { 
                            app_id: process.env.APP_ID,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                        };
                        
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,memberId,"SendComplainToAdmin",tokenIs.DeviceType);
                    }
                }
                
                // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,memberId,"SendComplainToAdmin",tokenIs.DeviceType);
            });

            res.status(200).json({ IsSuccess: true , Data: [addComplain] , Message: `Complain with Complain No. ${addComplain.complainNo} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Complain Not Added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
}); 

//Get All Complain------------------------------MONIL--------------04/02/2021
router.post("/getAllComplain", async function(req,res,next){
    try {
        const { societyId , memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getComplain = await complainSchema.aggregate([
            {
                $match: {
                    $and: [
                        { memberId: mongoose.Types.ObjectId(memberId) },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                    ]
                }
            }
        ]);

        if(getComplain.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getComplain.length , Data: getComplain , Message: "All Member Complains Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Complains Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Delete Complain------------------------------MONIL-------------------05/04/2021
router.post("/deleteComplain",async function(req,res,next){
    try {
        const { complainId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getComplain = await complainSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(complainId)
                }
            }
        ]);

        if(getComplain.length == 1){
            let deleteComplain = await complainSchema.findByIdAndDelete(complainId);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Complain with Complain No ${getComplain[0].complainNo}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Complain Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Add Reminder Category-------------------MONIL--------------------13/04/2021
router.post("/addReminderCategory", reminderCategoryIs.single("image") ,async function(req,res,next){
    try {
        const { ReminderName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await reminderCategorySchema.aggregate([
            {
                $match: {
                    ReminderName: ReminderName
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Category ${ReminderName} already exist` });
        }

        const file = req.file;

        let addReminderCategory = await new reminderCategorySchema({
            ReminderName: ReminderName,
            image: file != undefined ? file.path : ""
        });

        if(addReminderCategory != null){
            addReminderCategory.save();
            res.status(200).json({ IsSuccess: true , Data: [addReminderCategory] , Message: `Reminder Category ${ReminderName} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Category ${ReminderName} not Added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get All Reminder Category----------------MONIL-------------13/04/2021
router.post("/getReminderCategory",async function(req,res,next){
    try {
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getReminderCategory = await reminderCategorySchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getReminderCategory.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getReminderCategory.length , Data: getReminderCategory , Message: "Reminder Categories Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Reminder Categories Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get Member Notifications------------------MONIL-------------------19/04/2021
router.post("/getMemberNotification",async function(req,res,next){
    try {
        const { memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberNotification = await notificationSchema.aggregate([
            {
                $match: {
                    memberId: mongoose.Types.ObjectId(memberId)
                }
            },
            {
                $sort: { dateTime: -1 }
            }
        ]); 

        if(getMemberNotification.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getMemberNotification.length , Data: getMemberNotification , Message: "Member Notification Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: getMemberNotification , Message: "Member Notification Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Add Reminder------------------------------MONIL-------------------13/04/2021
//ScheduleType - 0 => Hours 
//ScheduleType - 1 => SpecificDate 
//ScheduleType - 2 => Daily 
//ScheduleType - 3 => Weekly 
//ScheduleType - 4 => Monthly 
router.post("/addReminder",async function(req,res,next){
    try {
        const { ReminderCategoryId , ScheduleType , Title , Note , ScheduleDate , every_hours , ScheduledTime } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getReminderCategory = await reminderCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(ReminderCategoryId)
                }
            }
        ]);

        if(getReminderCategory.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Reminder Category found for id: ${ReminderCategoryId}` });
        }

        let ReminderName = getReminderCategory[0].ReminderName;

        if(ScheduleType == 0){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 0,
                Hourly: {
                    ScheduleDate: ScheduleDate,
                    every_hours: every_hours
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                // addReminder.save(); 
                
                return res.status(200).json({ IsSuccess: true , Data: [addReminder] , Message: `Every ${every_hours}` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }
        }else if(ScheduleType == 1){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 1,
                Today: {
                    ScheduleDate: ScheduleDate,
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            });
            
            if(addReminder != null){
                addReminder.save();
                
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [addReminder], 
                    Message: `Reminder Add for ${ScheduleDate} - ${ScheduledTime}` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }

        }else if(ScheduleType == 2){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 2,
                Tomorrow: {
                    ScheduleDate: ScheduleDate,
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                addReminder.save();
                return res.status(200).json({ 
                    IsSuccess: true,
                    Data: [addReminder], 
                    Message: `Reminder Add for ${ScheduleDate} - ${ScheduledTime}` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }
        }else if(ScheduleType == 3){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 3,
                SpecificDate: {
                    ScheduleDate: ScheduleDate,
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                addReminder.save();
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [addReminder], 
                    Message: `Reminder Add for ${ScheduleDate} - ${ScheduledTime}` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }
        }else if(ScheduleType == 4){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 4,
                Daily: {
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                addReminder.save();
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [addReminder], 
                    Message: `Everyday ${ScheduledTime} Reminder Add` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }
        }else if(ScheduleType == 5){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 0,
                Weekly: {
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                addReminder.save();
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [addReminder], 
                    Message: `Weekly ${ScheduledTime} Reminder Add` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }

        }else if(ScheduleType == 6){
            let addReminder = await new reminderSchema({
                ReminderCategoryId: ReminderCategoryId,
                ReminderName: ReminderName,
                Title: Title,
                Note: Note,
                ScheduleType: 0,
                Monthly: {
                    ScheduledTime: ScheduledTime
                },
                dateTime: getCurrentDateTime()
            }); 

            if(addReminder != null){
                addReminder.save();
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [addReminder], 
                    Message: `Monthly ${ScheduledTime} Reminder Add` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Reminder Adding faild` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide Valid ScheduleType Value" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

// CRON_JOB for every hour Reminder
// cron.schedule('*/1 * * * *',async function(){
//     console.log('running a task every hour');

//     // let getTodaysReminders = await reminderSchema.aggregate([
//     //     {
//     //         $match: {
//     //             ScheduleType: 
//     //         }
//     //     }
//     // ]);

//     const rule = new schedule.RecurrenceRule();
//     rule.date = 15;
//     rule.month = 3;
//     rule.year = 2021;
//     rule.hour = 13;
//     rule.minute = 10;
//     // rule.second = 2021;

//     schedule.scheduleJob(rule,()=>{
//         console.log("==================HERE========================")
//         let currentDateTime = getCurrentDateTime();
//         console.log(currentDateTime);
//     });
    
// });

//Get Member Details-------------------------MONIL--------------------13/04/2021
router.post("/getMemberInformation",async function(req,res,next){
    try {
        const { memberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMember = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(memberId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) }
                    ]
                }
            },
            {
                $lookup: {
                    from: "societies",
                    localField: "society.societyId",
                    foreignField: "_id",
                    as: "SocietyData"
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo: 1,
                    "SocietyData.societyCode": 1   
                }
            }
        ]);

        if(getMember.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getMember , Message: "Member Details Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Details Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Only Full fill Flats----------------------MONIL-----------17/04/2021
router.post('/getOccupiedFlats',async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getFlats;
        if(wingId != null && wingId != undefined && wingId != ""){
            
            getFlats = await flatSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { wingId: mongoose.Types.ObjectId(wingId) },
                            { parentMember: { $exists: true } }
                        ]
                    }
                }
            ]);
        }else{
            getFlats = await flatSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { parentMember: { $exists: true } }
                        ]
                    }
                }
            ]);
        }

        if(getFlats.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: getFlats.length , Data: getFlats , Message: "Flat Data Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Flat Data Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Flat Member-----------------MONIL-----------------------17/04/2021
router.post("/getFlatMember",async function(req,res,next){
    try {
        const { flatIdList } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let dataSend = [];
        for(let i=0;i<flatIdList.length;i++){
            let flatId = String(flatIdList[i]);
            let getFlat = await flatSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(flatId)
                    }
                }
            ]);

            if(getFlat.length == 1){
                dataSend.push(getFlat[0]);
            }
        }

        if(dataSend.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: dataSend.length , Data: dataSend , Message: "Flat Members Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Flat Members Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Response To Unknown Visitor Entry-------------------------Monil---------18/04/2021
router.post("/responseToUnknownVisitorEntry",async function(req,res,next){
    try {
        const { entryId , memberId , societyId , response , flatId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVisitor = await unknownVisitorSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(entryId) },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                    ],
                }
            }
        ]);

        if(getVisitor.length == 1){
            let watchmanId = getVisitor[0].watchmanId;

            let getMemberFlat = await flatSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(flatId)
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
                        "WingData.wingName": 1,
                    }
                }
            ]);

            if(response == true){
                let titleIs = `Call Accepted`;
                let bodyIs = `Response Regarding Visitor EntryNo: ${getVisitor[0].entryNo}`;

                let notiDataIs = {
                    Message: "Response Regarding Visitor Entry",
                    EntryId: entryId,
                    CallStatus: "Accepted",
                    EntryNo: getVisitor[0].entryNo,
                    Wing: getMemberFlat[0].WingData[0].wingName,
                    Flat: getMemberFlat[0].flatNo,
                    notificationType: "UnknownVisitor",
                    watchmanId: watchmanId,
                    muteNotificationAudio: false,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                let watchmanTokens = await getSingleWatchmanPlayerId(watchmanId);
                
                if(watchmanTokens.length > 0){
                    
                    watchmanTokens.forEach(tokenIs=>{
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "880b4ef8-2179-4804-896a-b6e54d571308"
                        };
                        
                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,memberId,"UnknownVisitor",tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,memberId,"UnknownVisitor",tokenIs.DeviceType);
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: notiDataIs , Message: "Call Accepted" });
            }else if(response == false){
                let titleIs = `Call Rejected`;
                let bodyIs = `Response Regarding Visitor EntryNo: ${getVisitor[0].entryNo}`;

                let notiDataIs = {
                    Message: "Response Regarding Visitor Entry",
                    EntryId: entryId,
                    CallStatus: "Rejected",
                    EntryNo: getVisitor[0].entryNo,
                    notificationType: "UnknownVisitor",
                    watchmanId: watchmanId,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                let watchmanTokens = await getSingleWatchmanPlayerId(watchmanId);

                if(watchmanTokens.length > 0){
                    watchmanTokens.forEach(tokenIs=>{
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            android_channel_id: "880b4ef8-2179-4804-896a-b6e54d571308"
                        };
                        
                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,memberId,"UnknownVisitor",tokenIs.DeviceType);
                        // sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,false,true,tokenIs.watchmanId,memberId,"UnknownVisitor",tokenIs.DeviceType);
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: notiDataIs , Message: "Call Rejected" });

            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Pass true/false for Response Field" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Visitor Found for ${entryId}` });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Properties---------------------MONIL---------------------20/04/2021
router.post("/getMemberProperties",async function(req,res,next){
    try {
        const { memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getProperties = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    _id: mongoose.Types.ObjectId(memberId)
                }
            },
            {
                $lookup: {
                    from: "flats",
                    let: { flatId: "$society.flatId"},
                    pipeline: [
                        { 
                            $match:
                                { 
                                    $expr: { $eq: [ "$$flatId", "$_id" ] }
                                }
                        },
                        {
                            $lookup: {
                                from: "societies",
                                localField: "societyId",
                                foreignField: "_id",
                                as: "SocietyData"
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
                                residenceType: 1,
                                "SocietyData.Name": 1,
                                "SocietyData._id": 1,
                                "SocietyData.stateCode": 1,
                                "SocietyData.city": 1,
                                "SocietyData.IsActive": 1,  
                                "SocietyData.Address": 1,  
                                "SocietyData.societyCode": 1,
                                "WingData.wingName": 1,
                                "WingData._id": 1,
                            }
                        }
                    ],
                    as: "Property"
                }
            },
            {
                $project: {
                    MemberNo: 1,
                    Name: 1,
                    ContactNo: 1,
                    Property: 1,
                }
            }
        ]);

        if(getProperties.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getProperties , Message: "Member Properties Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Registered Events---------------MONIL--------------------23/04/2021
router.post("/getMemberRegisterEvents",async function(req,res,next){
    try {
        const { memberId , eventId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(eventId != undefined && eventId != null && eventId != ""){
            let getMemberEvents = await eventRegistrationSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { eventId: mongoose.Types.ObjectId(eventId) },
                            { memberId: mongoose.Types.ObjectId(memberId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "events",
                        localField: "eventId",
                        foreignField: "_id",
                        as: "EventDetails"
                    }
                }
            ]);

            if(getMemberEvents.length > 0){
                return res.status(200).json({ IsSuccess: true , Data: getMemberEvents , Message: "Member Register Events Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Register Events Found" });
            }
        }else{
            let getMemberEvents = await eventRegistrationSchema.aggregate([
                {
                    $match: {
                        memberId: mongoose.Types.ObjectId(memberId)
                    }
                },
                {
                    $lookup: {
                        from: "events",
                        localField: "eventId",
                        foreignField: "_id",
                        as: "EventDetails"
                    }
                }
            ]);
    
            if(getMemberEvents.length > 0){
                return res.status(200).json({ IsSuccess: true , Data: getMemberEvents , Message: "Member Register Events Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Register Events Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Plasma Record---------------------------MONIL-------------------20/04/2021
router.post("/addPlasmaDonar",async function(req,res,next){
    try {
        const { 
            DonarName, 
            MobileNo, 
            City, 
            State, 
            Gender, 
            DOB, 
            CovidHistory,
            CovidPositiveDate,
            Weight, 
            BloodGroup, 
            PlasmaDonationBefore,
            LastPlasmaDonationDate,
            IsVaccinated,
            DateOfVaccination
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let addDonar = await new plasmaDonarsSchema({
            DonarName: DonarName,
            MobileNo: MobileNo,
            City: City,
            State: State,
            Gender: Gender,
            DOB: DOB,
            CovidHistory: CovidHistory,
            CovidPositiveDate: CovidHistory == true ? CovidPositiveDate : "",
            Weight: parseFloat(Weight),
            BloodGroup: BloodGroup,
            PlasmaDonationBefore: PlasmaDonationBefore,
            LastPlasmaDonationDate: PlasmaDonationBefore == false ? "" : LastPlasmaDonationDate,
            IsVaccinated: IsVaccinated,
            DateOfVaccination: IsVaccinated == false ? "" : DateOfVaccination,
            dateTime: getCurrentDateTime()
        });

        if(addDonar != null){
            addDonar.save();
            res.status(200).json({ IsSuccess: true , Data: [addDonar] , Message: "Donar Added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Donar Added" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Donars---------------------------------MONIL--------------------20/04/2021
router.post("/getDonars",async function(req,res,next){
    try {
        const { City , State } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDonars;

        if(City != undefined && City != null && City != "" && State != undefined && State != null && State != ""){
            getDonars = await plasmaDonarsSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { City: City },
                            { State: State },
                        ]
                    }
                }
            ])
        }else{
            getDonars = await plasmaDonarsSchema.aggregate([
                {
                    $match: {}
                }
            ]);
        }

        if(getDonars.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getDonars , Message: "Donars Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Donars Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Notification Setting----------------------MONIL---------------------21/04/2021
router.post("/setMemberPreferences",async function(req,res,next){
    try {
        const { memberId , muteNotificationAudio , playerId , AnniversaryDate , Email , Contact , DateOfBirth } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let updateInMemberIs = {
            Private: {
                EmailId: Email,
                ContactNo: Contact,
                DOB: DateOfBirth,
                AnniversaryDate: AnniversaryDate
            }
        }

        let updateMember = await memberSchema.findByIdAndUpdate(memberId,updateInMemberIs)

        let getMemberToken = await memberTokenSchema.aggregate([
            {
                $match: {
                    $and: [
                        { memberId: mongoose.Types.ObjectId(memberId) },
                        { playerId: playerId }
                    ]
                }
            }
        ]);

        if(getMemberToken.length > 0){
            let update;
            if(muteNotificationAudio == true){
                update = {
                    muteNotificationAudio: true
                }
            }else if(muteNotificationAudio == false){
                update = {
                    muteNotificationAudio: false
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `Please Passed true / false to getNotifications field` });
            }

            let updateSetting = await memberTokenSchema.findByIdAndUpdate(getMemberToken[0]._id,update);

        }
        
        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Member Preferences Updated` });

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Notification Setting------------------MONIL---------------------22/04/2021
router.post("/getMemberPreferences",async function(req,res,next){
    try {
        const { memberId , fcmToken } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getToken;

        if(fcmToken != undefined && fcmToken != null && fcmToken != ""){
            getToken = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(memberId)
                    }
                },
                {
                    $lookup: {
                        from: "membertokens",
                        pipeline: [
                            {
                                $match: {
                                    $and: [
                                        { memberId: mongoose.Types.ObjectId(memberId) },
                                        { fcmToken: fcmToken }
                                    ]
                                }   
                            },
                            {
                                $project: {
                                    fcmToken: 1,
                                    memberId: 1,
                                    mobileNo: 1,
                                    DeviceType: 1,
                                    muteNotificationAudio: 1
                                }
                            }
                        ],
                        as: "MemberTokens"
                    }
                },
                {
                    $project: {
                        Private: 1,
                        MemberNo: 1,
                        Name: 1,
                        ContactNo: 1,
                        MemberTokens: 1
                    }
                }
            ]);
        }else{
            getToken = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(memberId)
                    }
                },
                {
                    $lookup: {
                        from: "membertokens",
                        localField: "_id",
                        foreignField: "memberId",
                        as: "MemberTokens"
                    }
                },
                {
                    $project: {
                        Private: 1,
                        MemberNo: 1,
                        Name: 1,
                        ContactNo: 1,
                        MemberTokens: 1
                    }
                }
            ]);
        }

        if(getToken.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getToken , Message: "Member Preference Settings Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Emergency Contact Number--------------MONIL-------------24/04/2021
router.post("/getSocietyEmergencyContacts",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getContacts = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        // let getGeneralContacts = await emergencyContactsSchemas.aggregate([
        //     {
        //         $match: {
        //             societyId: mongoose.Types.ObjectId(societyId)
        //         }
        //     }
        // ]);

        if(getContacts.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: getContacts.length, 
                Data: getContacts,
                Message: "Society Emergency Contacts Founds" 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Emergency Contacts found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Emergency Contact Number--------------MONIL-------------24/04/2021
router.post("/getSocietyEmergencyContacts_v1",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getContacts = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getGeneralContacts = await emergencyContactsSchema.aggregate([
            {
                $match: {}
            },
            {
                $project: {
                    ContactNo: "$contactNo",
                    Name: "$contactName",
                    image: 1,
                }
            }
        ]);

        let contacts = [...getGeneralContacts,...getContacts];

        if(contacts.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: contacts.length, 
                Data: contacts,
                Message: "Society Emergency Contacts Founds" 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Emergency Contacts found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Member Parcel--------------MONIL--------------18/05/2021
router.post("/addMyParcel",async function(req,res,next){
    try {
        const { memberId , societyId , parcelFrom , date , description } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let addParcel = await new memberParcelSchema({
            memberId: memberId,
            societyId: societyId,
            parcelFrom: parcelFrom,
            description: description,
            date: date,
            dateTime: getCurrentDateTime()
        });

        if(addParcel != null){
            try {
                await addParcel.save();
                return res.status(200).json({ IsSuccess: true , Data: [addParcel] , Message: "Member Parcel Added" });
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }            
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Parcel Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Parcels----------------MONIL--------------18/05/2021
router.post("/getMemberParcel",async function(req,res,next){
    try {
        const { memberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }   
        
        if(societyId != undefined && societyId != null && societyId != "" && (memberId == undefined || memberId == null || memberId == "")){
            let getParcels = await memberParcelSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: {
                        from: "members",
                        let: { memberId: "$memberId"},
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$memberId", "$_id" ] }
                                    }
                            },
                            {
                                $lookup: {
                                    from: "flats",
                                    let: { society: "$society" },
                                    pipeline: [
                                        { 
                                            $match:
                                                { 
                                                    $expr: { $in: [ "$_id" , "$$society.flatId" ] }
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
                                                "WingData._id": 1,
                                                "WingData.wingName": 1,
                                            }
                                        }
                                    ],
                                    as: "FlatData"
                                }
                            },
                            {
                                $project: {
                                    Name: 1,
                                    ContactNo: 1,
                                    FlatData: 1,
                                }
                            }
                        ],  
                        as: "Member"
                    }
                }
            ]);

            if(getParcels.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getParcels.length, 
                    Data: getParcels, 
                    Message: "Society Parcels Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Parcels Found" });
            }
        }else if(societyId != undefined && societyId != null && societyId != "" && memberId != undefined && memberId != null && memberId != ""){
            let getParcels = await memberParcelSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { memberId: mongoose.Types.ObjectId(memberId) }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "members",
                        let: { memberId: "$memberId"},
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$memberId", "$_id" ] }
                                    }
                            },
                            {
                                $lookup: {
                                    from: "flats",
                                    let: { society: "$society" },
                                    pipeline: [
                                        { 
                                            $match:
                                                { 
                                                    $expr: { $in: [ "$_id" , "$$society.flatId" ] }
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
                                                "WingData._id": 1,
                                                "WingData.wingName": 1,
                                            }
                                        }
                                    ],
                                    as: "FlatData"
                                }
                            },
                            {
                                $project: {
                                    Name: 1,
                                    ContactNo: 1,
                                    FlatData: 1,
                                }
                            }
                        ],  
                        as: "Member"
                    }
                }
            ]);

            if(getParcels.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getParcels.length, 
                    Data: getParcels, 
                    Message: "Member Parcels Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Parcels Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Parcel Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

router.post("/sendNoti",async function(req,res,next){
    try {

        const { memberId , type } = req.body;
        
        let getMemberToken = await getMemberPlayerId([memberId]);
        let data = {
            Name: "Hello Ashish Bhai"
        }
        getMemberToken.forEach(tokenIs=>{
            console.log("Normal");
            let message = { 
                app_id: process.env.APP_ID,
                contents: {
                    "en": "Body"
                },
                headings: {"en": `Hello`, "es": "Spanish Title"},
                data: data,   
                content_available: 1,
                include_player_ids: ["7b37c9b8-5f78-4d51-bbb3-48f65ad07d90","a7af645f-5ec0-4c3e-81f1-3f5d1232d0af"],
                buttons: [{ /* Buttons */
                    /* Choose any unique identifier for your button. The ID of the clicked button is passed to you so you can identify which button is clicked */
                    id: 'like-button',
                    /* The text the button should display. Supports emojis. */
                    text: 'Like',
                    /* A valid publicly reachable URL to an icon. Keep this small because it's downloaded on each notification display. */
                    icon: 'http://i.imgur.com/N8SN8ZS.png',
                    /* The URL to open when this action button is clicked. See the sections below for special URLs that prevent opening any window. */
                    url: 'https://example.com/?_osp=do_not_open'
                  },
                  {
                    id: 'read-more-button',
                    text: 'Read more',
                    icon: 'http://i.imgur.com/MIxJp1L.png',
                    url: 'https://example.com/?_osp=do_not_open'
                  }],
                android_channel_id: "ac902738-f0b1-495e-8fe3-be54786d8f0c"
            };
            sendOneSignalNotification(message,true,true);
        });
        res.send("Send");
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Remove Member Staff-------------------------MONIL--------------------24/04/2021
router.post("/removeMemberStaff",async function(req,res,next){
    try {
        const { staffId , societyId , flatId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaff = await staffSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { _id: mongoose.Types.ObjectId(staffId) }
                    ]
                }
            }
        ]);

        if(getStaff.length == 1){
            let staffWorkLocation = getStaff[0].workingLocation;

            if(staffWorkLocation.length > 1){
                let removeWorkLocation = await staffSchema.updateOne(
                    { _id: mongoose.Types.ObjectId(staffId) },
                    { 
                        $pull: { 
                            workingLocation: {
                                wingId: mongoose.Types.ObjectId(wingId),
                                flatId: mongoose.Types.ObjectId(flatId)
                            } 
                        }
                    },
                    { multi: true }
                );

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff ${getStaff[0].Name} removed from your Flat` });
            }else{
                let removeStaffRecord = await staffSchema.findByIdAndDelete(staffId);
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff ${getStaff[0].Name} Deleted From Society` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
})

//Log out API---------------------------------MONIL--------------------05/04/2021
router.post("/logout",async function(req,res,next){
    try {
        const { memberId , IMEI , playerId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let deleteMemberToken = await memberTokenSchema.deleteOne({
            memberId: mongoose.Types.ObjectId(memberId),
            playerId: playerId,
            IMEI: IMEI,
        });

        return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member LoggedOut & PlayerId Deleted" });
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update AdvertiseImage----------MONIL----------------01/05/2021
router.post("/updateAdvertise",async function(req,res,next){
    try {
        const { advertiseId , Image , Title , Description , ContactNo , WebsiteURL , EmailId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAdvertise = await advertisementSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(advertiseId)
                }
            }
        ]);

        if(getAdvertise.length == 1){
            let imgPaths = [];

            if(Image.length > 0){
                Image.forEach(dataIs=>{
                    const path = 'uploads/advertise/'+"ads_"+Date.now()+'.png'
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imgPaths.push(path);
                });
            }
            let update = {
                Title: Title != undefined && Title != "" ? Title : getAdvertise[0].Title,
                Description: Description != undefined && Description != "" ? Description : getAdvertise[0].Description,
                ContactNo: ContactNo != undefined && ContactNo != "" ? ContactNo : getAdvertise[0].ContactNo,
                WebsiteURL: WebsiteURL != undefined && WebsiteURL != "" ? WebsiteURL : getAdvertise[0].WebsiteURL,
                EmailId: EmailId != undefined && EmailId != "" ? EmailId : getAdvertise[0].EmailId,
                $push: {
                    Image: {
                        $each: imgPaths
                    }
                }
            }

            let updateAdvertiseImage = await advertisementSchema.findByIdAndUpdate(advertiseId,update);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Advertise Image Updated" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Advertise Found" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Image From Advertise------------------MONIL---------------------01/05/2021
router.post("/deleteAdvertiseImage",async function(req,res,next){
    try {
        const { advertiseId , ImagePath } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAdvertise = await advertisementSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(advertiseId)
                }
            }
        ]);

        if(getAdvertise.length == 1){
            let removeImage = await advertisementSchema.updateOne(
                {
                    _id: mongoose.Types.ObjectId(advertiseId)
                },
                {
                    $pull: {
                        Image: String(ImagePath)
                    }
                },
                { multi: true }
            );

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Image ${ImagePath} Deleted` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Image Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Member Search-------------------------------MONIL--------------------03/05/2021
router.post("/memberSearch",async function(req,res,next){
    try {
        const { searchData , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let query = {
            "society.societyId": mongoose.Types.ObjectId(societyId),
            $or: [
                { 
                    Name: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    ContactNo: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    BloodGroup: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    "Vehicles.vehicleNo": {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
            ]
        }

        let searchDataIs = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: query
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "society.wingId",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "flats",
                    localField: "society.flatId",
                    foreignField: "_id",
                    as: "FlatData"
                }
            },
            {
                $project: {
                    Name: 1,
                    ContactNo: 1,
                    BloodGroup: 1,
                    Vehicles: 1,
                    "WingData.wingName": 1,
                    "FlatData.flatNo": 1,
                }
            }
        ]);

        if(searchDataIs.length > 0){
            res.status(200).json({ 
                IsSuccess: true, 
                Count: searchDataIs.length, 
                Data: searchDataIs, 
                Message: `Search Result Found For ${searchData}` 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: searchDataIs , Message: `No Data Found For ${searchData}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Staff Rating & Review -------------------MONIL---------------------05/05/2021
router.post("/addStaffRating",async function(req,res,next){
    try {
        const { staffId , rating , review , ratingMemberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getStaff = await staffSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(staffId)
                }
            }
        ]);

        if(getStaff.length == 1){
            let getPreviousRating = await staffRatingSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { ratingMemberId: mongoose.Types.ObjectId(ratingMemberId) },
                            { staffId: mongoose.Types.ObjectId(staffId) }
                        ]
                    }
                }
            ]);

            if(getPreviousRating.length == 1){
                let update = {
                    rating: rating != undefined && rating != null ? Number(rating) : getPreviousRating[0].rating,
                    review: review != undefined && review != null ? review : getPreviousRating[0].review,
                    dateTime: getCurrentDateTime()
                }

                let previousRatingId = getPreviousRating[0]._id;
                let updateStaffRating = await staffRatingSchema.findByIdAndUpdate(previousRatingId,update);

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff Rating Updated` });

            }else{
                let addRating = await new staffRatingSchema({
                    staffId: staffId,
                    rating: Number(rating),
                    review: review,
                    ratingMemberId: ratingMemberId,
                    societyId: societyId,
                    dateTime: getCurrentDateTime()
                });

                if(addRating != null){
                    try {
                        await addRating.save();
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: false , Message: error.message });
                    }

                    return res.status(200).json({ IsSuccess: true , Data: [addRating] , Message: `Thank You For Rating Staff` });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Staff Rating Faild` });
                }
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Staff Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Vendor Rating & Review -------------------MONIL---------------------05/05/2021
router.post("/addVendorRating",async function(req,res,next){
    try {
        const { vendorId , rating , review , ratingMemberId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVendor = await vendorSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(vendorId)
                }
            }
        ]);

        if(getVendor.length == 1){
            let getPreviousRating = await vendorRatingSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { ratingMemberId: mongoose.Types.ObjectId(ratingMemberId) },
                            { vendorId: mongoose.Types.ObjectId(vendorId) }
                        ]
                    }
                }
            ]);

            if(getPreviousRating.length == 1){
                let update = {
                    rating: rating != undefined && rating != null ? Number(rating) : getPreviousRating[0].rating,
                    review: review != undefined && review != null ? review : getPreviousRating[0].review,
                    dateTime: getCurrentDateTime()
                }

                let previousRatingId = getPreviousRating[0]._id;

                let updateStaffRating = await vendorRatingSchema.findByIdAndUpdate(previousRatingId,update);

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Vendor Rating Updated` });

            }else{
                let addRating = await new vendorRatingSchema({
                    vendorId: vendorId,
                    rating: Number(rating),
                    review: review,
                    ratingMemberId: ratingMemberId,
                    societyId: societyId,
                    dateTime: getCurrentDateTime()
                });

                if(addRating != null){
                    try {
                        await addRating.save();
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: false , Message: error.message });
                    }

                    return res.status(200).json({ IsSuccess: true , Data: [addRating] , Message: `Thank You For Rating Vendor` });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Vendor Rating Faild` });
                }
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Vendor Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Staff Rating-----------------------------MONIL---------------------05/05/2021
router.post("/getStaffRatings",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let memberLookup = {
            from: "members",
            localField: "ratingMemberId",
            foreignField: "_id",
            as: "MemberData"
        };

        let ratingProject = {
            rating: 1,
            review: 1,
            dateTime: 1,
            societyId: 1,
            "MemberData.Name": 1,
            "MemberData.ContactNo": 1,
        }

        let StaffProject = {
            Name: 1,
            ContactNo1: 1,
            staffCategory: 1,
            Ratings: 1,
            TotalRatings: 1
        }

        if(societyId != undefined && societyId != null && societyId != ""){

            let getStaffRating = await staffSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: {
                        from: "staffratings",
                        let: { staffId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$staffId", "$staffId" ] }
                                    }
                            },
                            {
                                $lookup: memberLookup
                            },
                            {
                                $project: ratingProject
                            }
                        ],
                        as: "Ratings"
                    }
                },
                {
                    $addFields: { TotalRatings: { $size: "$Ratings" } }
                },  
                {
                    $project: StaffProject
                }
            ]);

            if(getStaffRating.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getStaffRating.length, 
                    Data: getStaffRating, 
                    Message: "Society Staff Rating Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Staff Ratings Found" });
            }
        }else{
            let getStaffRating = await staffSchema.aggregate([
                {
                    $lookup: {
                        from: "staffratings",
                        let: { staffId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$staffId", "$staffId" ] }
                                    }
                            },
                            {
                                $lookup: memberLookup
                            },
                            {
                                $project: ratingProject
                            }
                        ],
                        as: "Ratings"
                    }
                },
                {
                    $addFields: { TotalRatings: { $size: "$Ratings" } }
                },
                {
                    $project: StaffProject
                }
            ]);

            if(getStaffRating.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getStaffRating.length, 
                    Data: getStaffRating, 
                    Message: "Staff Ratings Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Staff Rating Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Vendor Rating-----------------------------MONIL---------------------05/05/2021
router.post("/getVendorRatings",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let memberLookup = {
            from: "members",
            localField: "ratingMemberId",
            foreignField: "_id",
            as: "MemberData"
        };

        let ratingProject = {
            rating: 1,
            review: 1,
            societyid: 1,
            dateTime: 1,
            "MemberData.Name": 1,
            "MemberData.vendorBelongsTo": 1,
        }

        let vendorProject = {
            Name: 1,
            ServiceName: 1,
            ContactNo: 1,
            Ratings: 1,
            TotalRatings: 1
        }

        if(societyId != undefined && societyId != null && societyId != ""){
            let getVendorRatings = await vendorSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: {
                        from: "vendorratings",
                        let: { vendorId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$vendorId", "$vendorId" ] }
                                    }
                            },
                            {
                                $lookup: memberLookup
                            },
                            {
                                $project: ratingProject
                            }
                        ],
                        as: "Ratings"
                    }
                },
                {
                    $addFields: {
                        TotalRatings: { $size: "$Ratings" }
                    }
                },
                {
                    $project: vendorProject
                }
            ]);

            if(getVendorRatings.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getVendorRatings.length, 
                    Data: getVendorRatings, 
                    Message: "Society Vendor Rating Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Vendor Ratings Found" });
            }
        }else{
            let getVendorRatings = await vendorSchema.aggregate([
                {
                    $lookup: {
                        from: "vendorratings",
                        let: { vendorId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$vendorId", "$vendorId" ] }
                                    }
                            },
                            {
                                $lookup: memberLookup
                            },
                            {
                                $project: ratingProject
                            }
                        ],
                        as: "Ratings"
                    }
                },
                {
                    $addFields: {
                        TotalRatings: { $size: "$Ratings" }
                    }
                },
                {
                    $project: vendorProject
                }
            ]);

            if(getVendorRatings.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true,
                    Count: getVendorRatings.length, 
                    Data: getVendorRatings, 
                    Message: "Vendor Ratings Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Vendor Rating Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Search In Vendor-----------------------------MONIL---------------------10/05/2021
router.post("/searchInVendor",async function(req,res,next){
    try {
        const { searchData } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let query = {
            $or: [
                { 
                    ServiceName: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    Name: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    ContactNo: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    CompanyName: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
                { 
                    About: {
                        $regex: searchData,
                        $options : "i"
                    } 
                },
            ]
        }

        let vendorSearch = await vendorSchema.aggregate([
            {
                $match: query
            }
        ]);

        if(vendorSearch.length > 0){
            return res.status(200).json({ 
                IsSuccess: true,
                Count: vendorSearch.length, 
                Data: vendorSearch, 
                Message: `Search Result Found For ${searchData}` 
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: vendorSearch , Message: `No Search Result Found For ${searchData}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Leave Society----------------MONIL--------------14/05/2021
router.post("/removeFromProperty",async function(req,res,next){
    try {
        const { societyId , memberId , wingId , flatId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMember = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(memberId) },
                        {
                            society: {
                                $elemMatch: {
                                    societyId: mongoose.Types.ObjectId(societyId),
                                    wingId: mongoose.Types.ObjectId(wingId),
                                    flatId: mongoose.Types.ObjectId(flatId)
                                }
                            }
                        }
                    ]
                }
            }
        ]);

        if(getMember.length == 1){
            let memberProperties = getMember[0].society;

            if(memberProperties.length == 1){
                let removeMember = await memberSchema.findByIdAndDelete(memberId);
                let removeFromFlat = await flatSchema.updateMany(
                    {},
                    { 
                        $pull: { 
                            memberIds: mongoose.Types.ObjectId(memberId) 
                        }
                    },
                    { multi: true }
                );

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Member and its flat removed with id ${flatId}` });
            }else{
                let removeMemberProperty = await memberSchema.updateOne(
                    {
                        _id: mongoose.Types.ObjectId(memberId)
                    },
                    { 
                        $pull: { 
                            society: {
                                societyId: societyId,
                                wingId: wingId,
                                flatId: flatId
                            }
                        }
                    },
                    { multi: true }
                );

                let removeFromFlat = await flatSchema.updateOne(
                    {
                        _id: mongoose.Types.ObjectId(flatId)
                    },
                    { 
                        $pull: { 
                            memberIds: mongoose.Types.ObjectId(memberId) 
                        }
                    },
                    { multi: true }
                );

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `From Member properties flat removed with id ${flatId}` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `No Member Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Instant Message To Watchman-------------MONIL---------19/05/2021
router.post("/instantMessageToWatchman",async function(req,res,next){
    try {
        const { watchmanIdList , societyId , message , flatId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let watchmanIds;
        if(watchmanIdList != undefined && watchmanIdList != null && watchmanIdList != "" && watchmanIdList != []){
            watchmanIds = await getSocietyWatchman(societyId,watchmanIdList);
        }else{
            watchmanIds = await getSocietyWatchman(societyId);
        }

        if(watchmanIds.length > 0){
            let watchmanTokens = await getWatchmanPlayerId(watchmanIds);

            if(watchmanTokens.length > 0){
                let getFlat = await flatSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { _id: mongoose.Types.ObjectId(flatId) },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { wingId: mongoose.Types.ObjectId(wingId) }
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
                            "WingData.wingName": 1
                        }
                    }
                ]);
                
                let flat;
                let wing;
                if(getFlat.length == 1){
                    flat = getFlat[0].flatNo;
                    wing = getFlat[0].WingData[0].wingName;
                }
                let titleIs = `Message From ${wing}-${flat}`;
                let bodyIs = `Message: ${message}`;

                let notiDataIs = {
                    NotificationType: "InstantWatchmanMessage",
                    Wing: wing,
                    Flat: flat,
                    Message: message != undefined ? message : "",
                    notificationType: "UnknownVisitor",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                watchmanTokens.forEach(tokenIs=>{
                    if(tokenIs.DeviceType == "IOS"){
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            // ios_sound: "notification-_2_.wav"
                        };

                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,null,"InstantWatchmanMessage","IOS");
                    }else{
                        let message = { 
                            app_id: process.env.APP_ID_W,
                            contents: {
                                "en": bodyIs
                            },
                            headings: {"en": `${titleIs}`, "es": "Spanish Title"},
                            data: notiDataIs,   
                            content_available: 1,
                            include_player_ids: [tokenIs.playerId],
                            // android_channel_id: "7935275a-4bcc-468b-a5e6-7042e8a44862"
                        };
                        sendOneSignalNotification(message,false,true,tokenIs.watchmanId,null,"InstantWatchmanMessage","Android");
                    }
                });

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Instant Message Send" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Watchman Token Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Watchman Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Sale or Rent Flat-----------------MONIL--------------------24/05/2021
router.post("/saleAndRentProperty",async function(req,res,next){
    try {
        const { memberId , societyId , wingId , flatId , isFor , description } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await saleAndRentSchema.aggregate([
            {
                $match: {
                    $and: [
                        { memberId: mongoose.Types.ObjectId(memberId) },
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) },
                        { flatId: mongoose.Types.ObjectId(flatId) },
                        { isFor: isFor }
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `This Property Is Already Added For ${isFor}` });
        }

        let addProperty = await new saleAndRentSchema({
            memberId: memberId,
            societyId: societyId,
            wingId: wingId,
            flatId: flatId,
            isFor: isFor.toUpperCase(),
            description: description,
            dateTime: getCurrentDateTime()
        });

        if(addProperty != null){
            try {
                await addProperty.save();
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            return res.status(200).json({ IsSuccess: true , Data: [addProperty] , Message: `Property Added For ${isFor}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Property Not Added For ${isFor}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Sale or Rent-----------------MONIL-------------24/05/2021
router.post("/getSaleAndRentProperty",async function(req,res,next){
    try {
        const { memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(memberId != undefined && memberId != null && memberId != ""){
            let getProperty = await saleAndRentSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { memberId: mongoose.Types.ObjectId(memberId) },
                            { status: 0 }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        let: { flatId: "$flatId"},
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$flatId", "$_id" ] }
                                    }
                            },
                            {
                                $lookup: {
                                    from: "societies",
                                    localField: "societyId",
                                    foreignField: "_id",
                                    as: "SocietyData"
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
                                    residenceType: 1,
                                    "SocietyData.Name": 1,
                                    "SocietyData._id": 1,
                                    "SocietyData.stateCode": 1,
                                    "SocietyData.city": 1,
                                    "SocietyData.IsActive": 1,  
                                    "SocietyData.Address": 1,  
                                    "SocietyData.societyCode": 1,
                                    "WingData.wingName": 1,
                                    "WingData._id": 1,
                                }
                            }
                        ],
                        as: "Property"
                    }
                }
            ]);

            if(getProperty.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getProperty.length,
                    Data: getProperty,
                    Message: "Member Rent/Sale Properties Found"
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Member Property For Rent/Sale Found" });
            }
        }else{
            let getProperty = await saleAndRentSchema.aggregate([
                {
                    $match: {
                        status: 0
                    }
                },
                {
                    $lookup: {
                        from: "flats",
                        let: { flatId: "$flatId"},
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $expr: { $eq: [ "$$flatId", "$_id" ] }
                                    }
                            },
                            {
                                $lookup: {
                                    from: "societies",
                                    localField: "societyId",
                                    foreignField: "_id",
                                    as: "SocietyData"
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
                                    residenceType: 1,
                                    "SocietyData.Name": 1,
                                    "SocietyData._id": 1,
                                    "SocietyData.stateCode": 1,
                                    "SocietyData.city": 1,
                                    "SocietyData.IsActive": 1,  
                                    "SocietyData.Address": 1,  
                                    "SocietyData.societyCode": 1,
                                    "WingData.wingName": 1,
                                    "WingData._id": 1,
                                }
                            }
                        ],
                        as: "Property"
                    }
                }
            ]);

            if(getProperty.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getProperty.length,
                    Data: getProperty,
                    Message: "Rent/Sale Properties Found"
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Property For Rent/Sale Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
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

//Sending Notification-------------------------MONIL---------------------04/02/2021
// 1 - Visitor
// 2 - SOS
// 3 - VideoCalling
// 4 - VoiceCall
// 5 - VisitorAccepted
// 6 - VisitorRejected
// 7 - MemberVerify
async function sendNotification(fcmToken,data,title,body,isForMember,sendFromMember,userId,sender,category,deviceType){

    let addNotice;

    if(isForMember === true){
        if(sendFromMember == true){
            addNotice = await new notificationSchema({
                memberId: String(userId),
                title: title,
                body: body,
                notificationType: category,
                sendByMember: sender == undefined || "" ? null : String(sender),
                dateTime: getCurrentDateTime(),
            });
        }else{
            addNotice = await new notificationSchema({
                memberId: String(userId),
                title: title,
                body: body,
                sendByWatchman: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }
    }else{
        if(sendFromMember == true){
            addNotice = await new notificationSchema({
                guardId: userId,
                title: title,
                body: body,
                sendByMember: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }else{
            addNotice = await new notificationSchema({
                guardId: userId,
                title: title,
                body: body,
                sendByWatchman: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }
    }

    if(addNotice != null){
        addNotice.save();
    }

    let payload;

    if(deviceType == "Android"){
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                        "sound": "alert_tone.mp3",
                        "content_available": true,
                        "android_channel_id": "noti_push_app_1"
                    }
        };
    }else if(deviceType == "IOS"){
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                        "sound": "alert.caf",
                        "content_available": true,
                    }
        };
    }else{
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                        "sound": "alert_tone.mp3",
                        "content_available": true,
                        "android_channel_id": "noti_push_app_1"
                    }
        };
    }
    
    if(isForMember == true){
        options = {
            'method': 'POST',
            'url': 'https://fcm.googleapis.com/fcm/send',
            'headers': {
                'authorization': 'key=AAAAmBchWwE:APA91bHUE5WIRphKIYriNXV-rM49TBW6XwgHJFc1ei4hLIOAJ2GwsmoScmRR0FChUAq0va1jy8fhShiLRieFVTBvr3KXMRMMdKqO359P51qNKVl1qtD3FnCoAx_3hcJBqMv1iIJFDQfq',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        };
    }else{
        options = {
            'method': 'POST',
            'url': 'https://fcm.googleapis.com/fcm/send',
            'headers': {
                'authorization': 'key=AAAASHprFFg:APA91bHkKKEDUW2p4gf8iZsG912SsRpOQfzCd3ULaeFMEcPTVEbBBF5q6gnIZQyTaBwxXGmSEsQzRqtG47bPwET1CZrrYlzusJf4uU9Z8LcNUkfw7rBYtTF_UGT2GWSHnjeai1y7olma',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        };
    }

    request(options, function (error, response , body) {
        // console.log("--------------------Sender--------------------");
        // let myJsonBody = JSON.stringify(body);
        // console.log(body);
        
        if (error) {
            console.log("==============================================================");
            console.log(error.message);
        } else {
            console.log("Sending Notification Successfully....!!!");
            console.log(response.body);
        }
    });
};

//Sending Notification-------------------------MONIL---------------------04/02/2021
// 1 - Visitor
// 2 - SOS
// 3 - VideoCalling
// 4 - VoiceCall
// 5 - Accepted
// 6 - Rejected
async function sendNormalNotification(fcmToken,data,title,body,isForMember,sendFromMember,userId,sender,category,deviceType){

    let addNotification;

    if(isForMember === true){
        if(sendFromMember == true){
            addNotification = await new notificationSchema({
                memberId: String(userId),
                title: title,
                body: body,
                notificationType: category,
                sendByMember: sender == undefined || "" ? null : String(sender),
                dateTime: getCurrentDateTime(),
            });
        }else{
            addNotification = await new notificationSchema({
                memberId: String(userId),
                title: title,
                body: body,
                sendByWatchman: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }
    }else{
        if(sendFromMember == true){
            addNotification = await new notificationSchema({
                guardId: userId,
                title: title,
                body: body,
                sendByMember: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }else{
            addNotification = await new notificationSchema({
                guardId: userId,
                title: title,
                body: body,
                sendByWatchman: sender == undefined || "" ? null : String(sender),
                notificationType: category,
                dateTime: getCurrentDateTime(),
            });
        }
    }

    if(addNotification != null){
        addNotification.save();
    }

    let payload;

    if(deviceType == "Android"){
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                        "android_channel_id": "noti_push_app_1"
                    }
        };
    }else if(deviceType == "IOS"){
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                    }
        };
    }else{
        payload = {
            "to":fcmToken,
            "priority":"high",
            "data": data,
            "notification":{
                        "body": body,
                        "title": title,
                        "badge":1,
                        "android_channel_id": "noti_push_app_1"
                    }
        };
    }
    
    if(isForMember == true){
        options = {
            'method': 'POST',
            'url': 'https://fcm.googleapis.com/fcm/send',
            'headers': {
                'authorization': 'key=AAAAmBchWwE:APA91bHUE5WIRphKIYriNXV-rM49TBW6XwgHJFc1ei4hLIOAJ2GwsmoScmRR0FChUAq0va1jy8fhShiLRieFVTBvr3KXMRMMdKqO359P51qNKVl1qtD3FnCoAx_3hcJBqMv1iIJFDQfq',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        };
    }else{
        options = {
            'method': 'POST',
            'url': 'https://fcm.googleapis.com/fcm/send',
            'headers': {
                'authorization': 'key=AAAASHprFFg:APA91bHkKKEDUW2p4gf8iZsG912SsRpOQfzCd3ULaeFMEcPTVEbBBF5q6gnIZQyTaBwxXGmSEsQzRqtG47bPwET1CZrrYlzusJf4uU9Z8LcNUkfw7rBYtTF_UGT2GWSHnjeai1y7olma',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        };
    }

    request(options, function (error, response , body) {
        // console.log("--------------------Sender--------------------");
        // let myJsonBody = JSON.stringify(body);
        // console.log(body);
        
        if (error) {
            console.log("==============================================================");
            console.log(error.message);
        } else {
            console.log("Sending Notification Successfully....!!!");
            console.log(response.body);
        }
    });
};

//Send Notification via oneSignal
var sendOneSignalNotification = function(data,receiver_type,sender_type,receiverId,senderId,notification_Category,deviceType) {
    var headers;
    if(receiver_type == true){
        //For Member
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic MDE5YmRjNmMtMWI1ZS00MDY0LWJjNmYtZjRlN2ZkY2ZkY2U3"
        };
    }else if(receiver_type == false){
        //For Watchman
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic MjM3NjdjMjctOWVmMS00Mzg3LTk0MzYtZGEzZjRmZWFkMjQz"
        };
    }else{
        //For Member
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

//Get Single member tokens 
async function getSingleMemberFcmTokens(memberId){
    let memberIdIs = String(memberId);
    // console.log(memberIdIs);
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

//Get member tokens 
async function getMemberFcmTokens(memberIdList,senderId){
    // console.log(memberIdList);
    let tokenAre = [];
    for(let i=0;i<memberIdList.length;i++){
    
        let memberIdIs = String(memberIdList[i]);

        if(senderId != null && senderId != undefined && senderId != ""){
            
            if(memberIdIs != String(senderId)){
                
                let memberToken = await memberTokenSchema.aggregate([
                    {
                        $match: {
                            memberId: mongoose.Types.ObjectId(memberIdIs),
                            // fcmToken: { $exists: true }
                        }
                    }
                ]);
                memberToken.forEach(dataIs=>{
                    tokenAre.push(dataIs);
                });
            }
        }else{
            let memberToken = await memberTokenSchema.aggregate([
                {
                    $match: {
                        memberId: mongoose.Types.ObjectId(memberIdIs),
                        fcmToken: { $exists: true }
                    }
                }
            ]);
            memberToken.forEach(dataIs=>{
                tokenAre.push(dataIs);
            });
        }
    }
    // console.log(tokenAre);
    
    return tokenAre;
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

async function getSingleWatchmanToken(watchmanId){
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

//Get Society Watchman-----------MONIL----------19/05/2021
async function getSocietyWatchman(societyId,watchmanIdList){
    let societyIdIs = String(societyId);

    let watchmanIds = [];
    if(watchmanIdList != undefined && watchmanIdList != null && watchmanIdList != "" && watchmanIdList != []){
        for(let i=0;i<watchmanIdList.length;i++){
            let watchmanId = String(watchmanIdList[i]);
            let getWatchman = await watchmanSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(watchmanId) },
                            { societyId: mongoose.Types.ObjectId(societyIdIs) }
                        ]
                    }
                },
                {
                    $group: {
                        _id: "$_id"
                    }
                }
            ]);

            getWatchman.forEach(id=>{
                watchmanIds.push(id._id);
            });
        }
    }else{
        let getWatchman = await watchmanSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyIdIs)
                }
            },
            {
                $group: {
                    _id: "$_id"
                }
            }
        ]);

        getWatchman.forEach(id=>{
            watchmanIds.push(id._id);
        });
    }

    return watchmanIds;
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

async function getWatchmanToken(watchmanIdList){
    let watchmanTokenList = [];
    for(let i=0;i<watchmanIdList.length;i++){
        let watchmanIdIs = String(watchmanIdList[i]);
        let getFcmToken = await watchmanTokenSchema.aggregate([
            {
                $match: {
                    watchmanId: mongoose.Types.ObjectId(watchmanIdIs),
                    fcmToken: { $exists: true }
                }
            }
        ]);

        getFcmToken.forEach(dataIs=>{
            watchmanTokenList.push(dataIs)
        });
    };

    return watchmanTokenList;
};

async function getSocietyAdmin(societyId){
    let societyIdIs = String(societyId)

    let getAdmin  = await memberSchema.aggregate([
        {
            $match: {
                society: {
                    $elemMatch: {
                        societyId: mongoose.Types.ObjectId(societyIdIs),
                        isVerify: true,
                        isAdmin: 1,
                    }
                }
            }
        }
    ]);

    return getAdmin;
}

async function getMemberOfFlat(flatIdList){
    let flatMemberIds = [];

    if(flatIdList.length >0){
        
        for(let i=0;i<flatIdList.length;i++){
            let flatId = String(flatIdList[i]);
            let getFlat = await flatSchema.aggregate([
                {
                    $unwind: "$memberIds"
                },
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(flatId)
                    }
                }
            ]);

            if(getFlat.length > 0){
                getFlat.forEach(member=>{
                    flatMemberIds.push(member.memberIds)
                });
            }
        }
    }

    return flatMemberIds;
    
}

function getMemberCodeNumber() {
    let generateNo = "MEMBER-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getComplainNumber() {
    let generateNo = "COMPLAIN-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getAdvertiseNumber(){
    let generateNo = "ADVERTISE-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getvendorCodeNumber() {
    let generateNo = "VENDOR-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getWatchmanNumber(){
    let generateNo = "WATCHMEN-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getStaffNumber(){
    let generateNo = "STAFF-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getInviteGuestNumber(){
    let generateNo = "GUEST-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getInvoiceNumber(){
    let generateNo = "INVOICE-"+ Math.random().toFixed(6).split('.')[1];
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

function getCurrentTime(){
    let time = moment()
            .tz("Asia/Calcutta")
            .format("DD/MM/YYYY,h:mm:ss a")
            .split(",")[1];

    return time;
}

function generateDateList(start, end) {
    
    let date1 = start.split("/");
    let date2 = end.split("/");
    let fromDate = date1[2] + "-" + date1[1] + "-" + date1[0];
    let toDate = date2[2] + "-" + date2[1] + "-" + date2[0];
    
    fromDate = new Date(fromDate);
    toDate = new Date(toDate);

    // console.log([fromDate,toDate]);
    
    for(var arr=[],dt=new Date(fromDate); dt<=toDate; dt.setDate(dt.getDate()+1)){
        // console.log(dt);
        let temp = moment(dt)
                        .tz("Asia/Calcutta")
                        .format('DD/MM/YYYY, h:mm:ss a')
                        .split(',')[0];
        arr.push(temp);
        // console.log(temp);
    }
    return arr;
};

module.exports = router;