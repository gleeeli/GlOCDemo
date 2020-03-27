//
//  BroadcastSetupViewController.m
//  BroadcastSetupUIExtension
//
//  Created by gleeeli on 2020/3/27.
//  Copyright © 2020 小柠檬. All rights reserved.
//

#import "BroadcastSetupViewController.h"
@interface BroadcastSetupViewController ()

@property (nonatomic, strong) UILabel *label;
@property(nonatomic,strong) UIButton *recodeBtn;

@end
@implementation BroadcastSetupViewController

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {
    
    // URL of the resource where broadcast can be viewed that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString:@"http://apple.com/broadcast/streamID"];
    
    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    NSDictionary *setupInfo = @{ @"broadcastName" : @"example" };
    
    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"YourAppDomain" code:-1 userInfo:nil]];
}

- (void)viewDidLoad
{
    NSLog(@"进入：Setup UI Extension viewDidLoad");
    self.view.backgroundColor = [UIColor greenColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 360, 100, 50)];
    self.label.text = @"自定义UI空间";
    [self.view addSubview:_label];
    
    _recodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _recodeBtn.frame =CGRectMake(50, 300, 100, 50);
    [_recodeBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_recodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_recodeBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recodeBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)nextBtn:(id)sender {
    [self userDidFinishSetup];
}

@end
