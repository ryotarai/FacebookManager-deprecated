FacebookManager
  by Ryota Arai
====================
This is a facebook wrapper for iOS which supports Single Sign On(http://developers.facebook.com/docs/guides/mobile/ios_sso/).
====================
>>Prepare
1. Set application ID to kFacebookAppId in FacebookManager.m
2. Edit plist file to define URL scheme.
(c.f. http://developers.facebook.com/docs/guides/mobile/ios_sso/)
3. Write code as below in your application delegate.

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    FacebookManager *manager = [FacebookManager sharedManager];
    return [manager.facebook handleOpenURL:url];
}
====================
>>Usage
[[FacebookManager sharedManager] 
requestWithGraphPath:@"me" 
target:self 
selector:@selector(meFacebookRequest:didLoad:)];
    
[[FacebookManager sharedManager] doRequests];
====================
>> How to request additional permissions.
Edit doRequest method in FacebookManager.m.