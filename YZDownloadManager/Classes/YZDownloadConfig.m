//
//  YZDownloadConfig.m
//  Pods
//
//  Created by 黄亚州 on 2020/3/25.
//

#import "YZDownloadConfig.h"
#import "YZDownloadUtils.h"

@implementation YZDownloadConfig

#pragma mark - Init

+ (YZDownloadConfig *)sharedConfig {
    static YZDownloadConfig *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark - Setter & Getter

- (NSString *)yz_cacheFolder {
    if (_yz_cacheFolder == nil || _yz_cacheFolder.length <= 0) {
        return @"YYDownloadFile";
    }
    
    return _yz_cacheFolder;
}

@end
