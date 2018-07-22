//
//  KMPhoto.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMPhoto.h"

@implementation KMPhoto

+ (KMPhoto *)instanceWithPhotoInfo:(NSDictionary *)photoInfo{
    
    KMPhoto * photo = [[KMPhoto alloc] init];
    
    NSString * createDateStr= [photoInfo objectForKey:@"created_at"];
    NSDate * createDate = [NSDate dateWithISOFormatString:createDateStr];
    NSString * description = [photoInfo objectForKey:@"description"];
    NSString * photoId = [photoInfo objectForKey:@"id"];
    float height = [[photoInfo objectForKey:@"height"] floatValue];
    float width = [[photoInfo objectForKey:@"width"] floatValue];
    NSInteger likes = [[photoInfo objectForKey:@"likes"] integerValue];
    NSString * updateDateStr = [photoInfo objectForKey:@"updated_at"];
    NSDate * updateDate = [NSDate dateWithISOFormatString:updateDateStr];
    NSDictionary * urls = [photoInfo objectForKey:@"urls"];
    NSString * fullImageUrl = [urls objectForKey:@"full"];
    NSString * rawImageUrl = [urls objectForKey:@"raw"];
    NSString * regularImageUrl = [urls objectForKey:@"regular"];
    NSString * smallImageUrl = [urls objectForKey:@"small"];
    NSString * thumbImageUrl = [urls objectForKey:@"thumb"];
    
    photo.photoId = photoId;
    photo.createDate = createDate;
    photo.modifyDate = updateDate;
    photo.photoDesc = description ? : @"";
    photo.likes = likes;
    photo.height = height;
    photo.width = width;
    photo.fullImage = fullImageUrl;
    photo.rawImage = rawImageUrl;
    photo.regularImage = regularImageUrl;
    photo.smalImage = smallImageUrl;
    photo.thumbImage = thumbImageUrl;
    
    return photo;
}

- (void)setUser:(KMUser *)user{
    
    _user = user;
    _userId = user.userId;
}

@end
