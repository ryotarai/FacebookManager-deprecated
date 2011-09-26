//
//  FacebookManager.h
//  Freco
//
//  Created by Arai Ryota on 11/09/20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

/*
 [Usage]
 
 1. requestWithGraphPath:target:selector:でリクエストを追加
 selectorは(FBRequest *)request, (id)resultを取るように
 
 2. doRequestsで溜まっているキューを処理する
 */



@interface FacebookManager : NSObject
<FBSessionDelegate,
FBRequestDelegate> {
    NSMutableArray *_requestQueue;
}

@property (nonatomic, retain) Facebook *facebook;

+ (FacebookManager *)sharedManager;
- (void)requestWithGraphPath:(NSString *)graphPath 
                      target:(id)target
                    selector:(SEL)selector ;
- (void)doRequests;
- (void)_performQueue;

@end
