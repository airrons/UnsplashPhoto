//
//  KMPhotoCollectionViewCell.h
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/19.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property(nonatomic,strong)KMPhoto * photo;

@end

NS_ASSUME_NONNULL_END
