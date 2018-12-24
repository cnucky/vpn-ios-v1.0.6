// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Foundation

class WebCommon: NSObject
{
    var signatureKey = "9_s9f7rduMD6WZ6At-?PT^dbW6!9zzhXXtrr"
    
    func VpnDisconnectRequest(UUIDValue: String, URLType: String, token: String , completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()
        
        let encode_sign = getwebServices.MD5("imei=" + UUIDValue +
            "&timestamp=" + CurrentTimestamp +
            "&token=" + token +
            "&" + signatureKey)
        
        
        
        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "token": token,
            "timestamp": CurrentTimestamp
        ]
        
        //        var currentObservation:Dictionary = [:] as Dictionary<String, AnyObject>
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            
            print("VpnConnectRequest serverResponse-->",serverResponse )
            let datatmpDict: NSDictionary = serverResponse
            print("VpnConnectRequest datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )
            
        })
    }
    
    func VpnConnectRequest(UUIDValue: String, URLType: String, token: String , completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()
        
        let encode_sign = getwebServices.MD5("imei=" + UUIDValue +
            "&timestamp=" + CurrentTimestamp +
            "&token=" + token +
            "&" + signatureKey)
        
        
        
        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "token": token,
            "timestamp": CurrentTimestamp
        ]
        
        //        var currentObservation:Dictionary = [:] as Dictionary<String, AnyObject>
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            
            print("VpnConnectRequest serverResponse-->",serverResponse )
            let datatmpDict: NSDictionary = serverResponse
            print("VpnConnectRequest datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )
            
        })
    }
    
    func NodelistRequest(UUIDValue: String, URLType: String, token: String, type: String, completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()
        
        let encode_sign = getwebServices.MD5("imei=" + UUIDValue +
            "&timestamp=" + CurrentTimestamp +
            "&token=" + token +
            "&type=" + type +
            "&" + signatureKey)
        
        
//        let parameters: NSDictionary = [
//            "encode_sign": encode_sign!,
//            "imei": UUIDValue,
//            "timestamp": CurrentTimestamp,
//            "token": token,
//            "type": type
//        ]
        
        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "token": token,
            "type": type,
            "timestamp": CurrentTimestamp
        ]
        
        //        var currentObservation:Dictionary = [:] as Dictionary<String, AnyObject>
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            
            print("NodelistRequest serverResponse-->",serverResponse )
            let datatmpDict: NSDictionary = serverResponse
            print("NodelistRequest datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )
            
        })
    }
    
    func Refresh_TokenRequest(UUIDValue: String, URLType: String, refresh_token: String, completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()
        
        let encode_sign = getwebServices.MD5("imei=" + UUIDValue +
            "&refresh_token=" + refresh_token +
            "&timestamp=" + CurrentTimestamp +
            "&" + signatureKey)

        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "refresh_token": refresh_token,
            "timestamp": CurrentTimestamp
        ]
        
        //        var currentObservation:Dictionary = [:] as Dictionary<String, AnyObject>
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            
            print("Refresh_TokenRequest serverResponse-->",serverResponse )
             let datatmpDict: NSDictionary = serverResponse
            print("Refresh_TokenRequest datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )
            
        })
    }
    
    func RegisterdataRequest(UUIDValue: String, URLType: String, username: String, password: String, repassword: String, completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()
        
//        let encode_sign = getEncodeSign(UUIDValue: UUIDValue, username: username, password: password, CurrentTimestamp: CurrentTimestamp)
        let encode_sign = getwebServices.MD5("imei=" + UUIDValue +
            "&password=" + password +
            "&repassword=" + repassword +
            "&timestamp=" + CurrentTimestamp +
            "&username=" + username +
            "&" + signatureKey)
        
        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "password": password,
            "repassword": repassword,
            "timestamp": CurrentTimestamp,
            "username": username
        ]
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            
            print("serverResponse-->",serverResponse )
            let datatmpDict: NSDictionary = serverResponse
            print("datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )
            
        })
        
    }
    
    func LogindataRequest(UUIDValue: String, URLType: String, username: String, password: String, completion:@escaping (NSDictionary) ->()) {
        
        let getwebServices:webservices = webservices()
        let CurrentTimestamp = getCurrentTimestamp()

//        let encode_sign = getwebServices.MD5("imei=" + UUIDValue + "&password=" + password + "&timestamp=" + CurrentTimestamp + "&username=" + username + "&" + signatureKey)
        let encode_sign = getEncodeSign(UUIDValue: UUIDValue, username: username, password: password, CurrentTimestamp: CurrentTimestamp)

        let parameters: NSDictionary = [
            "encode_sign": encode_sign!,
            "imei": UUIDValue,
            "password": password,
            "timestamp": CurrentTimestamp,
            "username": username
        ]
        
//        var currentObservation:Dictionary = [:] as Dictionary<String, AnyObject>
        
        getwebServices.dataRequest(UUIDValue: UUIDValue, URLType: URLType, parameters: parameters, completion: { serverResponse in
            //            if let observation = serverResponse["code"] as? Dictionary<String, AnyObject> {
            //                currentObservation = observation
            //                print("currentObservation inside of task: \(currentObservation)\n\n")
            //            }

            print("serverResponse-->",serverResponse )
//            let datatmpDict: NSDictionary = (serverResponse["data"] as! NSDictionary)
            let datatmpDict: NSDictionary = serverResponse
            print("datatmpDict msg-->",datatmpDict)
            completion(datatmpDict )

        })
    }
    
    
    
    func getCurrentTimestamp() -> String {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        
        return String(Int(since1970 * 1000))
    }
    
    func getEncodeSign(UUIDValue: String, username: String, password: String, CurrentTimestamp: String) -> String? {
        
        let getwebServices:webservices = webservices()

        let encode_sign = getwebServices.MD5("imei=" + UUIDValue + "&password=" + password + "&timestamp=" + CurrentTimestamp + "&username=" + username + "&" + signatureKey)

        return encode_sign
    }
    
}
