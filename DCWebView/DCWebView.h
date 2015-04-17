//
// DCWebView.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>
#import "DCARCMacros.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IS_IOS_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define IS_IOS_5 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)

#define DC_DEFAULT_STATUES_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define DC_DEFAULT_TOOLBAR_HEIGHT 44

@class DCWebViewNavigation;

typedef NS_ENUM(NSInteger, DCWebViewSelectionGranularity) {
    kDCWebViewSelectionGranularityDynamic,
    kDCWebViewSelectionGranularityCharacter
};

typedef NS_ENUM(NSInteger, DCNavigationResponsePolicy) {
    kDCNavigationResponsePolicyCancel,
    kDCNavigationResponsePolicyAllow
};

typedef NS_ENUM(NSInteger, DCNavigationActionPolicy) {
    kDCNavigationActionPolicyCancel,
    kDCNavigationActionPolicyAllow
};

// Blocks for navigation
typedef void (^DCWebViewLoadingStartHandler)();
typedef void (^DCWebViewLoadingProgressHandler)(double estimatedProgress);
typedef void (^DCWebViewLoadingCompletionHandler)(NSError *error);
typedef void (^DCWebViewNavigationActionHandler)(NSString *URLScheme);
typedef void (^DCWebViewServerRedirectHandler)(DCWebViewNavigation *navigation);
typedef void (^DCWebViewLinkActivatedHandler)(NSURL *URL);
typedef void (^DCWebViewNavigationDecisionHandler)(DCNavigationResponsePolicy policy);

// Blocks for Java Script evaluating
typedef void (^DCWebViewJavaScriptEvaluatingCompletionHandler)(id result, NSError *error);
typedef void (^DCWebViewJavaScriptMessageReceivedHandler)(id messageBody, NSString *messageName, NSError *error);

// Blocks for Web UI in pages
typedef void (^DCWebViewCompletionHandler)();
typedef void (^DCWebViewCompletionHandlerWithBoolValue)(BOOL result);
typedef void (^DCWebViewCompletionHandlerWithStringValue)(NSString *result);
typedef void (^DCWebViewJavaScriptAlertHandler)(NSString *message, DCWebViewCompletionHandler completionHandler);
typedef void (^DCWebViewJavaScriptConfirmHandler)(NSString *message, DCWebViewCompletionHandlerWithBoolValue completionHandler);
typedef void (^DCWebViewJavaScriptTextInputHandler)(NSString *prompt, NSString *text, DCWebViewCompletionHandlerWithStringValue completionHandler);

@interface DCWebView : UIView

@property (nonatomic, readonly)NSURL *URL;
@property (nonatomic, assign)BOOL isAutorotate;
@property (nonatomic, assign)BOOL isStatusBarHidden;
@property (nonatomic, assign)BOOL isNavigationBarHidden;
@property (nonatomic, readonly)BOOL canGoBack;
@property (nonatomic, readonly)BOOL canGoForward;
@property (nonatomic, readonly)BOOL loading;

// Both UIWebView and WKWebView properties
@property (nonatomic, assign)BOOL suppressesIncrementalRendering; // A Boolean value indicating whether the web view suppresses content rendering until it is fully loaded into memory
@property (nonatomic, assign)BOOL allowsInlineMediaPlayback; // A Boolean value indicating whether HTML5 videos play inline(YES) or use the native full-screen controller (NO)
@property (nonatomic, assign)BOOL mediaPlaybackRequiresUserAction; // A Boolean value indicating whether HTML5 videos require the user to start playing them (YES) or can play automatically (NO)
@property (nonatomic, assign)BOOL mediaPlaybackAllowsAirPlay; // A Boolean value indicating whether AirPlay is allowed.

// UIWebView(since iOS 5.1)-only properties
@property (nonatomic, assign)BOOL keyboardDisplayRequiresUserAction; // default is YES
@property (nonatomic, assign)BOOL scalesPageToFit;
@property (nonatomic, assign)UIDataDetectorTypes dataDetectorTypes;

// UIWebView(since iOS 7.0)-only properties
@property (nonatomic, assign)UIWebPaginationMode paginationMode;
@property (nonatomic, assign)UIWebPaginationBreakingMode paginationBreakingMode;
@property (nonatomic, assign)CGFloat pageLength;
@property (nonatomic, assign)CGFloat gapBetweenPages;
@property (nonatomic, readonly)NSUInteger pageCount;

// WKWebView-only properties
@property (nonatomic, assign)DCWebViewSelectionGranularity selectionGranularity; // The level of granularity with which the user can interactively select content in the web view.
@property (nonatomic, assign)BOOL allowsBackForwardNavigationGestures; // A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations.

@property (nonatomic, DC_STRONG)DCWebViewNavigation *navigation;
@property (nonatomic, DC_STRONG)NSString *scriptHandlerName;

// Block properites for navigation.
@property (nonatomic, copy)DCWebViewLoadingStartHandler loadingStartHandler;
@property (nonatomic, copy)DCWebViewLoadingProgressHandler loadingProgressHandler;
@property (nonatomic, copy)DCWebViewLoadingCompletionHandler loadingCompletionHandler;
@property (nonatomic, copy)DCWebViewNavigationActionHandler navigationActionHandler;
@property (nonatomic, copy)DCWebViewServerRedirectHandler serverRedirectHandler;
@property (nonatomic, copy)DCWebViewLinkActivatedHandler linkActivatedHandler;
@property (nonatomic, assign)DCNavigationResponsePolicy navigationResponsePolicy;
@property (nonatomic, assign)DCNavigationActionPolicy navigationActionPolicy;
@property (nonatomic, assign)BOOL supportProgressEstimation;

// Block properites for Java Script evaluating.
@property (nonatomic, copy)DCWebViewJavaScriptEvaluatingCompletionHandler scriptCompletionHandler;
@property (nonatomic, copy)DCWebViewJavaScriptMessageReceivedHandler scriptMessageReceivedHandler;

// Block properites for Java Script Web UI.
@property (nonatomic, copy)DCWebViewJavaScriptAlertHandler javaScriptAlertHandler;
@property (nonatomic, copy)DCWebViewJavaScriptConfirmHandler javaScriptConfirmHandler;
@property (nonatomic, copy)DCWebViewJavaScriptTextInputHandler javaScriptTextInputHandler;

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName;
- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName completionHandler:(DCWebViewLoadingCompletionHandler)completionHandler;
+ (instancetype)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL;
+ (instancetype)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName;

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;
- (DCWebViewNavigation *)goBack;
- (DCWebViewNavigation *)goForward;
- (DCWebViewNavigation *)reload;
- (DCWebViewNavigation *)reloadFromOrigin;
- (void)stopLoading;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(DCWebViewJavaScriptEvaluatingCompletionHandler)completionHandler;

@end
