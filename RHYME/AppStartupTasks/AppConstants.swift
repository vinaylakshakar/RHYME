//
//  AppConstants.swift
//  JoyPlus
//
//  Created by Silstone on 22/09/20.
//  Copyright © 2020 SilstoneGroup. All rights reserved.
//

import UIKit

typealias blockCompletedWithStatus = (Bool) -> Void
typealias blockCompletedWith = (Bool, String) -> Void
typealias completionHandlerWithResponseData = (Bool, Any?, String) -> Void

let _APP_DELEGATE   =   UIApplication.shared.delegate as! AppDelegate
let _SCENE_DELEGATE = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
let _APP_MANAGER    =   AppManager.shared

var _isSelfAssesmentTakenBeforeRegister = false
var selectedTab = 0
let _Grow_and_Learn = "Grow and Learn"
let _Terms_Conditions = "TermsConditions"

let kBaseUrl:String = "http://3.99.34.20/"
let kUserID:String = "USER_ID"
let ksendOTP:String = "sendOTP"
let kverifyOTP:String = "verifyOTP"
let kupdateProfile:String = "profile"
let kpostFLHA:String = "formFLHA"
let kchangeStatus:String = "formInventory/changeStatus"
let kreportTask:String = "reportTask"
let kmarkAsCompleteTask:String = "markAsCompleteTask"
let kuesrLogout:String = "Logout"
let ksearchTask:String = "searchTask"

let kuserInfo:String = "UserInfo"
let _isUserLoggedIn     =   "isUserLoggedIn"
let _isUserOnboarded     =   "isUserOnboarded"

let kAuthorizationToken :String =   "Authorization"
let kHazards:String =   "hazards"
let kLFHAProjectInfo:String =   "LFHAProjectInfo"
let kLFHATasks:String =   "LFHATasks"

let kDueThisWeekTaskCount :String =   "DueThisWeekTaskCount"
let kPendingTaskCount :String =   "PendingTaskCount"
let kCompletedTaskCount :String =   "CompletedTaskCount"
