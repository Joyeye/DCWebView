//
// DCWKWebViewNavigationImpl.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <WebKit/WebKit.h>

#import "DCARCMacros.h"
#import "DCWebViewNavigation.h"

@interface DCWKWebViewNavigationImpl : DCWebViewNavigation

@property (nonatomic, DC_STRONG)WKNavigation *navigator;

@end
