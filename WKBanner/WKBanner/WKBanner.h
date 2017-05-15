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
//titile
- (NSString *)banner:(WKBanner *)banner titleWithIndex:(NSInteger)index;
//font
- (UIFont *)banner:(WKBanner *)banner fontWithIndex:(NSInteger)index;

//占位图名
- (NSString *)bannerPlaceholder;

@required
- (NSInteger)numberOfImageInBaner:(WKBanner *)banner;

@end

@interface WKBanner : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *imageNameArr;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) id<WKBannerDelegate> delegate;
@property (weak, nonatomic) id<WKBannerDataSource> dataSource;

@property (assign, nonatomic) WKBannerSourceType sourceType;

+ (instancetype)banner;

+ (instancetype)bannerWithFrame:(CGRect)rect;

- (void)stopTimer;
- (void)startTimer;
- (void)restartTimer;
@end
