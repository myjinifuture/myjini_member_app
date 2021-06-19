require("dotenv").config();
const path = require("path");
const fs = require("fs");
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
const cron = require('node-cron');

const stateSchema = require('../models/stateModel');
const citySchema = require('../models/cityModel');
const societySchema = require('../models/societyModel');
const societyCategorySchema = require('../models/societyCategory');
const memberSchema = require('../models/memberModel');
const notificationSchema = require('../models/notificationContent');
const emergencyContactsSchema = require('../models/emergencyContacts');
const areaSchema = require('../models/areaModel');
const adsPackageSchema = require('../models/adsPackage');
const memberTokenSchema = require('../models/memberToken');
const vendorSchema = require('../models/vendorModel');
const vendorDealsSchema = require('../models/vendorDeals');
const dealsCategorySchema = require('../models/dealsCategory');
const dealsKeywordSchema = require('../models/dealsKeywords');
const dealsRedeemSchema = require('../models/dealRedeem');
const advertisePaymentSchema = require('../models/advertisePayments');
const advertisementSchema = require('../models/advertisementModel');
const adPrice = require("../models/advertisePrice");

let dealCategoryUploader = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/dealCategory");
    },
    filename: function (req, file, cb) {
        cb(
            null,
            file.fieldname + "_" + Date.now() + path.extname(file.originalname)
        );
    },
});
let dealCategoryImg = multer({ storage: dealCategoryUploader });

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

//Register Advertise Vendor---------------MONIL----------------16/04/2021
router.post("/registerVendor",async function(req,res,next){
    try {
        const { 
            Name, 
            ContactNo, 
            emailId, 
            Address, 
            Pincode, 
            CompanyName, 
            WebsiteURL,
            YoutubeURL,
            GSTNo,
            State,
            City,
            ReferalCode,
            lat,
            long,
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkExist = await vendorSchema.aggregate([
            {
                $match: {
                    ContactNo: ContactNo
                }
            }
        ]);

        if(checkExist.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Vendor Already Exist with Mobile No ${ContactNo}` });
        }

        let addVendor = await new vendorSchema({
            Name: Name,
            ContactNo: ContactNo,
            emailId: emailId,
            Address: Address,
            Pincode: Pincode,
            CompanyName: CompanyName,
            WebsiteURL: WebsiteURL,
            YoutubeURL: YoutubeURL,
            GSTNo: GSTNo,
            State: State,
            City: City,
            ReferalCode: ReferalCode,
            GoogleMap: {
                lat: parseFloat(lat),
                long: parseFloat(long),
                mapLink: "https://maps.google.com/?q="+parseFloat(lat)+","+parseFloat(long),
            },
            vendorBelongsTo: "deals"
        });

        if(addVendor != null){
            try {
                await addVendor.save();    
            } catch (error) {
                res.status(500).json({ IsSuccess: false , Message: error.message });
            }
            return res.status(200).json({ IsSuccess: true , Data: [addVendor] , Message: "Vendor Added" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Added" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Vendor Login ---------------MONIL----------------16/04/2021
router.post("/login",async function(req,res,next){
    try {

        const { ContactNo } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getVendor = await vendorSchema.aggregate([
            {
                $match: {
                    ContactNo: ContactNo
                }
            }
        ]);

        if(getVendor.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: getVendor , Message: "Vendor LoggedIn" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Advertise------------------------MONIL----------------------22/05/2021
router.post("/addAdvertise",async function(req,res,next){
    try {
        const {
            Title, 
            Description,
            vendorId,
            WebsiteURL,
            EmailId,
            VideoLink,
            lat,
            long,
            AdPosition,
            ContactNo,
            image,
        } = req.body;

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

        if(getVendor.length == 0){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Found" });
        }
        
        let imgPaths = [];

        if(image != undefined && image != null && image != [] && image != ""){
            image.forEach(dataIs=>{
                const path = 'uploads/advertise/'+Date.now()+'.png'
                
                const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
            
                fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                imgPaths.push(path);
            });
        }

        let getPrice = await adPrice.aggregate([
            {
                $match: {}
            }
        ]); 

        let addAdvertise = await new advertisementSchema({
            Title: Title, 
            Description: Description, 
            vendorId: vendorId, 
            WebsiteURL: WebsiteURL, 
            EmailId: EmailId, 
            VideoLink: VideoLink, 
            AdPosition: AdPosition.toUpperCase(), 
            ContactNo: ContactNo, 
            Image: imgPaths, 
            ExpiryDate: getCurrentDateTimePlusOneYear(),
            advertiseNo: getAdvertiseNumber(),
            Price: getPrice.length > 0 ? getPrice[0].Price : 21000,
            GoogleMap: {
                lat: Number(lat),
                long: Number(long),
                mapLink: `http://maps.google.com/maps?q=${lat},${long}`
            }, 
            dateTime: getCurrentDateTime(),
        });

        if(addAdvertise != null){
            try {
                await addAdvertise.save();
                return res.status(200).json({ IsSuccess: true , Data: [addAdvertise] , Message: "Advertise Added" });
            } catch (error) {
                return res.status(500).json({ IsSuccess: false , Message: error.message });
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Advertise Not Added" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Advertise----------------------------MONIL---------------24/05/2021
router.post("/getVendorAdvertise",async function(req,res,next){
    try {
        const { vendorId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getAdvertise = await advertisementSchema.aggregate([
            {
                $match: {
                    $and: [
                        { vendorId: mongoose.Types.ObjectId(vendorId) },
                        { isPaid: true }
                    ]
                }
            }
        ]);

        if(getAdvertise.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: getAdvertise.length, 
                Data: getAdvertise, 
                Message: "Vendor Advertise Found" 
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Advertise Found For Vendor" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Advertise------------------------MONIL----------------------25/05/2021
router.post("/updateAdvertise",async function(req,res,next){
    try {
        const {
            advertiseId,
            Title, 
            Description,
            WebsiteURL,
            EmailId,
            VideoLink,
            lat,
            long,
            AdPosition,
            ContactNo,
            image,
        } = req.body;

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

            if(image != undefined && image != null && image != [] && image != ""){
                image.forEach(dataIs=>{
                    const path = 'uploads/advertise/'+Date.now()+'.png'
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imgPaths.push(path);
                });
            }
            
            let update = {
                Title: Title != undefined ? Title : getAdvertise[0].Title, 
                Description: Description != undefined ? Description : getAdvertise[0].Description, 
                WebsiteURL: WebsiteURL != undefined ? WebsiteURL : getAdvertise[0].WebsiteURL, 
                EmailId: EmailId != undefined ? EmailId : getAdvertise[0].EmailId, 
                VideoLink: VideoLink != undefined ? VideoLink : getAdvertise[0].VideoLink, 
                AdPosition: AdPosition != undefined ? AdPosition.toUpperCase() : getAdvertise[0].AdPosition, 
                ContactNo: ContactNo != undefined ? ContactNo : getAdvertise[0].ContactNo, 
                $push: {
                    Image: imgPaths
                },
                GoogleMap: {
                    lat: lat != undefined ? Number(lat) : getAdvertise[0].lat,
                    long: long != undefined ? Number(long) : getAdvertise[0].long,
                    mapLink: `http://maps.google.com/maps?q=${lat != undefined ? Number(lat) : getAdvertise[0].lat},${long != undefined ? Number(long) : getAdvertise[0].long}`
                }, 
            }

            let updateAdvertise = await advertisementSchema.findByIdAndUpdate(advertiseId,update);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Avertise Updated" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Avertise Found" });
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Advertise-------------------------MONIL---------------25/05/2021
router.post("/deleteAdvertise",async function(req,res,next){
    try {
        const { advertiseId } = req.body;

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
            let deleteAdvertise = await advertisementSchema.findByIdAndDelete(advertiseId);
            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Avertise Deleted" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Avertise Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Vendor Image----------------------MONIL---------------17/05/2021
router.post("/updateVendorProfile", vendorImg.single("vendorImage") , async function(req,res,next){
    try {
        const { vendorId } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        const file = req.file;

        let getVendor = await vendorSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(vendorId)
                }
            }
        ]);

        if(getVendor.length == 1){
            let update = {
                vendorImage: file != undefined && file != "" && file != null ? file.path : ""
            }

            let updateProfile = await vendorSchema.findByIdAndUpdate(vendorId,update);

            res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Vendor Profile Updated" });
        }else{
            res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Vendor Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Deal Category----------------------------------MONIL--------------06/05/2021
router.post("/addDealCategory", dealCategoryImg.single("image") ,async function(req,res,next){
    try {
        const { DealCategoryName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDealCategory = await dealsCategorySchema.aggregate([
            {
                $match: {
                    DealCategoryName: {
                        $regex: DealCategoryName,
                        $options : "i"
                    }
                }
            }
        ]);

        if(getDealCategory.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Deal Category ${DealCategoryName} Already Exist` });
        }else{
            const file = req.file;

            let addDealCategory = await new dealsCategorySchema({
                DealCategoryName: DealCategoryName,
                file: file != undefined && file != null && file != "" ? file.path : ""
            });

            if(addDealCategory != null){
                try {
                    await addDealCategory.save();
                } catch (error) {
                    res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                return res.status(200).json({ IsSuccess: true , Data: [addDealCategory] , Message: `Deal Category ${DealCategoryName} Added` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [addDealCategory] , Message: `Deal Category ${DealCategoryName} Adding Faild` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Deal Categories--------------------------------MONIL--------------06/05/2021
router.post("/getDealCategories",async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDealCategories = await dealsCategorySchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getDealCategories.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: getDealCategories.length, 
                Data: getDealCategories, 
                Message: `Deals Categories Found` 
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Deals Categories Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Deal Category----------------------------------MONIL--------------06/05/2021
router.post("/addDealKeyword",async function(req,res,next){
    try {
        const { DealKeywordName } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDealKeyword = await dealsKeywordSchema.aggregate([
            {
                $match: {
                    DealKeywordName: {
                        $regex: DealKeywordName,
                        $options : "i"
                    }
                }
            }
        ]);

        if(getDealKeyword.length == 1){
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `Deal Keyword ${DealKeywordName} Already Exist` });
        }else{
            let addDealKeyword = await new dealsKeywordSchema({
                DealKeywordName: DealKeywordName
            });

            if(addDealKeyword != null){
                try {
                    await addDealKeyword.save();
                } catch (error) {
                    res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                return res.status(200).json({ IsSuccess: true , Data: [addDealKeyword] , Message: `Deal Keyword ${DealKeywordName} Added` });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [addDealKeyword] , Message: `Deal Keyword ${DealKeywordName} Adding Faild` });
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Deal Categories--------------------------------MONIL--------------06/05/2021
router.post("/getDealKeywords",async function(req,res,next){
    try {

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDealKeyword = await dealsKeywordSchema.aggregate([
            {
                $match: {}
            }
        ]);

        if(getDealKeyword.length > 0){
            return res.status(200).json({ 
                IsSuccess: true, 
                Count: getDealKeyword.length, 
                Data: getDealKeyword, 
                Message: `Deals keywords Found` 
            });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: `No Deals Keywords Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Add Vendor(Third-Party) Deals----------------------MONIL--------------29/04/2021
//OfferType - false - OneTime
//OfferType - true - MultipleTime
router.post("/addVendorDeals",async function(req,res,next){
    try {
        const { 
            vendorId,
            DealCategoryId,
            DealName,
            Description,
            Image,
            DealLink,
            TermsAndCondition,
            OfferType,
            ActualPrice,
            OfferPrice,
            Keywords,
            weekSchedule,
            StartDate,
            ExpiryDate,
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let checkVendor = await vendorSchema.aggregate([
            {
                $match: {
                    $and: [
                        { _id: mongoose.Types.ObjectId(vendorId) },
                        { vendorBelongsTo: "deals" }
                    ]
                }
            }
        ]);

        if(checkVendor.length == 1){
            let imgPaths = [];

            if(Image != undefined && Image != null && Image != []){
                Image.forEach(dataIs=>{
                    const path = 'uploads/vendorDeal/'+Date.now()+'.png';
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imgPaths.push(path);
                });
            }
            
            let addDeal = await new vendorDealsSchema({
                vendorId: vendorId,
                DealName: DealName,
                DealCategoryId: DealCategoryId,
                Description: Description,
                Image: imgPaths,
                DealLink: DealLink,
                TermsAndCondition: TermsAndCondition,
                OfferType: OfferType,
                ActualPrice: parseFloat(ActualPrice),
                OfferPrice: OfferPrice != undefined && OfferPrice != "" ? parseFloat(OfferPrice) : 0,
                Keywords: Keywords,
                weekSchedule: weekSchedule,
                StartDate: StartDate,
                ExpiryDate: ExpiryDate,
                dateTime: getCurrentDateTime(),
                DealNo: getDealNumber(),
            });

            if(addDeal != null){
                try {
                    await addDeal.save();
                } catch (error) {
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }

                return res.status(200).json({ IsSuccess: true , Data: [addDeal] , Message: "Deal Added" });
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "Deal Adding Faild" });
            }

        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Vendor Deals---------------------MONIL-------------06/05/2021
router.post("/getVendorDeals",async function(req,res,next){
    try {
        
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let day = moment().day();
        
        let getDeals;

        let nameOfDay;
        if(day == 0){
            nameOfDay = "Sunday";

            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Sunday.Active": false 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else if(day == 1){
            nameOfDay = "Monday";
            
            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Monday.Active": false 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else if(day == 2){
            nameOfDay = "Tuesday";

            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Tuesday.Active": true 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else if(day == 3){
            nameOfDay = "Wednesday";

            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Wednesday.Active": true 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);

            // getDeals.filter(data => );
        }else if(day == 4){
            nameOfDay = "Thursday";

            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Thursday.Active": true 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else if(day == 5){
            nameOfDay = "Friday";

            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Friday.Active": true 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else if(day == 6){
            nameOfDay = "Saturday";
            getDeals = await dealsCategorySchema.aggregate([
                {
                    $lookup: {
                        from: "vendordeals",
                        let: { categoryId: "$_id" , key: nameOfDay },
                        pipeline: [
                            { 
                                $match:
                                    {
                                        $and: [
                                            { $expr: { $eq: [ "$$categoryId" , "$DealCategoryId" ] } },
                                            { 
                                                "weekSchedule.Saturday.Active": true 
                                            }
                                        ]
                                    }
                            }
                        ],
                        as: "Deal"
                    }
                },
                {
                    $addFields: { TotalDeals: { $size: "$Deal" } }
                }
            ]);
        }else{
            return res.status(200).json({ IsSuccess: false , Message: "Something Went Wrong" });
        }

        if(getDeals.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: getDeals.length , Data: getDeals , Message: "Deal Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: getDeals.length , Message: "No Deal Category Found" });
        }
        
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Deal Test------------------MONIL-------------13/05/2021
router.post("/checkDeal",async function(req,res,next){
    try {
        // const {} = req.body;

        let getDeals = await vendorDealsSchema.aggregate([
            {
                $match: {
                    isActive: true
                }
            }
        ]);

        let currentDate = getCurrentDateTime();
        
        let avtiveDeals = [];
        getDeals.forEach(deal=>{
            let startDate = deal.StartDate;
            let endDate = deal.ExpiryDate;

            let isValid = isBetweenDates(currentDate,startDate,endDate);
            if(isValid == true){
                avtiveDeals.push(deal);
            }
        });

        if(avtiveDeals.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: avtiveDeals.length , Data: avtiveDeals , Message: "Deal Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Deal Category Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

router.post("/getDeals",async function(req,res,next){
    try {

        const { vendorId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    vendorId: mongoose.Types.ObjectId(vendorId)
                }
            },
            {
                $addFields: {
                    Discount: { 
                        $ceil: {
                            $subtract :[
                                100,
                                {
                                    $multiply: [
                                        {
                                            $divide: [ "$OfferPrice", "$ActualPrice" ]
                                        },100
                                    ]
                                }
                            ]
                        } 
                    }
                }
            },
            {
                $lookup: {
                    from: "dealscategories",
                    localField: "DealCategoryId",
                    foreignField: "_id",
                    as: "DealCategoryIs"
                }
            }
        ]); 

        if(getDeal.length > 0){
            return res.status(200).json({ IsSuccess: true , Count: getDeal.length , Data: getDeal , Message: "Vendor Deal Found" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Deal Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Update Deal Data---------------------MONIL------------14/05/2021
router.post("/updateDeal",async function(req,res,next){
    try {
        const { 
            dealId, 
            isActive,
            DealName,
            Description,
            DealLink,
            TermsAndCondition,
            OfferType,
            ActualPrice,
            OfferPrice,
            weekSchedule,
            StartDate,
            ExpiryDate,
            imageList,
            Keywords
        } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(dealId)
                }
            }
        ]);

        if(getDeal.length == 1){
            
            let imgPaths = [];

            if(imageList != undefined && imageList != null && imageList != []){
                imageList.forEach(dataIs=>{
                    const path = 'uploads/vendorDeal/'+'vendorDeal_'+Date.now()+'.png';
                    
                    const base64Data = dataIs.replace(/^data:([A-Za-z-+/]+);base64,/, '');
                
                    fs.writeFileSync(path, base64Data,  {encoding: 'base64'});
                    imgPaths.push(path);
                });
            }

            let update = {
                DealName: DealName != undefined && DealName != "" ? DealName : getDeal[0].DealName,
                Description: Description != undefined && Description != "" ? Description : getDeal[0].Description,
                DealLink: DealLink != undefined && DealLink != "" ? DealLink : getDeal[0].DealLink,
                TermsAndCondition: TermsAndCondition != undefined && TermsAndCondition != "" ? TermsAndCondition : getDeal[0].TermsAndCondition,
                OfferType: OfferType != undefined && OfferType != "" ? OfferType : getDeal[0].OfferType,
                ActualPrice: ActualPrice != undefined && ActualPrice != "" ? ActualPrice : getDeal[0].ActualPrice,
                OfferPrice: OfferPrice != undefined && OfferPrice != "" ? OfferPrice : getDeal[0].OfferPrice,
                isActive: isActive != undefined && isActive != "" ? isActive : getDeal[0].isActive,
                weekSchedule: weekSchedule != undefined && weekSchedule != "" ? weekSchedule : getDeal[0].weekSchedule,
                StartDate: StartDate != undefined && StartDate != "" ? StartDate : getDeal[0].StartDate,
                ExpiryDate: ExpiryDate != undefined && ExpiryDate != "" ? ExpiryDate : getDeal[0].ExpiryDate,
                $push: {
                    Keywords: { $each: Keywords },
                    Image: { $each: imgPaths }        
                }
            }

            let updateDeal = await vendorDealsSchema.findByIdAndUpdate(dealId,update);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Deal ${getDeal[0].DealName} updated` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Deal Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Revoked or Unactive deal-------------MONIL------------14/05/2021
router.post("/updateDealStatus",async function(req,res,next){
    try {
        const { dealId , isActive } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(dealId)
                }
            }
        ]);

        if(getDeal.length == 1){
            let update = {
                isActive: isActive
            }

            let updateDealStatus = await vendorDealsSchema.findByIdAndUpdate(dealId,update);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: `Deal ${getDeal[0].DealName} status updated` });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: `No Deal Found` });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Deal----------------------MONIL----------------14/05/2021
router.post("/deleteDeal",async function(req,res,next){
    try {
        const { dealId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(dealId)
                }
            }
        ]);

        if(getDeal.length == 1){
            let deleteDeal = await vendorDealsSchema.findByIdAndDelete(dealId);
            let imageFiles = getDeal[0].Image;
            imageFiles.forEach(async function(imagePath){
                let deleteImage = await deleteFile(imagePath);
            });

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Deal Deleted" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Deal Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Delete Deal Images---------------MONIL----------------14/05/2021
router.post("/deleteDealImage",async function(req,res,next){
    try {
        const { dealId , imagePath } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(dealId)
                }
            }
        ]);

        if(getDeal.length == 1){
            let removeImage = await vendorDealsSchema.updateOne(
                {
                    _id: mongoose.Types.ObjectId(dealId)
                },
                {
                    $pull: {
                        Image: String(imagePath)
                    }
                },
                { multi: true }
            );

            let deleteImage = await deleteFile(imagePath);

            return res.status(200).json({ IsSuccess: true , Data: 1 , Message: "Deal Image Removed" });
        }else{
            return res.status(200).json({ IsSuccess: true , Data: 0 , Message: "No Deal Found" });
        }


    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Redeem Deal----------------------MONIL----------------11/05/2021
router.post("/redeemOffer",async function(req,res,next){
    try {
        const { dealId , memberId } = req.body;
        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        let getDeal = await vendorDealsSchema.aggregate([
            {
                $match: {
                    _id: mongoose.Types.ObjectId(dealId)
                }
            }
        ]);

        if(getDeal.length == 1){
            if(getDeal[0].OfferType == false){
                //One Time Redeemed Deal Per Member

                let checkRedeemDeal = await dealsRedeemSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { _id: mongoose.Types.ObjectId(dealId) },
                                { memberId: mongoose.Types.ObjectId(memberId) }
                            ]
                        }
                    }
                ]);

                if(checkRedeemDeal.length == 1){
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: `This Offer Can Redeemed Only Once Per User` });
                }

                let redeemDeal = await new dealsRedeemSchema({
                    dealId: dealId,
                    memberId: memberId,
                    OfferType: getDeal[0].OfferType,
                    OfferPrice: getDeal[0].OfferPrice,
                    dateTime: getCurrentDateTime(),
                });

                if(redeemDeal != null){
                    try {
                        await redeemDeal.save();
                        return res.status(200).json({ 
                            IsSuccess: true, 
                            Data: [redeemDeal], 
                            Message: "Offer Redeemed Successfully" 
                        });
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: true , Message: error.message });
                    }
                }
            }else{
                let redeemDeal = await new dealsRedeemSchema({
                    dealId: dealId,
                    memberId: memberId,
                    OfferType: getDeal[0].OfferType,
                    OfferPrice: getDeal[0].OfferPrice,
                    dateTime: getCurrentDateTime(),
                });

                if(redeemDeal != null){
                    try {
                        await redeemDeal.save();
                        return res.status(200).json({ 
                            IsSuccess: true, 
                            Data: [redeemDeal], 
                            Message: "Offer Redeemed Successfully" 
                        });
                    } catch (error) {
                        return res.status(500).json({ IsSuccess: true , Message: error.message });
                    }
                }
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Deal Found" });
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Vendor Deal Payments-----------------MONIL---------------17/05/2021
router.post("/addAdvertisePayment",async function(req,res,next){
    try {
        const { advertiseId , vendorId , signature , paymentId , amount , orderId } = req.body;

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
            let addDealPayment = await new advertisePaymentSchema({
                advertiseId: advertiseId,
                vendorId: vendorId,
                signature: signature,
                paymentId: paymentId,
                amount: amount,
                orderId: orderId,
                invoiceNo: getInvoiceNumber(),
                dateTime: getCurrentDateTime(),
            });

            if(addDealPayment != null){
                try {
                    await addDealPayment.save();

                    let updateDeal = await advertisementSchema.findByIdAndUpdate(advertiseId,{ isPaid: true });

                    return res.status(200).json({ IsSuccess: true , Data: [addDealPayment] , Message: "Payment Done Successfully" });
                } catch (error) {
                    return res.status(500).json({ IsSuccess: false , Message: error.message });
                }
            }
        }else{
            return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Deal Found" });
        } 
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Vendor Payments-------------------MONIL--------------17/05/2021
router.post("/getVendorPayments",async function(req,res,next){
    try {
        const { vendorId , advertiseId , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(advertiseId != undefined && advertiseId != null && advertiseId != ""){
            let getAdvertise = await advertisementSchema.aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(advertiseId)
                    }
                }
            ]);
    
            if(getAdvertise.length == 1){
                if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
                    let dates = generateDateList(fromDate,toDate);
                    let getVendorPayments = await advertisePaymentSchema.aggregate([
                        {
                            $match: {
                                $and: [
                                    { vendorId: mongoose.Types.ObjectId(vendorId) },
                                    { "dateTime.0": { $in: dates } }
                                ]
                            }
                        }
                    ]);
            
                    if(getVendorPayments.length > 0){
                        return res.status(200).json({ 
                            IsSuccess: true, 
                            Count: getVendorPayments.length, 
                            Data: getVendorPayments, 
                            Message: `Vendor Payments between dates ${fromDate} to ${toDate} Found` 
                        });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                    }
                }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
                    let getVendorPayments = await advertisePaymentSchema.aggregate([
                        {
                            $match: {
                                $and: [
                                    { vendorId: mongoose.Types.ObjectId(vendorId) },
                                    { "dateTime.0": toDate }
                                ]
                            }
                        }
                    ]);
            
                    if(getVendorPayments.length > 0){
                        return res.status(200).json({ 
                            IsSuccess: true, 
                            Count: getVendorPayments.length, 
                            Data: getVendorPayments, 
                            Message: `Vendor Payments Found for Date ${toDate}` 
                        });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                    }
                }else{
                    let getVendorPayments = await advertisePaymentSchema.aggregate([
                        {
                            $match: {
                                vendorId: mongoose.Types.ObjectId(vendorId)
                            }
                        }
                    ]);
            
                    if(getVendorPayments.length > 0){
                        return res.status(200).json({ 
                            IsSuccess: true, 
                            Count: getVendorPayments.length, 
                            Data: getVendorPayments, 
                            Message: "Vendor Payments Found" 
                        });
                    }else{
                        return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                    }
                }
            }else{
                return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Deal Found" });
            }
        }else{
            if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
                let dates = generateDateList(fromDate,toDate);
                let getVendorPayments = await advertisePaymentSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { vendorId: mongoose.Types.ObjectId(vendorId) },
                                { "dateTime.0": { $in: dates } }
                            ]
                        }
                    }
                ]);
        
                if(getVendorPayments.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getVendorPayments.length, 
                        Data: getVendorPayments, 
                        Message: `Vendor Payments between dates ${fromDate} to ${toDate} Found` 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                }
            }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
                let getVendorPayments = await advertisePaymentSchema.aggregate([
                    {
                        $match: {
                            $and: [
                                { vendorId: mongoose.Types.ObjectId(vendorId) },
                                { "dateTime.0": toDate }
                            ]
                        }
                    }
                ]);
        
                if(getVendorPayments.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getVendorPayments.length, 
                        Data: getVendorPayments, 
                        Message: `Vendor Payments Found for Date ${toDate}` 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                }
            }else{
                let getVendorPayments = await advertisePaymentSchema.aggregate([
                    {
                        $match: {
                            vendorId: mongoose.Types.ObjectId(vendorId)
                        }
                    }
                ]);
        
                if(getVendorPayments.length > 0){
                    return res.status(200).json({ 
                        IsSuccess: true, 
                        Count: getVendorPayments.length, 
                        Data: getVendorPayments, 
                        Message: "Vendor Payments Found" 
                    });
                }else{
                    return res.status(200).json({ IsSuccess: true , Data: [] , Message: "No Vendor Payments Found" });
                }
            }
        }
    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//Get Member Redeem Offer----------------MONIL-------------21/05/2021
router.post("/getRedeemedOffers",async function(req,res,next){
    try {
        const { dealId , fromDate , toDate } = req.body;

        let authToken = req.headers['authorization'];
        
        if(authToken != config.tokenIs || authToken == null || authToken == undefined){
            return res.status(200).json({ IsSuccess: false , Data: [] , Message: "You are not authenticated" });
        }

        if(fromDate != undefined && fromDate != null && fromDate != "" && toDate != undefined && toDate != null && toDate != ""){
            let dates = generateDateList(fromDate,toDate);
            let getRedeemedOffers = await dealsRedeemSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { dealId: mongoose.Types.ObjectId(dealId) },
                            { "dateTime.0": { $in: dates } }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "vendordeals",
                        localField: "dealId",
                        foreignField: "_id",
                        as: "Deal"
                    }
                },
                {
                    $lookup: {
                        from: "members",
                        localField: "memberId",
                        foreignField: "_id",
                        as: "Member"
                    }
                },
                {
                    $project: {
                        dealId: 1,
                        OfferType: 1,
                        OfferPrice: 1,
                        dateTime: 1,
                        "Deal.DealName": 1,
                        "Deal.Description": 1,
                        "Deal.ActualPrice": 1,
                        "Deal.DealName": 1,
                        "Member.Name": 1,
                        "Member.ContactNo": 1
                    }
                }
            ]);

            if(getRedeemedOffers.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: getRedeemedOffers, 
                    Message: `Redeemed Offers Found for Interval: ${fromDate} to ${toDate}` 
                });
            }else{
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [], 
                    Message: `No Redeemed Offers Found for Interval: ${fromDate} to ${toDate}` 
                });
            }
        }else if(toDate != undefined && toDate != null && toDate != "" && (fromDate == undefined || fromDate == null || fromDate == "")){
            let getRedeemedOffers = await dealsRedeemSchema.aggregate([
                {
                    $match: {
                        $and: [
                            { dealId: mongoose.Types.ObjectId(dealId) },
                            { "dateTime.0": toDate }
                        ]
                    }
                },
                {
                    $lookup: {
                        from: "vendordeals",
                        localField: "dealId",
                        foreignField: "_id",
                        as: "Deal"
                    }
                },
                {
                    $lookup: {
                        from: "members",
                        localField: "memberId",
                        foreignField: "_id",
                        as: "Member"
                    }
                },
                {
                    $project: {
                        dealId: 1,
                        OfferType: 1,
                        OfferPrice: 1,
                        dateTime: 1,
                        "Deal.DealName": 1,
                        "Deal.Description": 1,
                        "Deal.ActualPrice": 1,
                        "Deal.DealName": 1,
                        "Member.Name": 1,
                        "Member.ContactNo": 1
                    }
                }
            ]);

            if(getRedeemedOffers.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: getRedeemedOffers, 
                    Message: `Redeemed Offers Found for Date: ${toDate}` 
                });
            }else{
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [], 
                    Message: `No Redeemed Offers Found for Date: ${toDate}` 
                });
            }
        }else{
            let getRedeemedOffers = await dealsRedeemSchema.aggregate([
                {
                    $match: {
                        dealId: mongoose.Types.ObjectId(dealId)
                    }
                },
                {
                    $lookup: {
                        from: "vendordeals",
                        localField: "dealId",
                        foreignField: "_id",
                        as: "Deal"
                    }
                },
                {
                    $lookup: {
                        from: "members",
                        localField: "memberId",
                        foreignField: "_id",
                        as: "Member"
                    }
                },
                {
                    $project: {
                        dealId: 1,
                        OfferType: 1,
                        OfferPrice: 1,
                        dateTime: 1,
                        "Deal.DealName": 1,
                        "Deal.Description": 1,
                        "Deal.ActualPrice": 1,
                        "Deal.DealName": 1,
                        "Member.Name": 1,
                        "Member.ContactNo": 1
                    }
                }
            ]);

            if(getRedeemedOffers.length > 0){
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: getRedeemedOffers, 
                    Message: `Redeemed Offers Found` 
                });
            }else{
                return res.status(200).json({ 
                    IsSuccess: true, 
                    Data: [], 
                    Message: `No Redeemed Offers Found` 
                });
            }
        }

    } catch (error) {
        res.status(500).json({ IsSuccess: true , Message: error.message });
    }
});

//Check Between Date
function isBetweenDates(yourDate,start,end){

    let startDateTimeMoment = moment(`${start[0]},${start[1]}`,"DD/MM/YYYY,h:mm:ss a");
    let endDateTimeMoment = moment(`${end[0]},${end[1]}`,"DD/MM/YYYY,h:mm:ss a");

    let yourDateTimeMoment = moment(`${yourDate[0]},${yourDate[1]}`,"DD/MM/YYYY,h:mm:ss a");

    let isBetween = moment(yourDateTimeMoment).isBetween(startDateTimeMoment,endDateTimeMoment);

    return isBetween;
}

//Get Time Diff
router.post("/getTime",async function(req,res,next){
    try {
        let a = ["12/05/2021","9:00 AM"];
        let b = ["13/05/2021","6:00 PM"];
        let c = ["13/05/2021","11:30 AM"]; 


        let s1 = moment(`${a[0]},${a[1]}`,"DD/MM/YYYY,h:mm:ss a");
        let s2 = moment(`${b[0]},${b[1]}`,"DD/MM/YYYY,h:mm:ss a");
        console.log(s1);
        console.log(s2);

        // // let duration = moment.duration(s2.diff(s1));
        var m3 = s2.diff(s1,'minutes'); 
        var m4 = s2.diff(s1,'h'); 

        let s3 = moment(`${c[0]},${c[1]}`,"DD/MM/YYYY,h:mm:ss a");

        console.log(s3)
        // console.log(duration);
        console.log("--------------------------------------------------------------------------");
        console.log(m3,m4);
        console.log("--------------------------------------------------------------------------");
        var bool1 = moment(s3).isBetween(s1,s2);

        console.log(bool1);

    } catch (error) {
        res.status(500).json({ IsSuccess: false , Message: error.message });
    }
});

//CRON_JOB for every 24 hour to check Close Deal
cron.schedule('0 0 * * *',async function(){
    console.log('running a task every 24 hour');
    let currentDateTime = getCurrentDateTime();
    let currentDate = currentDateTime[0];

    let expireOffer = await vendorDealsSchema.aggregate([
        {
            $match: {
                "ExpiryDate.0": getCurrentDate()
            }
        }
    ]);
    
    if(expireOffer.length > 0){
        expireOffer.forEach(async function(offerIs){
            let updateStatus = {
                isActive: false
            }
            let updateAdStatus = await vendorDealsSchema.findByIdAndUpdate(offerIs._id,updateStatus);
        });
    }
});

//Delete File Using Its path
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

function getDealNumber(){
    let generateNo = "DEAL-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
}

function getAdvertiseNumber(){
    let generateNo = "AD-"+ Math.random().toFixed(6).split('.')[1];
    return generateNo;
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

function getCurrentDateTimePlusOneYear(){
    let date = moment()
            .add(1, 'y')
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