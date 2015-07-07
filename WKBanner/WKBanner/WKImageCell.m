//
//  WKImageCell.m
//  AoMeiProject
//
//  Created by 吴珂 on 15/7/6.
//  Copyright (c) 2015年 张圆圆. All rights reserved.
//

#import "WKImageCell.h"

@implementation WKImageCell

+ (instancetype)imageCell
{
    return  [[NSBundle mainBundle] loadNibNamed:@"WKImageCell" owner:nil options:nil] [0];
}

@end
