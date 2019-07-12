//
//  ViewController1.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/9/7.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "ViewController1.h"
#import "TestNavigationView.h"
#import <WebKit/WebKit.h>
#import "YYKit.h"
#import "MCTestModel.h"
#import "TestHsegmentViewController.h"
#import "TestTableViewController.h"
#import "MyManager.h"
#import "TestWkwebViewViewController.h"
#import "TestScrollviewToTableviewViewController.h"
#import "TestRecorderViewController.h"
#import "BomAnimationViewController.h"
#import "FountainViewController.h"
#import "GlFountainLineViewController.h"
#import "TestAnimationViewController.h"
#import "CommLogicViewController.h"
#import "SmallLogicTestViewController.h"
#import "TestShadowViewController.h"
#import <AVKit/AVKit.h>
#import "TestMuattributeLabelViewController.h"

@interface ViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.array = [[NSMutableArray alloc] init];
    [self.array addObject:@"wkwebview"];
    [self.array addObject:@"scrollviewToTableview"];
    [self.array addObject:@"recorder"];
    [self.array addObject:@"bomAnimation"];
    [self.array addObject:@"fountain"];
    [self.array addObject:@"线型喷泉"];
    [self.array addObject:@"animation"];
    [self.array addObject:@"logic"];
    [self.array addObject:@"small logic"];
    [self.array addObject:@"Table view"];
    [self.array addObject:@"Hsegment 选项"];
    [self.array addObject:@"shadow 阴影"];
    [self.array addObject:@"富文本"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    //NSAssert(nil, @"token为空");
    //MCTestModel *model = [MCTestModel modelWithJSON:data];
    
    
//    TestManager1 *testManager = [TestManager1 sharedManager];
//    MyManager *myManager = [MyManager sharedManager];
//
//    NSLog(@"单列名字1:%@",testManager.myName);
//    NSLog(@"单列名字:%@",myManager.myName);
//
//    [testManager method1];
//    [myManager method1];

//    [self getMP3Duartion:nil];
    
    // XXX:有待修正
    UILabel *leftLabel = [[UILabel alloc] init];
    // FIXME:待修正
    leftLabel.textColor = [UIColor redColor];
    // TODO:todo
    leftLabel.textColor = [UIColor redColor];
}


//获取音频时间的时长
-(float)getMP3Duartion:(NSString *)mp3Path
{
    NSURL *url = [NSURL URLWithString:@"http://recitation.lemonread.com/1548034954.371522.mp3"];
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:url options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    NSLog(@"音频时长:%f",audioDurationSeconds);
    return audioDurationSeconds;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    TestNavigationView *testView = [[TestNavigationView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    testView.backgroundColor = [UIColor redColor];
//    testView.intrinsicContentSize = CGSizeMake(width, 44);
//    testView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = testView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    NSString *title = self.array[indexPath.row];
    if ([title isEqualToString:@"wkwebview"]) {
        vc = [[TestWkwebViewViewController alloc] initWithBaseHttpUrlStr:@"https://www.baidu.com/"];
    }
    else if ([title isEqualToString:@"scrollviewToTableview"]) {
        vc = [[TestScrollviewToTableviewViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }else if ([title isEqualToString:@"recorder"]) {
        vc = [[TestRecorderViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"bomAnimation"]) {
        vc = [[BomAnimationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"fountain"]) {
        vc = [[FountainViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"线型喷泉"]) {
        vc = [[GlFountainLineViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"animation"]) {
        vc = [[TestAnimationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"logic"]) {
        vc = [[CommLogicViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"small logic"]) {
        vc = [[SmallLogicTestViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"Table view"]) {
        vc = [[TestTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"Hsegment 选项"]) {
        vc = [[TestHsegmentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"shadow 阴影"]) {
        vc = [[TestShadowViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    else if ([title isEqualToString:@"富文本"]) {
        vc = [[TestMuattributeLabelViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    
    
    //1 2 3 4 5 6
    [self.navigationController pushViewController:vc animated:YES];
}

@end
