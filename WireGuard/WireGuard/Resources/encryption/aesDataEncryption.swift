//// SPDX-License-Identifier: MIT
//// Copyright © 2018 WireGuard LLC. All Rights Reserved.
//
//import Foundation
//import CommonCrypto
//
//extension Data {
////    func encryptedData(withHexKey hexKey: String?, hexIV: String?) -> Data? {
////    }
////
////    func originalData(withHexKey hexKey: String?, hexIV: String?) -> Data? {
////    }
//
//    init(fromHexString string: String?) {
//        var string = string
//        string = string?.lowercased()
//        var data = Data(capacity: (string?.count ?? 0) / 2)
//        var whole_byte: UInt8
//        let byte_chars = ["\0", "\0", "\0"]
//        let i: Int = 0
//        let length: Int = string?.count ?? 0
//        while i < length - 1 {
//            let c = string?[(string?.index((string?.startIndex)!, offsetBy: UInt(i)))!]
//            if (c ?? 0) < "0" || ((c ?? 0) > "9" && (c ?? 0) < "a") || (c ?? 0) > "f" {
//                continue
//            }
//            byte_chars[0] = c ?? 0
//            byte_chars[1] = string?[string?.index(string?.startIndex, offsetBy: UInt(i))] ?? 0
//            i += 1
//            whole_byte = strtol(byte_chars, nil, 16)
//            data?.append(&whole_byte, length: 1)
//        }
//        i += 1
//    }
//
//
//
//func fillDataArray(_ dataPtr: UnsafeMutablePointer<Int8>?, length: Int, usingHexString hexString: String?) {
//    var dataPtr = dataPtr
//    let data = Data(fromHexString: hexString)
//    assert((data.count + 1) == length, "The hex provided didn't decode to match length")
//
//    let total_bytes = UInt((length + 1) * MemoryLayout<Int8>.size)
//
//    dataPtr = malloc(total_bytes)
//    bzero(dataPtr, total_bytes)
//    memcpy(dataPtr, data.bytes, data.count)
//}
//
//func encryptedData(withHexKey hexKey: String?, hexIV: String?) -> Data? {
//    // Fetch key data and put into C string array padded with \0
//    var keyPtr = []
//    fillDataArray(keyPtr, length: kCCKeySizeAES256, usingHexString: hexKey)
//
//    // Fetch iv data and put into C string array padded with \0
//    var ivPtr = []
//    fillDataArray(&ivPtr, length: kCCKeySizeAES128 + 1, usingHexString: hexIV)
//
//
//    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
//    // That's why we need to add the size of one block here
//    var dataLength: Int = length
//    var bufferSize: size_t = dataLength + kCCBlockSizeAES128
//    var buffer = malloc(bufferSize)
//
//    var numBytesEncrypted: size_t = 0
//    var cryptStatus: CCCryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, ivPtr /* initialization vector */, bytes(), length(),  /* input */buffer, bufferSize,  /* output */&numBytesEncrypted)
//    free(keyPtr)
//    free(ivPtr)
//
//    if cryptStatus == kCCSuccess {
//        return Data(bytesNoCopy: &buffer, length: numBytesEncrypted)
//    }
//
//
//
//    free(buffer)
//    return nil
//}
//
//
//
////  Converted to Swift 4 by Swiftify v4.1.6841 - https://objectivec2swift.com/
//func originalData(withHexKey hexKey: String?, hexIV: String?) -> Data? {
//    // Fetch key data and put into C string array padded with \0
//    var keyPtr = []
//    fillDataArray(keyPtr, length: kCCKeySizeAES256 + 1, usingHexString: hexKey)
//
//    // Fetch iv data and put into C string array padded with \0
//    var ivPtr = []
//    fillDataArray(&ivPtr, length: kCCKeySizeAES128 + 1, usingHexString: hexIV)
//
//
//
//    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
//    // That's why we need to add the size of one block here
//
//    var dataLength: Int = length
//    var bufferSize: size_t = dataLength + kCCBlockSizeAES128
//    var buffer = malloc(bufferSize)
//    var numBytesDecrypted: size_t = 0
//    var cryptStatus: CCCryptorStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, ivPtr, bytes(), dataLength,  /* input */buffer, bufferSize,  /* output */&numBytesDecrypted)
//    free(keyPtr)
//    free(ivPtr)
//
//    if cryptStatus == kCCSuccess {
//        // The returned NSData takes ownership of the buffer and will free it on deallocation
//        return Data(bytesNoCopy: &buffer, length: numBytesDecrypted)
//    }
//
//
//    free(buffer)
//    return nil
//}
//
//
//
//}
