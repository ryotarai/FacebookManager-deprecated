//
//  facebookManagerSampleViewController.m
//  facebookManagerSample
//
//  Created by Arai Ryota on 11/09/26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "facebookManagerSampleViewController.h"
#import "FacebookManager.h"

@implementation facebookManagerSampleViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FacebookManager sharedManager] 
     requestWithGraphPath:@"me" 
     target:self 
     selector:@selector(meFacebookRequest:didLoad:)];
    
    [[FacebookManager sharedManager] doRequests];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)meFacebookRequest:(FBRequest *)request didLoad:(id)result {
    NSLog(@"meFacebookRequest:didLoad:");
    NSLog(@"%@", result);
}

@end
