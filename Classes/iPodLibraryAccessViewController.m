//
//  iPodLibraryAccessViewController.m
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 6/11/10.
//  Copyright Glaresoft 2010. All rights reserved.
//

#import "iPodLibraryAccessViewController.h"

@implementation iPodLibraryAccessViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath compare:@"status"] == 0) {
		AVAssetExportSession* export = (AVAssetExportSession*)object;
		switch (export.status) {
			case AVAssetExportSessionStatusUnknown:
				NSLog(@"AVAssetExportSessionStatusUnknown");
				break;
			case AVAssetExportSessionStatusExporting:
				NSLog(@"AVAssetExportSessionStatusExporting");
				break;
			case AVAssetExportSessionStatusCompleted:
				NSLog(@"AVAssetExportSessionStatusCompleted");
				break;
			case AVAssetExportSessionStatusFailed:
				NSLog(@"AVAssetExportSessionStatusFailed");
				break;
			case AVAssetExportSessionStatusCancelled:
				NSLog(@"AVAssetExportSessionStatusCancelled");
				break;
			case AVAssetExportSessionStatusWaiting:
				NSLog(@"AVAssetExportSessionStatusWaiting");
				break;
			default:
				break;
		}
	} 
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//AVAudioSession* avSession = [AVAudioSession sharedInstance];
	
	//try exporting an mp3 from the bundle
	NSURL* assetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Epistrophy" ofType:@"mp3"]];
	[self exportAssetAtURL:assetURL];	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"observeValueForKeyPath: %@", keyPath);
	if ([keyPath compare:@"status"] == 0) {
		NSLog(@"status of playerItem changed");
		AVPlayerItem* playerItem = (AVPlayerItem*)object;
		if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
			NSLog(@"playerItem ready to play");
			[player play];
		}
	}
}
*/

- (void)progressTimer:(NSTimer*)timer {
	AVAssetExportSession* export = (AVAssetExportSession*)timer.userInfo;
	switch (export.status) {
		case AVAssetExportSessionStatusExporting:
			NSLog(@"progress: %f", export.progress);
			break;
		case AVAssetExportSessionStatusCancelled:
		case AVAssetExportSessionStatusCompleted:
		case AVAssetExportSessionStatusFailed:
			[timer invalidate];
			break;
		default:
			break;
	}		
}

- (void)exportAssetAtURL:(NSURL*)assetURL {
	NSDictionary * options = [[NSDictionary alloc] init];
	AVURLAsset* asset = [AVURLAsset URLAssetWithURL:assetURL options:options];	
	//create an export session to write the asset as an m4a
	AVAssetExportSession* export = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
	//set the export session's outputURL to <Documents>/test.m4a
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL* outURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"test.m4a"]];
	[[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	export.outputURL = outURL;
	//set the output file type
	export.outputFileType = AVFileTypeAppleM4A;
	[export addObserver:self forKeyPath:@"status" options:0 context:nil];
	[export addObserver:self forKeyPath:@"progress" options:0 context:nil];
	[NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(progressTimer:) userInfo:export repeats:YES];
	[export exportAsynchronouslyWithCompletionHandler:^(void) {
		if (export.status == AVAssetExportSessionStatusFailed) {
			NSLog(@"export.error: %@", export.error);
		}
		[export release];
	}];				
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker 
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[self dismissModalViewControllerAnimated:YES];
	for (MPMediaItem* item in mediaItemCollection.items) {
		NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];
		NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
		NSLog(@"title: %@, url: %@", title, assetURL);
		[self exportAssetAtURL:assetURL];
	}
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)showMediaPicker {
	MPMediaPickerController* mediaPicker = [[[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic] autorelease];
	mediaPicker.delegate = self;
	[self presentModalViewController:mediaPicker animated:YES];
}

- (IBAction)pickSong:(id)sender {
	[self showMediaPicker];
}

- (void)dealloc {
    [super dealloc];
}

@end
