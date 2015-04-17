//
// DCWebViewDemoViewController.m
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import "DCWebView.h"
#import "DCWebViewController.h"
#import "DCWebViewDemoViewController.h"

#define kDCWebViewDemoViewDefaultButtonWidth 275
#define kDCWebViewDemoViewDefaultButtonHeight 44
#define kDCWebViewDemoViewSmallButtonWidth 90
#define kDCWebViewDemoViewSmallButtonHeight 30

@interface DCWebViewDemoViewController ()

@end

@implementation DCWebViewDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*2)];
    [self setView:scrollView];
    
    UIButton *mode1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode1Button setTitle:@"StatusBar+Navigator/Push" forState:UIControlStateNormal];
    [mode1Button setBackgroundColor:[UIColor redColor]];
    
    if (IS_IOS_7) {
        [mode1Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, 20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    }
    else {
        [mode1Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, 20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    }
    
    [mode1Button setClipsToBounds:YES];
    [mode1Button.layer setCornerRadius:5.0f];
    [mode1Button addTarget:self action:@selector(handleMode1ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode1Button];
    
    UIButton *mode2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode2Button setTitle:@"StatusBar+Navigator/Present" forState:UIControlStateNormal];
    [mode2Button setBackgroundColor:[UIColor redColor]];
    
    [mode2Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode1Button.frame.origin.y+mode1Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    
    [mode2Button setClipsToBounds:YES];
    [mode2Button.layer setCornerRadius:5.0f];
    [mode2Button addTarget:self action:@selector(handleMode2ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode2Button];
    
    UIButton *mode3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode3Button setTitle:@"StatusBar/Push" forState:UIControlStateNormal];
    [mode3Button setBackgroundColor:[UIColor redColor]];
    [mode3Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode2Button.frame.origin.y+mode2Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode3Button setClipsToBounds:YES];
    [mode3Button.layer setCornerRadius:5.0f];
    [mode3Button addTarget:self action:@selector(handleMode3ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode3Button];
    
    UIButton *mode4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode4Button setTitle:@"StatusBar/Present" forState:UIControlStateNormal];
    [mode4Button setBackgroundColor:[UIColor redColor]];
    [mode4Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode3Button.frame.origin.y+mode3Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode4Button setClipsToBounds:YES];
    [mode4Button.layer setCornerRadius:5.0f];
    [mode4Button addTarget:self action:@selector(handleMode4ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode4Button];
    
    UIButton *mode5Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode5Button setTitle:@"Navigator/Push" forState:UIControlStateNormal];
    [mode5Button setBackgroundColor:[UIColor redColor]];
    [mode5Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode4Button.frame.origin.y+mode4Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode5Button setClipsToBounds:YES];
    [mode5Button.layer setCornerRadius:5.0f];
    [mode5Button addTarget:self action:@selector(handleMode5ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode5Button];
    
    UIButton *mode6Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode6Button setTitle:@"Navigator/Present" forState:UIControlStateNormal];
    [mode6Button setBackgroundColor:[UIColor redColor]];
    [mode6Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode5Button.frame.origin.y+mode5Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode6Button setClipsToBounds:YES];
    [mode6Button.layer setCornerRadius:5.0f];
    [mode6Button addTarget:self action:@selector(handleMode6ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode6Button];
    
    UIButton *mode7Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode7Button setTitle:@"Full Screen/Push" forState:UIControlStateNormal];
    [mode7Button setBackgroundColor:[UIColor redColor]];
    [mode7Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode6Button.frame.origin.y+mode6Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode7Button setClipsToBounds:YES];
    [mode7Button.layer setCornerRadius:5.0f];
    [mode7Button addTarget:self action:@selector(handleMode7ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode7Button];
    
    UIButton *mode8Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode8Button setTitle:@"Full Screen/Present" forState:UIControlStateNormal];
    [mode8Button setBackgroundColor:[UIColor redColor]];
    [mode8Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode7Button.frame.origin.y+mode7Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode8Button setClipsToBounds:YES];
    [mode8Button.layer setCornerRadius:5.0f];
    [mode8Button addTarget:self action:@selector(handleMode8ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode8Button];
    
    UIButton *mode9Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [mode9Button setTitle:@"Init with Java Script/Web UI" forState:UIControlStateNormal];
    [mode9Button setBackgroundColor:[UIColor redColor]];
    [mode9Button setFrame:CGRectMake((self.view.frame.size.width-kDCWebViewDemoViewDefaultButtonWidth)/2, mode8Button.frame.origin.y+mode8Button.frame.size.height+20.0f, kDCWebViewDemoViewDefaultButtonWidth, kDCWebViewDemoViewDefaultButtonHeight)];
    [mode9Button setClipsToBounds:YES];
    [mode9Button.layer setCornerRadius:5.0f];
    [mode9Button addTarget:self action:@selector(handleMode9ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mode9Button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CGRectGetWidth(self.view.frame) < CGRectGetHeight(self.view.frame)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DC_SAFE_ARC_SUPER_DEALLOC();
}

- (void)handleMode1ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:NO navigationBarHidden:NO autorotate:NO]);
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleMode2ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:NO navigationBarHidden:NO autorotate:NO]);
    UINavigationController *navigationController = DC_SAFE_ARC_AUTORELEASE([[UINavigationController alloc] initWithRootViewController:viewController]);
    
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
}

- (void)handleMode3ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:NO navigationBarHidden:YES autorotate:NO]);
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleMode4ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:NO navigationBarHidden:YES autorotate:NO]);
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)handleMode5ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:YES navigationBarHidden:NO autorotate:NO]);
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleMode6ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:YES navigationBarHidden:NO autorotate:NO]);
    [self.navigationController presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)handleMode7ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:YES navigationBarHidden:YES autorotate:NO]);
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleMode8ButtonTapped:(id)sender
{
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] statusBarHidden:YES navigationBarHidden:YES autorotate:NO]);
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)handleMode9ButtonTapped:(id)sender
{
    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('Found' + count + 'pictures');";
    
    DCWebViewController *viewController = DC_SAFE_ARC_AUTORELEASE([[ DCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"] javaScriptString:js statusBarHidden:NO navigationBarHidden:NO autorotate:NO]);
    [self presentViewController:viewController animated:YES completion:^{
        
        [viewController.webView loadHTMLString:@"<head></head><img src='http://pic.gicpic.cn/bigimg/centerwater/11896000/74196fef2.jpg' />" baseURL:nil];
        
    }];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
