//
//  WWPriceFilter.m
//  YaoKe
//
//  Created by steaest on 2017/7/3.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import "WWPriceFilter.h"
#import "UIView+SDAutoLayout.h"
#import "XER_CollectionViewLayout.h"

#define NOSELECT 10000
#define HIGHPRICE 1
#define LOWPRICE 2
#define screenRate ([[UIScreen mainScreen] bounds].size.width  / 375.0)
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define RGBCOLOR(color) [UIColor colorWithRed:(((color)>>16)&0xff)*1.0/255.0 green:(((color)>>8)&0xff)*1.0/255.0 blue:((color)&0xff)*1.0/255.0 alpha:1.0]

@interface priceCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *priceLabel;
@end

@interface WWPriceFilter ()<UICollectionViewDelegate,UICollectionViewDataSource,XER_CollectionViewLayoutDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *fifLine2;
@property (nonatomic, strong) UILabel *customPrice;
@property (nonatomic, strong) UITextField *lowPrice;
@property (nonatomic, strong) UITextField *highPrice;
@property (nonatomic, strong) UILabel *lowtohigh;
@property (nonatomic, strong) UILabel *priceInterVal;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) XER_CollectionViewLayout *layout;
@property (nonatomic, strong) UILabel *priceSort;
@property (nonatomic, assign) BOOL isHighToLow;
@property (nonatomic, strong) NSString *lowPriceStr;
@property (nonatomic, strong) NSString *highPriceStr;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, assign) NSInteger lowOrhigher;
//排序方式记录
@property (nonatomic, copy) NSString *priceLowPriceSort;
@property (nonatomic, strong) UIImageView *priceLowToHighImage;
@property (nonatomic, strong) UIImageView *priceHighToLowImage;
@end

@implementation WWPriceFilter
- (instancetype)initinitWithHeight:(CGFloat)height{
    if (self == [super init]) {
        self.lowOrhigher = NOSELECT;
        self.height = height;
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lowPriceTextChange:) name:UITextFieldTextDidChangeNotification object:self.lowPrice];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highPriceTextChange:) name:UITextFieldTextDidChangeNotification object:self.highPrice];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //自定义价格区间
    [self addSubview:self.priceSort];
    [self.priceSort sizeToFit];
    self.priceSort.left = 15*screenRate;
    self.priceSort.top = 15*screenRate;
    
    [self addSubview:self.priceHighToLowImage];
    self.priceHighToLowImage.left = self.priceSort.left;
    self.priceHighToLowImage.width = 90*screenRate;
    self.priceHighToLowImage.height = 30*screenRate;
    self.priceHighToLowImage.top = self.priceSort.bottom+10*screenRate;
    
    [self addSubview:self.priceHighToLow];
    self.priceHighToLow.left = self.priceSort.left;
    self.priceHighToLow.width = 90*screenRate;
    self.priceHighToLow.height = 30*screenRate;
    self.priceHighToLow.top = self.priceSort.bottom+10*screenRate;
    
    [self addSubview:self.priceLowToHighImage];
    self.priceLowToHighImage.left = self.priceHighToLowImage.right+15*screenRate;
    self.priceLowToHighImage.width = 90*screenRate;
    self.priceLowToHighImage.height = 30*screenRate;
    self.priceLowToHighImage.top = self.priceHighToLowImage.top;
    
    [self addSubview:self.priceLowToHigh];
    self.priceLowToHigh.left = self.priceHighToLow.right+15*screenRate;
    self.priceLowToHigh.width = 90*screenRate;
    self.priceLowToHigh.height = 30*screenRate;
    self.priceLowToHigh.top = self.priceHighToLow.top;
    
    //价格排序
    [self addSubview:self.customPrice];
    [self.customPrice sizeToFit];
    self.customPrice.left = 15*screenRate;
    self.customPrice.top = self.priceHighToLow.bottom+20*screenRate;
    
    [self addSubview:self.lowPrice];
    [self.lowPrice sizeToFit];
    self.lowPrice.left = self.customPrice.left;
    self.lowPrice.top = self.customPrice.bottom+10*screenRate;
    self.lowPrice.width = 90*screenRate;
    self.lowPrice.height = 30*screenRate;
    
    [self addSubview:self.lowtohigh];
    [self.lowtohigh sizeToFit];
    self.lowtohigh.left = self.lowPrice.right+5*screenRate;
    self.lowtohigh.centerY = self.lowPrice.centerY;
    
    [self addSubview:self.highPrice];
    [self.highPrice sizeToFit];
    self.highPrice.left = self.lowtohigh.right+3;
    self.highPrice.top = self.lowPrice.top;
    self.highPrice.width = 90*screenRate;
    self.highPrice.height = 30*screenRate;
    
    //价格区间
    [self addSubview:self.priceInterVal];
    [self.priceInterVal sizeToFit];
    self.priceInterVal.left = self.priceSort.left;
    self.priceInterVal.centerY = self.lowPrice.bottom+20*screenRate;
    
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, self.priceInterVal.bottom, kWidth, kHeight-self.priceInterVal.bottom-self.sureBtn.height-64-45);
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
}

#pragma mark - collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    priceCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"priceCell" forIndexPath:indexPath];
    cell.priceLabel.text = @"1000-2000";
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath) {
        priceCell* oldCell = (priceCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.row inSection:0]];
        oldCell.priceLabel.textColor = [UIColor blackColor];
        oldCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        oldCell.layer.borderWidth = 1;
        oldCell.backgroundColor = [UIColor clearColor];
        self.selectedIndex = nil;
        self.lowPriceStr = nil;
        self.lowPriceStr = nil;
        self.lowPrice.text = nil;
        self.highPrice.text = nil;
    }else {
        priceCell* oldCell = (priceCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        oldCell.priceLabel.textColor = [UIColor whiteColor];
        oldCell.backgroundColor = [UIColor blackColor];
        oldCell.layer.borderColor = [UIColor clearColor].CGColor;
        oldCell.layer.borderWidth = 0;
        self.lowPriceStr = @"1000";
        self.lowPriceStr = @"2000";
        self.lowPrice.text = @"3000";
        self.highPrice.text =  @"4000";
        self.selectedIndex = indexPath;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    priceCell* oldCell = (priceCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.row inSection:0]];
    oldCell.priceLabel.textColor = [UIColor blackColor];
    oldCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    oldCell.layer.borderWidth = 1;
    oldCell.backgroundColor = [UIColor clearColor];
}
- (CGSize)layout:(XER_CollectionViewLayout *)layout sizeForCellAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90*screenRate, 30*screenRate);
}
- (CGFloat)layout:(XER_CollectionViewLayout *)layout absoluteSideForSection:(NSUInteger)section {
    return 30*screenRate;
}
#pragma mark - touch
- (void)clearAllFifter {
    _priceLowToHighImage.image = [UIImage imageNamed:@"jiagedidaogao"];
    _priceHighToLowImage.image = [UIImage imageNamed:@"jiagegaodi"];
    self.lowOrhigher = NOSELECT;
    self.lowPriceStr = nil;
    self.lowPriceStr = nil;
    self.lowPrice.text = nil;
    self.highPrice.text = nil;
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:self.selectedIndex];
    self.selectedIndex = nil;
}
- (void)cancelClick {
    self.lowPriceStr = nil;
    self.lowPriceStr = nil;
    self.lowPrice.text = nil;
    self.highPrice.text = nil;
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:self.selectedIndex];
    self.selectedIndex = nil;
}
- (void)lowOrHighClick {
    self.lowOrhigher = LOWPRICE;
    _priceLowToHighImage.image = [UIImage imageNamed:@"selecdigao"];
    _priceHighToLowImage.image = [UIImage imageNamed:@"jiagegaodi"];
}
- (void)highOrLowClick {
    self.lowOrhigher = HIGHPRICE;
    _priceLowToHighImage.image = [UIImage imageNamed:@"jiagedidaogao"];
    _priceHighToLowImage.image = [UIImage imageNamed:@"selecgaodi"];
}
- (void)lowPriceTextChange:(NSNotification *)notif {
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:self.selectedIndex];
    self.selectedIndex = nil;
}
- (void)highPriceTextChange:(NSNotification *)notif {
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:self.selectedIndex];
    self.selectedIndex = nil;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.integerValue == 0) {
        textField.text = @"0";
    }
}
- (void)sureClick {
    NSString *sortP;
   if (self.lowOrhigher == HIGHPRICE){
       self.priceLowPriceSort = @"FROM_HIGH_TO_LOW";
       sortP = @"价格由高到低";
   }else if (self.lowOrhigher == LOWPRICE){
       self.priceLowPriceSort = @"FROM_LOW_TO_HIGH";
       sortP = @"价格由低到高";
   }else {
       self.priceLowPriceSort = @"";
   }
    NSInteger one = self.lowPrice.text.integerValue;
    NSInteger two = self.highPrice.text.integerValue;
    if (one>two && self.selectedIndex == nil && self.highPrice.text.length > 0) {
        NSString *str = self.lowPrice.text;
        self.lowPrice.text = self.highPrice.text;
        self.highPrice.text = str;
    }
    NSString *showName;
    if (self.priceLowPriceSort.length > 0) {
        if (self.lowPrice.text.length>0 || self.highPrice.text.length > 0) {
            showName = [self showPriceSortFifter];
        }else {
            showName = sortP;
        }
    }else {
        if (self.lowPrice.text.length>0 || self.highPrice.text.length > 0) {
            showName = [self showPriceSortFifter];
        }else {
            showName = @"价格";
        }
    }
    if ([self.delegate respondsToSelector:@selector(sureClickLowPrice:andHighPrice:andPriceSort: andShowName:)]) {
        [self.delegate sureClickLowPrice:self.lowPrice.text ? self.lowPrice.text : @"" andHighPrice:self.highPrice.text ? self.highPrice.text : @"" andPriceSort:self.priceLowPriceSort andShowName:showName];
    }
}
- (NSString *)showPriceSortFifter {
    NSString *showName;
    if (self.lowPrice.text.length <= 0 || [self.lowPrice.text isEqualToString:@""]) {
        showName = [NSString stringWithFormat:@"<%@",self.highPrice.text];
    }else if ([self.lowPrice.text isEqualToString:@"0"]) {
        showName = [NSString stringWithFormat:@"0~%@",self.highPrice.text];
    }
    if (self.highPrice.text.length <= 0 || [self.highPrice.text isEqualToString:@""] || [self.highPrice.text isEqualToString:@"0"] ) {
        showName = [NSString stringWithFormat:@">%@",self.lowPrice.text];
    }
    if (self.lowPrice.text.length > 0 && self.highPrice.text.length > 0 ) {
        showName = [NSString stringWithFormat:@"%@~%@",self.lowPrice.text,self.highPrice.text];
    }
    return showName;
}

#pragma mark - 懒加载
- (XER_CollectionViewLayout *)layout{
    if (_layout == nil) {
        _layout = [[XER_CollectionViewLayout alloc] init];
        _layout.LineSpacing = 10*screenRate;
        _layout.InteritemSpacing = 15*screenRate;
        _layout.sectionInset = UIEdgeInsetsMake(15*screenRate, 15*screenRate, 60*screenRate, 0*screenRate);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.delegate = self;
        _layout.bounces = NO;
        _layout.lineBreak = YES;
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[priceCell class] forCellWithReuseIdentifier:@"priceCell"];
    }
    return _collectionView;
}
- (UIButton *)priceLowToHigh {
    if (_priceLowToHigh == nil) {
        _priceLowToHigh = [[UIButton alloc]init];
        [_priceLowToHigh addTarget:self action:@selector(lowOrHighClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceLowToHigh;
}
- (UIImageView *)priceLowToHighImage {
    if (!_priceLowToHighImage) {
        _priceLowToHighImage = [[UIImageView alloc]init];
        _priceLowToHighImage.image = [UIImage imageNamed:@"jiagedidaogao"];
    }
    return _priceLowToHighImage;
}
- (UIButton *)priceHighToLow {
    if (_priceHighToLow == nil) {
        _priceHighToLow = [[UIButton alloc]init];
        [_priceHighToLow addTarget:self action:@selector(highOrLowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceHighToLow;
}
- (UIImageView *)priceHighToLowImage {
    if (!_priceHighToLowImage) {
        _priceHighToLowImage = [[UIImageView alloc]init];
        _priceHighToLowImage.image = [UIImage imageNamed:@"jiagegaodi"];
    }
    return _priceHighToLowImage;
}
- (UILabel *)customPrice {
    if (_customPrice == nil) {
        _customPrice = [[UILabel alloc]init];
        _customPrice.text = [NSString stringWithFormat:@"%@:",@"自定义价格"];
        _customPrice.font = [UIFont systemFontOfSize:14*screenRate];
        _customPrice.textColor = [UIColor lightGrayColor];
    }
    return _customPrice;
}
- (UILabel *)lowtohigh {
    if (_lowtohigh == nil) {
        _lowtohigh = [[UILabel alloc]init];
        _lowtohigh.text = @"~";
        _lowtohigh.font = [UIFont systemFontOfSize:14*screenRate];
        _lowtohigh.textColor = [UIColor blackColor];
    }
    return _lowtohigh;
}
- (UITextField *)lowPrice {
    if (_lowPrice == nil) {
        _lowPrice = [[UITextField alloc]init];
        _lowPrice.layer.borderWidth = 1;
        _lowPrice.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _lowPrice.font = [UIFont systemFontOfSize:12*screenRate];
        _lowPrice.textColor = [UIColor blackColor];
        _lowPrice.placeholder = @"最低价";
        _lowPrice.textAlignment = NSTextAlignmentCenter;
        _lowPrice.keyboardType = UIKeyboardTypeNumberPad;
        _lowPrice.layer.cornerRadius = 2;
        _lowPrice.delegate = self;
    }
    return _lowPrice;
}

- (UITextField *)highPrice {
    if (_highPrice == nil) {
        _highPrice = [[UITextField alloc]init];
        _highPrice.layer.borderWidth = 1;
        _highPrice.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _highPrice.font = [UIFont systemFontOfSize:12*screenRate];
        _highPrice.textColor = [UIColor blackColor];
        _highPrice.placeholder = @"最高价";
        _highPrice.textAlignment = NSTextAlignmentCenter;
        _highPrice.keyboardType = UIKeyboardTypeNumberPad;
        _highPrice.layer.cornerRadius = 2;
        _highPrice.delegate = self;
    }
    return _highPrice;
}

- (UILabel *)priceInterVal {
    if (_priceInterVal == nil) {
        _priceInterVal = [[UILabel alloc]init];
        _priceInterVal.text = [NSString stringWithFormat:@"%@:",@"价格区间"];
        _priceInterVal.font = [UIFont systemFontOfSize:14*screenRate];
        _priceInterVal.textColor = [UIColor lightGrayColor];
    }
    return _priceInterVal;
}

- (UIButton *)sureBtn {
    if (_sureBtn == nil) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, self.height-49, kWidth/2, 49)];
        [_sureBtn setBackgroundColor:[UIColor blackColor]];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18*screenRate];
        _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [ _sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UILabel *)priceSort {
    if (_priceSort == nil) {
        _priceSort = [[UILabel alloc]init];
        _priceSort.text = [NSString stringWithFormat:@"%@:",@"价格排序"];
        _priceSort.font = [UIFont systemFontOfSize:14*screenRate];
        _priceSort.textColor = [UIColor grayColor];
    }
    return _priceSort;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height-49, kWidth/2, 49)];
        [_cancelBtn setBackgroundColor:RGBCOLOR(0xF6F6F6)];
        [_cancelBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18*screenRate];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [ _cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _cancelBtn;
}
@end


@implementation priceCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 2;
        [self addSubview:self.priceLabel];
        [self.priceLabel sizeToFit];
        self.priceLabel.centerX = self.bounds.size.width/2;
        self.priceLabel.centerY = self.bounds.size.height/2;
        [self.priceLabel sizeToFit];
    }
    return self;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:12*screenRate];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = @"50001-100000";
    }
    return _priceLabel;
}
@end
