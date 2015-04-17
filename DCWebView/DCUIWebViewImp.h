//
// DCUIWebViewImp.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>

#import "DCWebView.h"

@interface DCUIWebViewImp : DCWebView

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL;
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
