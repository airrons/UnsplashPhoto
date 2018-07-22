//
//  KMUnsplashDataManager.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMUnsplashDataManager.h"

@implementation KMUnsplashDataManager

+ (instancetype)shareInstance {
    
    static KMUnsplashDataManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareManager) {
            shareManager = [[KMUnsplashDataManager alloc] init];
        }
    });
    return shareManager;
}

/**
 请求照片列表。GET /photos
 @param page 页码
 @parme perPage 每页返回量
 @param orderType 排序类型,默认为最近
 */
- (void)requestPhotosWithPage:(NSInteger)page itemsPerPage:(NSInteger)perPage orderBy:(KMPhotoOrderType)orderType completion:(void(^)(NSArray * photoList,NSError * error))handler{
    
    [[KMUnsplashRestFullManager shareInstance] requestPhotosWithPage:page itemsPerPage:perPage orderBy:orderType completion:^(NSArray *photoList, NSError *error) {
        if (!error && photoList) {
            
            NSMutableArray * photos = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * photoInfo in photoList) {
                
                KMPhoto * photo = [KMPhoto instanceWithPhotoInfo:photoInfo];
                NSDictionary * userInfo = [photoInfo objectForKey:@"user"];
                KMUser * user = [KMUser instanceWithUserInfo:userInfo];
                photo.user = user;
                
                [photos addObject:photo];
            }
            
            if (handler) {
                handler(photos,nil);
            }
        }else{
            if (handler) {
                handler(nil,error);
            }
        }
    }];
}















@end
