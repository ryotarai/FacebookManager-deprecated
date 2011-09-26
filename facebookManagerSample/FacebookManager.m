//
//  FacebookManager.m
//  Freco
//
//  Created by Arai Ryota on 11/09/20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "FacebookManager.h"

@implementation FacebookManager

@synthesize facebook = _facebook;

static FacebookManager *_sharedManager;

// Please set Application ID of Facebook.
NSString *kFacebookAppId = @"";

NSString *kUserDefaultsKeyFBToken = @"Facebook:AccessToken";
NSString *kUserDefaultsKeyFBExpireDate = @"Facebook:ExpirationDate";

+ (FacebookManager *)sharedManager {
    if (!_sharedManager) {
        _sharedManager = [[FacebookManager alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _requestQueue = [[NSMutableArray alloc] init];
        
        NSAssert(kFacebookAppId != nil && ![kFacebookAppId isEqualToString:@""], 
                 @"Error (FacebookManager): Undefined Application ID");
        _facebook = [[Facebook alloc] initWithAppId:kFacebookAppId andDelegate:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:kUserDefaultsKeyFBToken] 
            && [defaults objectForKey:kUserDefaultsKeyFBExpireDate]) {
            _facebook.accessToken = [defaults objectForKey:kUserDefaultsKeyFBToken];
            _facebook.expirationDate = [defaults objectForKey:kUserDefaultsKeyFBExpireDate];
        }
    }
    
    return self;
}

- (void)dealloc {
    [_requestQueue release], _requestQueue = nil;
    
    _facebook.sessionDelegate = nil;
    [_facebook release], _facebook = nil;

    [super dealloc];
}

- (void)requestWithGraphPath:(NSString *)graphPath 
                      target:(id)target
                    selector:(SEL)selector{
    
    NSMethodSignature *signature = 
        [target methodSignatureForSelector:selector];
    
    NSAssert(
        signature.numberOfArguments == 2+2, 
        @"Error (FacebookManager): requestWithGraphPath (Num of arguments must be 2)"
    );
    
    NSInvocation *invocation = 
        [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:graphPath forKey:@"graphPath"];
    [request setObject:invocation forKey:@"invocation"];
    
    [_requestQueue addObject:request];
}


- (void)doRequests {
    
    
    if (![_facebook isSessionValid]) {
        // If you want to request additional permissions, set below.
        NSArray *permissions = nil;

        [_facebook authorize:permissions];
        
        return;
    }
    
    [self _performQueue];
    
}

- (void)_performQueue {
    for (NSMutableDictionary *queue in _requestQueue) {
        FBRequest *request =
        [[_facebook requestWithGraphPath:[queue objectForKey:@"graphPath"] 
                             andDelegate:self] 
         retain];
        
        [queue setObject:request forKey:@"request"];
    }
}

#pragma mark - FBSessionDelegate


- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:kUserDefaultsKeyFBToken];
    [defaults setObject:[_facebook expirationDate] forKey:kUserDefaultsKeyFBExpireDate];
    [defaults synchronize];
    
    [self _performQueue];
}



#pragma mark - FBRequestDelegate
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSDictionary *theQueue;
    
    for (NSMutableDictionary *queue in _requestQueue) {
        if ([queue objectForKey:@"request"] == request) {
            theQueue = queue;
        }
    }
    
    NSInvocation *invocation = [theQueue objectForKey:@"invocation"];
    [invocation setArgument:&request atIndex:2]; // 2以降を使用する
    [invocation setArgument:&result atIndex:3];
    
    [invocation invoke];
    
    // キューを削除
    [_requestQueue removeObject:theQueue];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
    NSLog(@"UserInfo: %@", [error userInfo]);
}

@end
