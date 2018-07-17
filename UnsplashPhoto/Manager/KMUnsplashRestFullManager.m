//
//  KMUnsplashRestFullManager.m
//  example
//
//  Created by airron on 2018/7/17.
//  Copyright © 2018年 王世坚. All rights reserved.
//  API Address :
//  https://unsplash.com/documentation#list-photos

#import "KMUnsplashRestFullManager.h"

#import <AFNetworking.h>

/**
 BaseUrl
 */
static NSString * baseUrl = @"https://api.unsplash.com/";

static NSString * accessKey = @"3eb1d95f786289b6eb3a114820bf36601f629277eb476f3d9c0522adb7b22c7a";

static NSString * accessSecret = @"f8efe7bcb8159b4e4094dc3b47536cc2a908b1338113cf60d613d6d26c4d961e";

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
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
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
    NSString * URLString = [NSString stringWithFormat:@"%@photos", baseUrl];
    NSDictionary * params = @{
                              @"client_id" : accessKey,
                              @"page": @(page),
                              @"per_page" : @(perPage),
                              @"order_by" : orderBy
                              };
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
    
//    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//    }];
}


/**
 请求精选照片列表。GET /photos/curated
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestCuratedPhotosWithPage:(NSInteger)page perPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
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
    NSString * URLString = [NSString stringWithFormat:@"%@photos/curated", baseUrl];
    NSDictionary * params = @{
                              @"client_id" : accessKey,
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
