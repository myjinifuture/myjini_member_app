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
const multer = require('multer');
const OneSignal = require('onesignal-node');
const client = new OneSignal.Client(process.env.APP_ID, process.env.API_KEY);
const userClient = new OneSignal.UserClient(process.env.USER_AUTH_KEY);

const stateSchema = require('../models/stateModel');
const citySchema = require('../models/cityModel');
const societySchema = require('../models/societyModel');
const societyCategorySchema = require('../models/societyCategory');
const wingSchema = require('../models/wingModel');
const professionSchema = require('../models/professionModel');
const flatSchema = require('../models/flatsModel');
const parkingSchema = require('../models/parkingModel');
const staffCategorySchema = require('../models/staffCategory');
const identityProofSchema = require('../models/identityProofCategory');
const purposeSchema = require('../models/purposeModel');
const guestCategorySchema = require('../models/guestCategory');
const noticeBoardSchema = require('../models/noticeBoard');
const societyDocsSchema = require('../models/societyDocuments');
const societyRulesSchema = require('../models/societyRulesModel');
const eventSchema = require('../models/eventModel');
const eventRegistrationSchema = require('../models/eventRegistration');
const vendorCategorySchema = require('../models/vendorCategory');
const vendorSchema = require('../models/vendorModel');
const memberSchema = require('../models/memberModel');
const notificationSchema = require('../models/notificationContent');
const emergencyContactsSchema = require('../models/emergencyContacts');
const areaSchema = require('../models/areaModel');
const adsPackageSchema = require('../models/adsPackage');
const memberTokenSchema = require('../models/memberToken');
const amenitySchema = require('../models/amenityModel');
const pollingQuestionSchema = require('../models/pollingQuestion');
const pollingOptionsSchema = require('../models/pollingOptions');
const pollingAnswersSchema = require('../models/pollingAnswers');
const watchmanSchema = require('../models/watchmanModel');
const watchmanTokenSchema = require('../models/watchmanToken');
const guestEntrySchema = require('../models/guestEntry');
const staffEntrySchema = require('../models/staffEntry');
const vendorEntrySchema = require('../models/vendorEntry');
const staffSchema = require('../models/staffModel');
const excelToJson = require('convert-excel-to-json');
const bannerSchema = require('../models/bannerModel');
const apkDetailsSchema = require('../models/apkDetails');
const gallerySchema = require('../models/galleryModel');
const complainCategorySchema = require('../models/complainCategory');
const complainSchema = require('../models/complainModel');
const transactionSchema = require('../models/transactionSourceModel');
const incomeExpenseDetailsSchema = require('../models/incomeExpenseDetails');
const masterAdminSchema = require('../models/adminModel');
const adminTokenSchema = require('../models/masterAdminToken');

//Register Master Admin-----------------MONIL------------08/04/2021
router.post("/registerMasterAdmin",async function(req,res,next){
    try {
        const { Name , ContactNo , emailId , alternateContactNo } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await masterAdminSchema.aggregate([
            {
                $match: {
                    ContactNo: ContactNo
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Admin already exist with ContactNo ${ContactNo} ` });
        }else{
            let addMasterAdmin = await new masterAdminSchema({
                Name: Name,
                ContactNo: ContactNo,
                emailId: emailId,
                alternateContactNo: alternateContactNo
            });

            if(addMasterAdmin != null){
                addMasterAdmin.save();
                return res.status(200).json({ IsSuccess: true , Data: [addMasterAdmin] , Message: `Master Admin Added` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Master Admin Added` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Login Master Admin--------------MONIL-----------08/04/2021
router.post("/login",async function(req,res,next){
    try {
        const { ContactNo , fcmToken , deviceType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAdmin = await masterAdminSchema.aggregate([
            {
                $match: {
                    ContactNo: ContactNo
                }
            }
        ]);

        if(getAdmin.length == 1){
            let masterAdminId = getAdmin[0]._id;
            let checkMemberToken = await adminTokenSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { adminId: mongoose.Types.ObjectId(masterAdminId) },
                            { ContactNo: ContactNo },
                            { fcmToken: fcmToken },
                            { DeviceType: deviceType }
                        ]
                    }
                }
            ]);
            if(checkMemberToken.length == 0){
                let addAdminToken = await new adminTokenSchema({
                    adminId: masterAdminId,
                    ContactNo: ContactNo,
                    fcmToken: fcmToken,
                    DeviceType: deviceType
                });
                if(addAdminToken != null){
                    addAdminToken.save();
                }
            }
            return res.status(200).json({ IsSuccess: true , Data: getAdmin , Message: "Admin LoggedIn" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: getAdmin , Message: `No Admin Found for ContactNo ${ContactNo}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Listing--------------------------MONIL---------------------08/04/2021
router.post("/getSocietyList",async function(req,res,next){
    try {

        const { IsVerify } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllSocietyList;
        
        if(IsVerify == true){
           
            getAllSocietyList = await societySchema.aggregate([
                {
                    $match: {
                        IsVerify: true
                    }
                }
            ]);
        }else if(IsVerify == false){
            
            getAllSocietyList = await societySchema.aggregate([
                {
                    $match: {
                        IsVerify: false
                    }
                }
            ]);
        }else{
            
            getAllSocietyList = await societySchema.aggregate([
                {
                    $match: {}
                }
            ]);
        }

        if(getAllSocietyList.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: getAllSocietyList.length, 
                Data: getAllSocietyList, 
                Message: "Society List Found" 
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Verify Society------------------------------MONIL----------------------08/04/2021
router.post("/societyVerification",async function(req,res,next){
    try {
        const { societyId , IsVerify , notificationNote , adminId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 1){
            if(IsVerify == true){
                let update = {
                    IsVerify: true
                }   
                let societyUpdate = await societySchema.findByIdAndUpdate(societyId,update);

                let getSocietySecretaryIds = await getSocietyAdmin(societyId);

                let getAdminTokens = await getMemberFcmTokens(getSocietySecretaryIds);

                let titleIs = `Your Society ${getSociety[0].societyCode} Is Verified Successfully..!!!, Now Member can join Society`;
                let bodyIs = notificationNote != undefined ? notificationNote : "";

                let notiDataIs = {
                    Message: `Your Society ${getSociety[0].societyCode} Is Verified Successfully..!!!, Now Member can join Society`,
                    Note: notificationNote != undefined ? notificationNote : "",
                    NotificationType: "SocietyVerification",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                getAdminTokens.forEach(tokenIs=>{
                    sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"SocietyVerification",tokenIs.DeviceType)
                });

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Society Verified and Approved" });
                
            }else if(IsVerify == false){
                let update = {
                    IsVerify: false
                }   
                let societyUpdate = await societySchema.findByIdAndUpdate(societyId,update);

                let getSocietySecretaryIds = await getSocietyAdmin(societyId);

                let getAdminTokens = await getMemberFcmTokens(getSocietySecretaryIds);

                let titleIs = "Your Society Is Verified and Rejected";
                let bodyIs = notificationNote != undefined ? notificationNote : "";

                let notiDataIs = {
                    Message: `Your Society ${getSociety[0].societyCode} Is Verified and Rejected`,
                    Note: notificationNote != undefined ? notificationNote : "",
                    NotificationType: "SocietyVerification",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                getAdminTokens.forEach(tokenIs=>{
                    sendNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"SocietyVerification",tokenIs.DeviceType);
                });

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Society Verified and Rejected" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please provide valid boolean value for IsVerify field" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get MyJini Dashcount--------------------------MONIL----------------------04/05/2021
router.post("/myjiniDashCount",async function(req,res,next){
    try {
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSocietyCount = await societySchema.aggregate([
            {
                $count: "SocietyCount"
            }
        ]);

        let getSocietyDocCount = await societyDocsSchema.aggregate([
            {
                $count: "DocCount"
            }
        ]);

        let getSocietyNoticeCount = await noticeBoardSchema.aggregate([
            {
                $count: "NoticeCount"
            }
        ]);

        let getVisitorsCount = await guestEntrySchema.aggregate([
            {
                $count: "VisitorsCount"
            }
        ]);

        let getMemberCount = await memberSchema.aggregate([
            {
                $count: "MemberCount"
            }
        ]);

        let getStaffCount = await staffSchema.aggregate([
            {
                $count: "StaffCount"
            }
        ]);

        let getComplaintsCount = await complainSchema.aggregate([
            {
                $count: "ComplaintsCount"
            }
        ]);

        let getRulesCount = await societyRulesSchema.aggregate([
            {
                $count: "RulesCount"
            }
        ]);

        let getEventsCount = await eventSchema.aggregate([
            {
                $count: "EventCount"
            }
        ]);

        let getGalleryCount = await gallerySchema.aggregate([
            {
                $count: "GalleryCount"
            }
        ]);

        let getAmenityCount = await amenitySchema.aggregate([
            {
                $count: "AmenityCount"
            }
        ]);

        let getPollingCount = await pollingQuestionSchema.aggregate([
            {
                $match: {}
            }
        ]);

        let getIncomeCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    type: "Income"
                }
            }
        ]);

        let getExpenseCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    type: "Expense"
                }
            }
        ]);

        let adminDashCount = {
            Society: getSocietyCount[0].SocietyCount,
            Documents: getSocietyDocCount[0].DocCount,
            Notice: getSocietyNoticeCount[0].NoticeCount,
            Visitors: getVisitorsCount[0].VisitorsCount,
            Members: getMemberCount[0].MemberCount,
            Staff: getStaffCount[0].StaffCount,
            Complaints: getComplaintsCount[0].ComplaintsCount,
            Rules: getRulesCount[0].RulesCount,
            Events: getEventsCount[0].EventCount,
            Gallery: getGalleryCount[0].GalleryCount,
            Amenity: getAmenityCount[0].AmenityCount,
            Polls: getPollingCount.length,
            Income: getIncomeCount.length,
            Expense: getExpenseCount.length,
            BalanceSheet: parseFloat(getIncomeCount.length) + parseFloat(getExpenseCount.length),
        }

        return res.status(200).json({ IsSuccess: true , Data: [adminDashCount] , Message: "MyJini Dash Count Found" });
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Information----------------------MONIL--------------------04/05/2021
router.post("/getSocietyInformation",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let societyIs = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "societycategories",
                    localField: "SocietyType",
                    foreignField: "_id",
                    as: "SocietyCategory"
                }
            },
            {
                $project: {
                    Name: 1,
                    Address: 1,
                    ContactPerson: 1,
                    ContactMobile: 1,
                    Location: 1,
                    stateCode: 1,
                    city: 1,
                    Email: 1,
                    societyCode: 1,
                    IsVerify: 1,
                    "SocietyCategory.categoryName": 1,
                }
            }
        ]);

        if(societyIs.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: societyIs , Message: "Society Data Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Data Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Active Members-------------------MONIL---------------------04/05/2021
//type - 0 - Inactive
//type - 1 - Active
router.post("/getSocietyActiveMembers",async function(req,res,next){
    try {
        const { societyId , type } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(type == 1){
            let getActiveMember = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        "society.societyId": mongoose.Types.ObjectId(societyId)
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
                                }
                            }
                        ],
                        as: "MemberProperty"
                    }
                },
                {
                    $project: {
                        Name: 1,
                        ContactNo: 1,
                        MemberProperty: 1   
                    }
                }
            ]);

            if(getActiveMember.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getActiveMember.length, 
                    Data: getActiveMember, 
                    Message: "Active Member Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Active Member Found" });
            }
        }else if(type == 0){
            let getInactiveFlats = await flatSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { parentMember: { $exists: false } } 
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
                    $lookup: {
                        from: "societies",
                        localField: "societyId",
                        foreignField: "_id",
                        as: "SocietyData"
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
                    }
                }
            ]);

            if(getInactiveFlats.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getInactiveFlats.length, 
                    Data: getInactiveFlats, 
                    Message: "Inactive Flats Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Inactive Flats Found" });
            }
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Vehicle Count----------------------------MONIL---------------------04/05/2021
//vehicelType - 0 - Bike
//vehicelType - 1 - Car
router.post("/getSocietyVehicle",async function(req,res,next){
    try {
        const { societyId , vehicleType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let vehicleTypeIs;

        if(vehicleType != undefined && vehicleType != null && vehicleType != ""){
            if(vehicleType == 0){
                vehicleTypeIs = "Bike"
            }else if(vehicleType == 1){
                vehicleTypeIs = "Car"
            }else{
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [] , 
                    Message: "Please Pass 0 for Bike and 1 for Car or else do not pass vehicleType field to get All Vehicles" 
                });
            }

            let getVehicles = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { "society.societyId": mongoose.Types.ObjectId(societyId) },
                            {
                                Vehicles: {
                                    $elemMatch: {
                                        vehicleType: vehicleTypeIs
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    $project: {
                        Vehicles: 1,
                        Name: 1,
                        ContactNo: 1
                    }
                }
            ]);

            if(getVehicles.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getVehicles.length, 
                    Data: getVehicles, 
                    Message: `Society Vehicles found for category ${vehicleTypeIs}` 
                })
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Vehicle Found For ${vehicleTypeIs}` })
            }
        }else{
            let getVehicles = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        "society.societyId": mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $project: {
                        Vehicles: 1,
                        Name: 1,
                        ContactNo: 1
                    }
                }
            ]);

            if(getVehicles.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getVehicles.length, 
                    Data: getVehicles, 
                    Message: `Society Vehicles Found` 
                })
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Vehicle Found` })
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Sending Notification-------------------------MONIL---------------------04/02/2021
// 1 - Visitor
// 2 - SOS
// 3 - VideoCalling
// 4 - VoiceCall
// 5 - Accepted
// 6 - Rejected
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

//Get Society Admin(Secretary)-------------Monil-------09/04/2021
async function getSocietyAdmin(societyId){
    let societyIdIs = String(societyId);

    let societyAdmins = await memberSchema.aggregate([
        {
            $match: {
                society: {
                    $elemMatch: {
                        societyId: mongoose.Types.ObjectId(societyIdIs)
                    }
                }
            }
        }
    ]);

    let adminIdList = [];

    societyAdmins.forEach(admin=>{
        adminIdList.push(admin._id);
    });

    return adminIdList;
}

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
        // console.log(memberToken);
        memberToken.forEach(dataIs=>{
            tokenAre.push(dataIs);
        });
    }
    // console.log(tokenAre);
    
    return tokenAre;
};

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


function getPollNumber(){
    let generateNo = "POLL-"+ Math.random().toFixed(6).split('.')[1];
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
    let Time = moment()
            .tz("Asia/Calcutta")
            .format("DD/MM/YYYY,h:mm:ss a")
            .split(",")[1];

    return Time;
}

module.exports = router;