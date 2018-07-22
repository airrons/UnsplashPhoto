//
//  ViewController.m
//  UnsplashPhoto
//
//  Created by airron on 2018/7/17.
//  Copyright © 2018年 王世坚. All rights reserved.
//

#import "ViewController.h"
#import "KMUnsplashRestFullManager.h"

#import "KMPhotoCollectionViewCell.h"

API_AVAILABLE(ios(11.0))
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)SFAuthenticationSession * authSession;

@property(nonatomic,strong)NSMutableArray * photoList;

@property(nonatomic,strong)UICollectionView * photosCollectionView;

@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photoList = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Unsplash";
    
    UIBarButtonItem * userBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"授权" style:UIBarButtonItemStylePlain target:self action:@selector(onOauthButtonClicked:)];
    self.navigationItem.leftBarButtonItem = userBarButtonItem;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.photosCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.photosCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KMPhotoCollectionViewCell class]) bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:@"kUnsplashIdentifier"];
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    self.photosCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photosCollectionView];
    
    [self.photosCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photosCollectionView.superview).with.insets(UIEdgeInsetsZero);
    }];
    
    __weak __typeof(self)weakSelf = self;
    self.photosCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        [[KMUnsplashDataManager shareInstance] requestPhotosWithPage:weakSelf.currentPage itemsPerPage:10 orderBy:KMPhotoOrderTypeLatest completion:^(NSArray *photoList, NSError *error) {
            if (!error && photoList) {
                [weakSelf.photoList removeAllObjects];
                [weakSelf.photoList addObjectsFromArray:photoList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.photosCollectionView reloadData];
                });
            }
            [weakSelf.photosCollectionView.mj_header endRefreshing];
            weakSelf.photosCollectionView.mj_footer.hidden = NO;
        }];
    }];
    
    self.photosCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [[KMUnsplashDataManager shareInstance] requestPhotosWithPage:weakSelf.currentPage itemsPerPage:10 orderBy:KMPhotoOrderTypeLatest completion:^(NSArray *photoList, NSError *error) {
            if (!error && photoList) {
                NSMutableArray * indexPathes = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i<photoList.count; i++) {
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:weakSelf.photoList.count+i inSection:0];
                    [indexPathes addObject:indexPath];
                }
                [weakSelf.photoList addObjectsFromArray:photoList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.photosCollectionView insertItemsAtIndexPaths:indexPathes];
                });
            }
            [weakSelf.photosCollectionView.mj_footer endRefreshing];
        }];
    }];
    
    self.photosCollectionView.mj_footer.hidden = YES;
    [self.photosCollectionView.mj_header beginRefreshing];

    [[KMUnsplashRestFullManager shareInstance] requestPhotoCollectionsWithPage:0 perPage:1 withCompletion:^(NSArray *collectionList, NSError *error) {
        
    }];

//    [[KMUnsplashRestFullManager shareInstance] requestCuratedPhotosWithPage:1 perPage:10 orderBy:KMPhotoOrderTypeLatest completion:^(NSArray *photoList, NSError *error) {
//
//    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

/*
 授权入口。部分接口须持有token才能够正常访问。 例如 点赞、取消点赞吗、添加照片到相册等。
 通过本入口可获得：accessToken,refreshToken 等重要令牌信息。
 */
- (void)onOauthButtonClicked:(id)sender{
    
    if (![KMUnsplashOAuthManager shareInstance].accessToken) {
        NSArray * scopes = @[kScopePublic,kScopeReadUser,kScopeWriteUser,
                             kScopeReadPhotos,kScopeWritePhotos
                             ,kScopeWiteLikes,kScopeWriteFollowers,
                             kScopeReadCollections,kScopeWriteCollections];
        
        NSString * scopeString = [scopes componentsJoinedByString:@"+"];
        
        NSString * redirectURI = kRediectURI;
        
        NSString * oauthURI = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=%@&scope=%@",kUnsplashAccessKey,redirectURI,@"code",scopeString];
        NSString * callBackURI = kCallBackURI;
        
        if (@available(iOS 11.0, *)) {
            _authSession = [[SFAuthenticationSession alloc] initWithURL:[NSURL URLWithString:oauthURI] callbackURLScheme:callBackURI completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
                NSArray * items = [callbackURL.absoluteString componentsSeparatedByString:@"?"];
                NSArray * codeInfo = [items.lastObject componentsSeparatedByString:@"="];
                NSString * code = [codeInfo lastObject];
                NSLog(@"code : %@",code);
                [[KMUnsplashOAuthManager shareInstance] requestAccessTokenWithOAuthCode:code WithCompletion:^(NSError *error) {
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"应用已授权!可使用token信息进行点赞等高级操作！" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                }];
            }];
            [_authSession start];
        } else {
            // Fallback on earlier versions
        }
    }else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户已授权！可直接使用AccessToken进行与用户相关的操作!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oauthURI]];
    
//    KMWebViewController * webViewController = [[KMWebViewController alloc] init];
//    webViewController.title = @"授权";
//    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
//    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark =========================== UICollectionDelegate DataSource =======================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KMPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kUnsplashIdentifier" forIndexPath:indexPath];
    KMPhoto * photo = self.photoList[indexPath.row];
    cell.photo = photo;
    __weak __typeof(self)weakSelf = self;
    cell.moreHandler = ^(NSInteger type, KMPhoto * _Nonnull photo) {
        [weakSelf onMoreHandlerWithType:type forPhoto:photo];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KMPhotoCollectionViewCell * cell = (KMPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray * photoItems = [NSMutableArray arrayWithCapacity:0];
    for (KMPhoto * photo in self.photoList) {
        NSString * regularImageUrl = photo.fullImage;
        KSPhotoItem * photoItem = [KSPhotoItem itemWithSourceView:cell.photoImageView imageUrl:[NSURL URLWithString:regularImageUrl]];
        [photoItems addObject:photoItem];
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photoItems selectedIndex:indexPath.row];
    [browser showFromViewController:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KMPhoto * photo = self.photoList[indexPath.row];
    float itemWidth = self.view.frame.size.width;
    float itemHeight = (photo.height/photo.width) * itemWidth + 60*2;
    CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
    
    return itemSize;
}

- (void)onMoreHandlerWithType:(NSInteger)type forPhoto:(KMPhoto *)photo{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该操作后续补充!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
