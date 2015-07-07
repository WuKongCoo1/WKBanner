//
//  WKBanner.h
//  WKBanner
//
//  Created by 吴珂 on 15/7/7.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//  横幅广告

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WKBannerSourceType) {
    WKBannerSourceTypeFromLocal = 0,
    WKBannerSourceTypeFromURL
};

@class WKBanner;
@protocol WKBannerDelegate <NSObject>

- (void)banner:(WKBanner *)banner selectedIndex:(NSInteger)index;

@end

@protocol WKBannerDataSource <NSObject>

@optional
//localImage
- (NSString *)banner:(WKBanner *)banner imageNameWithIndex:(NSInteger)index;
//URLImage
- (NSString *)banner:(WKBanner *)banner imageURLWithIndex:(NSInteger)index;

@required
- (NSInteger)numberOfImageInBaner:(WKBanner *)banner;

@end

@interface WKBanner : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *imageNameArr;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (assign, nonatomic) id<WKBannerDelegate> delegate;
@property (assign, nonatomic) id<WKBannerDataSource> dataSource;

@property (assign, nonatomic) WKBannerSourceType sourceType;

+ (instancetype)banner;

+ (instancetype)bannerWithFrame:(CGRect)rect;

@end
