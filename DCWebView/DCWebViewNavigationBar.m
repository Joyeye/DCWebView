//
// DCWebViewNavigationBar.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import "DCWebView.h"
#import "DCWebViewNavigationBar.h"

@interface DCWebViewNavigationBar() <UIActionSheetDelegate> {
    NSMutableArray *toolbarItems;

    UIBarButtonItem *refreshItem;
    UIBarButtonItem *indicatorItem;
    UIBarButtonItem *actionsItem;
    UIBarButtonItem *forwardItem;
    UIBarButtonItem *backItem;
    UIBarButtonItem *closeItem;
    
    UIActivityIndicatorView *indicator;
    UIProgressView *progressView;
    
    UIStatusBarStyle statusBarStyle;
    UIActionSheet *actionSheet;
}

@property (nonatomic, copy)DCWebViewLoadingCompletionHandler completionHandler;

@end

@implementation DCWebViewNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIBarButtonItem *flexibleItem = DC_SAFE_ARC_AUTORELEASE([[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                         target:nil
                                         action:nil]);
        
        forwardItem = [[UIBarButtonItem alloc] initWithImage:[self forwardArrowImage]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(handleForwardButtonTapped:)];
        
        backItem = [[UIBarButtonItem alloc] initWithImage:[self backArrowImage]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(handleBackButtonTapped:)];
        
        closeItem = [[UIBarButtonItem alloc] initWithTitle:([[self systemLanguage] hasPrefix:@"zh"]) ? @"关闭" : @"Close"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(handleCloseButtonTapped:)];
        
        refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                    target:self
                                                                    action:@selector(handleRefreshButtonTapped:)];
        
        actionsItem = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                       target:self
                       action:@selector(handleActionButtonTapped:)];
        
        [actionsItem setStyle:UIBarButtonItemStylePlain];
        
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator setHidesWhenStopped:YES];
        indicatorItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
        
        toolbarItems = [[NSMutableArray alloc] initWithObjects:
                                   flexibleItem, backItem,
                                   flexibleItem, forwardItem,
                                   flexibleItem, indicatorItem,
                                   flexibleItem, actionsItem,
                                   flexibleItem, closeItem,
                                   flexibleItem, nil];

        [self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth ];
        [self setItems:toolbarItems];
        [self setBarStyle:UIBarStyleBlack];
        [self setTintColor:[UIColor grayColor]];
        
        [self updateNavigatorStatus];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame webView:(DCWebView *)webView completionHandler:(DCWebViewLoadingCompletionHandler)completionHandler closeHandler:(DCWebViewNavigationBarCloseHandler)closeHandler
{
    self = [self initWithFrame:frame];
    
    if (self) {
        [self setWebView:webView];
        
        CGFloat topMargin = self.webView.isStatusBarHidden ? 0.0f : (self.webView.isNavigationBarHidden? DC_DEFAULT_STATUES_BAR_HEIGHT : DC_DEFAULT_TOOLBAR_HEIGHT+DC_DEFAULT_STATUES_BAR_HEIGHT);
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0f, topMargin, CGRectGetWidth(self.frame), 2.0f)];
        [progressView setAlpha:1.0f];
        
        if (self.webView && [self.webView supportProgressEstimation]) {
            [self.webView addSubview:progressView];
            [self.webView bringSubviewToFront:progressView];
        }
        
        [self.webView setLoadingCompletionHandler:completionHandler];
        [self setCloseHandler:closeHandler];
    }
    
    return self;
}

- (void)dealloc
{
    DC_SAFE_ARC_RELEASE(toolbarItems);
    
    DC_SAFE_ARC_RELEASE(refreshItem);
    DC_SAFE_ARC_RELEASE(indicatorItem);
    DC_SAFE_ARC_RELEASE(actionsItem);
    DC_SAFE_ARC_RELEASE(forwardItem);
    DC_SAFE_ARC_RELEASE(backItem);
    DC_SAFE_ARC_RELEASE(closeItem);
    
    DC_SAFE_ARC_RELEASE(indicator);
    DC_SAFE_ARC_RELEASE(actionSheet);
    
    DC_SAFE_ARC_SUPER_DEALLOC();
}

- (void)startIndicatorAnimating
{
    [indicator startAnimating];
}

- (void)stopIndicatorAnimating
{
    [indicator stopAnimating];
}

- (void)updateNavigatorStatus
{
    UIBarButtonItem *item = [toolbarItems objectAtIndex:1];
    [item setEnabled:self.webView.canGoBack ? YES : NO];
    item = [toolbarItems objectAtIndex:3];
    [item setEnabled:self.webView.canGoForward ? YES : NO];
}

- (void)updateProgressView:(double)estimatedProgress
{
    if (progressView.alpha == 0.0f) {
        [progressView setAlpha:1.0f];
    }
    
    [progressView setProgress:estimatedProgress animated:YES];
}

- (void)hideProgressView
{
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [progressView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [progressView setProgress:0.0f animated:NO];
    }];
}

#pragma mark -
#pragma mark - Button Actions

- (void)handleActionButtonTapped:(id)sender
{
    if (actionSheet != nil) {
        actionSheet = nil;
    }
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"Open in Safari", nil];
    
    if ([UIActionSheet instancesRespondToSelector:@selector(showFromBarButtonItem:animated:)]) {
        [actionSheet showFromBarButtonItem:actionsItem animated:YES];
    } else {
        [actionSheet showInView:self.webView];
    }
}

- (void)handleBackButtonTapped:(id)sender
{
    if ([self.webView canGoBack])
        [self.webView goBack];
}

- (void)handleForwardButtonTapped:(id)sender
{
    if ([self.webView canGoForward])
        [self.webView goForward];
}

- (void)handleRefreshButtonTapped:(id)sender
{
    [self.webView reload];
}

- (void)handleCancelButtonTapped:(id)sender
{
    if ([self.webView loading]) {
        [self.webView stopLoading];
    }
}

- (void)handleCloseButtonTapped:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:1 animated:NO];
    
    if (self.closeHandler) {
        self.closeHandler();
    }
}

- (void)handleActionsButtonTapped:(id)sender
{
    if (!actionSheet) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
        
        if ([UIActionSheet instancesRespondToSelector:@selector(showFromBarButtonItem:animated:)]) {
            [actionSheet showFromBarButtonItem:actionsItem animated:YES];
        }
        else {
            [actionSheet showInView:self.webView];
        }
    }
}

#pragma mark -
#pragma mark - Utils

- (NSString *)systemLanguage
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *sysLanguage = [languages objectAtIndex:0];
    
    return sysLanguage;
}

#pragma mark -
#pragma mark - Drawing Navigator Buttons

- (CGContextRef)createContext
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0,colorSpace,kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    
    return context;
}
- (UIImage *)backArrowImage
{
    UIImage *image = nil;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)) {
        CGSize size = CGSizeMake(24.0f, 25.0f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.5;
        path.lineCapStyle = kCGLineCapButt;
        path.lineJoinStyle = kCGLineJoinMiter;
        [path moveToPoint:CGPointMake(11.0, 4.0)];
        [path addLineToPoint:CGPointMake(1.0, 14.0)];
        [path addLineToPoint:CGPointMake(11.0, 23.0)];
        [[UIColor whiteColor] setStroke];
        [path stroke];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else {
        CGContextRef context = [self createContext];
        CGColorRef fillColor = [[UIColor blackColor] CGColor];
        CGContextSetFillColor(context, CGColorGetComponents(fillColor));
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 8.0f, 13.0f);
        CGContextAddLineToPoint(context, 24.0f, 4.0f);
        CGContextAddLineToPoint(context, 24.0f, 22.0f);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        image = DC_SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithCGImage:imageRef]);
        CGImageRelease(imageRef);
    }
    
    return image;
}

- (UIImage *)forwardArrowImage
{
    UIImage *image = nil;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)) {
        CGSize size = CGSizeMake(24.0f, 25.0f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.5;
        path.lineCapStyle = kCGLineCapButt;
        path.lineJoinStyle = kCGLineJoinMiter;
        [path moveToPoint:CGPointMake(1.0, 4.0)];
        [path addLineToPoint:CGPointMake(11.0, 14.0)];
        [path addLineToPoint:CGPointMake(1.0, 23.0)];
        [[UIColor whiteColor] setStroke];
        [path stroke];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else {
        CGContextRef context = [self createContext];
        CGColorRef fillColor = [[UIColor blackColor] CGColor];
        CGContextSetFillColor(context, CGColorGetComponents(fillColor));
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 24.0f, 13.0f);
        CGContextAddLineToPoint(context, 8.0f, 4.0f);
        CGContextAddLineToPoint(context, 8.0f, 22.0f);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        image = DC_SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithCGImage:imageRef]);
        CGImageRelease(imageRef);
    }
    
    return image;
}

#pragma mark -
#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)anActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (self.webView.loadingCompletionHandler) {
            self.webView.loadingCompletionHandler(nil);
        }
        
        if (self.webView.URL && [[UIApplication sharedApplication] canOpenURL:self.webView.URL]) {
            [[UIApplication sharedApplication] openURL:self.webView.URL];
        }
    }
    
    actionSheet = nil;
}

@end
