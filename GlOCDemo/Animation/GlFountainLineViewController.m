//
//  GlFountainLineViewController.m
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "GlFountainLineViewController.h"
#import "GlFountainLineView.h"

@interface GlFountainLineViewController ()
@property (nonatomic, strong) GlFountainLineView *fountain;
@end

@implementation GlFountainLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    slider.minimumValue = 0.0;
    slider.maximumValue = 5.0;
    slider.value = 5.0;
    [self.view addSubview:slider];
    
    self.fountain = [[GlFountainLineView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 150)];
    self.fountain.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.fountain];
}

- (void)slider:(UISlider *)slider {
    self.fountain.velocity = slider.value;
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
