//
//  KMUser.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/22.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMUser.h"

@implementation KMUser

+ (KMUser *)instanceWithUserInfo:(NSDictionary *)userInfo{
    
    NSString * bio = [userInfo objectForKey:@"bio"];
    NSString * firstName = [userInfo objectForKey:@"first_name"];
    NSString * userId = [userInfo objectForKey:@"id"];
    NSString * userName = [userInfo objectForKey:@"username"];
    NSString * lastName = [userInfo objectForKey:@"last_name"];
    NSString * location = [userInfo objectForKey:@"location"];
    
    NSDictionary * profileImageInfo = [userInfo objectForKey:@"profile_image"];
    NSString * largeProfileImage = [profileImageInfo objectForKey:@"large"];
    NSString * mediumProfileImage = [profileImageInfo objectForKey:@"medium"];
    NSString * smallProfileImage = [profileImageInfo objectForKey:@"small"];
    
    NSInteger totalCollections = [[userInfo objectForKey:@"total_collections"] integerValue];
    NSInteger totalLikes = [[userInfo objectForKey:@"total_likes"] integerValue];
    NSInteger totalPhotos = [[userInfo objectForKey:@"total_photos"] integerValue];
    
    KMUser * user = [[KMUser alloc] init];
    user.userId = userId;
    user.userName = userName;
    user.firstName = firstName;
    user.lastName = lastName;
    user.bio = bio;
    user.location = location;
    user.largeProfileImage = largeProfileImage;
    user.mediumProfileImage = mediumProfileImage;
    user.smallProfileImage = smallProfileImage;
    user.totalLikes = totalLikes;
    user.totalPhotos = totalPhotos;
    user.totalCollections = totalCollections;
    
    return user;
}

@end
