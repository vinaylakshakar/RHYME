//
//  AppLaunch.swift
//  JoyPlus
//
//  Created by Silstone on 15/09/20.
//  Copyright © 2020 SilstoneGroup. All rights reserved.
//

import UIKit

class AppLaunch: NSObject {
    
    // MARK: Setup App on Launch
    class func setupAppLaunch() -> Void {
        setupAppRootView()
    }
    
    // MARK: Set Root View
    class func setupAppRootView() -> Void {
        if _APP_MANAGER.isUserLoggedIn {
//            let email = _APP_MANAGER.userEmail
//            if email.count > 0 {
                _APP_MANAGER.isUserOnboarded ? AppLaunch.presentPostLogin(selectedIndex: 0) :presentOnboardingVC()
//            }else{
//                _APP_MANAGER.logoutUser()
//            }
        }else {
            //_APP_MANAGER.isUserTutorialViewed ? presentLogin() : presentWalkThrough()
            presentLogin()
        }
    }
    
    class func presentLogin(vc: UIViewController? = nil) -> Void {
         let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInNavigation") as! UINavigationController
            _SCENE_DELEGATE.window!.rootViewController = loginVC
     }

    class func presentPostLogin(selectedIndex:Int ) {
         let pro = UIStoryboard(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomTabBarController") as! UITabBarController
         pro.selectedIndex = selectedIndex
         _SCENE_DELEGATE.window!.rootViewController = pro
     }
    
    class func presentWalkThrough() -> Void {
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalkThroughNavVC") as! UINavigationController
               _SCENE_DELEGATE.window!.rootViewController = vc
      }
      
    class func presentOnboardingVC(vc: UIViewController? = nil) -> Void {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompleteProfileVC")
           let SelfAssesment = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInNavigation") as! UINavigationController
              _SCENE_DELEGATE.window!.rootViewController = SelfAssesment
        SelfAssesment.pushViewController(vc, animated: true)
          
       }
}

extension AppLaunch{
    
    class func getAllWeekDates(day:String)->String{
        let dateInWeek = Date()//7th June 2017
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }
        //["MON","TUE","WED","THU","FRI","SAT","SUN"]
        var date:NSInteger?
        if day=="mon" {
             date = calendar.component(.weekday, from: dateInWeek) - 1
        }
        if day=="tue" {
             date = calendar.component(.weekday, from: dateInWeek) - 2
        }
        if day=="wed" {
             date = calendar.component(.weekday, from: dateInWeek) - 3
        }
        if day=="thu" {
            date = calendar.component(.weekday, from: dateInWeek) - 4
        }
        if day=="fri" {
            date = calendar.component(.weekday, from: dateInWeek) - 5
        }
        if day=="sat" {
            date = calendar.component(.weekday, from: dateInWeek) - 6
        }
        if day=="sun" {
            date = calendar.component(.weekday, from: dateInWeek) - 7
        }
        print(date!)
        let dateStr = convertDateToStr(date: days[date!] as NSDate)
        return dateStr
    }
    
    class func convertDateToStr(date:NSDate) -> String {
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: date as Date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMMM dd, yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)

        return myStringafd
    }
    
    class func showAlertView(title:String,message:String) {
        let AlertAction = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: {  action in
//            print("repeat alert Action")
//            self.showAlertView(title: "You have been blocked!", message: "You have been blocked because you have violated our Terms and Conditions and Usage Policy. Please contact us if you feel we have made a mistake.")
//        })
        
        let logout = UIAlertAction(title: "OK", style: .default, handler: {  action in
            //_MAIL_COMPOSER.mailComposer()
            _APP_MANAGER.logoutUser()
            
        })

       // AlertAction.addAction(cancelAction)
        AlertAction.addAction(logout)

        _SCENE_DELEGATE.window!.rootViewController?.present(AlertAction, animated: true, completion: nil)
    }
    
}
