//
//  WWFilterBarCell.m
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWFilterBarCell.h"
#import "UIView+SDAutoLayout.h"

#define screenRate ([[UIScreen mainScreen] bounds].size.width  / 375.0)
#define RGBCOLOR(color) [UIColor colorWithRed:(((color)>>16)&0xff)*1.0/255.0 green:(((color)>>8)&0xff)*1.0/255.0 blue:((color)&0xff)*1.0/255.0 alpha:1.0]
#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface WWFilterBarCell ()
@property (nonatomic, assign) NSInteger cellCount;
@end

@implementation WWFilterBarCell

- (instancetype)initWithTitle:(NSString*)title andSubTitle:(NSString *)subTitle andCount:(NSInteger)cellCount{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.cellCount = cellCount;
        self.textLabel.text = title ? title : @"默认";
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    [self.textLabel sizeToFit];
    self.textLabel.left = 20;
    self.textLabel.centerY = 17;
    self.textLabel.width = 70;
    [self addSubview:self.textLabel];
    
    [self.arrowImg sizeToFit];
    self.arrowImg.left = self.textLabel.right;
    self.arrowImg.centerY = self.textLabel.centerY+1;
    [self addSubview:self.arrowImg];
    
    [self.sepView sizeToFit];
    self.sepView.left = kWidth/3-2;
    if (self.cellCount == 100) {
        self.sepView.left = kWidth/2-2;
    }
    self.sepView.top = 2;
    self.sepView.width = 1;
    self.sepView.height = 34;
    [self addSubview:self.sepView];
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 1;
        _textLabel.userInteractionEnabled = NO;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _textLabel;
}

- (UIImageView *)arrowImg{
    if (_arrowImg == nil) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImg.clipsToBounds = YES;
        _arrowImg.userInteractionEnabled = NO;
        _arrowImg.image = [UIImage imageNamed:@"shaixuan"];
    }
    return _arrowImg;
}

- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc]init];
        _sepView.backgroundColor = RGBCOLOR(0xE5E5E5);
    }
    return _sepView;
}

@end
