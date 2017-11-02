//
//  WWPriceFilter.h
//  YaoKe
//
//  Created by steaest on 2017/7/3.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceSortModel;

@protocol WWPriceFilterDelegate <NSObject>
- (void)sureClickLowPrice:(NSString *)lowPrice andHighPrice:(NSString *)highPrice andPriceSort:(NSString *)priceSort andShowName:(NSString*)showName;
@end

@interface WWPriceFilter : UIView
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *priceLowToHigh;
@property (nonatomic, strong) UIButton *priceHighToLow;
@property (nonatomic, weak) id <WWPriceFilterDelegate> delegate;

- (instancetype)initinitWithHeight:(CGFloat)height;
@end
