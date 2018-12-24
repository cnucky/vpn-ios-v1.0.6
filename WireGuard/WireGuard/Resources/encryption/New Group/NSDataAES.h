// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

#import <Foundation/Foundation.h>
//#import "webService.h"

@interface NSDataAES: NSData

//加密
//- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

-(void)runme;
-(void)runme2;

- (NSString *)encryptWithText:(NSString *)sText initRandomIv:(NSString *)RandomIv;//加密
- (NSString *)decryptWithText:(NSString *)sText initRandomIv:(NSString *)RandomIv;//解密
//-(NSString *)runEncode:(NSString *)strData;
//-(NSString *)runDEcode:(NSString *)strData;



@end

