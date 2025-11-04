//
//  AppManager.swift
// 
//

import UIKit
import Foundation
import CoreData
import SDWebImage
//import CryptoKit

class AppManager {
    
    static let shared = AppManager()
    
    let userDefaults = UserDefaults.standard
    
    // MARK: App level variables
    var deviceUniqueKey: String!
    
    var isUserLoggedIn: Bool { return UserDefaults.standard.bool(forKey: _isUserLoggedIn) }
    var isUserOnboarded: Bool { return UserDefaults.standard.bool(forKey: _isUserOnboarded) }
//    var isUserOnboarded: Bool { return UserDefaults.standard.bool(forKey: _UserOnboarded) }
//    var isEventPosted: Bool { return UserDefaults.standard.bool(forKey: _EventPosted) }
//    var isUserEnableNotification: Bool { return UserDefaults.standard.bool(forKey: _UserEnabledNotificatin) }
//
//    var currentUserLoginType: String { return UserDefaults.standard.string(forKey: _loginType) ?? "" }
    var userAuthorizationToken: String { return UserDefaults.standard.string(forKey: kAuthorizationToken) ?? "noAuthorization" }
    var hazardsArray: NSArray { return UserDefaults.standard.array(forKey: kHazards)! as NSArray }
    var FLHAProjectInfo: NSDictionary { return UserDefaults.standard.dictionary(forKey: kLFHAProjectInfo)! as NSDictionary}
    var FLHATaskArray: NSArray { return UserDefaults.standard.array(forKey: kLFHATasks)! as NSArray }
    var userInfo: NSDictionary { return UserDefaults.standard.dictionary(forKey: kuserInfo)! as NSDictionary}
    // Unhashed nonce.
    var currentNonce: String?
    var babycount = Int()
    var dueThisWeekTaskCount: String { return UserDefaults.standard.string(forKey: kDueThisWeekTaskCount) ?? "0" }
    var pendingTaskCount: String { return UserDefaults.standard.string(forKey: kPendingTaskCount) ?? "0" }
    var completedTaskCount: String { return UserDefaults.standard.string(forKey: kCompletedTaskCount) ?? "0" }
   
    
    // MARK:
    // MARK: Login
    func loginUser() {
//        guard !UserInfoViewModel.isBlocked else {
//            ErrorHandler.alertWithError(message: "ID_USER_BLOCKED_MSG".localized)
//            return
//        }
//
//        setUserLogin(state: true)
//        AppLaunch.presentTabBarView()
    }
    func setUserOnboarded(state: Bool) {
        UserDefaults.standard.set(state, forKey: _isUserOnboarded)
        UserDefaults.standard.synchronize()
    }
    
    func setUserLogin(state: Bool) {
        UserDefaults.standard.set(state, forKey: _isUserLoggedIn)
        UserDefaults.standard.synchronize()
    }
    
    //Set AuthorizationToken
    func saveAuthorizationToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: kAuthorizationToken)
        UserDefaults.standard.synchronize()
    }
    
    func saveHazardArray(_ hazardsArray: NSArray) {
        UserDefaults.standard.set(hazardsArray, forKey: kHazards)
        UserDefaults.standard.synchronize()
    }
    
    func saveLFHAProjectInfo(_ projectInfo: NSDictionary) {
        UserDefaults.standard.set(projectInfo, forKey: kLFHAProjectInfo)
        UserDefaults.standard.synchronize()
    }
    
    func saveUserInfo(_ userInfo: NSDictionary) {
        UserDefaults.standard.set(userInfo, forKey: kuserInfo)
        UserDefaults.standard.synchronize()
    }
    
    func saveLFHAProjectTask(_ projectTask: NSArray) {
        UserDefaults.standard.set(projectTask, forKey: kLFHATasks)
        UserDefaults.standard.synchronize()
    }
    //MARK: save task number
    func savedueThisWeekTaskCount(_ token: String) {
        UserDefaults.standard.set(token, forKey: kDueThisWeekTaskCount)
        UserDefaults.standard.synchronize()
    }
    func savePendingTaskCount(_ token: String) {
        UserDefaults.standard.set(token, forKey: kPendingTaskCount)
        UserDefaults.standard.synchronize()
    }
    func saveCompletedTaskCount(_ token: String) {
        UserDefaults.standard.set(token, forKey: kCompletedTaskCount)
        UserDefaults.standard.synchronize()
    }

}

// MARK:
// MARK: Logout
extension AppManager {
    func logoutUser() {
        clearSavedData()
    }
    
    func clearSavedData() {
        //_isSelfAssesmentTakenBeforeRegister = false
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        setUserLogin(state: false)
        setUserOnboarded(state: false)
        AppLaunch.presentLogin()
    }
}

// MARK:
// MARK: T&C and Privacy Policy
extension AppManager {
    func openTermsOfUseOn(vc: UIViewController) {
        //        let urlStr = _APP_MANAGER.TERMS_OF_USE_URL
        //        guard urlStr.count > 0 else {
        //            return
        //        }
        //
        //        guard URL(string: urlStr) != nil else {
        //            return
        //        }
        //
        //        let onlineFeatureVC = _APP_MANAGER.mainStoryboard.instantiateViewController(withIdentifier: ONLINE_FEATURE_VIEW_CONTROLLER) as! OnlineFeatureViewController
        //        onlineFeatureVC.strTitle = "ID_TERMS_OF_USE_LABEL".localized
        //        onlineFeatureVC.strLoadUrl = urlStr
        //        vc.present(onlineFeatureVC, animated: true, completion: nil)
    }
    
    func openPrivacyPolicyOn(vc: UIViewController) {
        //        let urlStr = _APP_MANAGER.PRIMVACY_POLICY_URL
        //        guard urlStr.count > 0 else {
        //            return
        //        }
        //
        //        guard URL(string: urlStr) != nil else {
        //            return
        //        }
        //
        //        let onlineFeatureVC = _APP_MANAGER.mainStoryboard.instantiateViewController(withIdentifier: ONLINE_FEATURE_VIEW_CONTROLLER) as! OnlineFeatureViewController
        //        onlineFeatureVC.strTitle = "ID_PRIVACY_POLICY_LABEL".localized
        //        onlineFeatureVC.strLoadUrl = urlStr
        //        vc.present(onlineFeatureVC, animated: true, completion: nil)
    }
}

