//
// DCWebView.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import "DCARCMacros.h"
#import "DCWKWebViewImp.h"
#import "DCUIWebViewImp.h"
#import "DCWebViewNavigation.h"
#import "DCWebViewNavigationBar.h"
#import "DCWebView.h"

@class DCWebView;
@class DCWebViewNavigation;
@class DCWebViewNavigaionBar;

@interface DCWebViewFactory : NSObject

- (DCWebView *)createWebViewWithFrame:(CGRect)frame;
- (DCWebView *)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL scriptHandleName:(NSString *)scriptHandlerName;
- (DCWebViewNavigaionBar *)createWebViewNavigationBar:(CGRect)frame;

@end

@implementation DCWebViewFactory

static DCWebViewFactory *_sharedInstance = nil;

+ (instancetype)sharedWebViewFactory
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DCWebViewFactory alloc] init];
    });
    
    return _sharedInstance;
}

- (void)dealloc
{
    DC_SAFE_ARC_RELEASE(_sharedInstance);
    DC_SAFE_ARC_SUPER_DEALLOC();
}

- (DCWebView *)createWebViewWithFrame:(CGRect)frame
{
    DCWebView *webView = nil;
    
    if (NSClassFromString(@"WKWebView")) {
        webView = [[DCWKWebViewImp alloc] initWithFrame:frame];
    }
    else {
        webView = [[DCUIWebViewImp alloc] initWithFrame:frame];
    }
    
    return DC_SAFE_ARC_AUTORELEASE(webView);
}

- (DCWebView *)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL
{
    DCWebView *webView = nil;
    
    if (NSClassFromString(@"WKWebView")) {
        webView = [[DCWKWebViewImp alloc] initWithFrame:frame URL:URL];
    }
    else {
        webView = [[DCUIWebViewImp alloc] initWithFrame:frame URL:URL];
    }
    
    return DC_SAFE_ARC_AUTORELEASE(webView);
}

- (DCWebView *)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName
{
    DCWebView *webView = nil;
    
    if (NSClassFromString(@"WKWebView")) {
        webView = [[DCWKWebViewImp alloc] initWithFrame:frame URL:URL javaScriptString:javaScriptString scriptHandleName:scriptHandlerName];
    }
    else {
        webView = [[DCUIWebViewImp alloc] initWithFrame:frame URL:URL];
    }
    
    return DC_SAFE_ARC_AUTORELEASE(webView);
}

- (DCWebViewNavigationBar *)createWebViewNavigationBar:(CGRect)frame
{
    return nil;
}

@end

@implementation DCWebView

+ (instancetype)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL
{
    return [[DCWebViewFactory sharedWebViewFactory] createWebViewWithFrame:frame URL:URL];
}

+ (instancetype)createWebViewWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName;
{
    return [[DCWebViewFactory sharedWebViewFactory] createWebViewWithFrame:frame URL:URL  javaScriptString:javaScriptString scriptHandleName:scriptHandlerName];
}

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName
{
    self = [[DCWebViewFactory sharedWebViewFactory] createWebViewWithFrame:frame URL:URL  javaScriptString:javaScriptString scriptHandleName:scriptHandlerName];
    
    if (self) {
        _URL = [[NSURL alloc] initWithString:[URL absoluteString]];
        _scriptHandlerName = scriptHandlerName;
        _navigationResponsePolicy = kDCNavigationResponsePolicyAllow;
        _navigationActionPolicy = kDCNavigationActionPolicyAllow;
//        [self setBackgroundColor:[UIColor redColor]];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName completionHandler:(DCWebViewLoadingCompletionHandler)completionHandler
{
    self = [self initWithFrame:frame URL:URL javaScriptString:javaScriptString scriptHandleName:scriptHandlerName];
    
    if (self) {
        [self setLoadingCompletionHandler:completionHandler];
    }
    
    return self;
}

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL
{
    
}


- (void)dealloc
{
    DC_SAFE_ARC_RELEASE(_URL);

    DC_SAFE_ARC_SUPER_DEALLOC();
}


- (DCWebViewNavigation *)navigation
{
    if (!_navigation) {
        _navigation = [[DCWebViewNavigation alloc] init];
    }
    
    return _navigation;
}

@end
