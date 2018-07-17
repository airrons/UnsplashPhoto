//
//  ViewController.m
//  UnsplashPhoto
//
//  Created by airron on 2018/7/17.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "ViewController.h"
#import "KMUnsplashRestFullManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[KMUnsplashRestFullManager shareInstance] requestPhotosWithPage:1 itemsPerPage:10 orderBy:KMPhotoOrderTypeLatest completion:^(NSArray *photoList, NSError *error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
