//
//  KMUnsplashRestFullManager.m
//  example
//
//  Created by airron on 2018/7/17.
//  Copyright © 2018年 王世坚. All rights reserved.
//  API Address :
//  https://unsplash.com/documentation#list-photos

#import "KMUnsplashRestFullManager.h"


@implementation KMUnsplashRestFullManager

+ (instancetype)shareInstance {
    
    static KMUnsplashRestFullManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareManager) {
            shareManager = [[KMUnsplashRestFullManager alloc] init];
        }
    });
    return shareManager;
}

#pragma mark =========================== Photo List =======================================

/**
 请求照片列表。GET /photos
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestPhotosWithPage:(NSInteger)page itemsPerPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * orderBy = @"latest";
    switch (orderType) {
        case KMPhotoOrderTypeLatest:
            orderBy = @"latest";
            break;
        case KMPhotoOrderTypeOldest:
            orderBy = @"oldest";
            break;
        case KMPhotoOrderTypePopular:
            orderBy = @"popular";
            break;
        default:
            break;
    }
    NSString * URLString = [NSString stringWithFormat:@"%@photos", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"page": @(page),
                              @"per_page" : @(perPage),
                              @"order_by" : orderBy
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if (handler) {
            handler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (handler) {
            handler(nil,error);
        }
    }];
}


/**
 请求精选照片列表。GET /photos/curated
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestCuratedPhotosWithPage:(NSInteger)page perPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * orderBy = @"latest";
    switch (orderType) {
        case KMPhotoOrderTypeLatest:
            orderBy = @"latest";
            break;
        case KMPhotoOrderTypeOldest:
            orderBy = @"oldest";
            break;
        case KMPhotoOrderTypePopular:
            orderBy = @"popular";
            break;
        default:
            break;
    }
    NSString * URLString = [NSString stringWithFormat:@"%@photos/curated", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"page": @(page),
                              @"per_page" : @(perPage),
                              @"order_by" : orderBy
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 请求单张照片的详细信息。GET /photos/:id
 @param photoId The photo’s ID. Required.
 @param width Image width in pixels.
 @param height Image height in pixels.
 @param rect 4 comma-separated integers representing x, y, width, height of the cropped rectangle.
 */
- (void)requestPhotoInfoWithPhotoId:(NSString *)photoId width:(CGFloat)width height:(CGFloat)height rect:(CGRect)rect completion:(void(^)(NSDictionary * result,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = [NSString stringWithFormat:@"%@photos/:id", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"id": photoId,
                              @"w" : @(width),
                              @"h" : @(height),
                              @"rect" : [NSString stringWithFormat:@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height]
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 随机请求一组精选照片。GET /photos/random
 */
- (void)requestRandomPhotosWithCompletion:(void(^)(NSArray * photoList,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = [NSString stringWithFormat:@"%@photos/random", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"featured": @(YES),
                              @"count" : @(30),
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 喜欢某张照片 POST /photos/:id/like
 @param photoId The photo’s ID. Required.
 */
- (void)likePhotoWithPhotoId:(NSString *)photoId withCompletion:(void(^)(NSDictionary * result,NSError *error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = [NSString stringWithFormat:@"%@photos/:id/like", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"featured": @(YES),
                              @"count" : @(30),
                              };
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 喜欢某张照片 DELETE /photos/:id/like
 @param photoId The photo’s ID. Required.
 */
- (void)unlikePhotoWithPhotoId:(NSString *)photoId withCompletion:(void(^)(NSDictionary * result,NSError *error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = [NSString stringWithFormat:@"%@photos/:id/like", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"featured": @(YES),
                              @"count" : @(30),
                              };
    [manager DELETE:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 用户登陆获取相应权限
 */
- (void)loginWithCompletion:(void(^)(NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = @"https://unsplash.com/oauth/token";
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"client_secret": kUnsplashAccessSecret,
                              };
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 喜欢某张照片 GET /collections
 @param page Page Index.
 @param perPage number of collections per page .
 */
- (void)requestPhotoCollectionsWithPage:(NSInteger)page perPage:(NSInteger)perPage withCompletion:(void(^)(NSArray * collectionList,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashAPIBaseUrl]];
    manager.securityPolicy = [self getSecurityPolicy];
    manager.requestSerializer = [self requestSerializer];
    manager.responseSerializer = [self responseSerializer];
    
    NSString * URLString = [NSString stringWithFormat:@"%@collections", kUnsplashAPIBaseUrl];
    NSDictionary * params = @{
                              @"client_id" : kUnsplashAccessKey,
                              @"page": @(page),
                              @"per_page" : @(perPage)
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (handler) {
            handler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (handler) {
            handler(nil,error);
        }
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


@end
