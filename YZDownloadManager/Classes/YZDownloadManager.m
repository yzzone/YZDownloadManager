//
//  YZDownloadManager.m
//  Pods
//
//  Created by 黄亚州 on 2020/3/23.
//

#import "YZDownloadManager.h"
#import "YZDownloadObject.h"

#import <pthread/pthread.h>

/// 申请互斥锁--宏定义
#define YZ_Lock() pthread_mutex_lock(&_lock)
/// 释放互斥锁--宏定义
#define YZ_Unlock() pthread_mutex_unlock(&_lock)

@interface YZDownloadManager ()

@end

@implementation YZDownloadManager {
    /// 互斥锁
    pthread_mutex_t _lock;
}

+ (YZDownloadManager *)sharedManager {
    static YZDownloadManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        // 以动态方式创建互斥锁
        pthread_mutex_init(&_lock, NULL);
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)yz_resetDownloadQueueData {
    
}

- (void)yz_cleanAllDownloadData {
    
}

- (void)yz_stopAllDownloadingData {
    
}

- (void)yz_recoverDownloadingScene {
    
}

- (void)yz_networkChanged:(YZNetworkType)network {
    
}

#pragma mark - 下载操作相关方法

- (void)yz_startDownload:(NSMutableArray <YZDownloadObject *> *)objectArray
     downloadRejectBlock:(nullable void (^)(NSMutableArray <YZDownloadRejectModel *> * _Nullable rejectArray))block
        subjoinRejectionArray:(nullable NSMutableArray *)rejectArray
    withPriorityDownload:(BOOL)isPriority
     isNeedShowCommonTip:(BOOL)isNeedShowCommonTip {
    
}

- (void)yz_pauseDownload:(NSMutableArray <YZDownloadObject *>*)objectArray {
    
}

- (void)yz_deleteDownload:(NSMutableArray <YZDownloadObject *>*)objectArray {
    
}

- (void)yz_completeDownload:(YZDownloadObject *)object {
    if (object.yz_downloadModel != nil && [object.yz_downloadModel yz_checkDownloadComplete] == YES) {
        object.yz_downloadModel.yz_state = YZDownloadStateCompleted;
        object.yz_downloadModel.yz_completeDate = [NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970]];
//        [self.completeDownloads addObject:object.downloadModel];
        // 下载完成从【未完成下载队列】中移除
        [self.yz_downloadingQueueArrM removeObject:object];
    }
    // 推动下载队进程
    [self yz_processDownloadQueue];
}

#pragma mark - 下载对象的相关方法

- (YZDownloadObject *)yz_getDownloadObjectByUrl:(NSString *)url {
    return nil;
}

- (NSMutableArray <YZDownloadObject *> *)co_getDownloadObjectArrayByDownloadState:(YZDownloadState)downloadState {
    return nil;
}

- (YZDownloadObject *)yz_getDownloadObjectByDownloadLocalName:(NSString *)localName {
    return nil;
}

#pragma mark - Private Methods

/// 推动下载队列继续前进
- (void)yz_processDownloadQueue {
    
}

@end
