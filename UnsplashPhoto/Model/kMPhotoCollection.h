//
//  kMPhotoCollection.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kMPhotoCollection : NSObject

@property(nonatomic,strong)NSString * collectionId;

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)NSString * coverPhotoId;

@property(nonatomic,assign)BOOL isCurated;

@property(nonatomic,assign)BOOL isFeatured;

@property(nonatomic,strong)NSString * title;

@property(nonatomic,strong)NSString * collectionDesc;

@property(nonatomic,assign)NSInteger totalPhotos;

@property(nonatomic,assign)BOOL isPrivate;

@property(nonatomic,strong)NSDate * publishedDate;

@property(nonatomic,strong)NSDate * updatedDate;

@property(nonatomic,strong)KMPhoto * coverPhoto;

@property(nonatomic,strong)NSMutableArray * previewPhotos;

@property(nonatomic,strong)KMUser * user;

+ (kMPhotoCollection *)instanceWithCollectionInfo:(NSDictionary *)collectionInfo;

@end
