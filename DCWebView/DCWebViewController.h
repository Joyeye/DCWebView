//
// DCWebViewController.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>
#import "DCARCMacros.h"

#define kDCOpenAdInExternalBrowserNotification @"OpenAdInExternalBrowser"

typedef void (^DCWebViewControllerBackActionHandler)();

@class DCWebView;

typedef NS_ENUM(NSInteger, DCWebViewControllerPresentingType) {
    kDCWebViewControllerPresentingPresent,
    kDCWebViewControllerPresentingPush
};

@class DCWebViewController;

// DC WebViewController(Adapting WKWebView and UIWebView automatically)

@interface DCWebViewController : UIViewController;

@property (nonatomic, readonly)NSURL *URL;
@property (nonatomic, readonly)DCWebView *webView;
@property (nonatomic, readonly)NSString *userJavaScript;
@property (nonatomic, assign)BOOL isAutorotate;
@property (nonatomic, assign)BOOL isStatusBarHidden;
@property (nonatomic, assign)BOOL isNavigationBarHidden;
@property (nonatomic, assign)DCWebViewControllerPresentingType presentingType;
@property (nonatomic, copy)DCWebViewControllerBackActionHandler backActionHandler;

//
//  Init with a URL
//
//  @param URL  loading URL
//
//  @return DCWebViewController instance
//
- (id)initWithURL:(NSURL *)URL;

//
//  Init with a URL and UI layout
//
//  @param URL loading URL
//  @param statusBarHidden Whether the status bar is hidden or not
//  @param navigationBarHidden Whether the navigation bar is hidden or not
//
//  @return DCWebViewController instance
//
- (id)initWithURL:(NSURL *)URL statusBarHidden:(BOOL)statusBarHidden navigationBarHidden:(BOOL)navigationBarHidden autorotate:(BOOL)autorotate;

//
//  Init with a URL with a Java Script and UI layout
//
//  @param URL loading URL
//  @param javaScriptString User script
//  @param statusBarHidden Whether the status bar is hidden or not
//  @param navigationBarHidden Whether the navigation bar is hidden or not
//
//  @return DCWebViewController instance
//
- (id)initWithURL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString statusBarHidden:(BOOL)statusBarHidden navigationBarHidden:(BOOL)navigationBarHidden autorotate:(BOOL)autorotate;

@end
