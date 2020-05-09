//
//  YZDownloadObject.m
//  Pods
//
//  Created by 黄亚州 on 2020/3/24.
//

#import "YZDownloadObject.h"
#import "YZDownloadModel.h"
#import "YZDownloadCell.h"
#import "YZDownloadUtils.h"
#import "YZDownloadManager.h"

@implementation YZDownloadObject

#pragma mark - Init

- (instancetype)init {
    return [self initWithDownloadObject:nil];
}

- (instancetype)initWithDownloadObject:(nullable YZDownloadModel *)downloadModel {
    if (self = [super init]) {
        _yz_downloadModel = downloadModel;
        _yz_toastTip = YES;
        
        // 扩展下载类型时，记得在这里实现具体的【初始化下载对象时】处理逻辑
        if ([downloadModel yz_checkInsideDownloaderCanDownloadFileType] == YES) {
            // 本地下载文件名未存在时，一般是新生成的下载对象
            if ([YZDownloadUtils yz_stringEmptyOrNull:downloadModel.yz_localName] == YES) {
                //pdf文件后缀和视频文件后缀区分
                downloadModel.yz_localName = [YZDownloadUtils yz_encryptionCacheFileNameForURLStr:downloadModel.yz_downloadUrl withFileExt:(downloadModel.yz_fileType == YZFileTypePdf ? @"pdf" : @"dat")];
            }
            
            int64_t currentSize = [YZDownloadUtils yz_computeLocalFileSizeByFilePath:[downloadModel
            yz_localDownloadFullPath]];
            
            // 已下载的文件大小不一致，更新
            if (downloadModel.yz_currentSize != currentSize) {
                downloadModel.yz_currentSize = currentSize;
                [downloadModel yz_updateModel2Database]; // 更新数据库数据
            }
        } else {
            [self yz_handleOtherDownloaderInitData];
        }
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSURL *)yz_getFileDownloadedUrl {
    if (self.yz_downloadModel == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[self.yz_downloadModel yz_localDownloadFullPath]];
    return url;
}

- (void)yz_startDownload:(BOOL)now {
    // 前一个下载节点状态
    YZDownloadState preState = self.yz_downloadModel.yz_state;
    if (now == YES) {
        // 如果已经下载完成，对下载池中的数据没有任何影响
        if (self.yz_downloadModel.yz_state == YZDownloadStateCompleted) {
            return;
        }
        
        // 发现本地的文件已经缓存完成，但由于某种原因没有更新下载状态
        if (self.yz_downloadModel.yz_currentSize >= self.yz_downloadModel.yz_totalSize) {
            [[YZDownloadManager sharedManager] yz_completeDownload:self];
        } else {
            self.yz_downloadModel.yz_state = YZDownloadStateDownloading;
        }
    } else {
        self.yz_downloadModel.yz_state = YZDownloadStateWaiting;
    }
    
    [self.yz_downloadModel yz_updateModel2Database]; // 更新数据库数据
    if (self.yz_downloadModel.yz_state == YZDownloadStateDownloading && preState != YZDownloadStateDownloading) {
        // 开启下载
        [self processInsideDownloaderWork:self.yz_downloadModel.yz_downloadUrl
                        downloadLocalPath:[self.yz_downloadModel yz_localDownloadFullPath]
                            downloadState:self.yz_downloadModel.yz_state];
        // 抛出更新UI下载信息
        for (id<YZDownloadObjectDelegate> delegate in self.yz_allDelegateArrM) {
            if ([delegate respondsToSelector:@selector(updateDownloadView)]) {
                [delegate updateDownloadView];
            }
        }
    }
}

- (void)yz_downloadPause:(BOOL)force withChangeDownloadState:(BOOL)change {
    
}

- (void)yz_deleteDownload {
    
}

- (void)yz_addDownloadCellDelegate:(YZDownloadCell *)delegateCell {
    
}

- (void)yz_removeDownloadCellDelegate:(YZDownloadCell *)delegateCell {
    
}

- (void)yz_removeDownloadCellDelegateByCellIdentify:(NSString *)cellIdentify {
    
}

- (void)yz_againDownloadForFileLose {
    
}

#pragma mark - other downloader

- (void)yz_handleOtherDownloaderInitData {
    
}

#pragma mark - Private Methods

/// 根据下载URL和下载状态推动下载器开始工作
/// @param dowloadUrl 下载地址
/// @param localPath 本地缓存路径
/// @param state 下载对象所处于的下载状态
- (void)processInsideDownloaderWork:(NSString *)dowloadUrl
                  downloadLocalPath:(NSString *)localPath
                      downloadState:(YZDownloadState)state {
    switch (state) {
        case YZDownloadStateDownloading: { // 开启下载工作
            // 扩展下载类型时，记得在这里实现具体的【下载】处理逻辑
            if ([self.yz_downloadModel yz_checkInsideDownloaderCanDownloadFileType] == YES) {
                [self startBreakPointDownloadURL:dowloadUrl withLocalPath:localPath];
            } else {
#warning 扩展其他平台的下载器
            }
        }
            break;
        case YZDownloadStateWaiting:
        case YZDownloadStatePaused: { // 等待、暂定状态 需要取消下载任务
            // 扩展下载类型时，记得在这里实现具体的【暂停下载】处理逻辑
            if ([self.yz_downloadModel yz_checkInsideDownloaderCanDownloadFileType] == YES) {
                if ([YZDownloadUtils yz_stringEmptyOrNull:dowloadUrl] == NO) {
                   
                }
            } else {
                #warning 扩展其他平台的下载器
            }
        }
            break;
        // 以下状态暂不需要处理
        case YZDownloadStateCompleted:
        case YZDownloadStateNo:
        case YZDownloadStateInterrupt:
        default:
            break;
    }
}

/// 开启断点续传下载
/// @param url 下载地址
/// @param localPath 本地缓存路径
- (void)startBreakPointDownloadURL:(NSString *)url withLocalPath:(NSString *)localPath {
    // 必要条件不可为空
    if ([YZDownloadUtils yz_stringEmptyOrNull:url] == YES) {
        NSParameterAssert(url);
        return;
    }
    
    if ([YZDownloadUtils yz_stringEmptyOrNull:localPath] == YES) {
        NSParameterAssert(localPath);
        return;
    }
}

@end
