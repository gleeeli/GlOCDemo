//
//  BomObject.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/2.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "BomObject.h"

@implementation BomObject
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)animationBomWithView:(UIView *)aniView {
    //粒子发射器
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(aniView.bounds.size.width/2.0, aniView.bounds.size.height/2.0);
    snowEmitter.emitterSize        = aniView.bounds.size;//发射源的尺寸大；
    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
    snowEmitter.emitterShape    = kCAEmitterLayerRectangle;//发射源的形状;
    snowEmitter.seed              = (arc4random() % 100) + 1;//用于初始化随机数产生的种子
    
    
    CAEmitterCell * spark = [CAEmitterCell emitterCell];
    spark.birthRate            = 30;//这个必须要设置，每秒产生cell数量
    spark.velocity            = 80;
    spark.emissionRange        = 2* M_PI;// 360 度 //周围发射角度
    spark.lifetime            = 1.0;
    spark.contents            = (id) [[UIImage imageNamed:@"bom2"] CGImage];
    spark.scaleSpeed        = -0.8;
    spark.alphaSpeed        = -.9;//粒子透明度在生命周期内的改变速度
    spark.spin                = M_PI_2;
    spark.spinRange            = M_PI_2;
    
    //粒子发射器
    CAEmitterLayer *snowEmitter1 = [CAEmitterLayer layer];
    snowEmitter1.emitterPosition = CGPointMake(aniView.bounds.size.width/2.0, aniView.bounds.size.height/2.0);
    snowEmitter1.emitterSize        = aniView.bounds.size;
    snowEmitter1.emitterMode        = kCAEmitterLayerOutline;
    snowEmitter1.emitterShape    = kCAEmitterLayerRectangle;
    snowEmitter1.seed              = (arc4random() % 100) + 1;
    
    
    CAEmitterCell * spark1 = [CAEmitterCell emitterCell];
    spark1.birthRate            = 30;
    spark1.velocity            = 100;
    spark1.emissionRange        = 2* M_PI;    // 360 度
    spark1.lifetime            = 2.0;
    spark1.contents            = (id) [[UIImage imageNamed:@"bom2"] CGImage];
    spark1.scaleSpeed        = -0.8;
    spark1.alphaSpeed        = -.9;
    spark1.spin                = M_PI_2;
    spark1.spinRange            = M_PI_2;
    
    // 将粒子添加到粒子发射器上
    snowEmitter.emitterCells = [NSArray arrayWithObject:spark];
    snowEmitter1.emitterCells = [NSArray arrayWithObject:spark1];
    
    [aniView.layer addSublayer:snowEmitter];
    [aniView.layer addSublayer:snowEmitter1];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    __weak typeof(snowEmitter) weakselEmitter = snowEmitter;
    __weak typeof(snowEmitter1) weakselEmitter1 = snowEmitter1;
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        __strong typeof(weakselEmitter) strongEmitter = weakselEmitter;
        __strong typeof(weakselEmitter1) strongEmitter1 = weakselEmitter1;
        strongEmitter.birthRate = 0;
        strongEmitter1.birthRate = 0;
    });
    
    dispatch_after(popTime2, dispatch_get_main_queue(), ^{
        __strong typeof(weakselEmitter) strongEmitter = weakselEmitter;
        __strong typeof(weakselEmitter1) strongEmitter1 = weakselEmitter1;
        [strongEmitter removeFromSuperlayer];
        [strongEmitter1 removeFromSuperlayer];
    });
}

- (void)animation1WithView:(UIView *)aniView {
    // Cells spawn in the bottom, moving up
    //分为3种粒子，子弹粒子，爆炸粒子，散开粒子
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = aniView.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize    = CGSizeMake(200, 200);
    fireworksEmitter.emitterMode    = kCAEmitterLayerPoints;
    fireworksEmitter.emitterShape    = kCAEmitterLayerPoint;
    fireworksEmitter.renderMode        = kCAEmitterLayerBackToFront;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate        = 1.0;
    rocket.emissionRange    = 0.25 * M_PI;  // some variation in angle
    rocket.velocity            = 380;
    rocket.velocityRange    = 100;
    rocket.yAcceleration    = 75;
    rocket.lifetime            = 1.02;    // we cannot set the birthrate < 1.0 for the burst
    
    //星星图片
    rocket.contents            = (id)[[UIImage imageNamed:@"Bomb"] CGImage];
    rocket.scale            = 0.2;
    rocket.color            = [[UIColor redColor] CGColor];
    rocket.greenRange        = 1.0;        // different colors
    rocket.redRange            = 1.0;
    rocket.blueRange        = 1.0;
    rocket.spinRange        = M_PI;        // slow spin
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate            = 1.0;        // at the end of travel
    burst.velocity            = 0;        //速度为0
    burst.scale                = 2.5;      //大小
    burst.redSpeed            =-1.5;        // shifting
    burst.blueSpeed            =+1.5;        // shifting
    burst.greenSpeed        =+1.0;        // shifting
    burst.lifetime            = 0.35;     //存在时间
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 400;
    spark.velocity            = 125;
    spark.emissionRange        = 2* M_PI;    // 360 度
    spark.yAcceleration        = 75;        // gravity
    spark.lifetime            = 3;
    //星星图片
    spark.contents            = (id) [[UIImage imageNamed:@"bom2"] CGImage];
    spark.scaleSpeed        =-0.2;
    spark.greenSpeed        =-0.1;
    spark.redSpeed            = 0.4;
    spark.blueSpeed            =-0.1;
    spark.alphaSpeed        =-0.25;
    spark.spin                = 2* M_PI;
    spark.spinRange            = 2* M_PI;
    
    // 3种粒子组合，可以根据顺序，依次烟花弹－烟花弹粒子爆炸－爆炸散开粒子
    fireworksEmitter.emitterCells    = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                = [NSArray arrayWithObject:burst];
    burst.emitterCells                = [NSArray arrayWithObject:spark];
    [aniView.layer addSublayer:fireworksEmitter];
}

@end
