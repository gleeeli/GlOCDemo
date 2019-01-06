//
//  TestAutoScorllviewViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/10/29.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "TestAutoScorllviewViewController.h"
#import "GlBaseAutoLayoutScrollview.h"

@interface TestAutoScorllviewViewController ()

@end

@implementation TestAutoScorllviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    GlBaseAutoLayoutScrollview *scrollview = [[GlBaseAutoLayoutScrollview alloc] initWithType:GlAutoScrollViewVertical];
    GlBaseAutoLayoutScrollview *scrollview = [[GlBaseAutoLayoutScrollview alloc] init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        make.leading.top.bottom.trailing.equalTo(self.view);
    }];
    
    scrollview.scrollType = GlAutoScrollViewVertical;
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor grayColor];
    [scrollview.contentView  addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    [scrollview.contentView  addSubview:view2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(scrollview.contentView);
        make.height.mas_equalTo(500);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom);
        make.leading.trailing.equalTo(scrollview.contentView);
        make.height.mas_equalTo(500);
        
        make.bottom.equalTo(scrollview.contentView).offset(-100);
    }];
    
    
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
