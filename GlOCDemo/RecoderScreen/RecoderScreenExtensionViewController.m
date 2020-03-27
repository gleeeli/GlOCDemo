//
//  RecoderScreenExtensionViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2020/3/27.
//  Copyright © 2020 小柠檬. All rights reserved.
//

#import "RecoderScreenExtensionViewController.h"
#import <ReplayKit/ReplayKit.h>

@interface RecoderScreenExtensionViewController ()<RPBroadcastActivityViewControllerDelegate>
@property(nonatomic,strong) UIButton *recodeBtn;
@property(nonatomic,strong) RPBroadcastActivityViewController* broadcastAVC;
@property(nonatomic,strong) RPBroadcastController *broadcastController;
@end

@implementation RecoderScreenExtensionViewController
{
    RPSystemBroadcastPickerView *_broadPickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _recodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _recodeBtn.tag = 301;
    _recodeBtn.frame =CGRectMake(50, 90, 100, 50);
    [_recodeBtn setTitle:@"方式一 录屏" forState:UIControlStateNormal];
    [_recodeBtn setTitle:@"结束录屏" forState:UIControlStateSelected];
    [_recodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_recodeBtn addTarget:self action:@selector(recoderScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recodeBtn];
    
    UIButton *recode2Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    recode2Btn.tag = 302;
    recode2Btn.enabled = NO;
    recode2Btn.frame =CGRectMake(160, 90, 150, 50);
    [recode2Btn setTitle:@"方式二 录屏,目前无效，" forState:UIControlStateNormal];
    [recode2Btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [recode2Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recode2Btn addTarget:self action:@selector(recoderScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recode2Btn];
    
    UIButton *recode3Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    recode3Btn.tag = 303;
    recode3Btn.frame =CGRectMake(160, 140, 100, 50);
    [recode3Btn setTitle:@"方式三 录屏，只能保存到相册" forState:UIControlStateNormal];
    [recode3Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recode3Btn addTarget:self action:@selector(recoderScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recode3Btn];
}

- (void)recoderScreen:(UIButton *)sender {
    if (_recodeBtn.isSelected) {
        
        __weak typeof(self) weakSelf = self;
        [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
            NSLog(@"结束录制");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.recodeBtn.selected = NO;
            });
        }];
    }else {
        if (sender.tag == 301) {
            [self starRecoderMethod1];
        }else if(sender.tag == 302) {
            [self starRecoderMethod2];
        }else if(sender.tag == 303) {
            [self starRecoderMethod3];
        }
        
    }
    
}


//方式一：启动支持录制的列表sheet，APP内容录屏，可获取码流。若要系统录屏则需要到控制中心 长按录制按钮选择APP
- (void)starRecoderMethod1 {
    NSLog(@"方式一录屏");
    [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
        
        self.broadcastAVC = broadcastActivityViewController;
        self.broadcastAVC.delegate = self;
        [self presentViewController:self.broadcastAVC animated:YES completion:nil];
    }];
}

//方式二：直接录制app内容 跳过sheet界面，这里没法结束 得从extension中结束
- (void)starRecoderMethod2 {
    NSLog(@"方式二录屏");
    if (@available(iOS 11.0, *)) {
        __weak typeof(self) weakSelf = self;
        
//        NSString *sampleIdentifier = @"lengmeng.GlOCDemo1.BroadcastSetupUIExtension";
        NSString *sampleIdentifier = @"lengmeng.GlOCDemo1.BroadcastUploadExtension";
        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithPreferredExtension:sampleIdentifier handler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
            NSLog(@"启动：%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.recodeBtn.selected = YES;
            });
        }];
    } else {
        // Fallback on earlier versions
        NSLog(@"error:系统版本过低");
    }
}

- (void)starRecoderMethod3 {
    NSLog(@"方式三录屏");
    if (@available(iOS 12.0, *)) {
        _broadPickerView = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(20, 190, 80, 80)];
//        _broadPickerView.preferredExtension = @"lengmeng.GlOCDemo1.BroadcastSetupUIExtension";
        [self.view addSubview:_broadPickerView];
    }else {
        NSLog(@"系统版本过低。。。");
    }
}

- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *)broadcastActivityViewController didFinishWithBroadcastController:(nullable RPBroadcastController *)broadcastController error:(nullable NSError *)error {
    NSLog(@"...didFinishWithBroadcastController");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //sheet界面dismiss
           [broadcastActivityViewController dismissViewControllerAnimated:YES completion:nil];
       });
       
    //启动录制
       self.broadcastController = broadcastController;
        __weak typeof(self) weakSelf = self;
       [broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
           NSLog(@"启动录制：startBroadcastWithHandler:%@",error);
           dispatch_async(dispatch_get_main_queue(), ^{
               weakSelf.recodeBtn.selected = YES;
           });
       }];
}
@end
