//
//  WWFilterBarView.h
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWFilterBarCell;

@interface WWFilterBarView : UIView
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) WWFilterBarCell* catCell;
@property (nonatomic, strong) WWFilterBarCell* priceCell;
@property (nonatomic, strong) WWFilterBarCell* brandCell;
@property (nonatomic,strong) UIView *bottomline;
@property (nonatomic, copy) NSString *cateName;
- (instancetype)initWithTitle:(NSString *)title andHiddenBrand:(NSInteger)isPriceOrBrand;
@end
