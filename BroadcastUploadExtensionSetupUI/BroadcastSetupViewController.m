//
//  BroadcastSetupViewController.m
//  BroadcastUploadExtensionSetupUI
//
//  Created by gleeeli on 2020/3/27.
//  Copyright © 2020 小柠檬. All rights reserved.
//

#import "BroadcastSetupViewController.h"


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
    NSLog(@"进入：upload Extension viewDidLoad");
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *recodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    recodeBtn.frame =CGRectMake(50, 300, 100, 50);
    [recodeBtn setTitle:@"下一步 Upload" forState:UIControlStateNormal];
    [recodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recodeBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recodeBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)nextBtn:(id)sender {
    [self userDidFinishSetup];
}
@end
