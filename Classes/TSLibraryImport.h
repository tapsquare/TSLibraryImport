//
//  TSLibraryImport.h
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 7/9/10.
//  Copyright 2010 tapsquare, llc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@interface TSLibraryImport : NSObject {
	AVAssetExportSession* export;
}

/**
 * Pass in the NSURL* you get from an MPMediaItem's 
 * MPMediaItemAssetURL property to get the file's extension.
 *
 * Helpful in constructing the destination url for the
 * imported file.
 */
+ (NSString*)extensionForAssetURL:(NSURL*)assetURL;

- (void)importAsset:(NSURL*)assetURL toURL:(NSURL*)destURL completionBlock:(void (^)(TSLibraryImport* import))completionBlock;

@property (readonly) NSError* error;
@property (readonly) AVAssetExportSessionStatus status;
@property (readonly) float progress;

@end
