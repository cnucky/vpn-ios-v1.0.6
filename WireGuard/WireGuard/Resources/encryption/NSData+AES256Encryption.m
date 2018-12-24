// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

#import "NSData+AES256Encryption.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//@interface NSData (AES256Encryption)
//- (NSData *)encryptedDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
//- (NSData *)originalDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
//@end

@implementation NSData (AES256Encryption)



+ (NSData *)dataFromHexString:(NSString *)string
{
    string = string.lowercaseString;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:string.length/2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSUInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
        continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (void)fillDataArray:(char **)dataPtr length:(NSUInteger)length usingHexString:(NSString *)hexString
{
    NSData *data = [NSData dataFromHexString:hexString];
    NSLog(@"Decrypted Result: %@", data);

    NSAssert((data.length) == length, @"The hex provided didn't decode to match length");
    
    unsigned long total_bytes = (length) * sizeof(char);
    
    *dataPtr = malloc(total_bytes);
    bzero(*dataPtr, total_bytes);
    memcpy(*dataPtr, data.bytes, data.length);
}


- (NSData *)encryptedDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
//    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexString:hexKey];
//    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256 usingHexString:hexKey];
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES128 usingHexString:hexKey];

    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
//    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexString:hexIV];
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128 usingHexString:hexIV];

    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr /* initialization vector */,
                                          [self bytes], [self length], /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    free(keyPtr);
    free(ivPtr);
    
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}


- (NSData *)originalDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
//    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexString:hexKey];
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES128 usingHexString:hexKey];

    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
//    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexString:hexIV];
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128 usingHexString:hexIV];

    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
//                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    free(keyPtr);
    free(ivPtr);
    
    if( cryptStatus == kCCSuccess )
    {
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}


- (void)decodeAndPrintCipherBase64Data:(NSString *)cipherText
                           usingHexKey:(NSString *)hexKey
                                 hexIV:(NSString *)hexIV
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    NSAssert(data != nil, @"Couldn't base64 decode cipher text");
    
    NSData *decryptedPayload = [data originalDataWithHexKey:hexKey
                                                      hexIV:hexIV];
    
    if (decryptedPayload) {
        NSString *plainText = [[NSString alloc] initWithData:decryptedPayload encoding:NSUTF8StringEncoding];
        NSLog(@"Decrypted Result: %@", plainText);
    }
}

- (void)encodeAndPrintPlainText:(NSString *)plainText
                    usingHexKey:(NSString *)hexKey
                          hexIV:(NSString *)hexIV
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptedPayload = [data encryptedDataWithHexKey:hexKey
                                                       hexIV:hexIV];
    
    if (encryptedPayload) {
        NSString *cipherText = [encryptedPayload base64EncodedStringWithOptions:0];
        NSLog(@"Encryped Result: %@", cipherText);
    }
}



//------------
- (void)runMe
{
    NSString *hexKey = @"2034F6E32958647FDFF75D265B455EBF40C80E6D597092B3A802B3E5863F878C";
    NSString *cipherText = nil;
    NSString *hexIV = nil;
    
    cipherText = @"9/0FGE21YYBl8NvlCp1Ft8j1V7BiIpCIlNa/zbYwL5LWyemd/7QEu0tkVz9/f0JG";
    hexIV = @"AD0ACC568C88C116D57B273D98FB92C0";
    [self decodeAndPrintCipherBase64Data:cipherText usingHexKey:hexKey hexIV:hexIV];
    
    cipherText = @"S6flMkdMeC77p/7pokXZkHT0is7Lp57Zgkokg/O99puZloTB/ZUzp0FwH8sWFekg";
    hexIV = @"0F0AFF0F0AFF0F0AFF0F0AFF0F0AFF00";
    [self decodeAndPrintCipherBase64Data:cipherText usingHexKey:hexKey hexIV:hexIV];
    
    NSString *plainText = @"Thank you Mr Warrender, Reinforcements have arrived! Send biscuits";
    hexIV = @"010932650CDD998833CC0AFF9AFF00FF";
    [self encodeAndPrintPlainText:plainText usingHexKey:hexKey hexIV:hexIV];
}


@end
