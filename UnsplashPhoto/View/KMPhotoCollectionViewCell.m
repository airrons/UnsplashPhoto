//
//  KMPhotoCollectionViewCell.m
//  UnsplashPhoto
//
//  Created by Rainbow on 2018/7/19.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "KMPhotoCollectionViewCell.h"

@interface KMPhotoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;


@end

@implementation KMPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.thumbnail.layer.cornerRadius = 22.0;
    self.thumbnail.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setPhoto:(KMPhoto *)photo{
    
    _photo = photo;
    
    self.indicatorView.hidden = NO;
    
    self.fullNameLabel.text = photo.user.userName;
    self.nickNameLabel.text = [NSString stringWithFormat:@"@%@ %@",photo.user.firstName,photo.user.lastName];
    
    NSDate * updateTime = photo.modifyDate;
    NSString * updateTimeStr = [updateTime stringWithFormat:@"yyyy-MM-dd"];
    self.updateTimeLabel.text = updateTimeStr;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",photo.likes];
    
    [self.photoImageView yy_setImageWithURL:[NSURL URLWithString:photo.smalImage] placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.indicatorView.hidden = YES;
    }];
    
    NSString * profileImageUrl = photo.user.mediumProfileImage;
    [self.thumbnail yy_setImageWithURL:[NSURL URLWithString:profileImageUrl] placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    
    [self.KVOController observe:self.photo keyPath:@"likes" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
    }];
}

- (IBAction)onLikeButtonClicked:(id)sender {
    
}


- (IBAction)onDownloadButtonClicked:(id)sender {
    
}

- (IBAction)onCollectionButtonClicked:(id)sender {
    
}

@end
