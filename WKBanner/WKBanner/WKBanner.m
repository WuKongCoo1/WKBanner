//
//  WKBanner.m
//  WKBanner
//
//  Created by 吴珂 on 15/7/7.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKBanner.h"
#import "WKImageCell.h"
#import <UIImageView+WebCache.h>

#define kCycleTimes 10000
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface WKBanner ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WKBanner

+ (instancetype)banner
{
    WKBanner *banner = [[NSBundle mainBundle] loadNibNamed:@"WKBanner" owner:nil options:nil][0];
    banner.frame = CGRectMake(0, 0, kScreenWidth, 100);
    return banner;
}

+ (instancetype)bannerWithFrame:(CGRect)rect
{
    WKBanner *banner = [WKBanner banner];
    banner.frame = rect;
    return banner;
}

- (void)awakeFromNib {
    //regist cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"WKImageCell" bundle:nil] forCellWithReuseIdentifier:@"WKImageCell"];
    
    self.pageControl.currentPage = 0;
}

- (void)didMoveToSuperview
{
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
        NSInteger count = [self.dataSource numberOfImageInBaner:self];
        if (count == 0) {
            NSAssert(NO, @"图片数量不能为0");
        }
        self.pageControl.numberOfPages = count;
    }else{
        NSAssert(NO, @"必须实现数据源方法");
    }
    
    [self addTimer];
    
    self.collectionView.contentSize = CGSizeMake(kCycleTimes * [self.dataSource numberOfImageInBaner:self] * kScreenWidth, self.bounds.size.height);
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * [self.dataSource numberOfImageInBaner:self] * kCycleTimes / 2, 0) animated:NO];
}


#pragma mark - UICollectionViewDelegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfImageInBaner:self] * kCycleTimes;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WKImageCell" forIndexPath:indexPath];
    NSInteger imageIndex = 0;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
        NSInteger numberOfImage = [self.dataSource numberOfImageInBaner:self];
        
        imageIndex = indexPath.row % numberOfImage;
    }else{
        NSAssert(NO, @"图片数目不能小于1");
    }
    
    switch (self.sourceType) {
        case WKBannerSourceTypeFromLocal: {
            if ([self.dataSource respondsToSelector:@selector(banner:imageNameWithIndex:)]) {
                cell.imageView.image = [UIImage imageNamed:[self.dataSource banner:self imageNameWithIndex:imageIndex]];
            }
            break;
        }
        case WKBannerSourceTypeFromURL: {
            if ([self.dataSource respondsToSelector:@selector(banner:imageURLWithIndex:)]){
                
                NSString *urlStr = [self.dataSource banner:self imageURLWithIndex:imageIndex];
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
            }
            break;
        }
        default: {
            break;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height;
    
    height = collectionView.bounds.size.height;
    
    width = self.bounds.size.width;
    
    return CGSizeMake(width, height);
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentPage = indexPath.row % [self.dataSource numberOfImageInBaner:self];
    NSLog(@"点击index:%lu", currentPage);
    
    if ([self.delegate respondsToSelector:@selector(banner:selectedIndex:)]) {
        [self.delegate banner:self selectedIndex:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((int)scrollView.contentOffset.x % (int)self.bounds.size.width == 0) {
        
        NSUInteger page = scrollView.contentOffset.x / self.bounds.size.width;
        
        NSInteger currentPage = page % [self.dataSource numberOfImageInBaner:self];
        
        self.pageControl.currentPage = currentPage;
    }
}

#pragma mark - AutoScroll
- (void)autoScroll:(NSTimer *)timer
{
    if ([self.dataSource numberOfImageInBaner:self] == 0) {
        return;
    }else if ([self.dataSource numberOfImageInBaner:self] == 1){
        self.pageControl.hidden = YES;
        return;
    }else{
        self.pageControl.hidden = NO;
        [self stopTimer];
    }
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems]lastObject];
    
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger section = currentIndexPath.section;
    BOOL animated = YES;
    if (nextItem == [self.dataSource numberOfImageInBaner:self] * kCycleTimes) {
        nextItem = (kCycleTimes / 2 * [self.dataSource numberOfImageInBaner:self]);
        animated = NO;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:section];
    
    //scrollToNextItem
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(autoScroll:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

- (void)removeTimer
{
    [_timer invalidate];
}

- (void)setupCollectionView
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(kCycleTimes / 2 * [self.dataSource numberOfImageInBaner:self]) inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
