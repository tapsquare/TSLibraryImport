//
//  iPodLibraryAccessViewController.h
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 6/11/10.
//  Copyright Glaresoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface iPodLibraryAccessViewController : UIViewController <MPMediaPickerControllerDelegate> {
	AVPlayer* player;
	IBOutlet UIProgressView* progressView;
	IBOutlet UILabel* elapsedLabel;
	NSTimeInterval startTime;
}

- (IBAction)pickSong:(id)sender;
- (void)exportAssetAtURL:(NSURL*)assetURL;

@end

