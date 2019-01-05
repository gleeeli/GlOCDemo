//
//  FountainViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/5.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "FountainViewController.h"
#import "FountainView.h"

@interface FountainViewController ()
@property (nonatomic, strong) FountainView *fountainView;
@end

@implementation FountainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 1.0;
    [self.view addSubview:slider];
    
    self.fountainView = [[FountainView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 200 - 150)];
    [self.view addSubview:self.fountainView];
}

- (void)slider:(UISlider *)slider {
    self.fountainView.scale = slider.value;
}
@end
