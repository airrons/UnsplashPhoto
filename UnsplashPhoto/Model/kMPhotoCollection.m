//
//  kMPhotoCollection.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "kMPhotoCollection.h"

@implementation kMPhotoCollection

+ (kMPhotoCollection *)instanceWithCollectionInfo:(NSDictionary *)collectionInfo{
    
    kMPhotoCollection * photoCollection = [[kMPhotoCollection alloc] init];
    NSString * title = [collectionInfo objectForKey:@"title"];
    NSInteger totalPhotos = [[collectionInfo objectForKey:@"total_photos"] integerValue];
    NSString * updateTimeStr = [collectionInfo objectForKey:@"updated_at"];
    NSDate * updateDate = [NSDate dateWithISOFormatString:updateTimeStr];
    BOOL cureated = [[collectionInfo objectForKey:@"curated"] boolValue];
    NSString * collectionDesc = [collectionInfo objectForKey:@"description"];
    BOOL featured = [[collectionInfo objectForKey:@"featured"] boolValue];
    NSString * collectionId = [collectionInfo objectForKey:@"id"];
    
    photoCollection.isCurated = cureated;
    photoCollection.collectionDesc = collectionDesc;
    photoCollection.isFeatured = featured;
    photoCollection.collectionId = collectionId;
    photoCollection.title = title;
    photoCollection.totalPhotos = totalPhotos;
    photoCollection.updatedDate = updateDate;
    
    return photoCollection;
}

@end
