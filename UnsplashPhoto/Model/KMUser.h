//
//  KMUser.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUser : NSObject

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)NSString * userName;

@property(nonatomic,strong)NSString * firstName;

@property(nonatomic,strong)NSString * lastName;

@property(nonatomic,strong)NSString * email;

@property(nonatomic,strong)NSString * bio;

@property(nonatomic,strong)NSString * location;

@property(nonatomic,strong)NSString * largeProfileImage;

@property(nonatomic,strong)NSString * mediumProfileImage;

@property(nonatomic,strong)NSString * smallProfileImage;

@property(nonatomic,assign)NSInteger followersCount;

@property(nonatomic,assign)NSInteger followingCount;

@property(nonatomic,strong)NSArray * photoIds;

@property(nonatomic,assign)NSInteger totalLikes;

@property(nonatomic,assign)NSInteger totalPhotos;

@property(nonatomic,assign)NSInteger totalCollections;

@property(nonatomic,assign)NSInteger donwloads;

+ (KMUser *)instanceWithUserInfo:(NSDictionary *)userInfo;

@end
