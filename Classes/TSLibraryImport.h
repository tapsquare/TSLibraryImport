//
//  TSLibraryImport.h
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 7/9/10.
//  Copyright 2010 tapsquare, llc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#define TSLibraryImportErrorDomain @"TSLibraryImportErrorDomain"

#define TSUnknownError @"TSUnknownError"
#define TSFileExistsError @"TSFileExistsError"

#define kTSUnknownError -65536
#define kTSFileExistsError -48 //dupFNErr

@interface TSLibraryImport : NSObject {
	AVAssetExportSession* export;
	NSError* movieFileErr;
}

/**
 * Pass in the NSURL* you get from an MPMediaItem's 
 * MPMediaItemPropertyAssetURL property to get the file's extension.
 *
 * Helpful in constructing the destination url for the
 * imported file.
 */
+ (NSString*)extensionForAssetURL:(NSURL*)assetURL;

/**
 * @param: assetURL The NSURL* returned by MPMediaItemPropertyAssetURL property of MPMediaItem.
 * @param: destURL The file URL to write the imported file to. You'll get an exception if a file
 * exists at this location.
 * @param completionBlock This block is called when the import completes. Note that 
 * completion doesn't imply success. Be sure to check the status and error properties
 * of the TSLibraryImport* instance from your completionBlock.
 */
- (void)importAsset:(NSURL*)assetURL toURL:(NSURL*)destURL completionBlock:(void (^)(TSLibraryImport* import))completionBlock;

@property (readonly) NSError* error;
@property (readonly) AVAssetExportSessionStatus status;
@property (readonly) float progress;

@end
