//
//  YZDownloadUtils.m
//  Pods
//
//  Created by 黄亚州 on 2020/3/25.
//

#import "YZDownloadUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation YZDownloadUtils

+ (BOOL)yz_stringEmptyOrNull:(NSString *)string {
    if (string == nil) { // nil object
        return YES;
    }
    
    if ([string isEqual:[NSNull null]] == YES) { // nsnull object
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] == NO) { // class fault
        return NO;
    }
    
    NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimedString.length <= 0) { // empty string
        return YES;
    }
    
    if ([trimedString isEqualToString:@"null"] == YES ||
        [trimedString isEqualToString:@"(null)"] == YES ||
        [trimedString isEqualToString:@"<null>"] == YES) { // is neither empty nor null
        return YES;
    }
    
    return NO;
}


+ (NSString *)yz_encryptionCacheFileNameForURLStr:(NSString *)url withFileExt:(NSString *)fileExt {
    const char *str = url.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:url];
    NSString *ext = (fileExt != nil && fileExt.length > 0) ? fileExt : (keyURL ? keyURL.pathExtension : url.pathExtension);
    // File system has file name length limit, we need to check if ext is too long, we don't add it to the filename
    if (ext.length > (NAME_MAX - CC_MD5_DIGEST_LENGTH * 2 - 1)) {
        ext = nil;
    }
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
    return filename;
}

+ (int64_t)yz_computeLocalFileSizeByFilePath:(NSString*)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    // 如果本地文件不存在
    if ([manager fileExistsAtPath:filePath] == NO) {
        return 0;
    }
    
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
}

@end
