//
//  YZDownloadObject.h
//  Pods
//
//  Created by 黄亚州 on 2020/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YZDownloadCell;
@class YZDownloadModel;

/// 下载对象用到的代理
@protocol YZDownloadObjectDelegate <NSObject>

@required
/// 更新有关下载的视图
- (void)updateDownloadView;

@end

/**
 * 文件下载对象，处理文件的下载逻辑，负责和下载器的交互工作
 */
@interface YZDownloadObject : NSObject
/// 下载对象代理
@property (nonatomic, strong, readonly) NSMutableArray <YZDownloadCell *> *yz_allDelegateArrM;
/// 下载数据模型
@property (nonatomic, strong, readonly) YZDownloadModel *yz_downloadModel;
/// 下载、优先、暂停、删除操作时是否需要toast提示
@property (nonatomic, assign, readonly) BOOL yz_toastTip;

/// 初始化下载对象通过下载模型
/// @param downloadModel 下载模型
- (instancetype)initWithDownloadObject:(nullable YZDownloadModel *)downloadModel NS_DESIGNATED_INITIALIZER;

/// 获取文件的下载地址
/// @return 文件的下载地址
- (NSURL *)yz_getFileDownloadedUrl;

/// 将要开启执行下载操作
/// @param now 是否要马上进入下载。如果为YES，则要执行插队操作；如果为NO，则进入正常的下载顺序
- (void)yz_startDownload:(BOOL)now;

/// 将要执行暂停下载操作，并设置是否要改变当前的下载状态
/// @param force 表示该暂停是否是由于一些业务逻辑被迫暂停（非用户手动指定操作，example：被其他的下载对象插队）
/// @param change 是否要改变当前的下载状态（example：退出账号登录时，此时要保留退出登录的下载状态，方便再次登录时及时开启）
- (void)yz_downloadPause:(BOOL)force withChangeDownloadState:(BOOL)change;

/// 将要删除下载操作
- (void)yz_deleteDownload;

/// 添加下载对象代理，如果已存在，则不需要再次添加，一个下载对象可能会在多个界面显示，所以可能存在多个
/// @param delegateCell 将要添加的下载cell
- (void)yz_addDownloadCellDelegate:(YZDownloadCell *)delegateCell;

/// 移除下载对象代理，首先要判断是否存在
/// @param delegateCell 将要移除的下载cell
- (void)yz_removeDownloadCellDelegate:(YZDownloadCell *)delegateCell;

/// 移除下载对象代理，首先要判断是否存在
/// @param cellIdentify 下载cell的标识
- (void)yz_removeDownloadCellDelegateByCellIdentify:(NSString *)cellIdentify;

/// 文件丢失需要重新再下载
- (void)yz_againDownloadForFileLose;

#pragma mark - other downloader

/// 处理其他下载器的初始化数据
- (void)yz_handleOtherDownloaderInitData;

@end

NS_ASSUME_NONNULL_END
