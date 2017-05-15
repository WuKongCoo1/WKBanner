//
//  ViewController.m
//  WKBanner
//
//  Created by 吴珂 on 15/7/7.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "ViewController.h"
#import "WKBanner.h"


@interface ViewController ()<WKBannerDelegate, WKBannerDataSource>

@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *imageUrlArr;

@property (nonatomic, strong) WKBanner *banner;
@property (nonatomic, strong) WKBanner *banner2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArr = @[@"main_ad", @"main_ad", @"main_ad", @"main_ad"];
    _imageUrlArr = @[@"http://a.hiphotos.baidu.com/image/pic/item/cf1b9d16fdfaaf5153ab5f08895494eef01f7a39.jpg", @"http://b.hiphotos.baidu.com/image/pic/item/7dd98d1001e9390148c7b69a7eec54e737d19648.jpg", @"http://c.hiphotos.baidu.com/image/pic/item/71cf3bc79f3df8dc03975718ce11728b46102895.jpg"];
    //1.默认
    _banner = [WKBanner banner];
    _banner.delegate = self;
    _banner.dataSource = self;
    _banner.sourceType = WKBannerSourceTypeFromLocal;
    [self.view addSubview:_banner];
    
    //2.指定frame
    _banner2 = [WKBanner bannerWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 150)];
    _banner2.delegate = self;
    _banner2.dataSource = self;
    _banner2.sourceType = WKBannerSourceTypeFromURL;
    [self.view addSubview:_banner2];
}

#pragma mark - WKBannerDelegate
- (void)banner:(WKBanner *)banner selectedIndex:(NSInteger)index
{
    
}


- (NSString *)banner:(WKBanner *)banner imageNameWithIndex:(NSInteger)index
{
    return _imageArr[index];
}


- (NSString *)banner:(WKBanner *)banner imageURLWithIndex:(NSInteger)index
{
    return _imageUrlArr[index];
}

//titile
- (NSString *)banner:(WKBanner *)banner titleWithIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"第%li张图片", (long)index + 1];
}
//font
- (UIFont *)banner:(WKBanner *)banner fontWithIndex:(NSInteger)index
{
    return [UIFont systemFontOfSize:14.f];
}

- (NSInteger)numberOfImageInBaner:(WKBanner *)banner
{
    if (banner == _banner) {
        return _imageArr.count;
    }else if (banner == _banner2){
        return _imageUrlArr.count;
    }
    return 0;
}

@end
