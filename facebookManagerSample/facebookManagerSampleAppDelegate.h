//
//  facebookManagerSampleAppDelegate.h
//  facebookManagerSample
//
//  Created by Arai Ryota on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class facebookManagerSampleViewController;

@interface facebookManagerSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet facebookManagerSampleViewController *viewController;

@end
