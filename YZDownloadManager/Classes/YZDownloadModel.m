//
//  YZDownloadModel.m
//  Pods
//
//  Created by 黄亚州 on 2020/3/24.
//

#import "YZDownloadModel.h"
#import "YZDownloadUtils.h"
#import "YZDownloadConfig.h"

@interface YZDownloadModel ()

@end

@implementation YZDownloadModel

#pragma mark - Private

#pragma mark - 本地数据库相关

+ (NSMutableArray <YZDownloadModel *> *)yz_getAllLocalDownloadModelArray {
    NSString *assertDesc = [NSString stringWithFormat:@"请重写:%s,否则无法获取到本地下载文件信息", __FUNCTION__];
    NSAssert(NO, assertDesc);
    return nil;
}

+ (void)yz_batchAddDownloadModel2Database:(NSMutableArray <YZDownloadModel *> *)modelArray {
    NSString *assertDesc = [NSString stringWithFormat:@"请重写:%s,否则无法批量添加下载文件信息到本地数据", __FUNCTION__];
    NSAssert(NO, assertDesc);
}

- (void)yz_addModel2Database {
    NSString *assertDesc = [NSString stringWithFormat:@"请重写:%s,否则无法添加下载文件信息到本地数据", __FUNCTION__];
    NSAssert(NO, assertDesc);
}

- (void)yz_deleteModelFromDatabase {
    NSString *assertDesc = [NSString stringWithFormat:@"请重写:%s,否则无法删除本地数据库中的下载文件信息", __FUNCTION__];
    NSAssert(NO, assertDesc);
}

- (void)yz_updateModel2Database {
    NSString *assertDesc = [NSString stringWithFormat:@"请重写:%s,否则无法更新本地数据库中的下载文件信息", __FUNCTION__];
    NSAssert(NO, assertDesc);
}

#pragma mark - 下载数据模型相关

- (NSString *)yz_localDownloadFullPath {
    if ([YZDownloadUtils yz_stringEmptyOrNull:self.yz_localName]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@/%@", [self yz_localDownloadDirectoryPath], self.yz_localName];
}

- (NSString *)yz_localDownloadDirectoryPath {
    // 缓存目录路径
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", [YZDownloadConfig sharedConfig].yz_cacheFolder]];
    
    // 目录路径是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSError * __autoreleasing error = nil;
        NSURL *fileUrl= [NSURL fileURLWithPath:cacheDir];
        // 不开启iCloud备份选项
        BOOL success = [fileUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(NO == success) {
            NSString *assertDesc = [NSString stringWithFormat:@"Error excluding %@ from backup %@", [fileUrl lastPathComponent], error];
            NSAssert(success, assertDesc);
        }
    }
    
    return cacheDir;
}

- (BOOL)yz_checkDownloadComplete {
    if ([self yz_checkInsideDownloaderCanDownloadFileType] == YES) {
        if (self.yz_state == YZDownloadStateCompleted &&
            [[NSFileManager defaultManager] fileExistsAtPath:[self yz_localDownloadFullPath]]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)yz_checkInsideDownloaderCanDownloadFileType {
    if (self.yz_fileType == YZFileTypePdf ||
        self.yz_fileType == YZFileTypeVideo) {
        return YES;
    }
    
    return NO;
}


- (BOOL)yz_checkBelongFolder {
    if (self.yz_belongFolder == YZBelongFolderValueYes && [YZDownloadUtils yz_stringEmptyOrNull:self.yz_folderName] == NO) {
        return YES;
    }
    
    return NO;
}

@end

@implementation YZDownloadRejectModel

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _yz_identifier = @"";
        _yz_fileType = NSNotFound;
    }
    return self;
}

#pragma mark - Private Methods

- (NSString *)yz_downloadReasonDescStr {
    NSString *reasonDesc = @"原因未知";
    switch (self.yz_reason) {
        case YZDownloadRejectReasonNoNewAdd:
            reasonDesc = @"本次操作没有新加入的下载对象";
            break;
        case YZDownloadRejectReasonEmptyData:
            reasonDesc = @"数据源为空";
            break;
        case YZDownloadRejectReasonEmptyURL:
            reasonDesc = @"下载地址为空";
            break;
        case YZDownloadRejectReasonNosupported:
            reasonDesc = @"下载类型目前不支持";
            break;
        case YZDownloadRejectReasonNoNetwork:
            reasonDesc = @"暂无网络，请检查网络设置";
            break;
        case YZDownloadRejectReasonWWANNetwork:
            reasonDesc = @"用户不允许消耗流量";
            break;
        default:
            break;
    }
    
    return reasonDesc;
}

#pragma mark - Setter & Getter

- (NSString *)description {
    if ([YZDownloadUtils yz_stringEmptyOrNull:self.yz_fileName] == YES) {
        return [self yz_downloadReasonDescStr];
    }
    
    return [NSString stringWithFormat:@"【%@】不能下载，原因：%@", self.yz_fileName, [self yz_downloadReasonDescStr]];
}

@end
