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
const fs = require("fs");
const { token } = require("morgan");

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
const societyEmergencyContactsSchema = require('../models/societyEmergencyContacts');
const shareTemplatSchema = require('../models/shareTemplates');
const companyCategorySchema = require('../models/companyModel');

const { reset } = require("nodemon");
const e = require("express");
const { json } = require("express");

//Banner Uploader
var bannerlocation = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/banners");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
var uploadbanner = multer({ storage: bannerlocation });

//Company Category Image Uploader
var companyImg = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/company");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
var companyUploader = multer({ storage: companyImg });

//Vendor Category Image Uploader
var vendorImg = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/vendorCategory");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
var vendorCategoryUploader = multer({ storage: vendorImg });

//Guest Category Image Uploader
var guestcategoriesImg = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/guestCategories");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
var guestcategoriesUploader = multer({ storage: guestcategoriesImg });

//Gallery Images Uploader
var gallerylocation = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/gallery");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
var galleryImg = multer({ storage: gallerylocation });

const memberExcel = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/memberExcel");
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }
});
const memberExcelUploader = multer({storage: memberExcel});

let amenitiesUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/amenities");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let amenitiesUploadIs = multer({ storage: amenitiesUploader });

let noticeFileUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/noticeBoardAttachments");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let noticeFile = multer({ storage: noticeFileUploader });

let societyDocsUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/societyDocs");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let societyDocsFiles = multer({ storage: societyDocsUploader });

let societyRulesUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/societyRules");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let societyRulesFiles = multer({ storage: societyRulesUploader });

let emergencyImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/emergencyContactImg");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let emergencyImg = multer({ storage: emergencyImgUploader });

let societyImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/societyImg");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let societyImg = multer({ storage: societyImgUploader });

let eventsImgUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/eventsImg");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let eventsImg = multer({ storage: eventsImgUploader });

//Add Society Category-----------MONIL----------28/03/2021
router.post("/addSocietyCategory",async function(req,res,next){
    const { categoryName } = req.body;
    try {
        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await societyCategorySchema.aggregate([
            {
                $match: { categoryName: {$in: categoryName} }
            }
        ]);
        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Society Category ${categoryName} already exist` });
        }

        categoryName.forEach(async function(category){
            let categoryRecord = await new societyCategorySchema({
                categoryName: category
            });
            if(categoryRecord != null){
                categoryRecord.save()
            }
        });
        if(categoryName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Society Category Added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Category Not Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get society Category--------------------------18/01/2021----------MONIL
router.post("/getAllSocietyCategory",async function(req,res,next){
    try {
        let authToken = req.headers['authorization'];
        // console.log(token);
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        let categoryRecord = await societyCategorySchema.aggregate([
           { $match: {} }
        ]);
        if(categoryRecord.length > 0){
            res.status(200).json({ IsSuccess: true , Data: categoryRecord , Message: "Society Category Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Category Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Create Society------------------MONIL----------28/03/2021
router.post("/createSociety", async function(req,res,next){
    try {
        const { 
            Name,
            Address,
            ContactPerson,
            ContactMobile,
            StateCode,
            City,
            mapLink,
            lat,
            long,
            email,
            SocietyType,
            NoOfWing,
            areaId
        } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistSociety = await societySchema.aggregate([
            {
                $match: {
                    $and: [
                        { Name : Name },
                        { Address : Address },
                        { ContactPerson : ContactPerson },         
                        { ContactMobile : ContactMobile },         
                        { StateCode : StateCode },         
                        { City : City },         
                        { SocietyType : mongoose.Types.ObjectId(SocietyType) }
                    ]
                }
            }
        ]);

        if(checkExistSociety.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Same Configure society already register" });
        }

        let getSocietyCategory = await societyCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(SocietyType)
                }
            }
        ]);

        if(getSocietyCategory.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Type Found" });
        }

        let societyCategory = getSocietyCategory[0].categoryName;

        let createSociety = await new societySchema({
            Name : Name.toUpperCase(),
            Address : Address,
            ContactPerson : ContactPerson,
            ContactMobile : ContactMobile,
            stateCode : StateCode,
            city : City,
            Location: {
                lat : lat,
                long : long,
                mapLink : mapLink
            },
            SocietyType : SocietyType,
            SocietyTypeIs: societyCategory,
            societyCode : societyCategory == "Society" ? getSocietyCodeNumber() : getIndustryCodeNumber(), 
            JoinDate : getCurrentDateTime(),
            Email: email,
            NoOfWing: NoOfWing,
            areaId: areaId
        });
        
        if(createSociety != null){
            createSociety.save();
            for(let i=0;i<NoOfWing;i++){
                let createWing = await new wingSchema({
                    societyId: createSociety._id,
                    wingName: "Wing-" + i,
                });
                if(createWing != null){
                    createWing.save();
                }
            }
            res.status(200).json({ IsSuccess: true , Data: [createSociety] , Message: "Society Created" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Not Created" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Wings------------------------MONIL-------------------------28/03/2021
router.post("/getAllWingOfSociety",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getWings = await wingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getWings.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getWings , Message: "Society Wings Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Wings Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Wings------------------------MONIL-------------------------28/03/2021
router.post("/getMemberOccupiedWing",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getWings = await wingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "flats",
                    let: { wingId: "$_id" },
                    pipeline: [
                        { 
                            $match:
                                {
                                    $and: [
                                        { $expr: { $eq: [ "$$wingId", "$wingId" ] } },
                                        { parentMember: { $exists: true } }
                                    ]
                                }
                        }
                    ],
                    as: "FlatData"
                }
            },
            {
                $addFields: {
                    SizeIs: { $size: "$FlatData" }
                }
            },
            {
                $match: {
                    SizeIs: { $gt: 0 }
                }
            },
            {
                $project: {
                    wingName: 1
                }
            }
        ]);

        if(getWings.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getWings , Message: "Society Wings Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Wings Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Society Details--------MONIL----------01/04/2021
router.post("/updateSociety", societyImg.array("societyImage") ,async function(req,res,next){
    try {
        const {
            societyId, 
            UPIID,
            InstaMojoKey,
            AccountHolderName,
            IFSCCode,
            AccountNo,
            openingBalance,
            currentBalance,
            InstaMojoToken,
            BankName,
            BankAddress,
            ContactPerson,
            ContactMobile,
            Email,
            Name,
            areaId, 
            societyImage
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let listOfBase64String = societyImage;
        
        let imgPaths = [];
        listOfBase64String.forEach(dataIs=>{
            const path = 'uploads/gallery/'+Date.now()+'.png'
            
            const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
        
            fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
            imgPaths.push(path);
        });

        let checkExist = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(checkExist.length == 1){
            let updateIs = {
                UPIID: UPIID != undefined ? UPIID : checkExist[0].UPIID,
                InstaMojoKey: InstaMojoKey != undefined ? InstaMojoKey : checkExist[0].InstaMojoKey,
                AccountHolderName: AccountHolderName != undefined ? AccountHolderName : checkExist[0].AccountHolderName,
                IFSCCode: IFSCCode != undefined ? IFSCCode : checkExist[0].IFSCCode,
                AccountNo: AccountNo != undefined ? AccountNo : checkExist[0].AccountNo,
                openingBalance: openingBalance != undefined ? openingBalance : checkExist[0].openingBalance,
                currentBalance: currentBalance != undefined ? currentBalance : checkExist[0].currentBalance,
                InstaMojoToken: InstaMojoToken != undefined ? InstaMojoToken : checkExist[0].InstaMojoToken,
                BankName: BankName != undefined ? BankName : checkExist[0].BankName,
                BankAddress: BankAddress != undefined ? BankAddress : checkExist[0].BankAddress,
                ContactPerson: ContactPerson != undefined ? ContactPerson : checkExist[0].ContactPerson,
                ContactMobile: ContactMobile != undefined ? ContactMobile : checkExist[0].ContactMobile,
                Email: Email != undefined ? Email : checkExist[0].Email,
                Name: Name != undefined ? Name : checkExist[0].Name,
                areaId: areaId,
                societyImage: imgPaths,
            }

            let updateSociety = await societySchema.findByIdAndUpdate(societyId,updateIs);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Society Data Updated" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Society Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
}); 

//Setup wing data--------------MONIL----------28/03/2021
router.post("/setUpWing",async function(req,res,next){
    try {
        const { societyId , societyCategory , wingId , totalFloor , maxFlatPerFloor , wingName , noOfParkingSlots , flatList } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getExistWing = await wingSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(wingId) },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);

        if(getExistWing.length == 1){

            if(societyCategory == "Industrial"){
                // For Industry
                if(getExistWing[0].isSetUp == true){
                    let deleteParking = await parkingSchema.deleteMany({ wingId: mongoose.Types.ObjectId(wingId) });

                    let updateWing = {
                        wingName: wingName != undefined ? wingName.toUpperCase() : getExistWing[0].wingName,
                        totalFloor: totalFloor != undefined ? totalFloor : getExistWing[0].totalFloor,
                        maxFlatPerFloor: maxFlatPerFloor != undefined ? maxFlatPerFloor : getExistWing[0].maxFlatPerFloor,
                        isSetUp: true
                    }
                    let updateWingDataIs = await wingSchema.findByIdAndUpdate(wingId,updateWing);

                    for(let k=0;k<noOfParkingSlots;k++){
                        let addParkingSlot = await new parkingSchema({
                            societyId: societyId,
                            wingId: wingId,
                            parkingSlotNo: "PARK-"+ wingName + k
                        });
                        if(addParkingSlot != null){
                            addParkingSlot.save();
                        }
                    }
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Data: 1, 
                        Message: "Department Data Updated and parking slots created" 
                    });
                }

                let updateWing = {
                    wingName: wingName.toUpperCase(),
                    totalFloor: totalFloor,
                    maxFlatPerFloor: maxFlatPerFloor,
                    isSetUp: true
                }
                let updateWingDataIs = await wingSchema.findByIdAndUpdate(wingId,updateWing);

                for(let k=0;k<noOfParkingSlots;k++){
                    let addParkingSlot = await new parkingSchema({
                        societyId: societyId,
                        wingId: wingId,
                        parkingSlotNo: "PARK-"+ wingName + k
                    });
                    if(addParkingSlot != null){
                        addParkingSlot.save();
                    }
                }
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: 1, 
                    Message: "Department Data Updated and parking slots created" 
                });
            }else if(societyCategory == "Society"){
                if(getExistWing[0].isSetUp == true){
                    // For Society
                    let deleteFlats = await flatSchema.deleteMany({ wingId: mongoose.Types.ObjectId(wingId) });
                    let deleteParking = await parkingSchema.deleteMany({ wingId: mongoose.Types.ObjectId(wingId) });
    
                    let updateWing = {
                        wingName: wingName.toUpperCase(),
                        totalFloor: totalFloor,
                        maxFlatPerFloor: maxFlatPerFloor,
                        isSetUp: true
                    }
                    let updateWingDataIs = await wingSchema.findByIdAndUpdate(wingId,updateWing);
                
                    for(let i=0;i<flatList.length;i++){
                        let addFlat = await new flatSchema({
                            flatNo: (flatList[i].flatNo).toUpperCase(),
                            societyId: societyId,
                            residenceType: Number(flatList[i].residenceType),
                            wingId: wingId
                        });
                        if(addFlat != null){
                            await addFlat.save();
                        }
                    }
                    for(let k=0;k<noOfParkingSlots;k++){
                        let addParkingSlot = await new parkingSchema({
                            societyId: societyId,
                            wingId: wingId,
                            parkingSlotNo: "PARK-"+ wingName + k
                        });
                        if(addParkingSlot != null){
                            addParkingSlot.save();
                        }
                    }
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Data: 1, 
                        Message: "Wing Data Updated and flats & parking slots created" 
                    });
                }
                let updateWing = {
                    wingName: wingName.toUpperCase(),
                    totalFloor: totalFloor,
                    maxFlatPerFloor: maxFlatPerFloor,
                    isSetUp: true
                }
                let updateWingDataIs = await wingSchema.findByIdAndUpdate(wingId,updateWing);
                for(let i=0;i<flatList.length;i++){
                    let addFlat = await new flatSchema({
                        flatNo: (flatList[i].flatNo).toUpperCase(),
                        societyId: societyId,
                        residenceType: Number(flatList[i].residenceType),
                        wingId: wingId
                    });
                    if(addFlat != null){
                        await addFlat.save();
                    }
                }
                for(let k=0;k<noOfParkingSlots;k++){
                    let addParkingSlot = await new parkingSchema({
                        societyId: societyId,
                        wingId: wingId,
                        parkingSlotNo: "PARK-"+ wingName + k
                    });
                    if(addParkingSlot != null){
                        addParkingSlot.save();
                    }
                }
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: 1, 
                    Message: "Wing Data Updated and flats & parking slots created" 
                });
            }else{
                return res.status(200).json({
                    IsSuccess: true,
                    Data: [],
                    Message: "Please Provide Proper Value To societyCategory Field which is either Society or Industrial"
                })
            }
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Such a wing found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Parking Slots-------------------MONIL----------------------21/05/2021
router.post("/getParkingSlots",async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        
        if(societyId != undefined && societyId != null && societyId != "" && wingId != undefined && wingId != null && wingId != ""){
            let getParkingSlots = await parkingSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { wingId: mongoose.Types.ObjectId(wingId) }
                        ]
                    }
                }
            ]);

            if(getParkingSlots.length > 0){
                return res.status(200).json({ IsSuccess: true , Data: getParkingSlots , Message: "Wing Parking Slot Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: getParkingSlots , Message: "No Parking Slot Found" });
            }
        }else{
            let getParkingSlots = await parkingSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);

            if(getParkingSlots.length > 0){
                return res.status(200).json({ IsSuccess: true , Data: getParkingSlots , Message: "Society Parking Slot Found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: getParkingSlots , Message: "No Parking Slot Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Flats of society----------------MONIL----------------------28/03/2021
router.post("/getFlatsOfSociety",async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getFlats = await flatSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { wingId: mongoose.Types.ObjectId(wingId) }
                    ]
                }
            }
        ]);

        if(getFlats.length >0){
            res.status(200).json({ IsSuccess: true , Count: getFlats.length , Data: getFlats , Message: "Flats found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Flats found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Wings using society code ---------------------MONIL---------10/04/2021
router.post("/getSocietyWings",async function(req,res,next){
    try {
        const { societyCode } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    societyCode: societyCode
                }
            }
        ]);

        if(getSociety.length == 1){
            let societyId = getSociety[0]._id;

            let societywings = await wingSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);

            if(societywings.length >0){
                res.status(200).json({ IsSuccess: true , Count: societywings.length , Data: societywings , Message: "Wings found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Wings found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Flat Of Society using societyCode and wingId ------------MONIL-----10/04/2021
router.post("/getSocietyFlats",async function(req,res,next){
    try {
        const { wingId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getFlats = await flatSchema.aggregate([
            {
                $match: {
                    wingId: mongoose.Types.ObjectId(wingId)
                }
            }
        ]);

        if(getFlats.length >0){
            res.status(200).json({ IsSuccess: true , Count: getFlats.length , Data: getFlats , Message: "Flats found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Flats found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Residence type-------------------MONIL-----------------------28/03/2021
// 0 - Owner
// 1 - Closed
// 2 - Rent
// 3 - Dead
// 4 - Shop
router.post("/insertResidenceType",async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        
        let bodyIs = req.body;

        bodyIs.forEach(async function(data){
            let flatIdIs = String(data.flatId);
            CheckFlats  = await flatSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(flatIdIs)
                    }
                }
            ]);
            if(CheckFlats.length == 1){
                let updateIs = {
                    residenceType: data.residenceType
                }
                let updateFlatDetails = await flatSchema.findByIdAndUpdate(flatIdIs,updateIs);
            }
            
        })

        res.status(200).json({ IsSuccess: true , Data: 1 , Message: `FlatIds residence type updated` });
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Members business Category---------------MONIL----------------------04/03/2021
router.post("/addProfessionCategory", async function(req,res,next){
    try {
        const { ProfessionName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExistProfessionCategory = await professionSchema.aggregate([
            {
                $match: {
                    ProfessionName: { $in : ProfessionName}
                }
            }
        ]);

        if(checkExistProfessionCategory.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Profession Category ${ProfessionName} already added ` });
        }

        ProfessionName.forEach(async function(categoryIs){
            let addProfessionCategoryIs = await new professionSchema({
                ProfessionName : categoryIs
            });
            if(addProfessionCategoryIs != null){
                addProfessionCategoryIs.save()
            }
        });

        if(ProfessionName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Profession Category ${ProfessionName} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Profession Category ${ProfessionName} not added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Members All business Category---------------MONIL----------------------04/03/2021
router.post("/getAllProfessionCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllProfessionCategoryIs = await professionSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getAllProfessionCategoryIs.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getAllProfessionCategoryIs , Message: `Profession Categories Found ` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Profession Categories Found ` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Staff Category---------------MONIL------------------18/02/2021
router.post("/addStaffCategory", async function(req,res,next){
    try {
        const { staffCategoryName } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await staffCategorySchema.aggregate([
            {
                $match: { staffCategoryName: { $in: staffCategoryName} }
            }
        ]);

        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Staff Category Already Exist` });
        }

        staffCategoryName.forEach(async function(category){
            let staffCategory = await new staffCategorySchema({
                staffCategoryName: category
            });

            if(staffCategory != null){
                staffCategory.save();
            }
        });
        
        if(staffCategoryName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Staff Category Added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Category Not Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Staff Category---------------------MONIL-------------------23/03/2021
router.post("/getAllStaffCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let staffCategoryAre = await staffCategorySchema.aggregate([
            {
                $match: {}
            }
        ])
        if(staffCategoryAre.length >0){
            res.status(200).json({ IsSuccess: true , Count: staffCategoryAre.length , Data: staffCategoryAre , Message: "Staff Category Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Staff Category Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Staff Category----------------------MONIL-----------------15/03/2021
router.post("/deleteStaffCategory",async function(req,res,next){
    try {
        const { staffCategoryId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await staffCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(staffCategoryId)
                }
            }
        ]);

        if(checkExist.length == 1){
            let deleteCategory = await staffCategorySchema.findByIdAndDelete(staffCategoryId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff Category ${checkExist[0].staffCategoryName} Deleted` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Staff Category Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//add identity proof Category-----------------MONIL-----------------26/02/2021
router.post("/addidentityCategory", async function(req,res,next){
    try {
        const { identityProofName } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await identityProofSchema.aggregate([
            {
                $match: {
                    identityProofName: { $in: identityProofName }
                }
            }
        ]);
        
        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Identity Category ${identityProofName} Already Exist` });
        }

        identityProofName.forEach(async function(categoryIs){
            let addIdentityProof = await new identityProofSchema({
                identityProofName: categoryIs
            });
            if(addIdentityProof != null){
                addIdentityProof.save();
            }
        });

        if(identityProofName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: identityProofName , Message: `Identity Proof Category ${identityProofName} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Identity Proof Category Not Added" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All identity proof Category-----------------MONIL-----------------26/02/2021
router.post("/getAllidentityCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getIdentityProof = await identityProofSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getIdentityProof.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getIdentityProof.length , Data: getIdentityProof , Message: "Identity Proof Category Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Identity Proof Category Not Found" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

// Delete identity Category-----------------------MONIL---------------------15/03/2021
router.post("/deleteIdentityCategory", async function(req,res,next){
    try {
        const { identityCategoryId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await identityProofSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(identityCategoryId)
                }
            }
        ]);
        if(checkExist.length == 1){
            let deleteCategory = await identityProofSchema.findByIdAndDelete(identityCategoryId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Identity Category ${checkExist[0].identityProofName} Deleted` })
        }else{
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "No Identity category found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All State-------------------MONIL---------28/03/2021
router.post("/getState", async function(req,res,next){
    try {
        const { countryCode } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let states = csc.getStatesOfCountry(countryCode);
        if(states.length > 0){
            res.status(200).json({ IsSuccess: true , Count: states.length , Data: states , Message: `State List Found for country code ${countryCode}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Countries Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All City-------------------MONIL---------28/03/2021
router.post("/getCity", async function(req,res,next){
    try {
        const { countryCode, stateCode } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let Cities = csc.getCitiesOfState(countryCode,stateCode);
        if(Cities.length > 0){
            res.status(200).json({ IsSuccess: true , Count: Cities.length , Data: Cities , Message: `City List Found for country code ${countryCode} and state code ${stateCode}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Cities Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Guest Purpose-----------------------------MONIL------------01/03/2021
router.post("/addGuestPurpose", async function(req,res,next){
    try {
        const { purposeName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await purposeSchema.aggregate([
            {
                $match: {
                    purposeName: { $in: purposeName }
                }
            }
        ]);

        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Category ${purposeName} already exist` });
        }

        purposeName.forEach(async function(categoryIs){
            let addPurpose = await new purposeSchema({
                purposeName: categoryIs
            });

            if(addPurpose != null){
                addPurpose.save()
            }
        })

        if(purposeName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: purposeName , Message: `Purpose Category ${purposeName} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Purpose Category ${purposeName} Not Added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Purpose Category------------------------MONIL-----------01/03/2021
router.post("/getAllPurposeCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllPurposeCategoriesAre = await purposeSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getAllPurposeCategoriesAre.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getAllPurposeCategoriesAre , Message: "Purpose Categories Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Purpose Categories Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Guest Category --------------------MONIL--------------02/01/2021
router.post("/addGuestCategory", guestcategoriesUploader.single("image") , async function(req,res,next){
    try {
        const { guestType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let checkExist = await guestCategorySchema.aggregate([
            {
                $match: { guestType: guestType }
            }
        ]);

        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Guest Category ${guestType} already exist` });
        }

        let addCategory = await new guestCategorySchema({
            guestType: guestType,
            image: file != undefined ? file.path : "" 
        });

        if(addCategory != null){
            addCategory.save();
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Guest Category ${guestType} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Guest Category ${guestType} not added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Guest Category --------------------MONIL--------------02/01/2021
router.post("/getAllGuestCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let guestCategory = await guestCategorySchema.aggregate([
            {
                $match: {  }
            }
        ]);
 
        if(guestCategory.length > 0){
            res.status(200).json({ IsSuccess: true , Count: guestCategory.length ,  Data: guestCategory , Message: "Guest Category Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Guest Category Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Company Category --------------------MONIL--------------02/01/2021
router.post("/addCompanyCategory", companyUploader.single("image") , async function(req,res,next){
    try {

        const { companyType } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let checkExist = await companyCategorySchema.aggregate([
            {
                $match: { companyType: companyType }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Company Category ${companyType} already exist` });
        }

        let addCategory = await new companyCategorySchema({
            companyType: companyType,
            image: file != undefined ? file.path : "" 
        });

        if(addCategory != null){
            addCategory.save();
            res.status(200).json({ IsSuccess: true , Data: [addCategory] , Message: `Company Category ${companyType} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Company Category ${companyType} not added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Company Category --------------------MONIL--------------02/01/2021
router.post("/getCompanyCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let companyCategory = await companyCategorySchema.aggregate([
            {
                $match: {  }
            }
        ]);
 
        if(companyCategory.length > 0){
            res.status(200).json({ IsSuccess: true , Count: companyCategory.length ,  Data: companyCategory , Message: "Company Category Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Company Category Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Guest Category------------------------MONIL------------15/03/2021
router.post("/deleteGuestCategory", async function(req,res,next){
    try {
        const { guestCategoryId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await guestCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(guestCategoryId)
                }
            }
        ]);

        if(checkExist.length == 1){
            let deleteCategory = await guestCategorySchema.findByIdAndDelete(guestCategoryId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Guest Category ${checkExist[0].guestType} Deleted` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Guest Category Found` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Notice Board---------------------------------MONIL---------------------13/02/2021
router.post("/addNotice", noticeFile.single("FileAttachment") , async function(req,res,next){
    try {
        const { societyId , Title , Description , wingIds , adminId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let addNotice;
        const file = req.file;

        if(!adminId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide adminId" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            }
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society admins can add notice board" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for societyId ${societyId}` });
        }

        if(wingIds != undefined && wingIds != "" && wingIds != null && wingIds != []){
            let wingList = wingIds.split(",");
            addNotice = await new noticeBoardSchema({
                societyId: societyId,
                Title: Title,
                Description: Description,
                noticeFor: {
                    isForWholeSociety: false,
                    wingId: wingList
                },
                FileAttachment: file != undefined ? file.path : '',
                dateTime: getCurrentDateTime()
            });
        }else{

            let wingList = await getSocietyWings(societyId)
            addNotice = await new noticeBoardSchema({
                societyId: societyId,
                Title: Title,
                noticeFor: {
                    isForWholeSociety: true,
                    wingId: wingList
                },
                Description: Description,
                FileAttachment: file != undefined ? file.path : '',
                dateTime: getCurrentDateTime()
            });
        }
        
        if(addNotice != null){
            try {
                await addNotice.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }

            let memberIdList;

            if(addNotice.noticeFor.isForWholeSociety == false){
                let wingList = wingIds.split(",");
                memberIdList = await getSocietyWingMembers(societyId,wingList);
            }else{
                memberIdList = await getSocietyMember(societyId);
            }

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList);

                let titleIs = `New Notice of ${Title} from ${getSociety[0].Name} `;
                let bodyIs = `${Description}`;

                let notiDataIs = {
                    notificationType: "NoticeBoard",
                    Message: `New Notice from ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    Image: file != undefined ? file.path : '',
                    Title: Title,
                    Description: Description,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.isAdmin == 0 && tokenIs.muteNotificationAudio == false){
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"NoticeBoard","IOS");
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"NoticeBoard","Android");   
                        }
                        // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"NoticeBoard",tokenIs.DeviceType);
                    }
                });
            }
            res.status(200).json({ IsSuccess: true , Data: [addNotice] , Message: `Notice Added to societyId ${societyId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Notice Not Added to societyId ${societyId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Society Notice-----------------------MONIL---------------------13/02/2021
router.post("/getSocietyNotice", async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
 
        if(wingId != undefined && wingId != null && wingId != ""){
            let noticeBoard = await noticeBoardSchema.aggregate([
                {
                    $match: { 
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { 
                                "noticeFor.wingId":  {
                                    $elemMatch: {
                                        $eq: mongoose.Types.ObjectId(wingId)
                                    }
                                }
                            }
                        ] 
                    }
                }
            ]);
            if(noticeBoard.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: noticeBoard.length, 
                    Data: noticeBoard, 
                    Message: "Society Wing Notice Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Wing Notice Found" });
            }
        }else{
            let noticeBoard = await noticeBoardSchema.aggregate([
                {
                    $match: { societyId: mongoose.Types.ObjectId(societyId) }
                }
            ]);
            if(noticeBoard.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: noticeBoard.length, 
                    Data: noticeBoard, 
                    Message: "Society Notice Found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Notice Found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update In notice----------------------------MONIL----------------------13/02/2021
router.post('/editNotice', noticeFile.single("FileAttachment") , async function(req,res,next){
    try {
        const { noticeId , Title , Description , wingName  } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        let checkExistNotice = await noticeBoardSchema.aggregate([
            {
                $match: { _id: mongoose.Types.ObjectId(noticeId) }
            }
        ]);
        const file = req.file;
        if(checkExistNotice.length == 1){
            let updateIs;
            if(wingName != undefined){
                updateIs = {
                    Title: Title != undefined ? Title : checkExistNotice[0].Title,
                    Description: Description != undefined ? Description : checkExistNotice[0].Description,
                    noticeFor: {
                        isForWholeSociety: false,
                        wingName: wingName
                    },
                    FileAttachment: file != undefined ? file.path : checkExistNotice[0].FileAttachment,
                }
            }else{
                updateIs = {
                    Title: Title != undefined ? Title : checkExistNotice[0].Title,
                    Description: Description != undefined ? Description : checkExistNotice[0].Description,
                    FileAttachment: file != undefined ? file.path : checkExistNotice[0].FileAttachment,
                }
            }
            let updateNoticeIs = await noticeBoardSchema.findByIdAndUpdate(noticeId,updateIs);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Notice Updated on noticeId ${noticeId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Notice Found for noticeId ${noticeId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Notice--------------------------------MONIL---------------------13/02/2021
router.post('/deleteNotice' , async function(req,res,next){
    try {
        const { noticeId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        let checkExistNotice = await noticeBoardSchema.aggregate([
            {
                $match: { _id: mongoose.Types.ObjectId(noticeId) }
            }
        ]);
        
        if(checkExistNotice.length == 1){
            let deleteNoticeIs = await noticeBoardSchema.findByIdAndDelete(noticeId);
        
            let deleteNoticeFile = await deleteFile(checkExistNotice[0].FileAttachment);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Notice Deleted for noticeId ${noticeId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Notice Found for noticeId ${noticeId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Society Documents----------MONIL----------30/03/2021
router.post("/addSocietyDocs", societyDocsFiles.single("FileAttachment") ,async function(req,res,next){
    try {
        const { societyId , Title , adminId , wingIds } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        {
                            society: {
                                $elemMatch: {
                                    societyId: mongoose.Types.ObjectId(societyId),
                                    isAdmin: 1
                                }
                            }
                        }
                    ]
                }
            }
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only Society Admin Can Add Documents" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for id ${societyId}` });
        }

        const file = req.file;
        let addDocs;

        if(wingIds != undefined && wingIds != null && wingIds != "" && wingIds != []){
            let wingList = wingIds.split(",");
            addDocs = await new societyDocsSchema({
                societyId: societyId,
                Title: Title,
                docFor: {
                    isForWholeSociety: false,
                    wingId: wingList
                },
                FileAttachment: file != undefined && file != "" ? file.path : "",
                dateTime: getCurrentDateTime()
            });
        }else{
            let wingList = await getSocietyWings(societyId);
            addDocs = await new societyDocsSchema({
                societyId: societyId,
                Title: Title,
                docFor: {
                    isForWholeSociety: true,
                    wingId: wingList
                },
                FileAttachment: file != undefined && file != "" ? file.path : "",
                dateTime: getCurrentDateTime()
            });
        }

        if(addDocs != null){
            try {
                await addDocs.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }

            let memberIdList;

            if(addDocs.docFor.isForWholeSociety == false){
                let wingList = wingIds.split(",");
                memberIdList = await getSocietyWingMembers(societyId,wingList);
            }else{
                memberIdList = await getSocietyMember(societyId);
            }

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList);

                let titleIs = `New Documnet From ${getSociety[0].Name} `;
                let bodyIs = `About: ${Title}`;

                let notiDataIs = {
                    notificationType: "AddDocument",
                    Message: `New Documnet of ${Title} from ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    Title: Title,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.isAdmin == 0 && tokenIs.muteNotificationAudio == false){
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddDocument","IOS");
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddDocument","Android");
                        }
                        // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"AddDocument",tokenIs.DeviceType);
                    }
                })
            }
            res.status(200).json({ IsSuccess: true , Data: [addDocs] , Message: `Society Docs ${Title} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Docs added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society docs---------------MONIL---------30/03/2021
router.post("/getSocietyDocs",async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSocietyDoc;

        if(wingId != undefined && wingId != null && wingId != "" && wingId != []){
            getSocietyDoc = await societyDocsSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { 
                                "docFor.wingId": {
                                    $elemMatch: {
                                        $eq: mongoose.Types.ObjectId(wingId)
                                    }
                                } 
                            }
                        ]
                    }
                }
            ]);

            if(getSocietyDoc.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getSocietyDoc.length, 
                    Data: getSocietyDoc, 
                    Message: "Society Wings Docs found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Wing Docs found" });
            }
        }else{
            getSocietyDoc = await societyDocsSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);

            if(getSocietyDoc.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getSocietyDoc.length, 
                    Data: getSocietyDoc, 
                    Message: "Society Docs found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Docs found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Edit Society Documents-------------------------MONIL---------------------27/04/2021
router.post("/updateSocietyDoc", societyDocsFiles.single("FileAttachment") ,async function(req,res,next){
    try {
        const { societyId , documentId , Title } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDocument = await societyDocsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(documentId) },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);

        if(getDocument.length == 1){
            const file = req.file;

            let update = {
                Title: Title != undefined ? Title : getDocument[0].Title,
                FileAttachment: file != undefined && file != "" ? file.path : getDocument[0].FileAttachment
            }

            let updateDoc = await societyDocsSchema.findByIdAndUpdate(documentId,update);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Society Doc ${getDocument[0].Title} Updated` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Society Doc Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Document--------------------------------MONIL---------------------13/02/2021
router.post('/deleteSocietyDoc' , async function(req,res,next){
    try {
        const { documentId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        let checkExistDocument = await societyDocsSchema.aggregate([
            {
                $match: { _id: mongoose.Types.ObjectId(documentId) }
            }
        ]);
        
        if(checkExistDocument.length == 1){
            let deleteDocumentIs = await societyDocsSchema.findByIdAndDelete(documentId);
            let deleteNoticeFile = await deleteFile(checkExistDocument[0].FileAttachment);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Document Deleted for documentId ${documentId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Document Found for documentId ${documentId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Society Rules----------MONIL----------30/03/2021
router.post("/addSocietyRules", societyDocsFiles.single("FileAttachment") ,async function(req,res,next){
    try {
        const { societyId , Title , Description , wingIds } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let addRules;

        if(wingIds != undefined && wingIds != null && wingIds != "" && wingIds != []){
            let wingList = wingIds.split(",");
            addRules = await new societyRulesSchema({
                societyId: societyId,
                Title: Title,
                ruleFor: {
                    isForWholeSociety: false,
                    wingId: wingList
                },
                Description: Description,
                FileAttachment: file != undefined ? file.path : "",
                dateTime: getCurrentDateTime()
            });
        }else{
            let wingList = await getSocietyWings(societyId);
            addRules = await new societyRulesSchema({
                societyId: societyId,
                Title: Title,
                ruleFor: {
                    isForWholeSociety: true,
                    wingId: wingList
                },
                Description: Description,
                FileAttachment: file != undefined ? file.path : "",
                dateTime: getCurrentDateTime()
            });
        }

        if(addRules != null){
            try {
                await addRules.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            res.status(200).json({ IsSuccess: true , Data: [addRules] , Message: `Society Rules ${Title} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Rules added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Society Rules----------MONIL----------30/03/2021
router.post("/updateSocietyRules", societyDocsFiles.single("FileAttachment") ,async function(req,res,next){
    try {
        const { ruleId , Title , Description } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getSocietyRule = await societyRulesSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(ruleId)
                }
            }
        ]);

        if(getSocietyRule.length == 1){
            const file = req.file;

            let update = {
                Title: Title,
                Description: Description,
                FileAttachment: file != undefined && file != "" && file != null ? file.path : getSocietyRule[0].FileAttachment,
            }

            let updateRule = await societyRulesSchema.findByIdAndUpdate(ruleId,update);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Society Rule Updated" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Society Docs found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Rules---------------MONIL---------30/03/2021
router.post("/getSocietyRules",async function(req,res,next){
    try {
        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];
       
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(wingId != undefined && wingId != null && wingId != ""){
            let getSocietyRule = await societyRulesSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { 
                                "ruleFor.wingId": {
                                    $elemMatch: {
                                        $eq: mongoose.Types.ObjectId(wingId)
                                    }
                                } 
                            }
                        ]
                    }
                }
            ]);
    
            if(getSocietyRule.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getSocietyRule.length, 
                    Data: getSocietyRule, 
                    Message: "Society Wing Rules found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Wing Rules found" });
            }
        }else{
            let getSocietyRule = await societyRulesSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);
    
            if(getSocietyRule.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Count: getSocietyRule.length, 
                    Data: getSocietyRule, 
                    Message: "Society Rules found" 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Rules found" });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete society Rule--------------------------------MONIL---------------------13/02/2021
router.post('/deleteSocietyRule' , async function(req,res,next){
    try {
        const { ruleId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        let checkExistRule = await societyRulesSchema.aggregate([
            {
                $match: { _id: mongoose.Types.ObjectId(ruleId) }
            }
        ]);
        
        if(checkExistRule.length == 1){
            let deleteRuleIs = await societyRulesSchema.findByIdAndDelete(ruleId);
            let deleteRuleFile = await deleteFile(checkExistRule[0].FileAttachment);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Rule Deleted for ruleId ${ruleId}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Rule Found for ruleId ${ruleId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Event--------------MONIL---------------------30/03/2021
router.post("/addEvent" , async function(req,res,next){
    try {
        const { Title , Description , EventType , societyId , wingIdList , organisedBy , venue , date , adminId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        console.log(adminId);

        if(!adminId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide adminId" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            }
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society admins can add notice board" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for societyId ${societyId}` });
        }


        let addEvent = await new eventSchema({
            Title: Title,
            Description: Description,
            EventType: EventType,
            societyId: societyId,
            wingIdList: wingIdList,
            organisedBy: organisedBy,
            venue: venue,
            date: date != undefined ? date : getCurrentDate(),
            addTimeStamp: getCurrentDateTime()
        });

        if(addEvent != null){
            try {
                await addEvent.save();
            } catch (error) {
                res.status(500).json({ IsSuccess: false , Message: error.message });
            }

            let memberIdList = await getSocietyMember(societyId);

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList,adminId);

                let titleIs = `New Event of ${Title} from ${getSociety[0].Name} `;
                let bodyIs = `About: ${Description} , EventDate: ${addEvent.date}`;

                let notiDataIs = {
                    notificationType: "AddEvent",
                    Message: `New Event of ${Title} from ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    Title: Title,
                    Description: Description,
                    EventDate: addEvent.date,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }

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
                            
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddEvent","IOS");
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
                            
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddEvent","Android");
                        }
                    }
                    // if(tokenIs.isAdmin == 0){
                        
                    //     // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"AddEvent",tokenIs.DeviceType);
                    // }
                })
            }
            res.status(200).json({ IsSuccess: true , Data: [addEvent] , Message: `Event ${Title} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Event Added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Event------------------------MONIL--------------27/04/2021
router.post("/updateEvent",async function(req,res,next){
    try {
        const { Title , EventType , Description , date , organisedBy , eventId , venue } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getEvents = await eventSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(eventId)
                }
            }
        ]);

        if(getEvents.length == 1){
            let update = {
                Title: Title,
                Description: Description,
                EventType: EventType,
                date: date,
                organisedBy: organisedBy,
                venue: venue
            }

            let updateEvent = await eventSchema.findByIdAndUpdate(eventId,update);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Event Updated" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Event Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add event Wings---------------MONIL--------------------11/04/2021
router.post("/addEventWings",async function(req,res,next){
    try {
        const { eventId , wingIdList } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getEvent = await eventSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(eventId)
                }
            }
        ]);

        if(getEvent.length == 1){
            let update = {
                wingIdList: wingIdList
            };

            let updatewing = await eventSchema.findByIdAndUpdate(eventId,update);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Event wings added" });

        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Event found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Events---------------------MONIL-------------30/03/2021
router.post("/getSocietyEvent",async function(req,res,next){
    try {
        const { societyId , memberId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getEvents = await eventSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "wings",
                    localField: "wingIdList",
                    foreignField: "_id",
                    as: "WingData"
                }
            },
            {
                $lookup: {
                    from: "eventregistrations",
                    let: { eventId: "$_id" },
                    pipeline: [
                        { 
                            $match:
                                { 
                                    $expr: { $eq: [ "$$eventId", "$eventId" ] }
                                }
                        },
                        {
                            $project: {
                                __v: 0
                            }
                        }
                    ],
                    as: "Registration"
                }
            },
            {
                $addFields: {
                    RegistrationCount: {
                        $size: "$Registration"
                    }
                }
            },
            {
                $addFields: {
                    ComingMemberCount: {
                        $sum: { $sum: "$Registration.noOfPerson" }
                    }
                }
            },
            {
                $project: {
                    "WingData.totalFloor" : 0,
                    "WingData.maxFlatPerFloor" : 0,
                    "WingData.societyId" : 0,
                    "WingData.societyId" : 0,
                    "WingData.__v" : 0,
                    __v : 0,
                    wingIdList : 0,
                }
            }
        ]);

        if(getEvents.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getEvents.length , Data: getEvents , Message: "Events Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Events Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Event
router.post("/getSocietyEvent_v2",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Event--------------------------MONIL----------------29/04/2021
router.post("/deleteEvent",async function(req,res,next){
    try {
        const { eventId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getEvent = await eventSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(eventId)
                }
            }
        ]);

        if(getEvent.length == 1){
            let deleteEvent = await eventSchema.findByIdAndDelete(eventId);

            let fileList = getEvent[0].images;

            fileList.forEach(async filePath=>{
                let deleteEventFile = await deleteFile(filePath);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Event ${getEvent[0].Title} Deleted` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `No Event Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Event Registration------------MONIL----------------30/03/2021
//response - 1 - Yes
//response - 0 - No
router.post("/eventRegistration",async function(req,res,next){
    try {
        const { eventId , memberId , noOfPerson , response } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let addRegistration = await new eventRegistrationSchema({
            eventId: eventId,
            memberId: memberId,
            response: response,
            noOfPerson: Number(noOfPerson),
            dateTime: getCurrentDateTime()
        });

        if(addRegistration != null){
            addRegistration.save();
            res.status(200).json({ IsSuccess: true , Data: [addRegistration] , Message: `Member memberId ${memberId} Registration for eventId ${eventId} successfully` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Event Registration faild" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Vendor Category----------------------------------MONIL---------------------02/03/2021
router.post("/addVendorCategory", vendorCategoryUploader.single("image") , async function(req,res,next){
    try {
        const { vendorCategoryName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let checkExist = await vendorCategorySchema.aggregate([
            {
                $match: {
                    vendorCategoryName: vendorCategoryName
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Vendor Category ${vendorCategoryName} Already exist` });
        }

        let addCategory = await new vendorCategorySchema({
            vendorCategoryName: vendorCategoryName,
            image: file != undefined ? file.path : ""
        });

        if(addCategory != null){
            addCategory.save();
            res.status(200).json({ IsSuccess: true , Data: [addCategory] , Message: `Vendor Category ${vendorCategoryName} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Vendor Category ${vendorCategoryName} not added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Vendor Category---------------------MONIL----------------------02/03/2021
router.post("/getAllVendorCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllVendorCategories = await vendorCategorySchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getAllVendorCategories.length >0){
            res.status(200).json({ IsSuccess: true , Data: getAllVendorCategories , Message: `Vendor Category found` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Vendor Category not found` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Vendor Category-----------------------MONIL---------------------15/03/2021
router.post("/deleteVendorCategory", async function(req,res,next){
    try {
        const { vendorCategoryId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken !== config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await vendorCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(vendorCategoryId)
                }
            }
        ]);
        if(checkExist.length == 1){
            let deleteCategory = await vendorCategorySchema.findByIdAndDelete(vendorCategoryId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Vendor Category ${checkExist[0].vendorCategoryName} Deleted` })
        }else{
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "No vendor category found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Emergency Contact Number---------------------MONIL--------02/01/2021
router.post("/addEmergencyNumber", emergencyImg.single("image") , async function(req,res,next){
    try {
        const { contactName , contactNo } = req.body;
        
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;
        
        let checkExistNo = await emergencyContactsSchema.aggregate([
            {
                $match: { 
                    contactNo: contactNo 
                }
            }
        ]);
        if(checkExistNo.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Emergency Contact Number ${contactNo} already exist` });
        }else{
            let addEmergencyContact = await new emergencyContactsSchema({
                contactName: contactName,
                contactNo: contactNo,
                image: file != undefined ? file.path : ""
            });
            if(addEmergencyContact != null){
                addEmergencyContact.save();
                res.status(200).json({ IsSuccess: true , Data: [addEmergencyContact] , Message: `Emergency Contact ${contactNo} Added` });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [addEmergencyContact] , Message: `Emergency Contact ${contactNo} Not Added` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Emergency Contacts----------------MONIL------------02/01/2021
router.post("/getAllEmergencyContacts", async function(req,res,next){
    try {
        
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let emergencyContacts = await emergencyContactsSchema.aggregate([
            {
                $match: {}
            }
        ]);
        if(emergencyContacts.length > 0){
            res.status(200).json({ IsSuccess: true , Count: emergencyContacts.length , Data: emergencyContacts , Message: "Emergency Contacts Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Emergency Contacts Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Directory Listing------------------MONIL--------01/04/2021
router.post("/directoryListing",async function(req,res,next){
    try {
        const { societyId , memberId } = req.body;

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
            let getDirectoryList;

            if(memberId != undefined && memberId != null && memberId != ""){
                getDirectoryList = await memberSchema.aggregate([
                    {
                        $unwind: "$society"
                    },  
                    {
                        $match: {
                            $and: [
                                { "society.societyId": mongoose.Types.ObjectId(societyId) },
                                { _id: { $ne: mongoose.Types.ObjectId(memberId) } }
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
                    }
                ]);
            }else{
                getDirectoryList = await memberSchema.aggregate([
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
                    }
                ]);
            }

            if(getDirectoryList.length > 0){
                res.status(200).json({ IsSuccess: true , Count: getDirectoryList.length , Data: getDirectoryList , Message: "Directory Listing found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Directory Listing found" });
            }
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society found for societyId ${societyId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Area of City--------------------MONIL------------01/04/2021
router.post("/addAreaOfCity",async function(req,res,next){
    try {
        const { Title , stateCode , city } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await areaSchema.aggregate([
            {
                $match: {
                    Title: {
                        $regex: Title,
                        $options : "i"
                    }
                }
            }
        ]);
        
        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Area ${Title} already exist` });
        }

        let addArea = await new areaSchema({
            Title: Title,
            stateCode: stateCode,
            city: city
        });

        if(addArea != null){
            addArea.save();
            res.status(200).json({ IsSuccess: true , Data: [addArea] , Message: `Area ${Title} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Area ${Title} not added` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
}); 

//Get All Area of City-------------------MONIL------------01/04/2021
router.post("/getCityArea",async function(req,res,next){
    try {
        const { stateCode , city } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAreas = await areaSchema.aggregate([
            {
                $match: {
                    $and: [
                        {stateCode: stateCode },
                        {city: city }
                    ]
                }
            }
        ]);

        if(getAreas.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getAreas.length ,  Data: getAreas , Message: `${city} area found` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No area found for ${city} city` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Advertise Package-----------------MONIL-----------01/04/2021
router.post("/addAdvertisePackage",async function(req,res,next){
    try {
        const { packageName , price , duration } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let addPackage = await new adsPackageSchema({
            packageName: packageName,
            price: price,
            duration: duration
        });

        if(addPackage != null){
            addPackage.save();
            res.status(200).json({ IsSuccess: true , Data: [addPackage] , Message: "Package added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Package added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Advertise Packages------------------MONIL------------------01/04/2021
router.post("/getAdvertisePackage",async function(req,res,next){
    try {
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAllPackage = await adsPackageSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getAllPackage.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getAllPackage.length , Data: getAllPackage , Message: "Advertise Packages Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Advertise Packages Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get List of unapproved Member List------------MONIL---------02/04/2021
router.post("/getMemberApprovalList",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMembers = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isVerify": false }
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
        ]);

        if(getMembers.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: getMembers.length , Data: getMembers , Message: "Pending for Approval Member List Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: getMembers , Message: "No members found for Pending Approval" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Approve / DisApprove the member------------------MONIL--------02/04/2021
router.post("/memberApproval",async function(req,res,next){
    try {
        const { memberId , isVerify , societyId , adminId , wingId , flatId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $project: {
                    societyCode: 1,
                    Name: 1
                }
            }
        ]);

        if(checkSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

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

        if(getFlat.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Flat Found" });
        }

        let societyCode = checkSociety[0].societyCode;
        let Flat = getFlat[0].flatNo;
        let Wing = getFlat[0].WingData[0].wingName;

        if(isVerify == true){
            
            let verifyMember = await memberSchema.updateOne(
                { _id: mongoose.Types.ObjectId(memberId) },
                { $set: { "society.$[i].isVerify": true } },
                { multi: true,
                    arrayFilters: [ 
                        { "i.societyId": mongoose.Types.ObjectId(societyId) }, 
                        { "i.wingId": mongoose.Types.ObjectId(wingId) }, 
                        { "i.flatId": mongoose.Types.ObjectId(flatId) } 
                    ]
                }
            );

            let titleIs = `You are verified for society ${checkSociety[0].Name} & Property ${Wing}-${Flat}`; 
            let bodyIs = `You are verified for society ${checkSociety[0].Name}, Now You Can Login to the society`;
            
            let notiDataIs = {
                NotificationType: "MemberVerify",
                SocietyCode: societyCode,
                SocietyName: checkSociety[0].Name,
                Wing: Wing,
                Flat: Flat,
                Message: `You Are verified , now you can join your society using society code: ${societyCode}`,
                content_available: true, 
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                view: "ghj"
            };

            let memberToken = await getSingleMemberPlayerId(memberId);

            memberToken.forEach(tokenIs => {
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
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"MemberVerify","IOS");
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
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"MemberVerify","Android");
                    }
                }
                
                // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"MemberVerify",tokenIs.DeviceType);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Member Is Verify and Approved" });
        }else{

            let getMember = await memberSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(memberId)
                    }
                },
                {
                    $project: {
                        society: 1
                    }
                }
            ]);

            let memberSociety = getMember[0].society;
            // let verifyMember = await memberSchema.updateOne(
            //     { _id: mongoose.Types.ObjectId(memberId) },
            //     { $set: { "society.$[i].isVerify": false } },
            //     { multi: true,
            //         arrayFilters: [ { "i.societyId": mongoose.Types.ObjectId(societyId) } ]
            //       }
            // );

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
            }

            let titleIs = `Your Verification for society ${checkSociety[0].Name} & Property ${Wing}-${Flat} is failed`; 
            let bodyIs = `You are not Verify for society ${checkSociety[0].Name} for any further query please contact society admin`;

            let notiDataIs = {
                NotificationType: "MemberVerify",
                SocietyCode: societyCode,
                SocietyName: checkSociety[0].Name,
                Wing: Wing,
                Flat: Flat,
                Message: `You are not Verify for society ${societyCode} for any further query please contact society admin`,
                content_available: true, 
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                view: "ghj"
            };

            let memberToken = await getSingleMemberPlayerId(memberId);

            memberToken.forEach(tokenIs => {
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
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"MemberVerify","IOS");
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
                        sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"MemberVerify","Android");
                    }
                }
                
                // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"MemberVerify",tokenIs.DeviceType);
            });

            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "Member Is Verify and DisApproved" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Society Amenities -------------------------MONIL --------------------09/03/2021
router.post("/addSocietyAmenity", amenitiesUploadIs.array("images") ,async function(req,res,next){
    try {
        const { amenityName , societyId , wingId , flatId , lat , long , completeAddress , description ,
                isPaid , Amount , fromTime , toTime , adminId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAdmin  = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            }
        ]);

        if(getAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society Admin can add amenity" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for id ${societyId}` });
        }

        const imageFiles = req.files;
        
        let imagePaths = [];

        for(let i=0;i<imageFiles.length;i++){
            imagePaths.push(imageFiles[i].path);
        }

        let isPaidIs = true
        if(isPaid == "false"){
            isPaidIs = false
        }

        let addAmenity = await new amenitySchema({
            amenityName: amenityName,
            societyId: societyId,
            images: imagePaths,
            isPaid: isPaidIs,
            Amount: isPaidIs == true ? parseFloat(Amount) : 0,
            fromTime: fromTime,
            toTime: toTime,
            location: {
                wingId: wingId == "" ? null : wingId,
                flatId: flatId == "" ? null : flatId,
                lat: lat,
                long: long,
                completeAddress: completeAddress
            },
            description: description 
        });

        if(addAmenity != null){
            try {
                await addAmenity.save();                 
            } catch (error) {
                res.status(500).json({ IsSuccess: false , Data: [] , Message: error.message });
            }
        
            let memberIdList = await getSocietyMember(societyId);

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList);

                let titleIs = `Amenity ${amenityName} Added `;
                let bodyIs = ` New Amenity ${amenityName}added in Society: ${getSociety[0].Name}`;

                let notiDataIs = {
                    notificationType: "NewAmenity",
                    Message: `New Amenity ${amenityName} added in Society: ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    Amenity: amenityName,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.admin == 0 && tokenIs.muteNotificationAudio == false){
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"NewAmenity","IOS");
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"NewAmenity","Android");
                        }
                    }
                    // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"NewAmenity",tokenIs.DeviceType);
                });
            } 
            res.status(200).json({ IsSuccess: true , Data: [addAmenity] , Message: "Amenity added" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "Amenity not added" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Data: [] , Message: error.message });
    }
});

//Get All Amenities---------------------------MONIL-----------------------09/03/2021
router.post("/getAllSocietyAmeties", async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAmenities = await amenitySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getAmenities.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getAmenities.length , Data: getAmenities , Message: "All amenities found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No amenities found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Data: [] , Message: error.message });
    }
});

//Update Society Amenity---------------------MONIL---------------------27/04/2021
router.post("/updateSocietyAmenity",async function(req,res,next){
    try {
        const { amenityName , amenityId , wingId , flatId , lat , long , completeAddress , description ,
            isPaid , Amount , fromTime , toTime , images } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAmenities = await amenitySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(amenityId)
                }
            }
        ]);

        if(getAmenities.length == 1){
            let imagePaths = [];

            if(images.length > 0){
                images.forEach(dataIs=>{
                    const path = 'uploads/amenities/'+ 'Society_Amenity' +Date.now()+'.png'
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imagePaths.push(path);
                });
            }
            
            let update = {
                amenityName: amenityName != undefined && amenityName != "" ? amenityName : getAmenities[0].amenityName,
                $push: {
                    images: imagePaths
                },
                isPaid: isPaid,
                Amount: isPaid == true ? parseFloat(Amount) : 0,
                fromTime: fromTime != undefined && fromTime != "" ? fromTime : getAmenities[0].fromTime,
                toTime: toTime != undefined && toTime != "" ? toTime : getAmenities[0].toTime,
                location: {
                    wingId: wingId == "" ? null : wingId,
                    flatId: flatId == "" ? null : flatId,
                    lat: lat,
                    long: long,
                    completeAddress: completeAddress
                },
                description: description != undefined ? description : getAmenities[0].description
            }

            let updateAmenity = await amenitySchema.findByIdAndUpdate(amenityId,update);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Amenity Updated" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No amenity found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Data: [] , Message: error.message });
    }
});

//Delete Society Amenity----------------------MONIL---------------------23/04/2021
router.post("/deleteSocietyAmenity",async function(req,res,next){
    try {
        const { societyId , amenityId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAmenity = await amenitySchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(amenityId) },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);

        if(getAmenity.length == 1){
            let deleteAmenity = await amenitySchema.findByIdAndDelete(amenityId);
            let fileList = getAmenity[0].images;

            fileList.forEach(async filePath=>{
                let deleteAmenityFile = await deleteFile(filePath);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Amenity ${getAmenity[0].amenityName} Deleted` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Amenity found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Data: [] , Message: error.message });
    }
});

//Add Polling Question------------------------MONIL----------------------24/03/2021
router.post("/addPollingQuestion",async function(req,res,next){
    try {
        const { pollQuestion , societyId , pollOption , adminId , wingIds } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(!adminId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide adminId" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            }
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society admins can add notice board" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for societyId ${societyId}` });
        }

        let addPollQuestion;

        if(wingIds != undefined && wingIds != null && wingIds != ""){
            addPollQuestion = await new pollingQuestionSchema({
                pollQuestion: pollQuestion,
                societyId: societyId,
                pollFor: {
                    isForWholeSociety: false,
                    wingId: wingIds
                },
                pollNo: getPollNumber(),
                dateTime: getCurrentDateTime()
            });
        }else{
            let wingList = await getSocietyWings(societyId);
            addPollQuestion = await new pollingQuestionSchema({
                pollQuestion: pollQuestion,
                societyId: societyId,
                pollFor: {
                    isForWholeSociety: true,
                    wingId: wingList
                },
                pollNo: getPollNumber(),
                dateTime: getCurrentDateTime()
            });
        }

        if(addPollQuestion != null){
            try {
                await addPollQuestion.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            
            let pollQuestionIdIs = addPollQuestion._id;
            let checkExistOption = await pollingOptionsSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { pollQuestionId: mongoose.Types.ObjectId(pollQuestionIdIs) },
                            { pollOption: { $in: pollOption } }
                        ]
                    }
                }
            ]);
    
            if(checkExistOption.length == 1){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Polling option ${pollOption} already exist` });
            }
    
            pollOption.forEach(async function(option){
                let addPollingOptions = await new pollingOptionsSchema({
                    pollQuestionId: pollQuestionIdIs,
                    pollOption: option
                });
                if(addPollingOptions != null){
                    addPollingOptions.save();
                }
            });
            let sendDataIs = {
                Questions: [addPollQuestion],
                Options: pollOption
            }

            let memberIdList;

            if(addPollQuestion.pollFor.isForWholeSociety == false){
                let wingList = wingIds.split(",");
                memberIdList = await getSocietyWingMembers(societyId,wingList);
            }else{
                memberIdList = await getSocietyMember(societyId);
            }

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList,adminId);

                let titleIs = `New Poll from Society: ${getSociety[0].Name}`;
                let bodyIs = `Poll Question: ${pollQuestion}`;

                let notiDataIs = {
                    notificationType: "AddPoll",
                    Message: `New Poll from Society: ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    PollQuestion: pollQuestion,
                    PollOption: pollOption
                }

                memberTokens.forEach(tokenIs=>{
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
                                ios_sound: "notification-_2_.wav"
                            };
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"AddPoll","IOS");
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
                            sendOneSignalNotification(message,true,false,tokenIs.memberId,watchmanId,"AddPoll","Android");
                        }
                    }
                    // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"AddPoll",tokenIs.DeviceType);
                })
            }
            res.status(200).json({ IsSuccess: true , Data: sendDataIs, Message: `Poll Question Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Poll Question Added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Polling Question of society------------------------MONIL----------------------24/03/2021
router.post("/getAllPollingQuestion",async function(req,res,next){
    try {
        const { societyId , memberId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let memberCount = await memberSchema.aggregate([
            {
                $match: {
                    society : { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } }
                }
            },
            {
                $count: "TotalMember"
            }
        ]);
        let temp = memberCount[0].TotalMember;
        
        if(memberId != undefined && memberId != null && memberId != ""){
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
                    $lookup: {
                        from: "pollanswers",
                        let: { pollQuesId: "$_id" },
                        pipeline: [
                            { 
                                $match:
                                    { 
                                        $and: [
                                            { 
                                                $expr: { 
                                                    $eq: [ "$$pollQuesId", "$pollQuestionId" ] 
                                                }, 
                                            },
                                            { responseByMembers: mongoose.Types.ObjectId(memberId) }
                                        ]
                                    }
                            },
                            {
                                $lookup: {
                                    from: "pollingoptions",
                                    localField: "pollOptionId",
                                    foreignField: "_id",
                                    as: "ResponseOptionIs"
                                }
                            },
                            {
                                $lookup: {
                                    from: "members",
                                    localField: "responseByMembers",
                                    foreignField: "_id",
                                    as: "ResponseMemberIs"
                                }
                            },
                            {
                                $project: {
                                    "ResponseMemberIs.Name": 1,
                                    "ResponseMemberIs.ContactNo": 1,
                                    "ResponseMemberIs.Image": 1,
                                    "ResponseOptionIs.pollOption": 1,
                                    pollQuestionId: 1,
                                    pollOptionId: 1,
                                    responseByMembers: 1,
                                }
                            }
                        ],
                        as: "PollAns"
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

            if(getPollQuestion.length > 0){
                res.status(200).json({ IsSuccess: true , Count: getPollQuestion.length , Data: getPollQuestion , Message: `Poll Questions Found for societyId ${societyId}` });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll Questions Found` });
            }
        }else{
            
            let getPollQuestion = await pollingQuestionSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: {
                        from: "pollingoptions",
                        let: { pollQuesId: "$_id" },
                        pipeline: [
                            {
                                $match: { 
                                    $expr: { $eq: [ "$$pollQuesId", "$pollQuestionId" ] }
                                }
                            },
                            {
                                $lookup: {
                                    from: "pollanswers",
                                    let: { pollOptionIdIs: "$_id" },
                                    pipeline: [
                                        { 
                                            $match:
                                                { 
                                                    $expr: { $eq: [ "$$pollOptionIdIs", "$pollOptionId" ] }
                                                }
                                        },
                                        {
                                            $lookup: {
                                                from: "members",
                                                localField: "responseByMembers",
                                                foreignField: "_id",
                                                as: "Member"
                                            }
                                        },
                                        {
                                            $project: {
                                                dateTime: 1,
                                                pollOptionId: 1,
                                                pollQuestionId: 1,
                                                "Member.Name": 1,
                                                "Member.ContactNo": 1,
                                                "Member.MemberNo": 1,
                                            }
                                        }
                                    ],
                                    as: "PollAnswer"
                                }
                            },
                            {
                                $addFields: { ResponseCount: { $size: "$PollAnswer" } }
                            },
                            {
                                $addFields: { ResponsePercent: { $multiply: ["$ResponseCount",100/temp] } }
                            },
                        ],
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
            if(getPollQuestion.length > 0){
                let sendData = getPollQuestion.push({MemberCount: temp});
                res.status(200).json({ 
                    IsSuccess: true , 
                    TotalQuestions: getPollQuestion.length - 1, 
                    Data: getPollQuestion , 
                    Message: `Poll Questions Found for societyId ${societyId}` 
                });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll Questions Found` });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Active/DisActive Poll Questions ------------------MONIL-----------------------------------24/03/2021
router.post("/enableOrDisablePollQues",async function(req,res,next){
    try {
        const { pollQuestionId , isActive } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let pollQuestionIs = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(pollQuestionId)
                }
            },
            {
                $project: {
                    isActive: 1,
                    societyId: 1,
                }
            }
        ]);

        if(pollQuestionIs.length == 1){
            let updateIs = {
                isActive: isActive
            }
            let updateInQuestion = await pollingQuestionSchema.findByIdAndUpdate(pollQuestionId,updateIs);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Poll question isActive : ${isActive}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll question found for pollQuestionId ${pollQuestionId}` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get all society poll responses----------------------MONIL----------------------11/04/2021
router.post("/getAllPollQuesResponse",async function(req,res,next){
    try {
        const { societyId } = req.body;

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
            let getPollQues = await await pollingQuestionSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $project: {
                        isActive: 1,
                        pollQuestion: 1,
                        pollNo: 1,
                    }
                }
            ]);

            if(getPollQues.length > 0){
                let memberCount = await memberSchema.aggregate([
                    {
                        $match: {
                            society : { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } }
                        }
                    },
                    {
                        $count: "TotalMember"
                    }
                ]);

                let temp = memberCount[0].TotalMember;

                let responseIs = [];

                for(let i=0;i<getPollQues.length;i++){
                    let getResponse = await pollingOptionsSchema.aggregate([
                        {
                            $match: {
                                pollQuestionId: mongoose.Types.ObjectId(getPollQues[i]._id)
                            }
                        },
                        {
                            $lookup: {
                                from: "pollanswers",
                                let: { pollOptionIdIs: "$_id" },
                                pipeline: [
                                    { 
                                        $match:
                                            { 
                                                $expr: { $eq: [ "$$pollOptionIdIs", "$pollOptionId" ] }
                                            }
                                    },
                                    {
                                        $lookup: {
                                            from: "members",
                                            localField: "responseByMembers",
                                            foreignField: "_id",
                                            as: "Member"
                                        }
                                    },
                                    {
                                        $project: {
                                            dateTime: 1,
                                            pollOptionId: 1,
                                            pollQuestionId: 1,
                                            "Member.firstName": 1,
                                            "Member.lastName": 1,
                                            "Member._id": 1,
                                        }
                                    }
                                ],
                                as: "PollAnswer"
                            }
                        },
                        {
                            $lookup: {
                                from: "pollquestions",
                                localField: "pollQuestionId",
                                foreignField: "_id",
                                as: "PollQuestion"
                            }
                        },
                        {
                            $addFields: { ResponseCount: { $size: "$PollAnswer" } }
                        },
                        {
                            $addFields: { ResponsePercent: { $multiply: ["$ResponseCount",100/temp] } }
                        },
                        {
                            $project: {
                                __v: 0,
                            }
                        }
                    ]);
                    if(getResponse.length > 0){
                        responseIs.push(getResponse);
                    }
                }

                if(responseIs.length > 0){
                    return res.status(200).json({ IsSuccess: true , Data: responseIs , Message: "Poll Response Found" });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Poll Response Found" });
                }   
            }else{
                return res.status(200).json({ IsSuccess: true , Data: responseIs , Message: "No Poll Question Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Polling Question Response------------------------MONIL----------------------24/03/2021
router.post("/getResponseOfPoll",async function(req,res,next){
    try {
        const { pollQuestionId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let societyIdIs = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(pollQuestionId)
                }
            },
            {
                $project: {
                    isActive: 1,
                    societyId: 1,
                }
            }
        ]);

        if(societyIdIs.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll question found for pollQuestionId ${pollQuestionId}` });
        }
        if(societyIdIs[0].isActive == false){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Poll Question is disable please enable for further process` });
        }

        societyIdIs = societyIdIs[0].societyId;

        let memberCount = await memberSchema.aggregate([
            {
                $match: {
                    society : { $elemMatch: { societyId: mongoose.Types.ObjectId(societyIdIs) } }
                }
            },
            {
                $count: "TotalMember"
            }
        ]);

        let temp = memberCount[0].TotalMember;

        let getResponse = await pollingOptionsSchema.aggregate([
            {
                $match: {
                    pollQuestionId: mongoose.Types.ObjectId(pollQuestionId)
                }
            },
            {
                $lookup: {
                    from: "pollanswers",
                    let: { pollOptionIdIs: "$_id" },
                    pipeline: [
                        { 
                            $match:
                                { 
                                    $expr: { $eq: [ "$$pollOptionIdIs", "$pollOptionId" ] }
                                }
                        },
                        {
                            $lookup: {
                                from: "members",
                                localField: "responseByMembers",
                                foreignField: "_id",
                                as: "Member"
                            }
                        },
                        {
                            $project: {
                                dateTime: 1,
                                pollOptionId: 1,
                                pollQuestionId: 1,
                                "Member.firstName": 1,
                                "Member.lastName": 1,
                                "Member._id": 1,
                            }
                        }
                    ],
                    as: "PollAnswer"
                }
            },
            {
                $lookup: {
                    from: "pollquestions",
                    localField: "pollQuestionId",
                    foreignField: "_id",
                    as: "PollQuestion"
                }
            },
            {
                $addFields: { ResponseCount: { $size: "$PollAnswer" } }
            },
            {
                $addFields: { ResponsePercent: { $multiply: ["$ResponseCount",100/temp] } }
            },
            {
                $project: {
                    __v: 0,
                    PollQuestion: 0
                }
            }
        ]);

        if(getResponse != null){
            res.status(200).json({ 
                IsSuccess: true , 
                Count: getResponse.length , 
                MemberCount: memberCount[0].TotalMember,
                Data: getResponse , 
                Message: `Poll Response Found for societyId ${pollQuestionId}` 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Poll Questions Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Polling Question---------------------MONIL---------------------24/03/2021
router.post("/deletePollQuestion",async function(req,res,next){
    try {
        const { pollQuestionId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkPollQuesion = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(pollQuestionId)
                }
            }
        ]);

        if(checkPollQuesion.length == 1){
            let deletePollQuestion = await pollingQuestionSchema.findByIdAndDelete(pollQuestionId);
            let deletePollOptions = await pollingOptionsSchema.deleteMany({ pollQuestionId: pollQuestionId });
            let deletePollAnswer = await pollingAnswersSchema.deleteMany({ pollQuestionId: pollQuestionId });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Poll question options answers deleted ` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No poll question found for pollQuestionId ${pollQuestionId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Society Statics--------------MONIL--------10/04/2021
router.post("/getSocietyStatics",async function(req,res,next){
    try {

        const { societyId } = req.body;

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

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for societyId ${societyId}` });
        }

        let societyMembersCount = await memberSchema.aggregate([
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

        let societyActiveMembersCount = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        {
                            society: {
                                $elemMatch: {
                                    societyId: mongoose.Types.ObjectId(societyId)
                                }
                            }
                        },
                        { isActive: true }
                    ]
                }
            }
        ]);

        let maleCount = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { 
                            society: {
                                $elemMatch: {
                                    societyId: mongoose.Types.ObjectId(societyId)
                                }
                            }  
                        },
                        { Gender: "male" }
                    ]
                }
            }
        ]);

        let femaleCount = await memberSchema.aggregate([
            {
                $match: {
                    $and: [
                        { 
                            society: {
                                $elemMatch: {
                                    societyId: mongoose.Types.ObjectId(societyId)
                                }
                            }  
                        },
                        { Gender: "female" }
                    ]
                }
            }
        ]);

        let staticCount = {
            Members: societyMembersCount.length,
            ActiveMembers: societyActiveMembersCount.length,
            Males: maleCount.length,
            Females: femaleCount.length,
        }

        if(staticCount != null){
            return res.status(200).json({ IsSuccess: true , Data: [staticCount] , Message: "Society Statics Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [staticCount] , Message: "Society Statics Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Dashboard Counter-------------MONIL-------03/04/2021
router.post("/getDashboardCount",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberCount = await memberSchema.aggregate([
            {
                $match: {
                    society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } }
                }
            },
            {
                $project: {
                    MemberNo: 1
                }
            }
        ]);

        let pendingApprovalMember = await memberSchema.aggregate([
            {
                $match: {
                    society: { 
                        $elemMatch: {
                            $and: [
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { isVerify: false }
                            ] 
                        } 
                    }
                }
            },
            {
                $project: {
                    MemberNo: 1
                }
            }
        ]);
        
        let getBikeCount = await memberSchema.aggregate([
            {
                $unwind: "$Vehicles"
            },
            {
                $match: {
                    $and: [
                        { society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } } },
                        { "Vehicles.vehicleType": "Bike" }
                    ]
                }
            },
            {
                $project: {
                    MemberNo: 1
                }
            }
        ]);

        let getCarCount =  await memberSchema.aggregate([
            {
                $unwind: "$Vehicles"
            },
            {
                $match: {
                    $and: [
                        { society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } } },
                        { "Vehicles.vehicleType": "Car" }
                    ]
                }
            },
            {
                $project: {
                    MemberNo: 1
                }
            }
        ]);

        let getStaffCount = await staffSchema.aggregate([
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

        let getVendorCount = await vendorSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getCommonVendorCount = await vendorSchema.aggregate([
            {
                $match: {
                    vendorBelongsTo: "other"
                }
            }
        ]); 
       
        let getAmenities = await amenitySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $project: {
                    amenityName: 1
                }
            }
        ]);

        let getWingCount = await wingSchema.aggregate([
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

        let getFlatCount = await flatSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $project: {
                    flatNo: 1
                }
            }
        ]);

        let getParkingCount = await parkingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getWatchmanCount = await watchmanSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getDocCount = await societyDocsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getEventCount = await eventSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getRulesCount = await societyRulesSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getNoticeBoardCount = await noticeBoardSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getGalleryCount = await gallerySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getComplainCount = await complainSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getVisitorCount = await guestEntrySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getIncomeCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { type: "Income" }
                    ]
                }
            }
        ]);

        let getExpenseCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { type: "Expense" }
                    ]
                }
            }
        ]);

        let getPollingCount = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let getsocietyEmergencyContactCount = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]); 

        let wingCount = await wingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        let DashboardCount = {
            Members: getMemberCount.length,
            Watchman: getWatchmanCount.length,
            Bike: getBikeCount.length,
            Car: getCarCount.length,
            Staff: getStaffCount.length,
            TotalStaff: Number(getStaffCount.length) + Number(getWatchmanCount.length),
            Vendor: Number(getVendorCount.length) + Number(getCommonVendorCount.length),
            CommonVendor: getCommonVendorCount.length,
            Amenities: getAmenities.length,
            Wing: getWingCount.length,
            Flat: getFlatCount.length,
            ParkingSlot: getParkingCount.length,
            Docs: getDocCount.length,
            Event: getEventCount.length,
            Rule: getRulesCount.length,
            NoticeBoard: getNoticeBoardCount.length,
            Gallery: getGalleryCount.length,
            Complain: getComplainCount.length,
            Visitor: getVisitorCount.length,
            Income: getIncomeCount.length,
            Expense: getExpenseCount.length,
            BalanceSheet: Number(getIncomeCount.length) + Number(getExpenseCount.length),
            Polling: getPollingCount.length,
            PendingApprovalMember: pendingApprovalMember.length,
            SocietyEmergencyContact: getsocietyEmergencyContactCount.length,
            Wing: wingCount.length
        }

        if(DashboardCount != null){
            return res.status(200).json({ IsSuccess: true , Data: DashboardCount , Message: "Dashboard Counts found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Dashboard Counts found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Dashboard Counter-------------MONIL-------03/04/2021
router.post("/getDashboardCount_v2",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberCount = await memberSchema.aggregate([
            {
                $match: {
                    society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } }
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let pendingApprovalMember = await memberSchema.aggregate([
            {
                $match: {
                    society: { 
                        $elemMatch: {
                            $and: [
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { isVerify: false }
                            ] 
                        } 
                    }
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);
        
        let getBikeCount = await memberSchema.aggregate([
            {
                $unwind: "$Vehicles"
            },
            {
                $match: {
                    $and: [
                        { society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } } },
                        { "Vehicles.vehicleType": "Bike" }
                    ]
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getCarCount =  await memberSchema.aggregate([
            {
                $unwind: "$Vehicles"
            },
            {
                $match: {
                    $and: [
                        { society: { $elemMatch: { societyId: mongoose.Types.ObjectId(societyId) } } },
                        { "Vehicles.vehicleType": "Car" }
                    ]
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getStaffCount = await staffSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getVendorCount = await vendorSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);
       
        let getAmenities = await amenitySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getWingCount = await wingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getFlatCount = await flatSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getParkingCount = await parkingSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getWatchmanCount = await watchmanSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getDocCount = await societyDocsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getEventCount = await eventSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getRulesCount = await societyRulesSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },{
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getNoticeBoardCount = await noticeBoardSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getGalleryCount = await gallerySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getComplainCount = await complainSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getVisitorCount = await guestEntrySchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getIncomeCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { type: "Income" }
                    ]
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            }
        ]);

        let getExpenseCount = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { type: "Expense" }
                    ]
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let getPollingCount = await pollingQuestionSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            }
        ]);

        let getsocietyEmergencyContactCount = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $group: {
                    _id: null,
                    count: { $sum: 1 }
                }
            },
        ]);

        let dashCount = {
            Members: getMemberCount.length > 0 ? getMemberCount[0].count : 0,
            Watchman: getWatchmanCount.length > 0 ? getWatchmanCount[0].count : 0,
            Bike: getBikeCount.length > 0 ? getBikeCount[0].count : 0,
            Car: getCarCount.length > 0 ? getCarCount[0].count : 0,
            Staff: getStaffCount.length > 0 ? getStaffCount[0].count : 0,
            TotalStaff: Number(getStaffCount.length > 0 ? getStaffCount[0].count : 0) + Number(getWatchmanCount.length > 0 ? getWatchmanCount[0].count : 0),
            Vendor: getVendorCount.length > 0 ? getVendorCount[0].count : 0,
            Amenities: getAmenities.length > 0 ? getAmenities[0].count : 0,
            Wing: getWingCount.length > 0 ? getWingCount[0].count : 0,
            Flat: getFlatCount.length > 0 ? getFlatCount[0].count : 0,
            ParkingSlot: getParkingCount.length > 0 ? getParkingCount[0].count : 0,
            Docs: getDocCount.length > 0 ? getDocCount[0].count : 0,
            Event: getEventCount.length > 0 ? getEventCount[0].count : 0,
            Rule: getRulesCount.length > 0 ? getRulesCount[0].count : 0,
            NoticeBoard: getNoticeBoardCount.length > 0 ? getNoticeBoardCount[0].count : 0,
            Gallery: getGalleryCount.length > 0 ? getGalleryCount[0].count : 0,
            Complain: getComplainCount.length > 0 ? getComplainCount[0].count : 0,
            Visitor: getVisitorCount.length > 0 ? getVisitorCount[0].count : 0,
            Income: getIncomeCount.length > 0 ? getIncomeCount[0].count : 0,
            Expense: getExpenseCount.length > 0 ? getExpenseCount[0].count : 0,
            BalanceSheet: (getIncomeCount.length > 0 ? getIncomeCount[0].count : 0) + (getExpenseCount.length > 0 ? getExpenseCount[0].count : 0),
            Polling: getPollingCount.length > 0 ? getPollingCount[0].count : 0,
            PendingApprovalMember: pendingApprovalMember.length > 0 ? pendingApprovalMember[0].count : 0,
            SocietyEmergencyContact: getsocietyEmergencyContactCount.length > 0 ? getsocietyEmergencyContactCount[0].count : 0
        }

        if(dashCount != null){
            return res.status(200).json({ IsSuccess: true , Data: [dashCount] , Message: "Dash Count Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Dash Count Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Banner Upload--------------MONIL----------04/04/2021
router.post("/addBanner", uploadbanner.single("image") ,async function(req,res,next){
    try {
        const { title , type } = req.body;
        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }
        
        const file = req.file;
        
        let addBanner = await new bannerSchema({
            title: title, 
            type: type, 
            image: file != undefined ? file.path : ""
        });

        if(addBanner != null){
            addBanner.save();
            return res.status(200).json({ IsSuccess: true , Data: [addBanner] , Message: "Banner Added" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Banner Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Banner-------------------MONIL-------------04/04/2021
router.post("/getBanner",async function(req,res,next){
    try {
        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getBanner = await bannerSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getBanner.length > 0){
            res.status(200).json({ IsSuccess: true , Data: getBanner , Message: "Banner Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Banner Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Android Version---------------------MONIL-----------06/02/2021
router.post("/addAPKVersion", async function(req,res,next){
    try {
        const { androidVersion , iosVersion , tinyURL , shareURL , message } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await apkDetailsSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(checkExist.length == 1){
            let existVersionId = checkExist[0]._id;
            let updateIs = {
                androidVersion: androidVersion != undefined ? androidVersion : record[0].androidVersion,
                iosVersion: iosVersion != undefined ? iosVersion : record[0].iosVersion,
                tinyURL: tinyURL != undefined ? tinyURL : record[0].tinyURL,
                shareURL: shareURL,
                message: message 
            }
            let updateRecord = await apkDetailsSchema.findByIdAndUpdate(existVersionId,updateIs);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Apk version updated" });
        }else{
            let addRecord = await new apkDetailsSchema({
                androidVersion: androidVersion,
                iosVersion: iosVersion,
                tinyURL: tinyURL,
                shareURL: shareURL,
                message: message 
            });
            if(addRecord != null){
                addRecord.save();
                res.status(200).json({ IsSuccess: true , Data: [addRecord] , Message: "Record addded" });
            } else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "Record Not addded" });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get APK Details---------------------MONIL--------------------06/02/2021
router.post("/getAPKVersions", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAppVersion = await apkDetailsSchema.aggregate([
            {
                $match: {}
            }
        ]);
        if(getAppVersion.length == 1){
            res.status(200).json({ IsSuccess: true , Data: getAppVersion , Message: "APK Versions Found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "APK Versions Not Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Assign Admin role to member-----------------MONIL--------------------04/04/2021
router.post("/assignAdminRole",async function(req,res,next){
    try {
        const { memberId , societyId , makeAdmin , adminId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMember = await memberSchema.aggregate([
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

        if(getMember.length == 1){

            let checkAdmin = await memberSchema.aggregate([
                {
                    $unwind: "$society"
                },
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(adminId) },
                            { "society.societyId": mongoose.Types.ObjectId(societyId) },
                            { "society.isAdmin": 1 }
                        ]
                    }
                }
            ]);
    
            if(checkAdmin.length == 0){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society Admins Can Assign & Revoke Roles" });
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
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
            }
            
            if(makeAdmin == 1){
                let updateMemberRole = await memberSchema.updateOne(
                    { _id: mongoose.Types.ObjectId(memberId) },
                    { $set: { "society.$[i].isAdmin": 1 } },
                    { multi: true,
                        arrayFilters: [ { "i.societyId": mongoose.Types.ObjectId(societyId) } ]
                    }
                );

                let memberTokens = await getSingleMemberPlayerId(adminId);

                if(memberTokens.length > 0){
                    let titleIs = `You Are Promoted To Society Admin , Notificationtype: Assign Admin Role`;
                    let bodyIs = `You Are Promoted To Society Admin for society ${getSociety[0].Name}`;

                    let notiDataIs = {
                        notificationType : "AssignAdminRole",
                        Society: getSociety[0].Name,
                        Message: `You Are Promoted To Society Admin for society ${getSociety[0].Name}`,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

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
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AssignAdminRole","IOS");
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
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AssignAdminRole","Android");
                            }
                        }
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Admin Role Assign` });
            }else if(makeAdmin == 0){
                let updateMemberRole = await memberSchema.updateOne(
                    { _id: mongoose.Types.ObjectId(memberId) },
                    { $set: { "society.$[i].isAdmin": 0 } },
                    { multi: true,
                        arrayFilters: [ { "i.societyId": mongoose.Types.ObjectId(societyId) } ]
                    }
                );

                let memberTokens = await getSingleMemberPlayerId(adminId);

                if(memberTokens.length > 0){
                    let titleIs = `You Are Revoked From Society Admin Role, Notificationtype: Revoked Admin Role`;
                    let bodyIs = `You Are Revoked From Society Admin Role for society ${getSociety[0].Name} , Please Login Again`;

                    let notiDataIs = {
                        notificationType : "RevokeAdminRole",
                        Society: getSociety[0].Name,
                        Message: `You Are Revoked From Society Admin Role for society ${getSociety[0].Name}`,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

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
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"RevokeAdminRole","IOS");
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
                                sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"RevokeAdminRole","Android");
                            }
                        }
                    });
                }

                return res.status(200).json({ IsSuccess: true , Data: 2 , Message: `Member Role Assign` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `Please Pass 0 or 1 for makeAdmin field` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Member Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//GalleryImg Upload--------------MONIL----------04/04/2021
router.post("/addGalleryImage" ,async function(req,res,next){
    try {
        const { title , description , societyId , adminId , wingIds } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(!adminId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please Provide adminId" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            }
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only society admins can add notice board" });
        }

        let getSociety = await societySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getSociety.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Society Found for societyId ${societyId}` });
        }
        
        const imgdata = req.body.image;

        let listOfBase64String = imgdata.split(",");
        
        let imgPaths = [];
        listOfBase64String.forEach(dataIs=>{
            const path = 'uploads/gallery/'+Date.now()+'.png'
            
            const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
        
            fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
            imgPaths.push(path);
        });

        let addGalleryImage;

        if(wingIds != undefined && wingIds != null && wingIds != ""){
            let wingList = wingIds.split(",");
            addGalleryImage = await new gallerySchema({
                title: title, 
                description: description, 
                galleryFor: {
                    isForWholeSociety: false,
                    wingId: wingList
                },
                societyId: societyId,
                adminId: adminId,
                image: imgPaths,
                dateTime: getCurrentDateTime(),
            });
        }else{
            let wingList = await getSocietyWings(societyId);
            addGalleryImage = await new gallerySchema({
                title: title, 
                description: description,
                galleryFor: {
                    isForWholeSociety: true,
                    wingId: wingList
                },
                societyId: societyId,
                adminId: adminId,
                image: imgPaths,
                dateTime: getCurrentDateTime(),
            });
        }

        if(addGalleryImage != null){
            try {
                await addGalleryImage.save();    
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }

            let memberIdList;

            if(addGalleryImage.galleryFor.wingId == false){
                let wingList = wingIds.split(",");
                memberIdList = await getSocietyWingMembers(societyId,wingList);
            }else{
                memberIdList = await getSocietyMember(societyId);
            }

            if(memberIdList.length > 0){
                let memberTokens = await getMemberPlayerId(memberIdList);

                let titleIs = `New Gallery of ${title} from ${getSociety[0].Name} `;
                let bodyIs;
                if(bodyIs != undefined && bodyIs != null && bodyIs != ""){
                    bodyIs = `${description}`;
                }else{
                    bodyIs = ``;
                }

                let notiDataIs = {
                    notificationType: "AddGallery",
                    Message: `New Notice from ${getSociety[0].Name}`,
                    SocietyName: getSociety[0].Name,
                    SocietyCode: getSociety[0].societyCode,
                    SocietyContactPerson: getSociety[0].ContactPerson,
                    SocietyContactMobile: getSociety[0].ContactMobile,
                    Image: imgPaths,
                    Title: title,
                    Description: description,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.isAdmin == 0 && tokenIs.muteNotificationAudio == false){
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddGallery","IOS");
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
                            sendOneSignalNotification(message,true,true,tokenIs.memberId,adminId,"AddGallery","Android");
                        }
                        // sendNormalNotification(tokenIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,tokenIs.memberId,adminId,"AddGallery",tokenIs.DeviceType);
                    }
                })
            }
            return res.status(200).json({ IsSuccess: true , Data: [addGalleryImage] , Message: "Gallery Image Added" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Gallery Image Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Edit Gallery---------------MONIL----------------19/04/2021
router.post("/editGallery",async function(req,res,next){
    try {
        const { galleryId , title , description , adminId , images } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getGallery = await gallerySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(galleryId)
                }
            }
        ]);

        if(getGallery.length == 1){
            
            let listOfBase64String = images;
        
            let imgPaths = [];

            if(images.length > 0){
                listOfBase64String.forEach(dataIs=>{
                    const path = 'uploads/gallery/'+Date.now()+'.png'
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imgPaths.push(path);
                });
            }

            let updateIs = {
                title: title,
                description: description,
                adminId: adminId,
                $push: {
                    image: imgPaths
                }
            }

            let updateGallery = await gallerySchema.findByIdAndUpdate(galleryId,updateIs);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Gallery Updated` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Gallery Found for id ${galleryId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Gallery-------------------MONIL-------------04/04/2021
router.post("/getGallery",async function(req,res,next){
    try {

        const { societyId , wingId } = req.body;

        let authToken = req.headers['authorization'];

        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(wingId != undefined && wingId != null && wingId != ""){
            let getGallery = await gallerySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { 
                                "galleryFor.wingId": {
                                    $elemMatch: {
                                        $eq: mongoose.Types.ObjectId(wingId)
                                    }
                                } 
                            }
                        ]
                    }
                }
            ]);
    
            if(getGallery.length > 0){
                res.status(200).json({ IsSuccess: true , Data: getGallery , Message: "Gallery Found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Gallery Found" });
            }
        }else{
            let getGallery = await gallerySchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                }
            ]);
    
            if(getGallery.length > 0){
                res.status(200).json({ IsSuccess: true , Data: getGallery , Message: "Gallery Found" });
            }else{
                res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Gallery Found" });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Gallery---------------------------------MONIL-------------10/04/2021
router.post("/deleteGallery",async function(req,res,next){
    try {
        const { galleryId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getGallery = await gallerySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(galleryId)
                }
            }
        ]);

        if(getGallery.length == 1){
            let deleteGallery = await gallerySchema.findByIdAndDelete(galleryId);

            let fileList = getGallery[0].image;

            fileList.forEach(async filePath=>{
                let deleteGalleryImages = await deleteFile(filePath);
            });

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Gallery Deleted" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Gallery Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Image From Gallery----------------------MONIL--------------28/04/2021
router.post("/deleteGalleryImage",async function(req,res,next){
    try {
        const { images , galleryId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getGallery = await gallerySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(galleryId)
                }
            }
        ]);

        if(getGallery.length == 1){
            images.forEach(async function(imageIs){
                let updateGallery = await gallerySchema.updateOne(
                    {
                        _id: mongoose.Types.ObjectId(galleryId)
                    },
                    {
                        $pull: {
                            image: String(imageIs)
                        }
                    },
                    { multi: true }
                );

                let deleteGalleryImages = await deleteFile(imageIs);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Image ${images} deleted from Gallery` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Gallery Found` });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Complain  Category Added------------------------MONIL--------------03/02/2021
router.post("/addComplainCategory", async function(req,res,next){
    try {
        const { complainName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await complainCategorySchema.aggregate([
            {
                $match: { complainName: {$in: complainName} }
            }
        ]);
        if(checkExist.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Category Already Exist" });
        }

        complainName.forEach(async function(category){
            let addComplain = await new complainCategorySchema({
                complainName: category
            });
            if(addComplain != null){
                addComplain.save();
            }
        });
        if(complainName.length > 0){
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Complain Category ${complainName} Added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Complain Category ${complainName} Not Added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Complain Category ------------------------MONIL--------------03/02/2021
router.post("/getAllComplainCategory", async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getComplainCategory = await complainCategorySchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getComplainCategory.length > 0){
            res.status(200).json({ 
                            IsSuccess: true , 
                            Count: getComplainCategory.length , 
                            Data: getComplainCategory , 
                            Message: "Complain Category Found" 
                        });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Complain Category found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Society Complain Category --------------------MONIL--------------------13/03/2021
router.post("/deleteComplainCategory",async function(req,res,next){
    try {

        const { complainCategoryId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await complainCategorySchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(complainCategoryId)
                }
            }
        ]);

        if(checkExist.length == 1){
            let deleteSociety = await complainCategorySchema.findByIdAndDelete(complainCategoryId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Complain Category Deleted" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Complain Category Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get All Complain------------------------------MONIL--------------04/02/2021
router.post("/getAllComplain", async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getComplain = await complainSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            },
            {
                $lookup: {
                    from: "members",
                    // localField: "memberId",
                    // foreignField: "_id",
                    let: { memberId: "$memberId" },
                    pipeline: [
                        {
                            $unwind: "$society"
                        },
                        { 
                            $match:
                                { 
                                    $expr: { $eq: [ "$$memberId", "$_id" ] },
                                    "society.societyId": mongoose.Types.ObjectId(societyId)
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
                                NoOfFamilyMember: 1,
                                BusinessDescription: 1,
                                ResidenceType: 1,
                                Address: 1,
                                EmailId: 1,
                                Image: 1,
                                MemberNo: 1,
                                VehicleNo: 1,
                                OfficeEmail: 1,
                                OfficeContact: 1,
                                OfficeAlternateNo: 1,
                                OfficeAddress: 1,
                                "WingData.wingName": 1,
                                "FlatData.flatNo": 1,
                                WorkType: 1,
                            }
                        }
                    ],
                    as: "MemberData"
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

//Resolved Member Complain------------MONIL-----05/04/2021
router.post("/responseToComplain",async function(req,res,next){
    try {
        const { complainId , complainStatus , adminId , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(!societyId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Id Required" });
        }

        if(!adminId){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Society Id Required" });
        }

        let checkAdmin = await memberSchema.aggregate([
            {
                $unwind: "$society"
            },
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(adminId) },
                        { "society.societyId": mongoose.Types.ObjectId(societyId) },
                        { "society.isAdmin": 1 }
                    ]
                }
            } 
        ]);

        if(checkAdmin.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Only Admin Can Response To the complain" });
        }

        let getComplain = await complainSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(complainId)
                }
            }
        ]);

        if(getComplain.length == 1){
            let memberId = getComplain[0].memberId;
            if(complainStatus == 1){
                
                let update = {
                    complainStatus: 1
                }
                let updateComplain = await complainSchema.findByIdAndUpdate(complainId,update);

                let memberToken = await getSingleMemberPlayerId(memberId);

                let titleIs = `Your Complain ${getComplain[0].complainNo} is Resolved`;
                let bodyIs = `Your Complain ${getComplain[0].complainNo} is Resolved By ${checkAdmin[0].Name}`;

                let notiDataIs = {
                    notificationType: "complainSolvedByAdmin",
                    ComplainNo: getComplain[0].complainNo,
                    ComplainCategory: getComplain[0].complainCategoryName,
                    Message: `Your Complain With Complain Number ${getComplain[0].complainNo} is resolved`,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                memberToken.forEach(tokenIs=>{
                    if(tokenIs.muteNotificationAudio == false){
                        if(dataIs.DeviceType == "IOS"){
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
                            sendOneSignalNotification(message,true,true,memberId,adminId,"complainSolvedByAdmin","IOS");
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
                            sendOneSignalNotification(message,true,true,memberId,adminId,"complainSolvedByAdmin","Android");
                        }
                    }
                    // sendNormalNotification(dataIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,memberId,adminId,"complainSolvedByAdmin",dataIs.DeviceType);
                });

                return res.status(200).json({ 
                    IsSuccess: true , 
                    Data: 1 , 
                    Message: `Your Complain With Complain Number ${getComplain[0].complainNo} is resolved` 
                });

            }else if(complainStatus == 2){

                let updateComplain = await complainSchema.findByIdAndDelete(complainId);

                let memberToken = await getSingleMemberPlayerId(memberId);

                let titleIs = `Complain ${getComplain[0].complainNo} is Rejected`;
                let bodyIs = `Your Complain With Complain Number ${getComplain[0].complainNo} is resolved`;

                let notiDataIs = {
                    notificationType: "complainRejectedByAdmin",
                    ComplainNo: getComplain[0].complainNo,
                    ComplainCategory: getComplain[0].complainCategoryName,
                    Message: `Your Complain With Complain Number ${getComplain[0].complainNo} is rejected by admin, it can't be solved`,
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                };

                memberToken.forEach(tokenIs=>{
                    if(tokenIs.muteNotificationAudio == false){
                        if(dataIs.DeviceType == "IOS"){
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
                            sendOneSignalNotification(message,true,true,memberId,adminId,"complainRejectedByAdmin","IOS");
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
                            sendOneSignalNotification(message,true,true,memberId,adminId,"complainRejectedByAdmin","Android");
                        }
                    }
                    // sendNormalNotification(dataIs.fcmToken,notiDataIs,titleIs,bodyIs,true,true,memberId,adminId,"complainRejectedByAdmin",dataIs.DeviceType);
                });

                return res.status(200).json({ 
                    IsSuccess: true , 
                    Data: 0 , 
                    Message: `Your Complain With Complain Number ${getComplain[0].complainNo} is resolved` 
                });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Please provide proper complainStatus" });
            }
            
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Complain found for complainId ${complainId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Add Income Source---------------------------MONIL----06/05/2021
router.post("/addTransactionSource",async function(req,res,next){
    try {
        const { sourceName , societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await transactionSchema.aggregate([
            {
                $match: {
                    $and: [
                        { sourceName: sourceName },
                        { societyId: mongoose.Types.ObjectId(societyId) }
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Source Name ${sourceName} already exist in society` });
        }

        let addSourceName = await new transactionSchema({
            sourceName: sourceName,
            societyId: societyId,
        });

        if(addSourceName != null){
            addSourceName.save();
            res.status(200).json({ IsSuccess: true , Data: [addSourceName] , Message: `Transaction Source Name ${sourceName} added` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Transaction Source Name ${sourceName} not added` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get All Income Sources-------------MONIL-----------06/04/2021
router.post("/getTransactionSources",async function(req,res,next){
    try {
        const { societyId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDetails = await transactionSchema.aggregate([
            {
                $match: {
                    societyId: mongoose.Types.ObjectId(societyId)
                }
            }
        ]);

        if(getDetails.length > 0){
            res.status(200).json({ IsSuccess: true , Count: getDetails.length , Data: getDetails , Message: "Transaction Sources found" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Transaction Sources found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
        
    }
});

//Delete Income-------------MONIL------------06/04/2021
router.post("/deleteTransactionSource",async function(req,res,next){
    try {
        const { sourceId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getTransactionSource = await transactionSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(sourceId)
                }
            }
        ]);

        if(getTransactionSource.length == 1){
            let deleteTransactionSource = await transactionSchema.findByIdAndDelete(sourceId);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Income Source deleted for incomeId ${sourceId}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Source: 0 , Message: `No Income Source found for sourceId ${sourceId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
        
    }
});

//Add Income Source Information---------------------------MONIL----06/04/2021
router.post("/addTransaction",async function(req,res,next){
    try {
        const { sourceId , societyId , paymentType , description , type , amount , refNo } = req.body;

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
                $project: {
                    currentBalance: 1
                }
            }
        ]);

        if(societyIs.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Found" });
        }

        let previousBalance = parseFloat(societyIs[0].currentBalance);

        if(type == "Income"){
    
            let currentBalance = previousBalance + parseFloat(amount);

            let addIncome = await new incomeExpenseDetailsSchema({
                sourceId: sourceId,
                societyId: societyId,
                description: description,
                paymentType: paymentType,
                type: "Income",
                credit: parseFloat(amount),
                previousBalance: previousBalance,
                currentBalance: currentBalance,
                refNo: refNo,
                dateTime: getCurrentDateTime()
            });
    
            if(addIncome != null){
                addIncome.save();
                let update = {
                    currentBalance: parseFloat(addIncome.currentBalance)
                }
                let updateSociety = await societySchema.findByIdAndUpdate(societyId,update);
                return res.status(200).json({ IsSuccess: true , Data: [addIncome] , Message: `Income Amount ${amount} credited` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Income added` });
            }
        }else if(type == "Expense"){

            let currentBalance = previousBalance - parseFloat(amount);

            let addExpense = await new incomeExpenseDetailsSchema({
                sourceId: sourceId,
                societyId: societyId,
                description: description,
                paymentType: paymentType,
                type: "Expense",
                debit: parseFloat(amount),
                previousBalance: previousBalance,
                currentBalance: currentBalance,
                refNo: refNo,
                dateTime: getCurrentDateTime()
            });
    
            if(addExpense != null){
                addExpense.save();
                let update = {
                    currentBalance: parseFloat(addExpense.currentBalance)
                }
                let updateSociety = await societySchema.findByIdAndUpdate(societyId,update);
                return res.status(200).json({ IsSuccess: true , Data: [addExpense] , Message: `Expense Amount ${amount} debited` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Expense added` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Please Provide valid Type like Income or Expense` })
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get All Society Income-------------MONIL------------06/04/2021
router.post("/getAllTransaction",async function(req,res,next){
    try {
        const { societyId , type , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(type == "Income"){
            let getDetails;
            if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
                let dateList = generateDateList(fromDate,toDate);
                // console.log(dateList);
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Income" },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { "dateTime.0": { $in: dateList } }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == "")){
                
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Income" },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { "dateTime.0": toDate }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }else{
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Income" },
                                { societyId: mongoose.Types.ObjectId(societyId) }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }

            if(getDetails.length > 0){
                return res.status(200).json({ IsSuccess: true , Count: getDetails.length , Data: getDetails , Message: "Society Income Details found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Income Details found" });
            }

        }else if(type == "Expense"){
            
            let getDetails;
            if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
                //Between two Dates
                let dateList = generateDateList(fromDate,toDate);
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Expense" },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { "dateTime.0": { $in: dateList } }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == "")){
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Expense" },
                                { societyId: mongoose.Types.ObjectId(societyId) },
                                { "dateTime.0": toDate }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }else{
                getDetails = await incomeExpenseDetailsSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { type: "Expense" },
                                { societyId: mongoose.Types.ObjectId(societyId) }
                            ]
                        }
                    },
                    {
                        $lookup: {
                            from: "transactionsources",
                            localField: "sourceId",
                            foreignField: "_id",
                            as: "IncomeSource"
                        }
                    }
                ]);
            }

            if(getDetails.length > 0){
                return res.status(200).json({ IsSuccess: true , Count: getDetails.length , Data: getDetails , Message: "Society Expense Details found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Expense Details found" });
            }
        }else{
            let getDetails = await incomeExpenseDetailsSchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: {
                        from: "transactionsources",
                        localField: "sourceId",
                        foreignField: "_id",
                        as: "IncomeSource"
                    }
                }
            ]);

            if(getDetails.length > 0){
                return res.status(200).json({ IsSuccess: true , Count: getDetails.length , Data: getDetails , Message: "Society Expense Details found" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Society Expense Details found" });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Delete Income-------------MONIL------------06/04/2021
router.post("/deleteTransaction",async function(req,res,next){
    try {
        const { incomeId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getIncomeDetails = await incomeExpenseDetailsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(incomeId)
                }
            }
        ]);

        if(getIncomeDetails.length == 1){
            let deleteIncome = await incomeExpenseDetailsSchema.findByIdAndDelete(incomeId);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Income Data deleted for incomeId ${incomeId}` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Income Data found for incomeId ${incomeId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
        
    }
});

//Get All Staff Entry -----------------MONIL---------07/04/2021
router.post("/getStaffEntry",async function(req,res,next){
    try {
        const { societyId , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let lookupIs = {
            from: "staffrecords",
            let: { staffId: "$staffId" },
            pipeline: [
                { 
                    $match:
                        { 
                            $expr: { $eq: [ "$$staffId", "$_id" ] }
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
                        Gender: 1,
                        societyId: 1,
                        entryNo: 1,
                        ContactNo2: 1,
                        Address: 1,
                        staffImage: 1,
                        EmergencyContactNo: 1,
                        staffCategory: 1,
                        "WingData.wingName": 1,
                        "WingData._id": 1,
                        "FlatData.flatNo": 1,
                        "FlatData._id": 1,
                        Work: 1,
                    }
                }
            ],
            as: "StaffData"
        }

        let getStaffEntry;

        if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
            //Between Two Dates
            let dateList = generateDateList(fromDate,toDate);
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { "inDateTime.0": { $in: dateList } }
                        ]
                    }
                },
                {
                    $lookup: lookupIs
                }
            ]);

        }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { "inDateTime.0": toDate }
                        ]
                    }
                },
                {
                    $lookup: lookupIs
                }
            ]);
        }else{
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: lookupIs
                }
            ]);
        }

        if(getStaffEntry.length > 0){
            return res.status(200).json({ IsSuccess: true , Data: getStaffEntry , Message: "Staff Entry Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Staff Entry Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get All Staff Entry -----------------MONIL---------07/04/2021
router.post("/getStaffEntry_v1",async function(req,res,next){
    try {
        const { societyId , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let staffLookupIs = {
            from: "staffrecords",
            localField: "staffId",
            foreignField: "_id",
            as: "StaffData"
        }

        let projectData = {
            inDateTime: 1,
            outDateTime: 1,
            vehicleNo: 1,
            societyId: 1,
            watchmanId: 1,
            "StaffData.Name": 1,
            "StaffData.ContactNo1": 1,
            "StaffData.Gender": 1,
            "StaffData.entryNo": 1,
            "StaffData.Address": 1,
            "StaffData.staffImage": 1,
            "StaffData.staffCategory": 1,
        }

        let getStaffEntry;

        if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
            //Between Two Dates
            let dateList = generateDateList(fromDate,toDate);
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { "inDateTime.0": { $in: dateList } }
                        ]
                    }
                },
                {
                    $lookup: staffLookupIs
                },
                {
                    $match: {
                        "StaffData.isForSociety": true
                    }
                },
                {
                    $project: projectData
                }
            ]);

        }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        $and: [
                            { societyId: mongoose.Types.ObjectId(societyId) },
                            { "inDateTime.0": toDate }
                        ]
                    }
                },
                {
                    $lookup: staffLookupIs
                },
                {
                    $match: {
                        "StaffData.isForSociety": true
                    }
                },
                {
                    $project: projectData
                }
            ]);
        }else{
            getStaffEntry = await staffEntrySchema.aggregate([
                {
                    $match: {
                        societyId: mongoose.Types.ObjectId(societyId)
                    }
                },
                {
                    $lookup: staffLookupIs
                },
                {
                    $match: {
                        "StaffData.isForSociety": true
                    }
                },
                {
                    $project: projectData
                }
            ]);
        }

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
    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Get All State-------------------MONIL---------08/02/2021
router.post("/addState", async function(req,res,next){
    try {
        const { countryCode } = req.body;

        // let authToken = req.headers['authorization'];
        
        // if(authToken != config.tokenIs || authToken == null || authToken == undefined){
        //     return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        // }

        let states = csc.getStatesOfCountry("IN");

        // states.forEach(async function(state){
        //     let addState = await new stateSchema({
        //         name: state.name,
        //         isoCode: state.isoCode,
        //         countryCode: state.countryCode,
        //         latitude: state.latitude,
        //         longitude: state.longitude,
        //     });

        //     if(addState != null){
        //         addState.save();
        //         // console.log(addState);
        //     }
        // });
        
        if(states.length > 0){
            res.status(200).json({ IsSuccess: true , Count: states.length , Data: states , Message: `State List Found for country code ${countryCode}` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Countries Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Society Emergency Contacts--------------------MONIL------------------24/04/2021
router.post("/addSocietyEmergencyContacts",async function(req,res,next){
    try {
        const { Name , ContactNo , image , alternateContactNo , societyId , ContactPerson } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const path = 'uploads/socEmergencyContact/'+ "societyEmergencyContacts-" +Date.now()+'.jpg'
                
        const base64Data = image.replace(/^data:([A-Za-z-+/]+);base64,/, '');
    
        fs.writeFileSync(path, base64Data,  {encoding: 'base64'});

        let checkExist = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    $and: [
                        { societyId: mongoose.Types.ObjectId(societyId) },
                        { Name: Name.toUpperCase() },
                        { ContactNo: ContactNo }
                    ]
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Emergency Contact ${ContactNo} already exist for ${Name}` });
        }

        let addSoceityEmergencyConatct = await new societyEmergencyContactsSchema({
            societyId: societyId,
            Name: Name.toUpperCase(),
            ContactPerson: ContactPerson,
            ContactNo: ContactNo,
            alternateContactNo: alternateContactNo,
            image: path != undefined ? path : ""
        });

        if(addSoceityEmergencyConatct != null){
            addSoceityEmergencyConatct.save();
            return res.status(200).json({ 
                IsSuccess: true, 
                Data: [addSoceityEmergencyConatct], 
                Message: `Society Emergency Contact ${ContactNo} added for ${Name}` 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: [] , Message: `Faild to add Emergency ContactNo ${ContactNo}` });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Society Emergency Contacts----------------MONIL-----------27/04/2021
router.post("/updateSocietyEmergencyContacts",async function(req,res,next){
    try {
        const { contactId , Name , ContactNo , image , alternateContactNo , ContactPerson } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getContacts = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(contactId)
                }
            }
        ]);

        if(getContacts.length == 1){
            let path = '';
                
            if(image != undefined && image != null && image != ""){
                console.log("helo");
                path = 'uploads/socEmergencyContact/'+ "societyEmergencyContacts-" +Date.now()+'.jpg';
                const base64Data = image.replace(/^data:([A-Za-z-+/]+);base64,/, '');        
                fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
            }

            let update = {
                Name: Name != undefined && Name != "" ? Name.toUpperCase() : getContacts[0].Name,
                ContactPerson: ContactPerson != undefined && ContactPerson != "" ? ContactPerson : getContacts[0].ContactPerson,
                ContactNo: ContactNo != undefined && ContactNo != "" ? ContactNo : getContacts[0].ContactNo,
                alternateContactNo: alternateContactNo != undefined && alternateContactNo != "" ? alternateContactNo : getContacts[0].alternateContactNo,
                image: path != undefined ? path : getContacts[0].image
            }

            let updateContact = await societyEmergencyContactsSchema.findByIdAndUpdate(contactId,update);
            return res.status(200).json({ 
                IsSuccess: true,  
                Data: 1,
                Message: "Society Emergency Contacts Founds" 
            });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Emergency Contacts found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Society Emergency Contacts-------------MONIL------27/04/2021
router.post("/deleteSocietyEmergencyContact",async function(req,res,next){
    try {
        const { contactId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getContacts = await societyEmergencyContactsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(contactId)
                }
            }
        ]);

        if(getContacts.length == 1){
            let deleteContact = await societyEmergencyContactsSchema.findByIdAndDelete(contactId);
            res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Contact ${getContacts[0].ContactNo} Deleted` });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Contact Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Staff ----------------------MONIL-----------------26/04/2021
router.post("/deleteStaff",async function(req,res,next){
    try {
        const { staffId } = req.body;

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
            let deleteStaff = await staffSchema.findByIdAndDelete(staffId);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Staff ${getStaff[0].Name} record deleted` });
        }else{
            let getWatchman = await watchmanSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(staffId)
                    }
                }
            ]);

            if(getWatchman.length == 1){
                let deleteStaff = await watchmanSchema.findByIdAndDelete(staffId);
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Watchman ${getWatchman[0].Name} record deleted` });
            }
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Staff Deleted` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//MyJini Broadcast Message-------------------------MONIL---------------18/05/2021 
router.post("/myjiniBroadcast",async function(req,res,next){
    try {
        const { message , societyIdList } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getMemberIds;
        if(societyIdList != undefined && societyIdList != null && societyIdList != []){
            getMemberIds = await getMultipleSocietyMembers(societyIdList)
        }else{
            getMemberIds = await getAllMyJiniMembers();
        }

        if(getMemberIds.length > 0){
            let memberTokens = await getMemberPlayerId(getMemberIds);

            if(memberTokens.length > 0){
                let titleIs = `Broadcast Message From MyJini`;
                let bodyIs = `About : ${message}`;

                let notiDataIs = {
                    NotificationType: "BroadcastMessageFromSociety",
                    Message: message != undefined ? message : "",
                    content_available: true, 
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    view: "ghj"
                }

                memberTokens.forEach(tokenIs=>{
                    if(tokenIs.DeviceType == "IOS"){
                        let messageIs = { 
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
                        
                        sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,null,"BroadcastMessageFromMyJini","IOS");
                    }else{
                        let messageIs = { 
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
                        
                        sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,null,"BroadcastMessageFromMyJini","Android");
                    }
                });
                return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Broadcast Message Send` });
            }else{
                return res.status({ IsSuccess: true , Data: 0 , Message: "No Member Tokens Found" });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Member Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Society Admin Broadcast Message-------------------------MONIL---------------18/05/2021 
router.post("/societyBroadcast",async function(req,res,next){
    try {
        const { societyId , adminId , message , wingIdList } = req.body;

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
            let getAdmin = await memberSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { _id: mongoose.Types.ObjectId(adminId) },
                            { 
                                society: {
                                    $elemMatch: {
                                        societyId: mongoose.Types.ObjectId(societyId),
                                        isAdmin: 1
                                    }
                                }
                            }
                        ]
                    }
                }
            ]);

            if(getAdmin.length == 0){
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Admin Found for adminId ${adminId}` });
            }

            let memberIds;

            if(wingIdList != undefined && wingIdList != null && wingIdList != "" && wingIdList != []){
                memberIds = await getSocietyWingMembers(societyId,wingIdList);
            }else{
                memberIds = await getSocietyMember(societyId,adminId);
            }
 
            if(memberIds.length > 0){
                let memberTokens = await getMemberPlayerId(memberIds);

                if(memberTokens.length > 0){
                    let titleIs = `Broadcast Message From Society ${getSociety[0].Name}`;
                    let bodyIs = `About : ${message}`;
                    console.log(bodyIs)

                    let notiDataIs = {
                        NotificationType: "BroadcastMessageFromSociety",
                        Message: message != undefined ? message : "",
                        SendByAdmin: getAdmin[0].Name,
                        content_available: true, 
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                        view: "ghj"
                    }

                    memberTokens.forEach(tokenIs=>{
                        if(tokenIs.DeviceType == "IOS"){
                            let messageIs = { 
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
                            
                            sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,adminId,"BroadcastMessageFromSociety","IOS");
                        }else{
                            let messageIs = { 
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
                            
                            sendOneSignalNotification(messageIs,true,true,tokenIs.memberId,adminId,"BroadcastMessageFromSociety","Android");
                        }
                    });
                    return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Broadcast Message Send` });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Member Token Found` });
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Member Found` });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No society Found for societyId ${societyId}` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete All Records
router.post("/delete",async function(req,res,next){
    try {
        const { societyId } = req.body;

        if(societyId != null && societyId != undefined && societyId != ""){
            let delSociety = await societySchema.findByIdAndDelete(societyId);
            // let delSociety1 = await memberSchema.deleteMany();
            let delSociety2 = await flatSchema.deleteMany({societyId: societyId});
            let delSociety3 = await wingSchema.deleteMany({societyId: societyId});
            let delSociety6 = await parkingSchema.deleteMany({societyId: societyId});
            let delSociety7 = await memberTokenSchema.deleteMany();
            let delSociety8 = await watchmanSchema.deleteMany({societyId: societyId});
            let delSociety9 = await watchmanTokenSchema.deleteMany();
            let delSociety10 = await staffEntrySchema.deleteMany({societyId: societyId});
            // let delSociety11 = await vendorEntrySchema.deleteMany({societyId: societyId});
            let delSociety12 = await guestEntrySchema.deleteMany({societyId: societyId});
            let delSociety13 = await staffSchema.deleteMany({societyId: societyId});
            let delSociety14 = await pollingQuestionSchema.deleteMany();
            let delSociety15 = await pollingOptionsSchema.deleteMany();
            let delSociety16 = await pollingAnswersSchema.deleteMany();
            // let delSociety17 = await vendorSchema.deleteMany({societyId: societyId});

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Data Deleted" });
        }else{
            let delSociety = await societySchema.deleteMany();
            // let delSociety1 = await memberSchema.deleteMany();
            let delSociety2 = await flatSchema.deleteMany();
            let delSociety3 = await wingSchema.deleteMany();
            let delSociety6 = await parkingSchema.deleteMany();
            let delSociety7 = await memberTokenSchema.deleteMany();
            let delSociety8 = await watchmanSchema.deleteMany();
            let delSociety9 = await watchmanTokenSchema.deleteMany();
            let delSociety10 = await staffEntrySchema.deleteMany();
            // let delSociety11 = await vendorEntrySchema.deleteMany();
            let delSociety12 = await guestEntrySchema.deleteMany();
            let delSociety13 = await staffSchema.deleteMany();
            let delSociety14 = await pollingQuestionSchema.deleteMany();
            let delSociety15 = await pollingOptionsSchema.deleteMany();
            let delSociety16 = await pollingAnswersSchema.deleteMany();
            // let delSociety17 = await vendorSchema.deleteMany();

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Data Deleted" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

var M = require('mstring');

//Share Member Society Address-----------------MONIL-------26/05/2021
router.post("/shareMemberSocietyDetails",async function(req,res,next){
    try {
        const { name , flatNo , wing , mapLink , address } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        // let Message = M(function(){
        //     return `Hello, My Name is ${name}
        //     Reside At ${flatNo}-${wing}
        //     MapLink: ${mapLink}
        //     Address: ${address}`
        // });
        // console.log(Message);
        let Message = `Hello, My Name is ${name} \n Reside At ${flatNo}-${wing} \n MapLink: ${mapLink} \n Address: ${address}`

        return res.send({ Data: Message });
    } catch (error) {
        res.status(200).json({ IsSuccess: false , Message: error.message });
    }
});

//Share Society Address-----------------MONIL-------26/05/2021
router.post("/shareSocietyDetails",async function(req,res,next){
    try {
        const { name , mapLink , address } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let Message = `Society Name: ${name} \n Address: ${address} \n MapLink: ${mapLink}`;

        return res.send({ Data: Message });
    } catch (error) {
        res.status(200).json({ IsSuccess: false , Message: error.message });
    }
});

//Share MyJini-----------------MONIL-------26/05/2021
router.post("/shareMyJiniApp",async function(req,res,next){
    try {
        const { webLink , appLink } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let Message = `Download MyJini App now to manage your society security, maintenance, staffing & operations and more:\n ${webLink} \n\nDownload the App from the below link \n ${appLink}`;

        return res.send({ Data: Message });
    } catch (error) {
        res.status(200).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete File--------------MONIL-------------14/05/2021
router.post("/deleteImage",async function(req,res,next){
    let a = await deleteFile("uploads/amenities/Society_Amenity1619520886079.png");

    if(a == true){
        return res.send("Deleted");
    }else{
        return res.send("Not Deleted");
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
// 5 - Accepted
// 6 - Rejected
async function sendNotification(fcmToken,data,title,body,isForMember,sendFromMember,userId,sender,category,deviceType){

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

//Get Society Members-----------MONIL---------18/05/2021
async function getMultipleSocietyMembers(societyIdList){
    let memberIds = [];

    for(let i=0;i<societyIdList.length;i++){
        let societyId = societyIdList[i];

        let getMembers = await memberSchema.aggregate([
            {
                $match: {
                    society: {
                        $elemMatch: {
                            societyId: mongoose.Types.ObjectId(societyId)
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

        if(getMembers.length > 0){
            getMembers.forEach(id=>{
                memberIds.push(id._id);
            });
        }
    }

    return memberIds;
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
                DeviceType: 1
            }
        }
    ]);
    return memberToken;
};

//Get Society Member--------------MONIL---------10/04/2021
async function getSocietyMember(societyId,excludeMember){
    let societyIdIs = String(societyId);

    let memberIds = [];

    if(excludeMember != undefined && excludeMember != null && excludeMember != ""){
        let getMembers = await memberSchema.aggregate([
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
    
        if(getMembers.length > 0){
            getMembers.forEach(member=>{
                if(member._id != excludeMember){
                    memberIds.push(member._id);
                }
            })
        }
    }else{
        let getMembers = await memberSchema.aggregate([
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
    
        if(getMembers.length > 0){
            getMembers.forEach(member=>{
                memberIds.push(member._id);
            })
        }
    }

    return memberIds;
}

//Get Society Wing Members-----------MONIL--------18/05/2021
async function getSocietyWingMembers(societyId,wingIdList){
    let societyIdIs = String(societyId);

    let memberIds = [];
    if(wingIdList != undefined && wingIdList != null && wingIdList != "" && wingIdList != []){
        for(let i=0;i<wingIdList.length;i++){
            let wingId = String(wingIdList[i]);

            let getMembers = await memberSchema.aggregate([
                {
                    $match: {
                        society: {
                            $elemMatch: {
                                societyId: mongoose.Types.ObjectId(societyIdIs),
                                wingId: mongoose.Types.ObjectId(wingId)
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

            if(getMembers.length > 0){
                getMembers.forEach(id=>{
                    memberIds.push(id._id);
                });
            }
        }
    }

    return memberIds;
}

//Get All Members-------------MONIL------------18/05/2021
async function getAllMyJiniMembers(){
    let memberIds = [];

    let getMembers = await memberSchema.aggregate([
        {
            $group: {
                _id: "$_id"
            }
        }
    ]);

    getMembers.forEach(id=>{
        memberIds.push(id._id);
    });

    return memberIds;
}

//Get Society WingList-----------MONIL--------22/05/2021
async function getSocietyWings(societyId){
    let societyIdIs = String(societyId);

    let wingIdList = [];

    let getWings = await wingSchema.aggregate([
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

    if(getWings.length > 0){
        getWings.forEach(id=>{
            wingIdList.push(id._id)
        });
    }

    return wingIdList;
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

function getSocietyCodeNumber() {
    let generateNo = "SOC-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getIndustryCodeNumber() {
    let generateNo = "INDUSTRY-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getExpenseNumber(){
    let generateNo = "EXPENSE-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getPollNumber(){
    let generateNo = "POLL-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getAlphanumericFlatNumberSingleDigit(floor,maxFlatPerFloor){
    let alpha = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    for(let i=1;i<=floor;i++){
        for(let j=1;j<=maxFlatPerFloor;j++){
            console.log(alpha[i-1] + "-" + j);
        }
    }
}

function getAlphanumericFlatNumber(floor,maxFlatPerFloor){
    let alpha = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    for(let i=1;i<=floor;i++){
        for(let j=1;j<=maxFlatPerFloor;j++){
            let num;
            if(j > 9){
                num = alpha[i-1] + "-" + i + j;
            }else{
                num = alpha[i-1] + "-" + i + "0" + j;
            }
            console.log(num);
        }
    }
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