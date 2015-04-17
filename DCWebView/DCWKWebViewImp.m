//
// DCWKWebViewImp.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <WebKit/WebKit.h>

#import "DCWebViewNavigation.h"
#import "DCWKWebViewImp.h"

#define DC_WEB_VIEW_SCRIPT_HANDLER_NAME @"observer"

@interface DCWKWebViewImp () <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate> {
    WKWebView *webView;
    WKWebViewConfiguration *webViewConfiguration;
}

@end

@implementation DCWKWebViewImp

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setSupportProgressEstimation:YES];
        
        webView = [[WKWebView alloc] initWithFrame:self.bounds];

        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setUIDelegate:self];
        [webView setNavigationDelegate:self];
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addSubview:webView];
        
        [webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setScriptHandlerName:scriptHandlerName];
        [self setSupportProgressEstimation:YES];
        
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        [userController addUserScript:userScript];
        [webViewConfiguration setUserContentController:userController];
        
        if (self.scriptHandlerName && [self.scriptHandlerName length] > 0) {
            [userController addScriptMessageHandler:self name:self.scriptHandlerName];
        }
        else {
            [userController addScriptMessageHandler:self name:DC_WEB_VIEW_SCRIPT_HANDLER_NAME];
        }
        
        webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:webViewConfiguration];
        
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setUIDelegate:self];
        [webView setNavigationDelegate:self];
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addSubview:webView];
        
        [webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    
    return self;
}

- (void)dealloc
{
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    DC_SAFE_ARC_RELEASE(webView);
    
    DC_SAFE_ARC_SUPER_DEALLOC();
}

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL
{
    [webView loadHTMLString:HTMLString baseURL:baseURL];
}

- (void)setIsStatusBarHidden:(BOOL)isStatusBarHidden
{
    [super setIsStatusBarHidden:isStatusBarHidden];
    
    if (isStatusBarHidden) {
        if (self.isNavigationBarHidden) {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        }
        else {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
        }
    }
    else {
        if (self.isNavigationBarHidden) {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
        }
        else {
            [webView setFrame:CGRectMake(webView.frame.origin.x, DC_DEFAULT_STATUES_BAR_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
        }
    }
}

- (void)setIsNavigationBarHidden:(BOOL)isNavigationBarHidden
{
    [super setIsNavigationBarHidden:isNavigationBarHidden];
    
    if (isNavigationBarHidden) {
        if (self.isStatusBarHidden) {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        }
        else {
            [webView setFrame:CGRectMake(webView.frame.origin.x, DC_DEFAULT_STATUES_BAR_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_STATUES_BAR_HEIGHT)];
        }
    }
    else {
        if (self.isStatusBarHidden) {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
        }
        else {
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
        }
    }
}

- (BOOL)canGoBack
{
    return [webView canGoBack];
}

- (BOOL)canGoForward
{
    return [webView canGoForward];
}

- (BOOL)loading
{
    return [webView isLoading];
}

- (DCWebViewNavigation *)goBack
{
    [webView goBack];
    [self.navigation setNavigationType:kDCWebViewNavigationTypeBackForward];
    
    return self.navigation;
}

- (DCWebViewNavigation *)goForward
{
    [webView goForward];
    [self.navigation setNavigationType:kDCWebViewNavigationTypeBackForward];
    
    return self.navigation;
}

- (DCWebViewNavigation *)reload
{
    [webView reload];
    [self.navigation setNavigationType:kDCWebViewNavigationTypeReload];
    
    return self.navigation;
}

- (DCWebViewNavigation *)reloadFromOrigin
{
    [webView reloadFromOrigin];
    [self.navigation setNavigationType:kDCWebViewNavigationTypeReloadFromOrigin];
    
    return self.navigation;
}

- (void)stopLoading
{
    [webView stopLoading];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(DCWebViewJavaScriptEvaluatingCompletionHandler)completionHandler
{
    [webView evaluateJavaScript:javaScriptString completionHandler:^(id result, NSError *error) {
        if (completionHandler) {
            completionHandler(result, error);
        }
    }];
}

- (void)setSelectionGranularity:(DCWebViewSelectionGranularity)selectionGranularity
{
    if (webView.configuration) {
        [webView.configuration setSelectionGranularity:(WKSelectionGranularity)selectionGranularity];
    }
}

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures
{
    if (webView) {
        [webView setAllowsBackForwardNavigationGestures:allowsBackForwardNavigationGestures];
    }
}

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    if (webView.configuration) {
        [webView.configuration setSuppressesIncrementalRendering:suppressesIncrementalRendering];
    }
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    if (webView.configuration) {
        [webView.configuration setAllowsInlineMediaPlayback:allowsInlineMediaPlayback];
    }
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    if (webView.configuration) {
        [webView.configuration setMediaPlaybackRequiresUserAction:mediaPlaybackRequiresUserAction];
    }
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    if (webView.configuration) {
        [webView.configuration setMediaPlaybackAllowsAirPlay:mediaPlaybackAllowsAirPlay];
    }
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    // Do nothing
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    // Do nothing
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    // Do nothing
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    // Do nothing
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    // Do nothing
}

- (void)setPageLength:(CGFloat)pageLength
{
    // Do nothing
}

- (void)setGapBetweenPages:(CGFloat)gapBetweenPages
{
    // Do nothing
}

- (NSUInteger)pageCount
{
    return 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual: @"estimatedProgress"] && object == webView) {
        if (self.loadingProgressHandler) {
            self.loadingProgressHandler(webView.estimatedProgress);
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark - WKScriptMessageHandler Delegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.scriptMessageReceivedHandler) {
        if (message) {
            self.scriptMessageReceivedHandler(message.body, message.name, nil);
        }
        else {
            self.scriptMessageReceivedHandler(nil, nil, [NSError errorWithDomain:@"" code:1111 userInfo:nil]);
        }
    }
}

#pragma mark -
#pragma mark - WKNavigationDelegate Delegate

// Decides whether to allow or cancel a navigation
// according to webView, navigationAction which
// includes HTTP request info, e.g., User Agent,
// Accept in the HTTP header

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    switch (navigationAction.navigationType) {
        case WKNavigationTypeBackForward: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeBackForward];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeFormSubmitted];
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeFormResubmitted];
            break;
        }
        case WKNavigationTypeLinkActivated: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeLinkActivated];
            
            if (self.linkActivatedHandler) {
                self.linkActivatedHandler(navigationAction.request.URL);
            }
            
            break;
        }
        case WKNavigationTypeReload: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeReload];
            break;
        }
        case WKNavigationTypeOther: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeOther];
            break;
        }
        default:
            break;
    }
    
    if (decisionHandler) {
        decisionHandler((WKNavigationActionPolicy)self.navigationActionPolicy);
    }

    [self.navigation setURLScheme:[navigationAction.request.URL scheme]];
    
    if (self.navigationActionHandler) {
        self.navigationActionHandler(self.navigation.URLScheme);
    }
}

// Decides whether to allow or cancel a navigation according to
// its response.
//
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if (decisionHandler) {
        decisionHandler((WKNavigationResponsePolicy)self.navigationResponsePolicy);
    }
}

// Invoked when a main frame navigation starts.

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (self.loadingStartHandler) {
        self.loadingStartHandler();
    }
}

// Invoked when a server redirect is received for the main
// frame.

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    if (self.serverRedirectHandler) {
        self.serverRedirectHandler((DCWebViewNavigation *)navigation);
    }
}

// Invoked when an error occurs while starting to load data for
// the main frame.

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (self.loadingCompletionHandler) {
        self.loadingCompletionHandler(error);
    }
}

// Invoked when content starts arriving for the main frame.

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if (self.loadingStartHandler) {
        self.loadingStartHandler();
    }
}

// Invoked when a main frame navigation completes.

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.loadingCompletionHandler) {
        self.loadingCompletionHandler(nil);
    }
}

// Invoked when an error occurs during a committed main frame
// navigation.

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (self.loadingCompletionHandler) {
        self.loadingCompletionHandler(error);
    }
}

// Invoked when the web view needs to respond to an authentication challenge.
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
}

#pragma mark -
#pragma mark - WKUIDelegate Delegate

// Invoked after web view created.
- (WKWebView *)webView:(WKWebView *)aWebView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return webView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(DCWebViewCompletionHandler)completionHandler
{
    if (self.javaScriptAlertHandler) {
        self.javaScriptAlertHandler(message, completionHandler);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    if (self.javaScriptConfirmHandler) {
        self.javaScriptConfirmHandler(message, completionHandler);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
{
    if (self.javaScriptTextInputHandler) {
        self.javaScriptTextInputHandler(prompt, defaultText, completionHandler);
    }
}

@end
