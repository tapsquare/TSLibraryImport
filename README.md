TSLibraryImport
===============

In iOS4, you're able to get access to the raw audio data of files stored in the user's iPod Library, but the method isn't straightforward: You have to use AVAssetExportSession with the passthrough preset, write the file to a QuickTime .mov file and then extract the audio data out of the .mov file to whatever container is appropriate.

The `TSLibraryImport` hides this complexity behind a simple interface.

Use
---

Add `TSLibraryImport.h` and `TSLibraryImport.m` to your project. Make sure you also add `AVFoundation.framework` to your project.

To import a file:

	MPMediaItem* item; //obtained using MediaPlayer.framework APIs
	NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
	NSURL* destinationURL ...; //file URL for the location you'd like to import the asset to.
	TSLibraryImport* import = [[TSLibraryImport alloc] init];
	[import importAsset:assetURL toURL:outURL completionBlock:^(TSLibraryImport* import) {
		//check the status and error properties of
		//TSLibraryImport
	}
