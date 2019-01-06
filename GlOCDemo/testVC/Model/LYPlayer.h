//
//  LYPlayer.h
//  LeanAudioUnit
//
//  Created by loyinglin on 2017/9/13.
//  Copyright © 2017年 loyinglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYPlayer;
@protocol LYPlayerDelegate <NSObject>

- (void)onPlayToEnd:(LYPlayer *)player;

@end


@interface LYPlayer : NSObject
@property (nonatomic, assign) NSInteger samplerate;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, weak) id<LYPlayerDelegate> delegate;

- (instancetype)initWithUrl:(NSURL *)url;

- (void)play;

- (double)getCurrentTime;

@end
