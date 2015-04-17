//
// DCUIWebViewImp.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>

#import "DCWebViewNavigation.h"
#import "DCUIWebViewImp.h"

@interface DCUIWebViewImp () <UIWebViewDelegate> {
    UIWebView *webView;
}

@end

@implementation DCUIWebViewImp

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setSupportProgressEstimation:NO];

        webView = [[UIWebView alloc] initWithFrame:self.bounds];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setDelegate:self];
        [webView setScalesPageToFit:YES];
        [webView setAllowsInlineMediaPlayback:YES];
        [webView setMediaPlaybackRequiresUserAction:NO];
//        [self setBackgroundColor:[UIColor greenColor]];
        [self addSubview:webView];
        
        [webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    
    return self;
}

- (void)dealloc
{
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
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_TOOLBAR_HEIGHT)];
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
            [webView setFrame:CGRectMake(webView.frame.origin.x, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-DC_DEFAULT_STATUES_BAR_HEIGHT)];
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
    [self.navigation setNavigationType:kDCWebViewNavigationTypeReloadFromOrigin];
    
    return self.navigation;
}

- (void)stopLoading
{
    [webView stopLoading];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(DCWebViewJavaScriptEvaluatingCompletionHandler)completionHandler
{
    NSString *currentUrl = [webView stringByEvaluatingJavaScriptFromString:javaScriptString];
    
    if (completionHandler) {
        completionHandler(currentUrl, currentUrl ? nil : [NSError errorWithDomain:@"" code:1111 userInfo:nil]);
    }
}

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    if ([webView respondsToSelector:@selector(setSuppressesIncrementalRendering:)]) {
        [webView setSuppressesIncrementalRendering:suppressesIncrementalRendering];
    }
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    if ([webView respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
        [webView setAllowsInlineMediaPlayback:allowsInlineMediaPlayback];
    }
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    if ([webView respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
        [webView setMediaPlaybackRequiresUserAction:mediaPlaybackRequiresUserAction];
    }
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    if ([webView respondsToSelector:@selector(setMediaPlaybackAllowsAirPlay:)]) {
        [webView setMediaPlaybackAllowsAirPlay:mediaPlaybackAllowsAirPlay];
    }
}

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    if ([webView respondsToSelector:@selector(setKeyboardDisplayRequiresUserAction:)]) {
        [webView setKeyboardDisplayRequiresUserAction:keyboardDisplayRequiresUserAction];
    }
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    if ([webView respondsToSelector:@selector(setScalesPageToFit:)]) {
        [webView setScalesPageToFit:scalesPageToFit];
    }
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes
{
    if ([webView respondsToSelector:@selector(setDataDetectorTypes:)]) {
        [webView setDataDetectorTypes:dataDetectorTypes];
    }
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    if ([webView respondsToSelector:@selector(setPaginationMode:)]) {
        [webView setPaginationMode:paginationMode];
    }
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    if ([webView respondsToSelector:@selector(setPaginationBreakingMode:)]) {
        [webView setPaginationBreakingMode:paginationBreakingMode];
    }
}

- (void)setPageLength:(CGFloat)pageLength
{
    if ([webView respondsToSelector:@selector(setPageLength:)]) {
        [webView setPageLength:pageLength];
    }
}
- (void)setGapBetweenPages:(CGFloat)gapBetweenPages
{
    if ([webView respondsToSelector:@selector(setGapBetweenPages:)]) {
        [webView setGapBetweenPages:gapBetweenPages];
    }
}

- (NSUInteger)pageCount
{
    NSUInteger count = 0;
    
    if ([webView respondsToSelector:@selector(pageCount)]) {
        count = [webView pageCount];
    }
    
    return count;
}

- (void)setSelectionGranularity:(DCWebViewSelectionGranularity)selectionGranularity
{
    // Do nothing
}

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures
{
    // Do nothing
}

- (double)estimatedProgress
{
    return 1.0;
}

#pragma mark -
#pragma mark UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = YES;
    
    switch (navigationType) {
        case UIWebViewNavigationTypeBackForward: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeBackForward];
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeFormSubmitted];
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeFormResubmitted];
            break;
        }
        case UIWebViewNavigationTypeLinkClicked: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeLinkActivated];
            
            if (self.linkActivatedHandler) {
                self.linkActivatedHandler(request.URL);
            }
            
            break;
        }
        case UIWebViewNavigationTypeReload: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeReload];
            break;
        }
        case UIWebViewNavigationTypeOther: {
            [self.navigation setNavigationType:kDCWebViewNavigationTypeOther];
            break;
        }
        default:
            break;
    }
    
    [self.navigation setURLScheme:[request.URL scheme]];
    
    if (self.navigationActionHandler) {
        self.navigationActionHandler(self.navigation.URLScheme);
    }

    result = self.navigationResponsePolicy == kDCNavigationResponsePolicyAllow ? YES : NO;
    
    return result;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.loadingStartHandler) {
        self.loadingStartHandler();
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loadingCompletionHandler) {
        self.loadingCompletionHandler(nil);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.loadingCompletionHandler) {
        self.loadingCompletionHandler(error);
    }
}

@end
