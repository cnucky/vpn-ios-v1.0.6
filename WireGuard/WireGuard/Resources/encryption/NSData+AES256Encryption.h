// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
 
@interface NSData (AES256Encryption)
- (NSData *)encryptedDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
- (NSData *)originalDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
- (void)runMe;

- (void)encodeAndPrintPlainText:(NSString *)plainText
                    usingHexKey:(NSString *)hexKey
                          hexIV:(NSString *)hexIV;

- (void)decodeAndPrintCipherBase64Data:(NSString *)cipherText
                           usingHexKey:(NSString *)hexKey
                                 hexIV:(NSString *)hexIV;
@end


NS_ASSUME_NONNULL_END
