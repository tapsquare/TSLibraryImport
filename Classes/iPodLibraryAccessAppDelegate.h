//
//  iPodLibraryAccessAppDelegate.h
//  iPodLibraryAccess
//
//  Created by Art Gillespie on 6/11/10.
//  Copyright Glaresoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPodLibraryAccessViewController;

@interface iPodLibraryAccessAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPodLibraryAccessViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPodLibraryAccessViewController *viewController;

@end

