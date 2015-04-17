//
// DCWebViewController.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import "DCWebView.h"
#import "DCWebViewNavigationBar.h"
#import "DCWebViewController.h"

@interface DCWebViewController () <UIWebViewDelegate, UIActionSheetDelegate> {
    DCWebViewNavigationBar *navigator;
}

@end

@implementation DCWebViewController

#pragma mark -
#pragma mark View Lifecycle

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    
    if (self) {
        _URL = [[NSURL alloc] initWithString:[URL absoluteString]];
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)URL statusBarHidden:(BOOL)statusBarHidden navigationBarHidden:(BOOL)navigationBarHidden autorotate:(BOOL)autorotate
{
    self = [super init];
    
    if (self) {
        _URL = [[NSURL alloc] initWithString:[URL absoluteString]];
        _isStatusBarHidden = statusBarHidden;
        _isNavigationBarHidden = navigationBarHidden;
        _isAutorotate = autorotate;
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString statusBarHidden:(BOOL)statusBarHidden navigationBarHidden:(BOOL)navigationBarHidden autorotate:(BOOL)autorotate
{
    self = [super init];
    
    if (self) {
        _URL = [[NSURL alloc] initWithString:[URL absoluteString]];
        _userJavaScript = javaScriptString;
        _isStatusBarHidden = statusBarHidden;
        _isNavigationBarHidden = navigationBarHidden;
        _isAutorotate = autorotate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setBackActionHandler:^() {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    if (self.userJavaScript && self.userJavaScript.length > 0) {
        _webView = [[DCWebView alloc] initWithFrame:self.view.frame URL:self.URL javaScriptString:self.userJavaScript scriptHandleName:nil];
    }
    else {
        _webView = [[DCWebView alloc] initWithFrame:self.view.frame URL:self.URL javaScriptString:nil scriptHandleName:nil];
    }

    [self.webView setIsNavigationBarHidden:self.isNavigationBarHidden];
    [self.webView setIsStatusBarHidden:self.isStatusBarHidden];
    [self setView:self.webView];

    navigator = [[DCWebViewNavigationBar alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame)-DC_DEFAULT_TOOLBAR_HEIGHT, CGRectGetWidth(self.view.frame), DC_DEFAULT_TOOLBAR_HEIGHT) webView:self.webView completionHandler:^(NSError *error) {
        [navigator stopIndicatorAnimating];
        [navigator updateNavigatorStatus];
    } closeHandler:^{
        if (self.presentingType == kDCWebViewControllerPresentingPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
    
    [navigator startIndicatorAnimating];
    [self.view addSubview:navigator];

    [self.webView setLoadingStartHandler:^(void) {
        NSLog(@"Start to load web content.");
    }];

    [self.webView setLoadingCompletionHandler:^(NSError *error) {
        [navigator stopIndicatorAnimating];
        [navigator updateNavigatorStatus];

        if (error) {
            NSLog(@"Web content loaded with a error: %@", error);
        }
        else {
            NSLog(@"Web content loaded successfuly.");
        }
    }];
    
    [self.webView setNavigationActionHandler:^(NSString *URLScheme) {
        NSLog(@"URL scheme: %@", URLScheme);
    }];
    
    [self.webView setLinkActivatedHandler:^(NSURL *URL){
        NSLog(@"URL clicked: %@", [URL absoluteString]);
    }];
    
    [self.webView setLoadingProgressHandler:^(double estimatedProgress) {
        estimatedProgress >= 1.0f ? [navigator hideProgressView] : [navigator updateProgressView:estimatedProgress];
    }];

    [self setIsStatusBarHidden:self.isStatusBarHidden];
    [self setIsNavigationBarHidden:self.isNavigationBarHidden];
    
    if (self.navigationController) {
        NSLog(@"I have a navigation controller.");
        [self setPresentingType:kDCWebViewControllerPresentingPush];
    }
    else {
        NSLog(@"I haven't a navigation controller.");
        [self setPresentingType:kDCWebViewControllerPresentingPresent];
    }
    
    [self.webView setJavaScriptAlertHandler:^(NSString *message, DCWebViewCompletionHandler completionHandler)
     {
         [[[UIAlertView alloc] initWithTitle:@"Tips" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         
         completionHandler();
    }];
    
    [self.webView setJavaScriptConfirmHandler:^(NSString *message, DCWebViewCompletionHandlerWithBoolValue completionHandler)
     {
         [[[UIAlertView alloc] initWithTitle:@"Tips" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         
//         completionHandler();
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DC_SAFE_ARC_RELEASE(_webView);
    
    DC_SAFE_ARC_SUPER_DEALLOC();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self isAutorotate];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}

- (void)setIsStatusBarHidden:(BOOL)isStatusBarHidden
{
    _isStatusBarHidden = isStatusBarHidden;
    
    if (isStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    [self.webView setIsStatusBarHidden:isStatusBarHidden];
}

- (void)setIsNavigationBarHidden:(BOOL)isNavigationBarHidden
{
    _isNavigationBarHidden = isNavigationBarHidden;
    
    if (isNavigationBarHidden) {
        [navigator removeFromSuperview];
    }
    else {
        [self.view addSubview:navigator];
    }
    
    [self.webView setIsNavigationBarHidden:isNavigationBarHidden];
}

@end
