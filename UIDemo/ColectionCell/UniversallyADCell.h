//
//  UniversallyADCell.h
//  UIDemo
//
//  Created by iosteams on 2018/10/15.
//  Copyright © 2018年 tielan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniversallyADCell : UICollectionViewCell

/* 图片数组 */
@property (copy , nonatomic)NSArray *imageArray;

+(CGSize)referenceSize;

@end
