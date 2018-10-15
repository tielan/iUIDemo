//
//  UniversallyADCell.m
//  UIDemo
//
//  Created by iosteams on 2018/10/15.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import "UniversallyADCell.h"

@interface UniversallyADCell()
{
    UIImageView *image1;
    UIImageView *image2;
    UIImageView *image3;
}

@end

@implementation UniversallyADCell

+(CGSize)referenceSize{
    return CGSizeMake(375, 200);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    image1 = [[UIImageView alloc] init];
    image1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:image1];
    
    image2 = [[UIImageView alloc] init];
    image2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:image2];
    
    image3 = [[UIImageView alloc] init];
    image3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:image3];
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat superViewW = self.frame.size.width;
    
    image1.frame = CGRectMake(0, 0, superViewW*0.5, 100);
    [self setBorderWithView:image1 top:NO left:NO bottom:NO right:YES borderColor:[UIColor blueColor] borderWidth:0.5];
    image2.frame = CGRectMake(superViewW*0.5, 0, superViewW*0.5, 100);
    image3.frame = CGRectMake(0, 100, superViewW, 100);
    [self setBorderWithView:image3 top:YES left:NO bottom:NO right:NO borderColor:[UIColor blueColor] borderWidth:0.5];
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

@end
