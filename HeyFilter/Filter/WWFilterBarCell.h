//
//  WWFilterBarCell.h
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWFilterBarCell : UIButton
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UIImageView* arrowImg;
- (instancetype)initWithTitle:(NSString*)title andSubTitle:(NSString *)subTitle andCount:(NSInteger)cellCount;
@end
