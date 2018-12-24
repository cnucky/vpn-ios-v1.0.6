// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Foundation
import CommonCrypto

enum URLType: String, CaseIterable {
    
    case Login = "/user/login"
    case Register = "/user/register"
    case RefreshToken = "/user/refreshtoken"
    case VpnConnect = "/vpn/connect"
    case VpnDisconnect = "/vpn/disconnect"
    case NodeList = "/index/nodelist"

    static let allValues = URLType.allCases.map { $0.rawValue }
}

class webservices: NSObject
{
//    var url = URL(string: "http://23.224.78.66:8090/user/login")
    var url = "http://23.224.78.66:8090"

    
    func dataRequest(UUIDValue: String, URLType: String, parameters: NSDictionary,completion:@escaping (NSDictionary) ->())   {

//        var returnData : String = ""
//        var returnDictArray: Dictionary<String, String> = [:]
        
        print("appDelegate UUIDValue--->",UUIDValue)

        let number = Int.random(in: 111111 ..< 999999)
//        print(" number---> ", number)
        let suffixNumber = String(number)
        
        let aesExtension:NSDataAES = NSDataAES()
        
        
        
        var strparamString = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            if let json = String(data: jsonData, encoding: .utf8) {
                print("jsonData--->",json)
                 strparamString = aesExtension.encrypt(withText: json, initRandomIv: suffixNumber)
//                print(" json encrypt---> ", strparamString as Any)

                let postdata_parameters: NSDictionary = [
                    "post-data": strparamString
                ]
                
                do {
                    let postDatajsonData = try JSONSerialization.data(withJSONObject: postdata_parameters)
                    if let postDatajson = String(data: postDatajsonData, encoding: .utf8) {
                        print("jsonData2--->",postDatajson)
 
                        let strpostdata_parameters = postDatajson
                        
                        let url4 = URL(string: url + URLType)!
                        let session4 = URLSession.shared
                        let request = NSMutableURLRequest(url: url4)
                        request.httpMethod = "POST"
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.addValue(UUIDValue, forHTTPHeaderField: "imei")
                        request.addValue(suffixNumber, forHTTPHeaderField: "suffix")
                        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                        
                        let paramString = strpostdata_parameters //"post-data=" //+ strparamString!
                        request.httpBody = paramString.data(using: String.Encoding.utf8)
                        
                        print("request--->", request as Any) //JSONSerialization
                        
                        
                        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
                            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                                print("*****error")
                                return
                            }
                            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            //            print("*****This is the data 4: \(dataString)") //JSONSerialization
//                            print("data dataRequest--->", data as Any) //JSONSerialization
                            print("dataString--->", dataString as Any) //JSONSerialization
                            
//                            let dict: NSDictionary = JSONSerialization.jsonObject(with: dataString, options: []) as? [String: Any]
                            let dictionary1 = self.convertToDictionary(from: dataString! as String)
                            print("dictionary1--->", dictionary1 as Any) //JSONSerialization
//                            print("dictionary2 data--->", dictionary1!["data"] as Any ) //JSONSerialization
//                            print("dictionary2 suffix--->", dictionary1!["suffix"] as Any ) //JSONSerialization

//                            print(" json decrypt---> ", aesExtension.decrypt(withText: dictionary1!["data"] as Any as? String , initRandomIv: dictionary1!["suffix"] as Any as? String))
                            let returnData = aesExtension.decrypt(withText: dictionary1!["data"] , initRandomIv: dictionary1!["suffix"])
                            print(" json returnData---> ", returnData as Any)
                            print(" json returnData1---> ", self.convertToDictionary2(text: returnData!) as Any)
 
                            let dictionary2: NSDictionary = self.convertToDictionary2(text: returnData!)! as NSDictionary
                            print("dictionary2--->", dictionary2 as Any)
                            
//                            returnDictArray = self.convertToDictionary2(text: returnData!) as! Dictionary<String, String>
//                            print(" json returnDictArray---> ", returnDictArray)
                            
                            
                            
                            completion(dictionary2 )
                            
                            
                            
                            
                            
//                            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//                            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//
//                            dispatch_async(backgroundQueue,
//                                           {
//                                            // run in background
//
//
//                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//                                                // after above code done
//                                                // dismiss loading animation
//
//                                            })
//                            })
                            
                            
                            
                            
                        }
                        task.resume()
                        
                        
                        
                        
                        
                    }
                } catch {
                    print("something went wrong with parsing json")
                }
                
                
                
            }
        } catch {
            print("something went wrong with parsing json")
        }
        
        
//        return ""

    }
    
    
    
    func convertToDictionary(from text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
    }
    
    func convertToDictionary2(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func MD5(_ string: String) -> String? {
        print("encode_sign string",string as Any)

        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    
}
