//
//  CBDownloader.h
//  CBDownloaderDemo
//
//  Created by 崔冰smile on 2019/2/20.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBDownloader : NSObject
//指定下载的URL
- (void)downloadFileWithUrl:(NSURL *)url Progress:(void(^)(float))progress Completion:(void(^)(NSString *))completion Failed:(void(^)(NSString *))failed;
//暂停
- (void)pause;
//继续
- (void)resume;
@end

NS_ASSUME_NONNULL_END
