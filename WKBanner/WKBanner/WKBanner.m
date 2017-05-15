//
//  WKBanner.m
//  WKBanner
//
//  Created by 吴珂 on 15/7/7.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKBanner.h"
#import "WKImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kCycleTimes 10000
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface WKBanner ()<UIGestureRecognizerDelegate>

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
    [super awakeFromNib];
    //regist cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"WKImageCell" bundle:nil] forCellWithReuseIdentifier:@"WKImageCell"];
    
    self.pageControl.currentPage = 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
        NSInteger count = [self.dataSource numberOfImageInBaner:self];
        if (count == 0) {
            //            NSAssert(NO, @"图片数量不能为0");
        }else{
            [self addTimer];
            self.pageControl.numberOfPages = count;
        }
    }else{
        
        NSAssert(NO, @"必须实现数据源方法");
    }
    
    
    
    self.collectionView.contentSize = CGSizeMake(kCycleTimes * [self.dataSource numberOfImageInBaner:self] * kScreenWidth, self.bounds.size.height);
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * [self.dataSource numberOfImageInBaner:self] * kCycleTimes / 2, 0) animated:NO];
    
    id target = self.collectionView.panGestureRecognizer.delegate;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:nil];
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    
    
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //    NSLog(@"%@", self.dataSource);
    //    if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
    //        NSInteger count = [self.dataSource numberOfImageInBaner:self];
    //        if (count == 0) {
    //            NSAssert(NO, @"图片数量不能为0");
    //        }
    //        self.pageControl.numberOfPages = count;
    //    }else{
    //        NSAssert(NO, @"必须实现数据源方法");
    //    }
    //
    //    [self addTimer];
    //
    //    self.collectionView.contentSize = CGSizeMake(kCycleTimes * [self.dataSource numberOfImageInBaner:self] * kScreenWidth, self.bounds.size.height);
    //    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * [self.dataSource numberOfImageInBaner:self] * kCycleTimes / 2, 0) animated:NO];
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
    [cell scaleAnimationWithTime:1.f];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
        NSInteger numberOfImage = [self.dataSource numberOfImageInBaner:self];
        
        imageIndex = indexPath.row % numberOfImage;
    }else{
        NSAssert(NO, @"图片数目不能小于1");
    }
    
    switch (self.sourceType) {
        case WKBannerSourceTypeFromLocal: {
            if ([self.dataSource respondsToSelector:@selector(banner:imageNameWithIndex:)]) {
                NSLog(@"%@", [UIImage imageNamed:[self.dataSource banner:self imageNameWithIndex:imageIndex]]);
                cell.imageView.image = [UIImage imageNamed:[self.dataSource banner:self imageNameWithIndex:imageIndex]];
            }
            [self setTitleWithCell:cell index:imageIndex];
            break;
        }
        case WKBannerSourceTypeFromURL: {
            if ([self.dataSource respondsToSelector:@selector(banner:imageURLWithIndex:)]){
                
                NSString *urlStr = [self.dataSource banner:self imageURLWithIndex:imageIndex];
                
                UIImage *placeholderImage;
                if ([self.dataSource respondsToSelector:@selector(bannerPlaceholder)]) {
                    placeholderImage = [UIImage imageNamed:[self.dataSource bannerPlaceholder]];
                }else{
                    placeholderImage = [UIImage imageNamed:@"Homework_imgicon"];
                }
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage];
            }
            [self setTitleWithCell:cell index:imageIndex];
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
        [self.delegate banner:self selectedIndex:currentPage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((int)scrollView.contentOffset.x % (int)self.bounds.size.width == 0) {
        
        NSUInteger page = scrollView.contentOffset.x / self.bounds.size.width;
        NSInteger currentPage = 1;
        if ([self.dataSource respondsToSelector:@selector(numberOfImageInBaner:)]) {
            if ([self.dataSource numberOfImageInBaner:self] != 0) {
                currentPage = page % [self.dataSource numberOfImageInBaner:self];
            }
            
        }else{
            return;
        }
        
        
        
        self.pageControl.currentPage = currentPage;
    }
}


- (void)setTitleWithCell:(WKImageCell *)cell index:(NSInteger)imageIndex
{
    if ([self.dataSource respondsToSelector:@selector(banner:titleWithIndex:)]) {
        cell.titleLabel.text = [self.dataSource banner:self titleWithIndex:imageIndex];
        cell.titleLabelRight.constant = self.pageControl.bounds.size.width + 10;
        [cell layoutIfNeeded];
    }
    
    [cell setTitle:cell.titleLabel.text];
    
    if ([self.dataSource respondsToSelector:@selector(banner:fontWithIndex:)]) {
        cell.titleLabel.font = [self.dataSource banner:self fontWithIndex:imageIndex];
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
        //        [self stopTimer];
    }
    
    
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems]lastObject];
    if (currentIndexPath == nil) {
        return;
    }
    
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopTimer) object:nil];
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)addTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(autoScroll:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}


- (void)setupCollectionView
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(kCycleTimes / 2 * [self.dataSource numberOfImageInBaner:self]) inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

- (void)restartTimer
{
    [self addTimer];
}

- (void)startTimer
{
    
    [self stopTimer];
    self.pageControl.numberOfPages = [self.dataSource numberOfImageInBaner:self];
    if ([self.dataSource numberOfImageInBaner:self] == 0) {
        return;
    }
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * [self.dataSource numberOfImageInBaner:self] * kCycleTimes / 2, 0) animated:NO];
    [self addTimer];
    
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)setTimer:(NSTimer *)timer
{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = timer;
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self stopTimer];
    return NO;
}

@end
