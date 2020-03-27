//
//  RecoderScreenViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2020/3/27.
//  Copyright © 2020 小柠檬. All rights reserved.
//

#import "RecoderScreenViewController.h"
#import <ReplayKit/ReplayKit.h>
#import <ReplayKit/RPScreenRecorder.h>
//#import "RPScreenRecoder.h"

@interface RecoderScreenViewController ()<RPPreviewViewControllerDelegate>
@property(nonatomic,strong) UIButton *recodeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,assign) NSInteger index;
@end

@implementation RecoderScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录屏";
    
    self.index = 0;
    
    _recodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _recodeBtn.frame =CGRectMake(50, 300, 100, 50);
    [_recodeBtn setTitle:@"录屏" forState:UIControlStateNormal];
    [_recodeBtn setTitle:@"结束录屏" forState:UIControlStateSelected];
    [_recodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_recodeBtn addTarget:self action:@selector(recoderScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recodeBtn];
    
    //获取Documents目录路径
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSLog(@"document === %@",documentDirectory);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // NSTimer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 360, 100, 50)];
    [self.view addSubview:_label];
}

- (void)timerAction{
    self.index ++;
    self.label.text = [NSString stringWithFormat:@"当前%ld",self.index];
}




- (void)recoderScreen:(id)sender {
    
    if (_recodeBtn.isSelected) {
        [self endRecoder];
    }else {
        [self checkRecoder];
    }
}

- (void)checkRecoder {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([[RPScreenRecorder sharedRecorder] isAvailable]) {
            NSLog(@"正在录制，请勿重复点击");
        } else {
            
            self.recodeBtn.selected = YES;
            [self startRecoder];
        }
    });
}

- (void)startRecoder {
    [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
        if (!error) {
            
            NSLog(@"===启动成功");
        }else {
            NSLog(@"===error:%@",error);
        }
    }];
}

- (void)endRecoder {
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
        NSLog(@"结束录制%@",error);
        if (error) {
            NSLog(@"这里关闭有误%@",error.description);
            
        } else {
            self.recodeBtn.selected = false;
             [previewViewController setPreviewControllerDelegate:self];
            //在结束录屏时显示预览画面
            [self showVideoPreviewController:previewViewController withAnimation:YES];
        }
    }];
}

- (void)showVideoPreviewController:(RPPreviewViewController *)previewController withAnimation:(BOOL)animation {
    if (previewController==nil) {
        NSLog(@"warn:previewController is null");
        return;
    }
    //UI需要放到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:previewController animated:YES completion:nil];
    });
}

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    NSLog(@"previewControllerDidFinish");
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    NSLog(@"didFinishWithActivityTypes:%@",activityTypes);
    [previewController dismissViewControllerAnimated:YES completion:nil];
}
@end
