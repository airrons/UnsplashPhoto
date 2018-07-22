//
//  KMUnsplashOAuthManager.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/21.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUnsplashOAuthManager : NSObject

@property(nonatomic,readonly)NSString * accessToken;

+ (instancetype)shareInstance;

/*
 用户登陆获取相应权限
 */
- (void)requestAccessTokenWithOAuthCode:(NSString *)code WithCompletion:(void(^)(NSError * error))handler;

@end
