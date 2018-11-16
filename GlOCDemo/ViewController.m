//
//  ViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/8/2.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "ViewController.h"
//#import ""
#import <SDAutoLayout/SDAutoLayout.h>
//#import <AAChartKit/AAChartKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AAChartKit.h"

//#import <AAChartKit/AAChartView.h>
////#import "AAGlobalMacro.h"
//#import <AAChartKit/AAGlobalMacro.h>
//#import <AAChartKit/AAChart.h>
//#import <AAChartKit/AATooltip.h>
//#import <AAChartKit/AALegend.h>
//#import <AAChartKit/AATitle.h>
//#import <AAChartKit/AASubtitle.h>
//#import <AAChartKit/AAYAxis.h>
//#import <AAChartKit/AAXAxis.h>
//#import <AAChartKit/AALabels.h>
//#import <AAChartKit/AAMarker.h>
//#import <AAChartKit/AASeries.h>
#import "BaseAutoLayoutScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<AAChartViewDidFinishLoadDelegate>
@property(nonatomic, strong) AAChartView *aaChartView;

//@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *atView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSLog(@"array :%@",array);
//

//
    
    
//    [self initBaseView];
//    [self testScrollView];
//    [self testStackView];
//    [self testbounds];
    
//    [self testAutoLayout];
    
//    [self testZhexian];
    
    [self testAnimationView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.atView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:nil];
}

- (void)testAnimationView{
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 100, 100)];
    testView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:testView];
    
    UIView *atView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.atView = atView;
    atView.backgroundColor = [UIColor orangeColor];
    [testView addSubview:atView];
    
    self.atView.layer.anchorPoint = CGPointMake(0,0);
    self.atView.layer.position = CGPointMake(0,0);
    
    CGFloat x = CGRectGetMaxX(testView.frame);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 64, 100, 50)];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:btn];
}

- (void)testClick:(id)btn{
    [UIView animateWithDuration:5.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.atView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)testAutoLayout
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    [self.view addSubview:label];
    label.sd_layout
    .leftSpaceToView(self.view, 10)
//    .rightSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10)
    .autoWidthRatio(0)
    .autoHeightRatio(0);
    
    [label setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 20];
    
    
//    UIView *cenView = [[UIView alloc] init];
//    cenView.alpha = 0.3;
//    cenView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:cenView];
//    cenView.sd_layout
//    .centerXEqualToView(self.view)
//    .centerYEqualToView(self.view)
//    .widthIs(100)
//    .autoHeightRatio(0);
//
//
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
//    [cenView addSubview:label];
//    label.sd_layout
//    .leftSpaceToView(cenView, 10)
//    .rightSpaceToView(cenView, 10)
//    .topSpaceToView(cenView, 10)
//    .autoHeightRatio(0);
//    [cenView setupAutoHeightWithBottomView:label bottomMargin:10];
//
//    UILayoutGuide *layoutGuid = [[UILayoutGuide alloc]init];
//    [self.view addLayoutGuide:layoutGuid];
}

- (void)testZhexian
{
    //折线图
    [self setup];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:[NSNumber numberWithInteger:7076120]];
    [dataArray addObject:[NSNumber numberWithInteger:1240342]];
    [dataArray addObject:[NSNumber numberWithInteger:14671152]];
    [dataArray addObject:[NSNumber numberWithInteger:384462]];
    [dataArray addObject:[NSNumber numberWithInteger:0]];
    
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
    for (int i =0; i < 5; i++)
    {
        NSString *xTitle = [NSString stringWithFormat:@"%d",i];
        [categoriesArray addObject:xTitle];
    }
    
    [self reloadWithData:dataArray categories:categoriesArray];
}

- (void)testbounds
{
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    fView.backgroundColor = [UIColor yellowColor];
    fView.bounds = CGRectMake(-10, 0, 50, 100);
    [self.view addSubview:fView];
    
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    sView.backgroundColor = [UIColor greenColor];
    [fView addSubview:sView];
}

- (void)testStackView{
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 100)];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 10;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:stackView];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor yellowColor];
        if (i == 1) {
            view.backgroundColor = [UIColor blueColor];
        }
        else if(i == 2)
        {
            view.backgroundColor = [UIColor redColor];
        }
        [stackView addArrangedSubview:view];
    }
}

- (void)setup {
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    self.aaChartView = [[AAChartView alloc] initWithFrame:rect];
    self.aaChartView.contentHeight = self.aaChartView.frame.size.height-80;
    [self.view addSubview:self.aaChartView];
    self.aaChartView.delegate = self;
    self.aaChartView.scrollEnabled = NO;
    
}

- (void)reloadWithData:(NSArray <NSNumber *> *)data categories:(NSArray *)categoriesArray {
    NSMutableArray *newData            = [NSMutableArray array];
    __block float  maxData             = 0;
    [data enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [newData addObject:@(obj.floatValue / 1000 / 60)];
        
        maxData = MAX(obj.floatValue / 1000 / 60, maxData);
        NSUInteger newMax = maxData * 100;
        maxData = newMax / 100;
    }];
    NSMutableArray *newCategoriesArray = [NSMutableArray array];
    [categoriesArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [newCategoriesArray addObject:obj];
        } else {
            [newCategoriesArray addObject:[obj stringValue]];
        }
    }];
    NSUInteger newMax2  = maxData * 2 / 3 * 100;
    float      maxData2 = newMax2 / 100;
    NSUInteger newMax3  = maxData / 3 * 100;
    float      maxData3 = newMax3 / 100;
    NSArray    *ydata   = @[@(0), @(maxData3), @(maxData2), @(maxData + 1)];
    
    NSArray    *colors    = @[@"#3789FF"];
    AAChart    *charts    = AAObject(AAChart).typeSet(AAChartTypeLine);//.zoomTypeSet(AAChartZoomTypeNone)
    //charts.pinchType = AAChartZoomTypeNone;
    //点击提示信息
    AATooltip  *tooltips  = AAObject(AATooltip).enabledSet(YES);
    tooltips.valueSuffix = @"%";
//    tooltips.valueDecimals = @2;
//    tooltips.shared = YES;
//    tooltips.headerFormat = @"头部格式";
//    //tooltips.formatter = @"格式";
//    tooltips.footerFormat = @"footer格式";
    tooltips
    .useHTMLSet(true)
    .headerFormatSet(@"阅读人数：<b>{point.key}={series.name}</b><br>")//{series.name}这个不知道啥意思 得到得是1
    .pointFormatSet(@"阅读率：&nbsp<b>{point.y}</b>")
    .valueDecimalsSet(@2)//设置取值精确到小数点后几位
    .backgroundColorSet(@"#000000")
    .borderColorSet(@"#000000")
    .styleSet(@{@"color":@"#FFD700"/*(纯金色)*/,
                @"fontSize":@"12px",});
    
    
    AALegend   *legends   = AAObject(AALegend).enabledSet(false);
    AATitle    *titles    = AAObject(AATitle).textSet(@"标题");
    AATitle    *ytitles   = AAObject(AATitle).textSet(@"y标题");
    AASubtitle *subtitles = AAObject(AASubtitle).textSet(@"副标题");
    
    AAYAxis *yAxiss = AAObject(AAYAxis);
    yAxiss.tickPositions = ydata;
    yAxiss.title         = ytitles;
    yAxiss.labels        = AAObject(AALabels).enabledSet(true);
    yAxiss.lineColor     = @"#DC143C";
    yAxiss.lineWidth     = @1;
    yAxiss.gridLineWidth = @1;//分割线
    yAxiss.visible = YES;
    
    
    AAMarker *aaMarker = AAObject(AAMarker).radiusSet(@3)//曲线连接点半径，默认是4
    .symbolSet(@"circle").lineWidthSet(@2).lineColorSet(@"#3789FF").fillColorSet(@"#FFFFFF");
    AASeries *aaSeries = AAObject(AASeries);
    aaSeries.marker = aaMarker;
    aaSeries.keys = [[NSArray alloc] initWithObjects:@"序列1",@"序列2",@"序列3",@"序列4",@"序列2",@"序列2",@"序列2", nil];
    
    AASeriesElement *seriess = AAObject(AASeriesElement).dataSet(newData).nameSet(@"seriess名字").markerSet(aaMarker);
    
    AAXAxis *xAxiss = AAObject(AAXAxis);
    xAxiss.visible = YES;
    xAxiss.categories = categoriesArray;

    AAOptions *options = AAObject(AAOptions);
    options.chart    = charts;
    options.title    = titles;
    options.subtitle = subtitles;
    options.xAxis    = xAxiss;
    options.yAxis    = yAxiss;
    options.tooltip  = tooltips;
    options.legend   = legends;
    options.series   = @[seriess];
    options.colors   = colors;
    [self.aaChartView aa_drawChartWithOptions:options];
    
}

- (void)AAChartViewDidFinishLoad {
    
}

#pragma mark 测试autolayout
- (void)initBaseView{
    BaseAutoLayoutScrollView *scrollView = [[BaseAutoLayoutScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.scrollType = AutoScrollViewVertical;
    scrollView.contentView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scrollView];
    
    CGFloat tiheight = SCREEN_WIDTH / 750 * 445;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tiheight)];
    topImageView.image = [UIImage imageNamed:@"banner_home"];
    topImageView.backgroundColor = [UIColor greenColor];
    [scrollView.contentView addSubview:topImageView];
    
    CGFloat roundWidth = SCREEN_WIDTH / 750 * 340;
    UIView *assignView = [[UIView alloc] init];
    assignView.backgroundColor = [UIColor yellowColor];
    [scrollView.contentView addSubview:assignView];
    assignView.sd_layout
    .widthIs(roundWidth)
    .autoHeightRatio(1.0)
    .leftSpaceToView(scrollView.contentView, 8.67)
    .topSpaceToView(topImageView, -20);
    
    /*
     [assignView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerX.equalTo(scrollView.contentView).multipliedBy(0.5);
     }];
     */
    
    UIView *checkView = [[UIView alloc] init];
    checkView.backgroundColor = [UIColor redColor];
    [scrollView.contentView addSubview:checkView];
    checkView.sd_layout
    .widthRatioToView(assignView, 1.0)
    .heightRatioToView(assignView, 1)
    .centerYEqualToView(assignView)
    .rightSpaceToView(scrollView.contentView, 8.67);
    
//    [checkView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.centerY.equalTo(assignView);
//        make.right.equalTo(scrollView.contentView.mas_right).offset(-8.67);
//    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor grayColor];
    [scrollView.contentView addSubview:bottomView];
    bottomView.sd_layout
    .topSpaceToView(checkView, 50)
    .leftSpaceToView(scrollView.contentView, 10)
    .widthIs(300)
    .heightIs(1000)
    .bottomEqualToView(scrollView.contentView);
    
//    [scrollView.contentView]
//    [scrollView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1000);
//    }];
}

- (void)testScrollView
{
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollview];
    scrollview.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10));
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor darkGrayColor];
    [scrollview addSubview:contentView];
    contentView.sd_layout
    .topSpaceToView(scrollview, 200)
    .leftEqualToView(scrollview)
    .rightEqualToView(scrollview)
    .heightIs(1000);
    
    [scrollview setupAutoContentSizeWithBottomView:contentView bottomMargin:70];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
