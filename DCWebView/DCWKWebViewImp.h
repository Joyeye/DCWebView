//
// DCWKWebViewImp.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#import <UIKit/UIKit.h>
#import "DCARCMacros.h"

#import "DCWebView.h"

@interface DCWKWebViewImp : DCWebView

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL;
- (id)initWithFrame:(CGRect)frame URL:(NSURL *)URL javaScriptString:(NSString *)javaScriptString scriptHandleName:(NSString *)scriptHandlerName;
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
