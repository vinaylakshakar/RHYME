//
//  Networking.swift
//  ExploreMine
//
//  Created by Silstone on 01/11/19.
//  Copyright © 2019 SilstoneGroup. All rights reserved.
//

import Foundation
import Alamofire


class NetworkApi: NSObject{
    
    //MARK: check session
    //MARK: POST API
    func UnivarsalPostApi(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        
        let originalString = "\(kBaseUrl)\(apiMethod)/"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .post,parameters: params,encoding: URLEncoding.default,headers: headers).responseJSON { (response)  in
            completionHandler(response)
        }
        
        
    }
    
    func UnivarsalJsonPostApi(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        
        let originalString = "\(kBaseUrl)\(apiMethod)/"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .post,parameters: params,encoding: JSONEncoding.default,headers: headers).responseJSON { (response)  in
            completionHandler(response)
        }
        
    }
    
    
    
    //MARK: GET API
    func GetCountryList(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)countryList/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    
    func GetProfile(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)profile/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func getTask(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)getTask/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func getProject(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)getProject/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func getFormList(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)getFormList/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetformFLHA(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)formFLHA/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetformInventory(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)formInventory/"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func UpdateprofileApi(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        
        let originalString = "\(kBaseUrl)\(apiMethod)/"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .put,parameters: params,encoding: JSONEncoding.default,headers: headers).responseJSON { (response)  in
            completionHandler(response)
        }
        
        
    }
    
    
    func callGetApi(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let userid = UserDefaults.standard.string(forKey: kUserID)
        print(userid!)
        let originalString = "\(kBaseUrl)GetUserProfile?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func categoryGetApi(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)Category?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func AllcategoryGetApi(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)Category?userId=0"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func forgotPostApi(apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
                        //            "Username": "sdsol",
                        //            "Password": "sdsol99",
               "Authorization" : "application/json",
               "Content-Type" : "application/x-www-form-urlencoded"
                    ]
        let originalString = "\(kBaseUrl)ForgotPassword"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .post,parameters: params,encoding: URLEncoding.default,headers: header).responseJSON { (response)  in
            completionHandler(response)
        }
    }
    func suggestedappGetApi(apiMethod:String, parameters:String,completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
            
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)GetAllApplication?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetSelectedActivities(apiMethod:String, parameters:String,completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
            
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)GetSelectedActivities?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetDashboard(apiMethod:String, parameters:String,completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
            
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)Dashboard?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetSchedule(apiMethod:String, parameters:String,completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
            
            "Authorization" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let userid = UserDefaults.standard.string(forKey: kUserID)
        let originalString = "\(kBaseUrl)GetSchedule?userId=\(userid!)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    
    
//    func callGetApiWithSession(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//        checkSession { (isSession) in
//            if isSession {
//                self.callGetApi(apiMethod: apiMethod, parameters: parameters, headers: headers) { (response) in
//                    completionHandler(response)
//                }
//            } else {
//                self.getSession() { (response) in
//                    self.callGetApi(apiMethod: apiMethod, parameters: parameters, headers: headers) { (response) in
//                        completionHandler(response)
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: Delete API
//    func callDeleteApi(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//
//
//
//                let originalString = "\(kBaseUrl)\(apiMethod)"
//                let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                guard let serviceUrl = URL(string:urlString!) else { return }
//                Alamofire.request(serviceUrl, method: .delete, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
//                    completionHandler(response)
//                }
//
//
//                    let originalString = "\(kBaseUrl)\(apiMethod)"
//                    let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                    guard let serviceUrl = URL(string:urlString!) else { return }
//                    Alamofire.request(serviceUrl, method: .delete, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
//                        completionHandler(response)
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: POST API FOR MAKE UNFAVOURITE
//    func callPostApi(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//
//        let originalString = "\(kBaseUrl)\(apiMethod)/"
//        print(originalString)
//        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        guard let serviceUrl = URL(string:urlString!) else { return }
//        Alamofire.request(originalString,method: .post,parameters: params,encoding: URLEncoding.default,headers: headers).responseJSON { (response)  in
//            completionHandler(response)
//        }
//
//
//    }
    
//    func callPostNewApi(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//
//        let originalString = "\(kBaseUrl)\(apiMethod)?"
//        print(originalString)
//        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        guard let serviceUrl = URL(string:urlString!) else { return }
//        Alamofire.request(originalString,method: .post,parameters: params,encoding: JSONEncoding.default,headers: headers).responseJSON { (response)  in
//            completionHandler(response)
//        }
////        Alamofire.request(originalString)
////        .responseJSON { response in
////          // do stuff with the JSON or error
////        }
//
//    }
    
    //
    func callPostWithStr(apiFor:String,parameters:String,completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
               "Accept": "application/json"
                ]
            let originalString = "\(kBaseUrl)\(apiFor)?\(parameters)"
            guard let serviceUrl = URL(string:originalString) else { return }
            
            Alamofire.request(serviceUrl,method: .post,encoding: URLEncoding.default,headers: headers).responseJSON { (response)  in
                completionHandler(response)
                
    //            if response.result.isSuccess {
    //                 completionHandler(response)
    //            } else if response.error?._code == NSURLErrorNotConnectedToInternet{
    //                print(response)
    //            }
            }
        }
    
    
    
    func impactFactor(apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//        let header: HTTPHeaders = [
//                        //            "Username": "sdsol",
//                        //            "Password": "sdsol99",
//               "Authorization" : "application/json",
//               "Content-Type" : "application/json; charset=utf-8"
//                    ]
        let originalString = "\(kBaseUrl)ImpactFactors"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        guard let serviceUrl = URL(string:urlString!) else { return }
//        Alamofire.request(originalString,method: .post,parameters: params,encoding: JSONEncoding.default,headers: header).responseJSON { (response)  in
//            completionHandler(response)
//        }
        
        
//                Alamofire.request(originalString)
//                .responseJSON { response in
//                  // do stuff with the JSON or error
//                    completionHandler(response)
//                }
      
        
        var request = URLRequest(url: URL(string:urlString!)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

       // let values = ["06786984572365", "06644857247565", "06649998782227"]
        let parameters = params["factors"] as! [[String:AnyObject]]

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)

                   Alamofire.request(request)
                    .responseJSON { response in
                        // do whatever you want here
                       completionHandler(response)
                }
        }
    
    func submitsubcategorywithid(apiMethod:String, params:[String: Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let header: HTTPHeaders = [
                        //            "Username": "sdsol",
                        //            "Password": "sdsol99",
               "Authorization" : "application/json",
               "Content-Type" : "application/json; charset=utf-8"
                    ]
        let originalString = "\(kBaseUrl)PostUserCategory"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .post,parameters: params,encoding: JSONEncoding.default,headers: header).responseJSON { (response)  in
            completionHandler(response)
        }
    }
    
    func signinwithapple(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        
        let originalString = "\(kBaseUrl)SignInWithApple"
        print(originalString)
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(originalString,method: .post,parameters: params,encoding: URLEncoding.default,headers: headers).responseJSON { (response)  in
            completionHandler(response)
        }
    }
//    func callPostApiWithSession(headers:HTTPHeaders, apiMethod:String, params:[String : Any], completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//
//        checkSession { (isSession) in
//            if isSession {
//                self.callPostApi(headers: headers, apiMethod: apiMethod, params: params) { (response) in
//                    completionHandler(response)
//                }
//            } else {
//                self.getSession() { (response) in
//                    self.callPostApi(headers: headers, apiMethod: apiMethod, params: params) { (response) in
//                        completionHandler(response)
//                    }
//                }
//            }
//        }
//    }
    func updateProfileandCategories(headers:HTTPHeaders, apiMethod:String, imageData: Data?, onCompletion: ((DataResponse<Any>) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let originalString = "\(kBaseUrl)UpdateProfileAndCategory"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                //                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: serviceUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(response)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    func requestWithMultipart(headers:HTTPHeaders, apiMethod:String, imageData: Data?, onCompletion: ((DataResponse<Any>) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let originalString = "\(kBaseUrl)\(apiMethod)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                //                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: serviceUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(response)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
        
        
//    func requestWithMultipartWithSession(headers:HTTPHeaders, apiMethod:String, imageData: Data?, onCompletion: ((DataResponse<Any>) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
//
//        checkSession { (isSession) in
//            if isSession {
//                self.requestWithMultipart(headers: headers, apiMethod: kFiles, imageData: imageData, onCompletion: { (response) in
//                    onCompletion!(response)
//                }) { (error) in
//
//                }
//            } else {
//                   self.getSession() { (response) in
//                    self.requestWithMultipart(headers: headers, apiMethod: kFiles, imageData: imageData, onCompletion: { (response) in
//                        onCompletion!(response)
//                    }) { (error) in
//
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: Google Directions API
//    func callGetDirectionsApi(originPoint:String, destinationPoint:String, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
//
//        let originalString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originPoint)&destination=\(destinationPoint)&mode=driving&key=\(kGoogleApiKey)"
//        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        guard let serviceUrl = URL(string:urlString!) else { return }
//        Alamofire.request(serviceUrl, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
//            completionHandler(response)
//        }
//    }
    
    //vinay here-
    func GetCategoryApps(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let userid = UserDefaults.standard.string(forKey: kUserID)
        print(userid!)
        let originalString = "\(kBaseUrl)GetCategoryApps?\(parameters)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetCategoryAppsUser(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let userid = UserDefaults.standard.string(forKey: kUserID)
        print(userid!)
        let originalString = "\(kBaseUrl)GetCategoryAppsUser?\(parameters)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetEmptyHoursDateForApp(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)GetEmptyHoursDateForApp?\(parameters)"
        
        Alamofire.request(originalString, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetUserAwards(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)GetUserAwards?\(parameters)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(serviceUrl, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
    func GetUserStatics(apiMethod:String, parameters:String, headers:HTTPHeaders, completionHandler: @escaping (_ response: DataResponse<Any>) -> Void)  {
        let originalString = "\(kBaseUrl)GetUserStatics?\(parameters)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let serviceUrl = URL(string:urlString!) else { return }
        Alamofire.request(serviceUrl, method: .get, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
}
