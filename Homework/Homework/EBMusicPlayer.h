//
//  EBMusicPlayer.h
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EBTrack.h"

@interface EBMusicPlayer : NSObject

@property (nonatomic, strong) EBTrack *currentTrack;
@property (nonatomic, assign) BOOL isPlaying;

- (void)startPlayingTrack:(EBTrack *)track;
- (void)pause;
- (void)play;

@end
