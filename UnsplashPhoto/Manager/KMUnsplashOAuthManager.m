//
//  KMUnsplashOAuthManager.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/21.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMUnsplashOAuthManager.h"

static NSString * baseUrl = kUnsplashAPIBaseUrl;

@interface KMUnsplashOAuthManager()

@property(readwrite,strong)NSString * accessToken;

@end

@implementation KMUnsplashOAuthManager

+ (instancetype)shareInstance {
    
    static KMUnsplashOAuthManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareManager) {
            shareManager = [[KMUnsplashOAuthManager alloc] init];
        }
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readAccessToken];
    }
    return self;
}

/*
 用户登陆获取相应权限
 */
- (void)requestAccessTokenWithOAuthCode:(NSString *)code WithCompletion:(void(^)(NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://unsplash.com/"]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = @"https://unsplash.com/oauth/token";
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"client_secret" : kUnsplashAccessSecret,
                              @"code" : code,
                              @"redirect_uri" : kRediectURI,
                              @"grant_type" : @"authorization_code",
                              };
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self saveAccessToken:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}


- (AFSecurityPolicy *)getSecurityPolicy{
    //客户端不进行证书验证。
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    return securityPolicy;
}

- (AFJSONRequestSerializer *)requestSerializer{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //超时时间20s
    requestSerializer.timeoutInterval = 20.0;
    return requestSerializer;
}




- (AFJSONResponseSerializer *)responseSerializer{
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setReadingOptions:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    return responseSerializer;
}

- (void)saveAccessToken:(NSDictionary *)accessInfo{
    
    self.accessToken = [accessInfo objectForKey:@"access_token"];
    
    void(^saveBlock)(void) = ^{
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.accessToken forKey:@"kAccessInfo"];
        [userDefaults synchronize];
    };
    
    if ([NSThread isMainThread]) {
        saveBlock();
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            saveBlock();
        });
    }
}

- (void)readAccessToken{
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * accessInfo = [userDefaults objectForKey:@"kAccessInfo"];
    self.accessToken = [accessInfo objectForKey:@"access_token"];
}


@end
