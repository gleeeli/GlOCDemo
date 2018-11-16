//
//  TestAudioViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/10/17.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestAudioViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestAudioViewController ()

@end

@implementation TestAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)testclick:(id)sender {
    [self showOpenPermission];
    if (![self canRecord]) {//开始录音判断是否有麦克风权限
        NSLog(@"error:没有权限,请开启麦克风权限");
        [self showOpenPermission];
        //return;
    }
}

- (void)showOpenPermission{
    AVAudioSession* sharedSession = [AVAudioSession sharedInstance];
    [sharedSession requestRecordPermission:^(BOOL granted) {
        NSLog(@"是否有权限：%d",granted);
    }];
}

//是否有麦克风权限
- (BOOL)canRecord
{
    BOOL bCanRecord = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            bCanRecord = YES;
            break;
        default:
            break;
    }
    return bCanRecord;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
