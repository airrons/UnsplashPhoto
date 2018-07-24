//
//  KMUnsplashDataManager.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUnsplashDataManager : NSObject

+ (instancetype)shareInstance;

/**
 请求照片列表。GET /photos
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestPhotosWithPage:(NSInteger)page itemsPerPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler;

/*
喜欢某张照片 GET /collections
@param page Page Index.
@param perPage number of collections per page .
*/
- (void)requestPhotoCollectionsWithPage:(NSInteger)page perPage:(NSInteger)perPage withCompletion:(void(^)(NSArray * collectionList,NSError * error))handler;

@end
