//
//  WWFilterView.m
//  YaoKe
//
//  Created by steaest on 2017/8/3.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import "WWFilterView.h"
#import "WWFilterBarView.h"
#import "WWFilterBarCell.h"
#import "WWPriceFilter.h"
#import "WWFilterList.h"
#import "WWFilterBrand.h"
#import "UIView+SDAutoLayout.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface WWFilterView ()<WWFilterListDelegate,WWPriceFilterDelegate,BrandListViewDelegate>
@property (nonatomic, strong) NSLayoutConstraint *priceCon;
@property (nonatomic, strong) NSLayoutConstraint *brandCon;
@property (nonatomic, strong) NSLayoutConstraint* catCon;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, assign) NSInteger SubFilter;
@property (nonatomic, assign) NSInteger fifterCon;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) BOOL isView;
@end

@implementation WWFilterView

#pragma mark - 构造方法初始化
- (instancetype)initWithFrame:(CGRect)frame andWithShowSubFilter:(NSInteger )SubFilter andIsView:(BOOL)isView andCateGoryWithStoreId:(NSString *)storeId{
    if (self = [super initWithFrame:frame]) {
        self.storeId = storeId;
        self.isView = isView;
        self.oldFrame = frame;
        self.SubFilter = SubFilter;
        self.fifterCon = frame.size.height-44;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - 视图布局
- (void)setupSubviews {
    __weak __typeof__(self) weakSelf = self;
    [self addSubview:self.priceView];
    [self addSubview:self.brandView];
    [self addSubview:self.category_cb];
    [self addSubview:self.controlBar];
    self.priceView.translatesAutoresizingMaskIntoConstraints = NO;
    self.brandView.translatesAutoresizingMaskIntoConstraints = NO;
    self.controlBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.category_cb.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict = @{@"cb":self.controlBar,@"catcb":self.category_cb,@"fifter":self.priceView,@"brand":self.brandView};
    NSDictionary *metrics = @{@"cbh":@(44),@"fifH":@(self.fifterCon)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[fifter]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cb]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[catcb]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[brand]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[fifter(==fifH)]" options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[brand(==fifH)]" options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[catcb(==fifH)]" options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cb(==cbh)]" options:0 metrics:metrics views:dict]];
    self.catCon = [NSLayoutConstraint constraintWithItem:self.category_cb attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.controlBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.fifterCon];
    [self addConstraint:self.catCon];
    self.priceCon = [NSLayoutConstraint constraintWithItem:self.priceView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.controlBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.fifterCon];
    [self addConstraint:self.priceCon];
    self.brandCon = [NSLayoutConstraint constraintWithItem:self.brandView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.controlBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.fifterCon];
    [self addConstraint:self.brandCon];
    [self fifterViewFrameAdjusts];
    ///select brand
    self.brandView.clickCellAction = ^(id brandDidModel) {
        weakSelf.controlBar.brandCell.textLabel.text = @"选中品牌";
        [weakSelf closeFifter];
        if ([weakSelf.delegate respondsToSelector:@selector(didSelectBrandGlobId:)]) {
            [weakSelf.delegate didSelectBrandGlobId:nil];
        }
    };
}

- (void)fifterViewFrameAdjusts {
    if (self.isView == YES) {
        self.frame = CGRectMake(0, 0, kWidth, 44);
    }else {
        self.frame = CGRectMake(0, 64, kWidth, 44);
    }
}

#pragma mark - delegate && touch
///select category
- (void)cateList:(NSString *)subName andCatagoryID:(NSString *)catalogIds {
    [self closeFifter];
    self.controlBar.catCell.textLabel.text = subName;
    if ([self.delegate respondsToSelector:@selector(categoryCatagoryID:)]) {
        [self.delegate categoryCatagoryID:catalogIds];
    }
}
/// select price
- (void)sureClickLowPrice:(NSString *)lowPrice andHighPrice:(NSString *)highPrice andPriceSort:(NSString *)priceSort andShowName:(NSString *)showName{
    [self closeFifter];
    self.controlBar.priceCell.textLabel.text = showName;
    if ([self.delegate respondsToSelector:@selector(priceSureClickLowPrice:andHighPrice:andPriceSort:)]) {
        [self.delegate priceSureClickLowPrice:lowPrice andHighPrice:highPrice andPriceSort:priceSort];
    }
}
///  select all brand
- (void)allBrandClickList {
    [self closeFifter];
    self.controlBar.brandCell.textLabel.text = @"所有品牌";
    if ([self.delegate respondsToSelector:@selector(didSelAllBrandClickList)]) {
        [self.delegate didSelAllBrandClickList];
    }
}

#pragma mark - 动画
- (void)showCatCB{
    self.frame = self.oldFrame;
    if (self.catCon.constant == -self.fifterCon) {
        [UIView animateWithDuration:0.3 animations:^{
            self.priceCon.constant = -self.fifterCon;
            self.brandCon.constant = -self.fifterCon;
            self.controlBar.priceCell.arrowImg.transform = CGAffineTransformIdentity;
            self.controlBar.brandCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                self.catCon.constant = 0;
                self.controlBar.catCell.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }else{
        [self fifterViewFrameAdjusts];
        [UIView animateWithDuration:0.3 animations:^{
            self.catCon.constant = -self.fifterCon;
            self.controlBar.catCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        }];
    }
}

- (void)showPriceCB{
    self.frame = self.oldFrame;
    if (self.priceCon.constant == -self.fifterCon) {
        [UIView animateWithDuration:0.3 animations:^{
            self.catCon.constant = -self.fifterCon;
            self.brandCon.constant = -self.fifterCon;
            self.controlBar.catCell.arrowImg.transform = CGAffineTransformIdentity;
            self.controlBar.brandCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.priceCon.constant = 0;
                self.controlBar.priceCell.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }else {
        [self fifterViewFrameAdjusts];
        [UIView animateWithDuration:0.25 animations:^{
            self.priceCon.constant = -self.fifterCon;
            self.controlBar.priceCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void)showBrandCB {
    self.frame = self.oldFrame;
    if (self.brandCon.constant == -self.fifterCon) {
        [UIView animateWithDuration:0.3 animations:^{
            self.catCon.constant = -self.fifterCon;
            self.priceCon.constant = -self.fifterCon;
            self.controlBar.catCell.arrowImg.transform = CGAffineTransformIdentity;
            self.controlBar.priceCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.brandCon.constant = 0;
                self.controlBar.brandCell.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }else {
        [self fifterViewFrameAdjusts];
        [UIView animateWithDuration:0.25 animations:^{
            self.brandCon.constant = -self.fifterCon;
            self.controlBar.brandCell.arrowImg.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void)closeFifter {
    [self fifterViewFrameAdjusts];
    [UIView animateWithDuration:0.25 animations:^{
        self.priceCon.constant = -self.fifterCon;
        self.brandCon.constant = -self.fifterCon;
        self.catCon.constant = -self.fifterCon;
        self.controlBar.brandCell.arrowImg.transform = CGAffineTransformIdentity;
        self.controlBar.catCell.arrowImg.transform = CGAffineTransformIdentity;
        self.controlBar.priceCell.arrowImg.transform = CGAffineTransformIdentity;
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark - 懒加载
- (WWFilterBarView *)controlBar{
    if (_controlBar == nil) {
        _controlBar = [[WWFilterBarView alloc] initWithTitle:nil andHiddenBrand:self.SubFilter];
        [_controlBar.catCell addTarget:self action:@selector(showCatCB) forControlEvents:UIControlEventTouchUpInside];
        [_controlBar.brandCell addTarget:self action:@selector(showBrandCB) forControlEvents:UIControlEventTouchUpInside];
        [_controlBar.priceCell addTarget:self action:@selector(showPriceCB) forControlEvents:UIControlEventTouchUpInside];
        _controlBar.priceCell.sepView.hidden = YES;
        _controlBar.bottomline.hidden = NO;
    }
    return _controlBar;
}

- (WWFilterList *)category_cb{
    if (_category_cb == nil) {
        _category_cb = [[WWFilterList alloc] initWithStoreID:self.storeId andHeight:self.fifterCon andBrandID:nil];
        _category_cb.storeId = self.storeId;
        _category_cb.delelgate = self;
    }
    return _category_cb;
}

- (WWPriceFilter *)priceView {
    if (_priceView == nil) {
        _priceView = [[WWPriceFilter alloc]initinitWithHeight:self.fifterCon];
        _priceView.delegate = self;
    }
    return _priceView;
}

- (WWFilterBrand *)brandView {
    if (_brandView == nil) {
        _brandView = [[WWFilterBrand alloc] initWithFrame:CGRectMake(0, self.controlBar.bottom, kWidth, self.fifterCon) andIsPhoto:NO];
        _brandView.delegate = self;
    }
    return _brandView;
}

@end
