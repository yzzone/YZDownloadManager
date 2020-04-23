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

/// 执行开始下载操作，可以指定是否执行优先下载
/// @param objectArray 下载对象数据的集合
/// @param block 下载被拒绝原因回调，rejectArray 回调中被拒原因数组
/// @param rejectArray 附加下载被拒原因数组，主要是生成下载时由于某些原因（下载URL为空、类型不支持等）造成的，和block回调中的rejectArray合并返回
/// @param isPriority 是否是要执行优先下载
/// @param isNeedShowCommonTip 是否需要展示公共toast提示
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

/// 通过下载URL获取下载对象，该方法只适用于通过URL执行的下载，如果没有匹配到数据，则返回nil
/// @param url 下载地址
/// @return 下载数据
- (YZDownloadObject *)yz_getDownloadObjectByUrl:(NSString *)url {
    return nil;
}

/// 根据下载状态获取下载池中的下载对象集合
/// @return 下载完成的下载对象集合
- (NSMutableArray <YZDownloadObject *> *)co_getDownloadObjectArrayByDownloadState:(YZDownloadState)downloadState {
    return nil;
}

/// 通过缓存的下载文件名称查找下载模型数据
/// @param localName 下载文件名称
- (YZDownloadObject *)yz_getDownloadObjectByDownloadLocalName:(NSString *)localName {
    return nil;
}

#pragma mark - Private Methods

/// 推动下载队列继续前进
- (void)yz_processDownloadQueue {
    
}

@end
