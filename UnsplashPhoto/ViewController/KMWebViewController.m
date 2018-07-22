//
//  KMWebViewController.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/21.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMWebViewController.h"

#import <WebKit/WebKit.h>

@interface KMWebViewController ()<WKNavigationDelegate>

/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation KMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myWebView];
    self.myWebView.frame = self.view.bounds;
    [self.view addSubview:self.myProgressView];
    
    NSArray * scopes = @[kScopePublic];
    NSString * scopeString = [scopes componentsJoinedByString:@"+"];
    
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    
    NSString * oauthURI = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=%@&scope=%@",kUnsplashAccessKey,redirectURI,@"code",scopeString];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oauthURI]]];
    
    UIBarButtonItem * closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBarButtonClicked:)];
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
    //https://unsplash.com/oauth/authorize?client_id=3eb1d95f786289b6eb3a114820bf36601f629277eb476f3d9c0522adb7b22c7a&redirect_uri=beautyPhotos%3A%2F%2Funsplash&response_type=code&scope=public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections
    // Do any additional setup after loading the view.
}

- (void)onCloseBarButtonClicked:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.myWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}

- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _myWebView.navigationDelegate = self;
        _myWebView.opaque = NO;
        _myWebView.multipleTouchEnabled = YES;
        [_myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _myWebView;
}

// 记得取消监听
- (void)dealloc
{
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
