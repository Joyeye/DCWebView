//
// DCUIWebViewNavigator.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>

#import "DCARCMacros.h"

@class DCWebView;

typedef NS_ENUM(NSInteger, DCWebViewNavigationType) {
    kDCWebViewNavigationTypeLinkActivated,
    kDCWebViewNavigationTypeBackForward,
    kDCWebViewNavigationTypeFormSubmitted,
    kDCWebViewNavigationTypeFormResubmitted,
    kDCWebViewNavigationTypeReload,
    kDCWebViewNavigationTypeReloadFromOrigin,
    kDCWebViewNavigationTypeOther
};

@interface DCWebViewNavigation : NSObject

@property (nonatomic, assign)DCWebViewNavigationType navigationType;
@property (nonatomic, DC_STRONG)NSString *URLScheme;
@property (nonatomic, DC_STRONG)DCWebView *webView;

- (instancetype)initWithWebView:(DCWebView *)webView;

@end
