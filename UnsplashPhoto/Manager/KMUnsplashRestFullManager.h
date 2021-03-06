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

/*
 请求单张照片的详细信息。GET /photos/:id
 @param photoId The photo’s ID. Required.
 @param width Image width in pixels.
 @param height Image height in pixels.
 @param rect 4 comma-separated integers representing x, y, width, height of the cropped rectangle.
 */
- (void)requestPhotoInfoWithPhotoId:(NSString *)photoId width:(CGFloat)width height:(CGFloat)height rect:(CGRect)rect completion:(void(^)(NSDictionary * result,NSError * error))handler;

/*
 随机请求一组精选照片。GET /photos/random
 */
- (void)requestRandomPhotosWithCompletion:(void(^)(NSArray * photoList,NSError * error))handler;


/*
 喜欢某张照片 GET /collections
 @param page Page Index.
 @param perPage number of collections per page .
 */
- (void)requestPhotoCollectionsWithPage:(NSInteger)page perPage:(NSInteger)perPage withCompletion:(void(^)(NSArray * collectionList,NSError * error))handler;

/*
 用户登陆获取相应权限
 */
- (void)loginWithCompletion:(void(^)(NSError * error))handler;

@end
