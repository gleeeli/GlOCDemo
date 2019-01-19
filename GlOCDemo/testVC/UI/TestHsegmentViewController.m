//
//  TestHsegmentViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/11/9.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "TestHsegmentViewController.h"
#import "HMSegmentedControl.h"

@interface TestHsegmentViewController ()

@end

@implementation TestHsegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"选项卡一",@"选项卡二"]];
    
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
    segmentedControl.selectionIndicatorColor = [UIColor redColor];
    segmentedControl.selectionIndicatorHeight = 2.0;
    segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    segmentedControl.indexChangeBlock = ^(NSInteger index) {
        
    };
    [self.view addSubview:segmentedControl];
    segmentedControl.frame = CGRectMake(0, 0, 320, 50);
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
