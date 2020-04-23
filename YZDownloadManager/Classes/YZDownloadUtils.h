//
//  YZDownloadUtils.h
//  Pods
//
//  Created by 黄亚州 on 2020/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZDownloadUtils : NSObject

/// 判断字符串是否为空
/// @param string 字符串
+ (BOOL)yz_stringEmptyOrNull:(NSString *)string;

/// 对下载地址做MD5加密处理成唯一文件名称
/// @param url 文件下载地址
/// @param fileExt 文件扩展名
/// @return MD5加密处理的文件名称
+ (NSString *)yz_encryptionCacheFileNameForURLStr:(NSString *)url withFileExt:(NSString *)fileExt;

/// 计算本地文件大小
/// @param filePath 文件的本地路径
+ (int64_t)yz_computeLocalFileSizeByFilePath:(NSString*)filePath;

@end

NS_ASSUME_NONNULL_END
