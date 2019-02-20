//
//  ViewController.m
//  CBDownloaderDemo
//
//  Created by 崔冰smile on 2019/2/20.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "ViewController.h"
#import "CBDownloader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *vProgress;
@property (nonatomic, strong) CBDownloader *downloader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.vProgress.progress = 0;
    self.downloader = [[CBDownloader alloc] init];
}

- (IBAction)download:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg"];

    __weak typeof(self) weakSelf = self;
    [self.downloader downloadFileWithUrl:url Progress:^(float progress) {
        NSLog(@"+++++%@",@(progress));
        [weakSelf.vProgress setProgress:progress animated:YES];
    } Completion:^(NSString *comp) {
        
    } Failed:^(NSString *errmsg) {
        
    }];
}

- (IBAction)pause:(id)sender {
    [self.downloader pause];
}

- (IBAction)continue:(id)sender {
    [self.downloader resume];
}

@end
