//
//  KMUnsplashRestFullManager.h
//  example
//
//  Created by airron on 2018/7/17.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KMPhotoOrderTypeLatest = 0, //最新排序
    KMPhotoOrderTypeOldest, //最老排序
    KMPhotoOrderTypePopular, //最流行排序
} KMPhotoOrderType;

@interface KMUnsplashRestFullManager : NSObject

+ (instancetype)shareInstance;

/**
 请求照片列表。
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestPhotosWithPage:(NSInteger)page itemsPerPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler;

/**
 请求精选照片列表。GET /photos/curated
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestCuratedPhotosWithPage:(NSInteger)page perPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler;

@end
