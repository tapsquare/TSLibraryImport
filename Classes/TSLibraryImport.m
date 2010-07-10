//
//  TSLibraryImport.m
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 7/9/10.
//  Copyright 2010 tapsquare, llc. All rights reserved.
//

#import "TSLibraryImport.h"

@interface TSLibraryImport()

+ (BOOL)validIpodLibraryURL:(NSURL*)url;

@end


@implementation TSLibraryImport

+ (BOOL)validIpodLibraryURL:(NSURL*)url {
	NSString* IPOD_SCHEME = @"ipod-library";
	if (nil == url) return NO;
	if (nil == url.scheme) return NO;
	if ([url.scheme compare:IPOD_SCHEME] != NSOrderedSame) return NO;
	if ([url.pathExtension compare:@"mp3"] != NSOrderedSame &&
		[url.pathExtension compare:@"aif"] != NSOrderedSame &&
		[url.pathExtension compare:@"m4a"] != NSOrderedSame &&
		[url.pathExtension compare:@"wav"] != NSOrderedSame) {
		return NO;
	}
	return YES;
}

+ (NSString*)extensionForAssetURL:(NSURL*)assetURL {
	if (nil == assetURL)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"nil assetURL" userInfo:nil];
	if (![self validIpodLibraryURL:assetURL])
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid iPod Library URL: %@", assetURL] userInfo:nil];
	return assetURL.pathExtension;
}

- (void)importAsset:(NSURL*)assetURL toURL:(NSURL*)destURL {
	if (nil == assetURL || nil == destURL)
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"nil url" userInfo:nil];
	//TODO: throw on invalid urls
	//TODO: add completion handler to method
	
	NSDictionary * options = [[NSDictionary alloc] init];
	AVURLAsset* asset = [AVURLAsset URLAssetWithURL:assetURL options:options];	
	//TODO: throw on nil?
	
	AVAssetExportSession* export = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
	
	//TODO: if tmpURL exists, fail -- caller must handle this themselves
	//TODO: create a tmp url to write the .mov file to (NOT destURL)
	export.outputURL = destURL;

	export.outputFileType = AVFileTypeQuickTimeMovie;
	[export exportAsynchronouslyWithCompletionHandler:^(void) {
		if (export.status == AVAssetExportSessionStatusFailed) {
			NSLog(@"export.error: %@", export.error);
		} else if (export.status == AVAssetExportSessionStatusCancelled) {
			NSLog(@"export canceled: %@", export.error);
		} else {
			NSLog(@"export complete!");
			//TODO: parse .mov file to dest file
		}
		
		[export release];
	}];
}

@end
