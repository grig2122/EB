//
//  Stream.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBTrack.h"

@interface EBTrack ()

// Private properties
/*
 * UIImage *image and NSString *localMediaFilePath properties are private properties.
 * If you would like to display the image or play the music file please 
 * use above methods implemented in EBTrack (Network) category
 *
 * - (void)loadMediaFileWithCompletionBlock:(void(^)(NSString *localFilePath))block
 * - (void)loadImageWithCompletionBlock:(void(^)(UIImage *image))block
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *localMediaFilePath;

@end

@implementation EBTrack

@end
