//
//  Tests.m
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 7/10/10.
//  Copyright 2010 tapsquare, llc. All rights reserved.
//

#import "GHUnit.h"
#import "TSLibraryImport.h"

@interface Tests : GHTestCase
@end


@implementation Tests
- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
	return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}   

- (void)testInvalidURL {
	NSURL* badURL = [NSURL URLWithString:@"lame-scheme://item/lame.txt?id=1234"];
	GHAssertThrowsSpecificNamed([TSLibraryImport extensionForAssetURL:badURL], NSException, NSInvalidArgumentException, @"extensionForAsset should throw NSInvalidArgumentException for %@", badURL);
}

- (void)testInvalidExtension {
	NSURL* badExtension = [NSURL URLWithString:@"ipod-library://item/item.moo?id=879187038471087"];
	GHAssertThrowsSpecificNamed([TSLibraryImport extensionForAssetURL:badExtension], NSException, NSInvalidArgumentException, @"extension for Asset should throw NSInvalidArgumentException (unrecognized file extension) for %@", badExtension);
}

- (void)testExtensionParsing {
	// pulled these from my library using iOS 4. I imagine this url scheme could
	// change in the future, so will have to test against future versions of 
	// SDK.
	
	// Note that the MPMediaItemAssetURL property returns nil for .m4p (DRM'ed) 
	// files in the library
	
	// mp3 - ipod-library://item/item.mp3?id=1425010501608620615
	// m4a - ipod-library://item/item.m4a?id=-5920761218465604600
	// aif - ipod-library://item/item.aif?id=-3986756244970330071

	NSURL* mp3URL = [NSURL URLWithString:@"ipod-library://item/item.mp3?id=1425010501608620615"];
	NSURL* m4aURL = [NSURL URLWithString:@"ipod-library://item/item.m4a?id=-5920761218465604600"];
	NSURL* aifURL = [NSURL URLWithString:@"ipod-library://item/item.aif?id=-3986756244970330071"];

	GHAssertEqualStrings(@"mp3", [TSLibraryImport extensionForAssetURL:mp3URL], @"mp3 extension incorrect: %@", [TSLibraryImport extensionForAssetURL:mp3URL]);
	GHAssertEqualStrings(@"m4a", [TSLibraryImport extensionForAssetURL:m4aURL], @"m4a extension incorrect: %@", [TSLibraryImport extensionForAssetURL:m4aURL]);
	GHAssertEqualStrings(@"aif", [TSLibraryImport extensionForAssetURL:aifURL], @"aif extension incorrect: %@", [TSLibraryImport extensionForAssetURL:aifURL]);
}

- (void)testExportNilParameters {
	TSLibraryImport* import = [[[TSLibraryImport alloc] init] autorelease];
	NSURL* dummyURL = [NSURL URLWithString:@"ipod-library://item/item.mp3?id=1425010501608620615"];
	GHAssertThrowsSpecificNamed([import importAsset:dummyURL toURL:nil completionBlock:nil], NSException, NSInvalidArgumentException, @"nil parameter should throw NSInvalidArgumentException");
	GHAssertThrowsSpecificNamed([import importAsset:nil toURL:dummyURL completionBlock:nil], NSException, NSInvalidArgumentException, @"nil parameter should throw NSInvalidArgumentException");
}

- (void)testExportInvalidURL {
	TSLibraryImport* import = [[[TSLibraryImport alloc] init] autorelease];
	NSURL* badURL = [NSURL URLWithString:@"lame-scheme://item/lame.txt?id=1234"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSURL* outURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"test.mov"]];
	
	GHAssertThrowsSpecificNamed([import importAsset:badURL toURL:outURL completionBlock:nil], NSException, NSInvalidArgumentException, @"importAsset: should throw NSInvalidArgumentException for %@", badURL);
}

@end
