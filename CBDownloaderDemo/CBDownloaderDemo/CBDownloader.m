//
//  CBDownloader.m
//  CBDownloaderDemo
//
//  Created by 崔冰smile on 2019/2/20.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "CBDownloader.h"

@interface CBDownloader ()<NSURLSessionDownloadDelegate>
@property (nonatomic, copy) void (^progressBlock)(float);
@property (nonatomic, copy) void (^completionBlock)(NSString *);
@property (nonatomic, copy) void (^failedBlock)(NSString *);

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
//续传的数据
@property (nonatomic, strong) NSData *resumeData;
@end

@implementation CBDownloader
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

- (void)pause {
    if (!self.downloadTask) {
        return;
    }
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
        self.downloadTask = nil;
    }];
}

- (void)resume {
    if (!self.resumeData) {
        return;
    }
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    self.resumeData = nil;
    [self.downloadTask resume];
}

- (void)downloadFileWithUrl:(NSURL *)url Progress:(nonnull void (^)(float))progress Completion:(nonnull void (^)(NSString * _Nonnull))completion Failed:(nonnull void (^)(NSString * _Nonnull))failed {
    
    self.progressBlock = progress;
    self.completionBlock = completion;
    self.failedBlock = failed;
    
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}

#pragma mark-delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    if (self.completionBlock) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.completionBlock(@"下载完成");
        }];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    if (self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(progress);
        });
    }
}

//恢复下载调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"+++++%@",@(fileOffset));
}

-(void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"+++++%@",error);
    if (error) {
        if (self.failedBlock) {
            self.failedBlock(error.description);
        }
    }
    
}
@end
