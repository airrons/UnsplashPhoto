//
//  KMPhoto.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMPhoto : NSObject

@property(nonatomic,strong)NSString * photoId;

@property(nonatomic,strong)NSDate * createDate;

@property(nonatomic,strong)NSDate * modifyDate;

@property(nonatomic,strong)NSString * photoDesc;

@property(nonatomic,assign)NSInteger likes;

@property(nonatomic,assign)BOOL likedByUser;

@property(nonatomic,assign)NSInteger downloads;

@property(nonatomic,assign)NSInteger views;

@property(nonatomic,assign)float width;

@property(nonatomic,assign)float height;

@property(nonatomic,strong)NSString * fullImage;

@property(nonatomic,strong)NSString * rawImage;

@property(nonatomic,strong)NSString * regularImage;

@property(nonatomic,strong)NSString * smalImage;

@property(nonatomic,strong)NSString * thumbImage;

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)KMUser * user;

+ (KMPhoto *)instanceWithPhotoInfo:(NSDictionary *)photoInfo;

@end
