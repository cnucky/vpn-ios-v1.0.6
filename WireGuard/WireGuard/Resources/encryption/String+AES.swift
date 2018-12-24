import Foundation
import CryptoSwift

extension String {
 
//    func aesEncrypt(key: String, iv: String) throws -> String{
//        let data = self.data(using: String.Encoding.utf8)
//        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
//        let encData = NSData(bytes: enc, length: Int(enc.count))
//        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
//        let result = String(base64String)
//        return result
//    }
//
//    func aesDecrypt(key: String, iv: String) throws -> String {
//        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
//        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
//        let decData = NSData(bytes: dec, length: Int(dec.count))
//        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
//        return String(result!)
//    }
}
