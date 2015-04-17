//
// DCUIWebViewNavigation.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import "DCWebViewNavigation.h"

@implementation DCWebViewNavigation

- (instancetype)initWithWebView:(DCWebView *)webView
{
    self = [super init];
    
    if (self) {
        [self setWebView:webView];
    }
    
    return self;
}

@end
