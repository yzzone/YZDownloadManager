//
//  YZDownloadConfig.h
//  Pods
//
//  Created by 黄亚州 on 2020/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 下载管理中用到的相关配置信息
 */
@interface YZDownloadConfig : NSObject
/// 缓存文件夹
@property (nonatomic, strong, nonnull) NSString *yz_cacheFolder;

/// 下载管理配置单例对象
/// @return 单例对象
+ (YZDownloadConfig *)sharedConfig;

@end

NS_ASSUME_NONNULL_END
