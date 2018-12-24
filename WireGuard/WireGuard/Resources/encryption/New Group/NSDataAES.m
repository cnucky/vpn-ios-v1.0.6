// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

#import "NSDataAES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation NSDataAES

//加密
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128operation:kCCEncrypt key:key iv:iv];
}


//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128operation:kCCDecrypt key:key iv:iv];
}

- (NSData *)AES128operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [self length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [self bytes], [self length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess){
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    }else{
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}


-(void)runme
{
//    NSString *aesKey = @"!eRT8&^&-v+t-z2vC2fX9p^u2pDCV_Qc";
//    NSString *aesIV = @"MLRzB6w+wY099983";
////    NSString *str = @"0000000000000000";
//    NSString *str = @"{\"encode_sign\":\"9fa57415583936d25bf8c2a3703aed81\",\"password\":\"123456\",\"timestamp\":\"1545041204983\",\"username\":\"zxc123\"}";
//
//
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    //加密
//    data = [data AES128EncryptWithKey:aesKey iv:aesIV];
//    data = [GTMBase64 encodeData:data];
//
//    NSString *encodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    NSLog(@"encodeStr--->%@",encodeStr);
//
//
//
//    NSString *strdecryp = @"OD3+MZ2BBk9BWiEuQERUxUgLx9PLvS+OXGiIkxeFrnB9L9aAhGve3VmWFllq9D/ugEtQdS+AT3aLnXPLeO9PnXbYPtopH91vlpQ6eT/9mmM4CtlvxqthrRNGiVotXlAu7UPyFmFeJtG7Zw0QzPaD7uNTFbtEUIIFe2s9nnUMiUFx13CjNPB1Gsm+AFbWjkM1r01PNlXidx1XKHGjoymItA==";
//
//
//    NSData *datadecryp = [strdecryp dataUsingEncoding:NSUTF8StringEncoding];
//    //加密
//    datadecryp = [datadecryp AES128DecryptWithKey:aesKey iv:aesIV];
//    datadecryp = [GTMBase64 decodeData:datadecryp];
//
//    NSString *dencodeStr = [[NSString alloc] initWithData:datadecryp encoding:NSUTF8StringEncoding];
//
//    NSLog(@"dencodeStr--->%@",dencodeStr);
    
    
}

-(void)runme2
{
    NSString *str = @"{\"encode_sign\":\"9fa57415583936d25bf8c2a3703aed81\",\"password\":\"123456\",\"timestamp\":\"1545041204983\",\"username\":\"zxc123\"}";
    
    NSString *strdecryp = @"oIy+QQDJ5xwKwawnRuw2PUU\/ZZYwwnSr1Uv4XmiudAInzfBXQ5gzvppZkcaIyVe8";
    
    
    NSString *encrypt = [self encryptWithText:str initRandomIv:@"VR5BhQ"];
    NSLog(@"enctry = %@",encrypt);
    NSString *decrypt = [self decryptWithText:strdecryp initRandomIv:@"VR5BhQ"];
    NSLog(@"decrypt = %@",decrypt);
    
}

-(NSString *)runEncode:(NSString *)strData
{
    NSString *str = @"{\"encode_sign\":\"9fa57415583936d25bf8c2a3703aed81\",\"password\":\"123456\",\"timestamp\":\"1545041204983\",\"username\":\"zxc123\"}";
    
    NSString *strdecryp = @"oIy+QQDJ5xwKwawnRuw2PUU\/ZZYwwnSr1Uv4XmiudAInzfBXQ5gzvppZkcaIyVe8";
    
    
    NSString *encrypt = [self encryptWithText:strData initRandomIv:@"VR5BhQ"];
    NSLog(@"enctry = %@",encrypt);
//    NSString *decrypt = [NSData decryptWithText:strdecryp];
//    NSLog(@"decrypt = %@",decrypt);
    
    return encrypt;
}

-(NSString *)runDEcode:(NSString *)strData
{
    NSString *str = @"{\"encode_sign\":\"9fa57415583936d25bf8c2a3703aed81\",\"password\":\"123456\",\"timestamp\":\"1545041204983\",\"username\":\"zxc123\"}";
    
    NSString *strdecryp = @"oIy+QQDJ5xwKwawnRuw2PUU\/ZZYwwnSr1Uv4XmiudAInzfBXQ5gzvppZkcaIyVe8";
    
    
//    NSString *encrypt = [NSData encryptWithText:str];
//    NSLog(@"enctry = %@",encrypt);
    NSString *decrypt = [self decryptWithText:strData initRandomIv:@"VR5BhQ"];
    NSLog(@"decrypt = %@",decrypt);
    
    return decrypt;
}


//----------------------
- (NSString *)encryptWithText:(NSString *)sText initRandomIv:(NSString *)RandomIv
{
    //kCCEncrypt 加密
//    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"des"];
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"!eRT8&^&-v+t-z2vC2fX9p^u2pDCV_Qc" initRandomIv:RandomIv];
}

- (NSString *)decryptWithText:(NSString *)sText initRandomIv:(NSString *)RandomIv
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"!eRT8&^&-v+t-z2vC2fX9p^u2pDCV_Qc" initRandomIv:RandomIv];
}

- (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key initRandomIv:(NSString *)RandomIv
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
 
//    NSString *initRandomIv = @"VR5BhQ";
//    NSString *initIv = @"MLRzB6w+wY" + initRandomIv;
    NSString *initIv = [NSString stringWithFormat:@"MLRzB6w+wY%@",RandomIv];
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmAES128,//  加密根据哪个标准（des，3des，aes。。。。）
//                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeAES256,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}
@end
