//
//  iPodLibraryAccessViewController.m
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 6/11/10.
//  Copyright Glaresoft 2010. All rights reserved.
//

#import "iPodLibraryAccessViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TSLibraryImport.h"

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
	[progressView setProgress:0.f];

	AVAudioSession* session = [AVAudioSession sharedInstance];
	NSError* error = nil;
	// Thought maybe setting this to one of the "exclusive" categories
	// would give us faster results, e.g., by granting us access to the
	// hardware encoder, but with any other category, you get -11820 errors
	// from AVAssetExportSession
	if(![session setCategory:AVAudioSessionCategoryAmbient error:&error]) {
		NSLog(@"Couldn't set audio session category: %@", error);
	}
	
	if(![session setActive:YES error:&error]) {
		NSLog(@"Couldn't make audio session active: %@", error);
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)progressTimer:(NSTimer*)timer {
	AVAssetExportSession* export = (AVAssetExportSession*)timer.userInfo;
	switch (export.status) {
		case AVAssetExportSessionStatusExporting:
		{
			NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - startTime;
			float minutes = rintf(delta/60.f);
			float seconds = rintf(fmodf(delta, 60.f));
			[elapsedLabel setText:[NSString stringWithFormat:@"%2.0f:%02.0f", minutes, seconds]];
			[progressView setProgress:export.progress];
			break;
		}
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
	
	// create destination URL
	NSString* ext = [TSLibraryImport extensionForAssetURL:assetURL];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL* outURL = [[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"test"]] URLByAppendingPathExtension:ext];	
	
	TSLibraryImport* import = [[TSLibraryImport alloc] init];
	[import importAsset:assetURL toURL:outURL completionBlock:^(TSLibraryImport* import) {
		NSLog(@"export complete!");
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
