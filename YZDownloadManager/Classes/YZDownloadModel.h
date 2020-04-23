//
//  YZDownloadModel.h
//  Pods
//
//  Created by 黄亚州 on 2020/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 下载节点状态（针对视频、直接打开的PDF等）
typedef NS_ENUM (NSInteger, YZDownloadState) {
    /// 初始化状态。加入下载池中还没执行下载，比如用户不愿意开启流量下载
    YZDownloadStateNo = 1 << 0,
    /// 正在下载中
    YZDownloadStateDownloading = 1 << 1,
    /// 等待下载
    YZDownloadStateWaiting = 1 << 2,
    /// 下载暂停
    YZDownloadStatePaused = 1 << 3,
    /// 下载完成
    YZDownloadStateCompleted = 1 << 4,
    /// 下载中断
    YZDownloadStateInterrupt = 1 << 5
};

/// 文件类型
typedef NS_ENUM(NSInteger, YZFileType) {
    /// Pdf文件
    YZFileTypePdf = 1 << 0,
    /// 视频
    YZFileTypeVideo = 1 << 1
};

/// 属于文件夹类型值
typedef NS_ENUM(NSInteger, YZBelongFolderValue) {
    /// 不属于文件夹
    YZBelongFolderValueNo = 1 << 0,
    /// 属于文件夹
    YZBelongFolderValueYes = 1 << 1
};

/**
 * 下载数据模型，用于记录下载文件的信息
 *
 * 该模型进行下载信息的增、删、改、查操作，通过重写该类可以处理自己项目的数据本地存储。
 *
 */
@interface YZDownloadModel : NSObject

/// 下载文件的标识，用于保障数据模型的唯一性。一般存放文件的ID
@property (nonatomic, strong) NSString *yz_identifier;
/// 下载文件的类型
@property (nonatomic, assign) YZFileType yz_fileType;
/// 当前已下载的文件大小
@property (nonatomic, assign) int64_t yz_currentSize;
/// 文件的总大小
@property (nonatomic, assign) int64_t yz_totalSize;
/// 下载完成的日期时间，格式为时间戳
@property (nonatomic, strong) NSString *yz_completeDate;
/// 下载文件的名称
@property (nonatomic, strong) NSString *yz_fileName;
/// 文件的下载状态
@property (nonatomic, assign) YZDownloadState yz_state;
/// 下载文件的URL，这是一个特别重要的数据。下载对象（YZDownloadObject）的唯一性是通过下载地址判断的
@property (nonatomic, strong) NSString *yz_downloadUrl;
/// 文件的本地存储文件名。通过下载地址MD5加密处理，为了安全行和yz_fileName保持不一致
@property (nonatomic, strong) NSString *yz_localName;
/// 是否是文件夹下的某个文件下载
@property (nonatomic, assign) YZBelongFolderValue yz_belongFolder;
/// 文件夹名称，如果（yz_belongFolder == 0，则为nil）
@property (nonatomic, strong) NSString *yz_folderName;
/// 文件下载的来源，可以区分下载文件的平台
@property (nonatomic, assign) NSInteger yz_source;
/// 文件子类型，用于区分yz_fileType一致时的小类型处理
@property (nonatomic, assign) NSInteger yz_subType;

#pragma mark - 本地数据库相关

/// 从本地存储数据库中获取全部下载模型数据集合
/// @return 下载数据集合
+ (NSMutableArray <YZDownloadModel *> *)yz_getAllLocalDownloadModelArray;

/// 批量添加下载信息到数据库
/// @param modelArray 下载模型集合
+ (void)yz_batchAddDownloadModel2Database:(NSMutableArray <YZDownloadModel *> *)modelArray;

/// 添加模型数据到本地数据库
- (void)yz_addModel2Database;

/// 从数据库删除该模型数据
- (void)yz_deleteModelFromDatabase;

/// 更新model至数据库
- (void)yz_updateModel2Database;

#pragma mark - 下载数据模型相关

/// 获取本地下载文件的完整路径(缓存目录路径+本地MD5文件名称)
/// @return 本地完整路径
- (NSString *)yz_localDownloadFullPath;

/// 获取下载文件缓存目录路径。放在Caches会在设备存储不足时被强制清理，所以建议放在Documents文件夹中，并开启不需要iCloud备份选项
/// @return 缓存目录路径
- (NSString *)yz_localDownloadDirectoryPath;

/// 检测文件是否下载完成
/// @return 是否完成下载
- (BOOL)yz_checkDownloadComplete;

/// 检查文件类型是否是使用了内嵌的下载器（自己写的）中执行的下载
/// @return 是否使用了内嵌下载器被下载
- (BOOL)yz_checkInsideDownloaderCanDownloadFileType;

/// 检测是否属于文件夹中
/// @return 是否属于文件夹中
- (BOOL)yz_checkBelongFolder;

@end

/// 下载被拒绝的原因类型
typedef NS_ENUM(NSInteger, YZDownloadRejectReason) {
    /// 没有问题，可以正常下载
    YZDownloadRejectReasonNo = 1 << 0,
    /// 本次操作没有新的下载对象进入下载池，是对下载池中的对象进行的操作
    YZDownloadRejectReasonNoNewAdd = 1 << 1,
    /// 数据源为空
    YZDownloadRejectReasonEmptyData = 1 << 2,
    /// 下载地址为空
    YZDownloadRejectReasonEmptyURL = 1 << 3,
    /// 下载类型不支持
    YZDownloadRejectReasonNosupported = 1 << 4,
    /// 无网络
    YZDownloadRejectReasonNoNetwork = 1 << 5,
    /// 用户不允许在移动网络下执行下载
    YZDownloadRejectReasonWWANNetwork = 1 << 6
};

/**
 * 下载时被拒绝模型数据，比如：不愿意消耗WWAN网络、URL为空、类型不支持等待原因
 */
@interface YZDownloadRejectModel : NSObject
/// 下载文件的标识
@property (nonatomic, strong) NSString *yz_identifier;
/// 下载文件的类型
@property (nonatomic, assign) YZFileType yz_fileType;
/// 被拒绝原因
@property (nonatomic, assign) YZDownloadRejectReason yz_reason;
/// 下载文件名称
@property (nonatomic, strong) NSString *yz_fileName;

@end

NS_ASSUME_NONNULL_END
