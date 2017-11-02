//
//  WWFilterBarView.m
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWFilterBarView.h"
#import "WWFilterBarCell.h"
#import "UIView+SDAutoLayout.h"

#define THREEBTN                                 300
#define CUSTOMTWOBTN                       200
#define TWOBTN                                     100
#define screenRate ([[UIScreen mainScreen] bounds].size.width  / 375.0)
#define RGBCOLOR(color) [UIColor colorWithRed:(((color)>>16)&0xff)*1.0/255.0 green:(((color)>>8)&0xff)*1.0/255.0 blue:((color)&0xff)*1.0/255.0 alpha:1.0]
#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface WWFilterBarView ()
@property (nonatomic, assign) NSInteger isPriceOrBrand;
@end

@implementation WWFilterBarView
- (instancetype)initWithTitle:(NSString *)title andHiddenBrand:(NSInteger)isPriceOrBrand {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.isPriceOrBrand = isPriceOrBrand;
        _cateName = title;
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self addSubview:self.catCell];
    if (self.isPriceOrBrand == THREEBTN) {
        [self addSubview:self.brandCell];
        self.brandCell.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self addSubview:self.priceCell];
    [self addSubview:self.bottomline];
    self.bottomline.translatesAutoresizingMaskIntoConstraints = NO;
    self.catCell.translatesAutoresizingMaskIntoConstraints = NO;
    self.priceCell.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict;
    if (self.isPriceOrBrand == THREEBTN) {
        dict = @{@"cat":self.catCell,@"brand":self.brandCell,@"price":self.priceCell,@"bot":self.bottomline};
    }else {
        dict = @{@"cat":self.catCell,@"price":self.priceCell,@"bot":self.bottomline};
    }
    NSDictionary *metrics = @{@"Hcat":@(15*screenRate),@"catsize":@(kWidth/3),@"catto":@(33*screenRate),@"Vcat":@(10*screenRate),@"catH":@(7*screenRate),@"catpWidth":@(kWidth/2)};
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.catCell attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    if (self.isPriceOrBrand == THREEBTN) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cat(==catsize)]-0-[brand(==catsize)]-0-[price(==catsize)]-0-|" options:0 metrics:metrics views:dict]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.brandCell attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.catCell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }else if (self.isPriceOrBrand == CUSTOMTWOBTN) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cat(==catsize)]-0-[price(==catsize)]" options:0 metrics:metrics views:dict]];
    } else {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cat(==catpWidth)]-0-[price(==catpWidth)]-0-|" options:0 metrics:metrics views:dict]];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.priceCell attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.catCell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bot]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bot(==0.5)]-0-|" options:0 metrics:nil views:dict]];
}

#pragma mark - 懒加载
- (WWFilterBarCell *)catCell{
    if (_catCell == nil) {
        _catCell = [[WWFilterBarCell alloc] initWithTitle:self.cateName andSubTitle:nil andCount:self.isPriceOrBrand];
    }
    return _catCell;
}

- (WWFilterBarCell *)priceCell{
    if (_priceCell == nil) {
        _priceCell = [[WWFilterBarCell alloc] initWithTitle:@"价格" andSubTitle:nil andCount:self.isPriceOrBrand];
    }
    return _priceCell;
}

- (WWFilterBarCell *)brandCell{
    if (_brandCell == nil) {
        _brandCell = [[WWFilterBarCell alloc] initWithTitle:@"所有品牌" andSubTitle:nil andCount:self.isPriceOrBrand];
    }
    return _brandCell;
}

- (UIView *)bottomline {
    if (_bottomline == nil) {
        _bottomline = [[UIView alloc]init];
        _bottomline.backgroundColor = RGBCOLOR(0xE8E8E8);
    }
    return _bottomline;
}

@end
