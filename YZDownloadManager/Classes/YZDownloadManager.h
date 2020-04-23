//
//  YZDownloadManager.h
//  Pods
//
//  Created by 黄亚州 on 2020/3/23.
//

#import <Foundation/Foundation.h>
#import "YZDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 网络类型
typedef NS_ENUM(NSInteger, YZNetworkType) {
    /// 无网络
    YZNetworkTypeNone = 1 << 0,
    /// 移动网络
    YZNetworkTypeWWAN  = 1 << 1,
    /// WI-FI网络
    YZNetworkTypeWIFI = 1 << 2
};

@class YZDownloadObject;
@class YZDownloadRejectModel;

/**
 * 下载管理的总代理类，用于下载池中下载对象的管理
 */
@interface YZDownloadManager : NSObject

/// 下载池中的下载对象集合
@property (nonatomic, strong, readonly) NSMutableArray <YZDownloadObject *> *yz_allDownloadArrM;
/// 处于下载队列中（未下载完成）的下载对象集合
@property (nonatomic, strong, readonly) NSMutableArray <YZDownloadObject *> *yz_downloadingQueueArrM;

/// 下载管理单例对象
/// @return 单例对象
+ (YZDownloadManager *)sharedManager;

/// 重新读取本地数据库中下载池和未完成下载队列的两个集合的数据
- (void)yz_resetDownloadQueueData;

/// 清理当前用户下的所有下载数据，包括已下载的文件和本地存储的下载信息
- (void)yz_cleanAllDownloadData;

/// 停止当前用户下的可下载（正在下载中、等待下载）的对象。只取消下载操作，不改变下载状态，方便下次复原下载场景
- (void)yz_stopAllDownloadingData;

/// 复原上次app强制退出时的正在下载（正在下载中、等待下载）场景，可用在app重启、切换账号等情况调用该方法
- (void)yz_recoverDownloadingScene;

/// 网络状态变化时对处于下载（正在下载中、等待下载）的影响
/// @param network 变化后的网络状态
- (void)yz_networkChanged:(YZNetworkType)network;

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
     isNeedShowCommonTip:(BOOL)isNeedShowCommonTip;

/// 执行暂停下载操作
/// @param objectArray 下载对象数据的集合
- (void)yz_pauseDownload:(NSMutableArray <YZDownloadObject *>*)objectArray;

/// 执行删除下载对象操作
/// @param objectArray 下载对象数据的集合
- (void)yz_deleteDownload:(NSMutableArray <YZDownloadObject *>*)objectArray;

/// 执行完成下载对象操作
/// @param object 下载对象
- (void)yz_completeDownload:(YZDownloadObject *)object;

#pragma mark - 下载对象的相关方法

/// 通过下载URL获取下载对象，该方法只适用于通过URL执行的下载，如果没有匹配到数据，则返回nil
/// @param url 下载地址
/// @return 下载数据
- (YZDownloadObject *)yz_getDownloadObjectByUrl:(NSString *)url;

/// 根据下载状态获取下载池中的下载对象集合
/// @return 下载完成的下载对象集合
- (NSMutableArray <YZDownloadObject *> *)co_getDownloadObjectArrayByDownloadState:(YZDownloadState)downloadState;

/// 通过缓存的下载文件名称查找下载模型数据
/// @param localName 下载文件名称
- (YZDownloadObject *)yz_getDownloadObjectByDownloadLocalName:(NSString *)localName;

@end

NS_ASSUME_NONNULL_END
