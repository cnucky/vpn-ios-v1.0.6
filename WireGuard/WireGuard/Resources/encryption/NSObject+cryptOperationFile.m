// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

#import "NSObject+cryptOperationFile.h"

@implementation NSObject (cryptOperationFile)


- (NSData *) cryptOperation:(CCOperation)operation
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keys[kCCKeySizeAES256 + 1];
    [key getCString:keys maxLength:sizeof(keys) encoding:NSUTF8StringEncoding];
    // Perform PKCS7Padding on the key.
    unsigned long bytes_to_pad = sizeof(keys) - [key length];
    if (bytes_to_pad > 0)
    {
        char byte = bytes_to_pad;
        for (unsigned long i = sizeof(keys) - bytes_to_pad; i < sizeof(keys); i++)
        keys[i] = byte;
    }
    NSUInteger dataLength = [self length];
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus status = CCCrypt(operation, kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keys, kCCKeySizeAES256,
                                     [iv UTF8String],
                                     [self bytes], dataLength, /* input */
                                     buffer, bufferSize, /* output */
                                     &numBytesDecrypted);
    if (status == kCCSuccess)
    {
        //the returned NSData takes ownership of buffer and will free it on dealloc
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256Encrypt
{
    return [self cryptOperation:kCCEncrypt];
}

- (NSData *)AES256Decrypt
{
    return [self cryptOperation:kCCDecrypt];
}


@end
