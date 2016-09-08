//
//  EBPlayerViewController.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#define ENDPOINT @"http://streaming.earbits.com/api/v1/track.json?stream_id=5654d7c3c5aa6e00030021aa"

#import "EBPlayerViewController.h"
#import "API.h"
#import "EBMusicPlayer.h"
#import "EBTrack+Network.h"

static void *kObservationContext = &kObservationContext;

@interface EBPlayerViewController ()

// Other
@property (nonatomic, strong) EBMusicPlayer *musicPlayer;

// Models
@property (nonatomic, strong) NSMutableArray *tracks;

// Views
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

// Actions
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

@end

#pragma mark - EBPlayerViewController

@implementation EBPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tracks = [[NSMutableArray alloc] init];
    [self setupMediaPlayer];
    [self registerAsObserver];
}

- (void)dealloc
{
    [self unregisterObserver];
}

#pragma mark - Private methods

- (void)loadTrack
{
    __weak typeof(self)weakSelf = self;
    [self.activityIndicator startAnimating];
    API *api = [API sharedInstance];
    [api requestTrackFromEndpoint:ENDPOINT
                       completion:^(EBTrack *track) {
                           [weakSelf.tracks addObject:track];
                           [weakSelf.musicPlayer startPlayingTrack:track];
                           [weakSelf displayTrackDetails:track];
                           [weakSelf.activityIndicator stopAnimating];
                       }];
}

- (void)setupMediaPlayer
{
    self.musicPlayer = [[EBMusicPlayer alloc] init];
}

- (void)displayTrackDetails:(EBTrack *)track
{
    __weak typeof(self)weakSelf = self;
    self.trackNameLabel.text = track.trackName;
    self.artistNameLabel.text = track.artistName;
    [track loadImageWithCompletionBlock:^(UIImage *image) {
        weakSelf.artistImageView.image = image;
    }];
}

#pragma mark - Actions

- (IBAction)playButtonPressed:(id)sender
{
    UIButton *playButton = sender;
    playButton.selected = !playButton.selected;
    
    if (!self.musicPlayer.currentTrack)
    {
        [self loadTrack];
    }
    else
    {
        if ([self.musicPlayer isPlaying])
        {
            [self.musicPlayer pause];
        }
        else
        {
            [self.musicPlayer play];
        }
    }
}

- (IBAction)prevButtonPressed:(id)sender
{
    NSInteger indexOfPlayingTrack = [self.tracks indexOfObject:self.musicPlayer.currentTrack];
    NSInteger indexOfPrevTrack = indexOfPlayingTrack - 1;
    if (indexOfPrevTrack >= 0 && self.musicPlayer.currentTrack)
    {
        EBTrack *track = [self.tracks objectAtIndex:indexOfPrevTrack];
        [self.musicPlayer startPlayingTrack:track];
        [self displayTrackDetails:track];
    }
}

- (IBAction)nextButtonPressed:(id)sender
{
    NSInteger indexOfPlayingTrack = [self.tracks indexOfObject:self.musicPlayer.currentTrack];
    NSInteger indexOfNextTrack = indexOfPlayingTrack + 1;
    if (indexOfNextTrack < [self.tracks count])
    {
        EBTrack *track = [self.tracks objectAtIndex:indexOfNextTrack];
        [self.musicPlayer startPlayingTrack:track];
        [self displayTrackDetails:track];
    }
    else
        [self loadTrack];
}

#pragma mark - KVO

- (void)registerAsObserver
{
    [self.musicPlayer addObserver:self
                       forKeyPath:@"isPlaying"
                          options:NSKeyValueObservingOptionNew
                          context:kObservationContext];
}

- (void)unregisterObserver
{
    [self.musicPlayer removeObserver:self forKeyPath:@"isPlaying"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kObservationContext)
    {
        if ([keyPath isEqual:@"isPlaying"] && [object isKindOfClass:[EBMusicPlayer class]])
        {
            self.playButton.selected = self.musicPlayer.isPlaying;
        }
    }
    else if ([super respondsToSelector:_cmd])
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
















