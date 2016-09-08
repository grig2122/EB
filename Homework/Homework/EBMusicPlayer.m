//
//  EBMusicPlayer.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBMusicPlayer.h"
#import "EBTrack+Network.h"

@interface EBMusicPlayer ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation EBMusicPlayer

- (void)startPlayingTrack:(EBTrack *)track
{
    __weak typeof(self)weakSelf = self;
    [track loadMediaFileWithCompletionBlock:^(NSString *mediaFilePath) {
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:mediaFilePath]];
        weakSelf.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
        if (!error)
        {
            [weakSelf play];
        }
        else
        {
            [weakSelf handleError:error];
        }
    }];
    
    weakSelf.currentTrack = track;
}

- (void)play
{
    [self.audioPlayer play];
    self.isPlaying = YES;
}

- (void)pause
{
    [self.audioPlayer pause];
    self.isPlaying = NO;
}

- (BOOL)isPlaying
{
    return self.audioPlayer.isPlaying;
}

- (void)handleError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

@end
