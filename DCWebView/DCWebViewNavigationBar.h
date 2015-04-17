//
// DCWebViewNavigationBar.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>
#import "DCARCMacros.h"
#import "DCWebView.h"

typedef void(^DCWebViewNavigationBarCloseHandler)(void);

@class DCWebView;

@interface DCWebViewNavigationBar : UIToolbar

@property(nonatomic, DC_STRONG)DCWebView *webView;
@property(nonatomic, copy)DCWebViewNavigationBarCloseHandler closeHandler;

- (instancetype)initWithFrame:(CGRect)frame webView:(DCWebView *)webView completionHandler:(DCWebViewLoadingCompletionHandler)completionHandler closeHandler:(DCWebViewNavigationBarCloseHandler)closeHandler;

- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;
- (void)updateNavigatorStatus;
- (void)updateProgressView:(double)estimatedProgress;
- (void)hideProgressView;

@end
