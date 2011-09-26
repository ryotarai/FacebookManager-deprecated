//
//  facebookManagerSampleViewController.h
//  facebookManagerSample
//
//  Created by Arai Ryota on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBRequest;

@interface facebookManagerSampleViewController : UIViewController

- (void)meFacebookRequest:(FBRequest *)request didLoad:(id)result;

@end
