//
//  EBTrack+JSON.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBTrack+Network.h"
#import <AFNetworking/AFImageDownloader.h>


@implementation EBTrack (Network)


// Map json to Track object
+ (EBTrack *)trackFromJson:(id)responseObject
{
    EBTrack *track = [[EBTrack alloc] init];
    
    // track name
    track.trackName = responseObject[@"name"];
    
    // artist name
    track.artistName = responseObject[@"artist"][@"name"];
    
    // image url
    id images = responseObject[@"artist"][@"images"];
    if ([images isKindOfClass:[NSArray class]] && [images count] > 0)
    {
        track.artistImageURL = [images firstObject][@"small"];
    }
    
    // media file
    NSURL *url = [NSURL URLWithString:responseObject[@"media_file"]];
    NSData *musicData = [NSData dataWithContentsOfURL:url];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.mp3",track.trackName,track.artistName];
    NSString *mp3File = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3File])
        [musicData writeToFile:mp3File atomically:YES];
    track.mediaFile = mp3File;
    
    
    return track;
}


// Download artist image
- (void)loadImageWithCompletionBlock:(void(^)(UIImage *image))block
{
    __weak typeof(self)weakSelf = self;
    AFImageDownloader *imageDownloader = [[AFImageDownloader alloc] init];
    [imageDownloader downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.artistImageURL]]
                                        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                                            if (block) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    block(responseObject);
                                                });
                                            }
                                        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                            [weakSelf handleError:error];
                                        }];
}

- (void)handleError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

@end
