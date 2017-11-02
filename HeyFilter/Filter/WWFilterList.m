//
//  WWFilterList.m
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWFilterList.h"
#import "UIView+SDAutoLayout.h"

#define screenRate ([[UIScreen mainScreen] bounds].size.width  / 375.0)
#define RGBCOLOR(color) [UIColor colorWithRed:(((color)>>16)&0xff)*1.0/255.0 green:(((color)>>8)&0xff)*1.0/255.0 blue:((color)&0xff)*1.0/255.0 alpha:1.0]


@interface WWFilterLeftCell : UITableViewCell
@property (nonatomic, strong) UIImageView *categoryIamge;
@property (nonatomic, strong) UILabel *categoryName;
@property (nonatomic, strong) UIImageView *directionImage;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *contraintView;
@end


@interface WWFilterRightSubCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *subName;
@property (nonatomic,strong) UIImageView *categoryImage;
@end


@implementation WWFilterList

- (instancetype)initWithStoreID:(NSString *)storeId andHeight:(CGFloat) height andBrandID:(NSString *)brandID{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.clickTime = 1;
        self.storeId = storeId;
        self.height = height;
        self.brandGlobalId = brandID;
        [self setUpSubviews];
    }
    return self;
}

- (void)clearCab {
    self.clickTime = 1;
}

- (void)setItemId:(NSString *)itemId {
    _itemId = itemId;
}

- (void)layoutSubviews {
    [self.tab reloadData];
    [self.collectionView reloadData];
}

- (void)setUpSubviews{
    [self addSubview:self.tab];
    [self addSubview:self.collectionView];
    self.tab.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* dict = @{@"tab":self.tab,@"sub":self.collectionView};
    NSDictionary *metrics = @{@"tabw":@(100*screenRate),@"subw":@((275)*screenRate),@"allsizeH":@(45*screenRate),@"allsizeV":@(160*screenRate),@"shadowsize":@(8*screenRate),@"allW":@(42*screenRate)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tab(==tabw)]-0-[sub(==subw)]-0-|" options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tab]-0-|" options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sub]-0-|" options:0 metrics:metrics views:dict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.height]];
}

#pragma mark - tabbleView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tab]) {
        WWFilterLeftCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kCellCategory" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.line.hidden = YES;
        }else {
            cell.line.hidden = NO;
        }
        cell.categoryName.text = @"大分类";
        if (indexPath.row == self.selectID.integerValue) {
            cell.backgroundColor = [UIColor whiteColor];
        }else {
            cell.backgroundColor = RGBCOLOR(0xF2F2F2);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42*screenRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WWFilterLeftCell* oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectID.unsignedIntegerValue inSection:0]];
    oldCell.backgroundColor = RGBCOLOR(0xF2F2F2);
    WWFilterLeftCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.newIndexRow != indexPath.row) {
        self.newIndexRow = indexPath.row;
    }else {
        self.clickTime = self.clickTime+1;
    }
    if (self.clickTime == 2) {
        if ([self.delelgate respondsToSelector:@selector(cateList:andCatagoryID:)]) {
            [self.delelgate cateList:cell.categoryName.text andCatagoryID:nil];
        }
        self.clickTime = 1;
    }else {
        self.selectID = [NSNumber numberWithInteger:indexPath.row];
        WWFilterLeftCell* oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectID.unsignedIntegerValue inSection:0]];
        oldCell.directionImage.hidden = YES;
        WWFilterLeftCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.directionImage.hidden = NO;
        [self.collectionView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tab]) {
        WWFilterLeftCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = RGBCOLOR(0xF2F2F2);
    }
}

#pragma mark - collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
            return 20;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        WWFilterRightSubCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"skucell" forIndexPath:indexPath];
        cell.categoryImage.image = nil;
        cell.categoryImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.subName.text = @"小分类";
        return cell;
    }
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        NSString *catalodsName = @"选中的";
        if ([self.delelgate respondsToSelector:@selector(cateList:andCatagoryID:)]) {
            [self.delelgate cateList:catalodsName andCatagoryID:nil];
        }
    }
}

- (CGSize)layout:(XER_CollectionViewLayout *)layout sizeForCellAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(110*screenRate, 25*screenRate);
}

- (CGFloat)layout:(XER_CollectionViewLayout *)layout absoluteSideForSection:(NSUInteger)section {
    return 25*screenRate;
}

#pragma mark - 懒加载
- (UITableView *)tab{
    if (_tab == nil) {
        _tab = [[UITableView alloc] init];
        _tab.delegate = self;
        _tab.dataSource = self;
        [_tab registerClass:[WWFilterLeftCell class] forCellReuseIdentifier:@"kCellCategory"];
        _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tab.showsHorizontalScrollIndicator = NO;
        _tab.showsVerticalScrollIndicator = NO;
        _tab.bounces = NO;
        _tab.scrollEnabled = YES;
        _tab.backgroundColor = RGBCOLOR(0xf2f2f2);
    }
    return _tab;
}

- (XER_CollectionViewLayout *)layout{
    if (_layout == nil) {
        _layout = [[XER_CollectionViewLayout alloc] init];
        _layout.LineSpacing = 10*screenRate;
        _layout.InteritemSpacing = 25*screenRate;
        _layout.sectionInset = UIEdgeInsetsMake(15*screenRate, 22.5*screenRate, 60*screenRate, 0*screenRate);
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
        [_collectionView registerClass:[WWFilterRightSubCell class] forCellWithReuseIdentifier:@"skucell"];
    }
    return _collectionView;
}

@end


#pragma mark - tabbleViewCell
@implementation WWFilterLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBCOLOR(0xF2F2F2);
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    [self addSubview:self.categoryName];
    [self addSubview:self.line];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryIamge.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryName.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *dict = @{@"name":self.categoryName,@"l":self.line,@"dimage":self.directionImage};
    NSDictionary *metrics1 = @{@"Hline":@(13*screenRate),@"Himage":@(16*screenRate),@"imagesize":@(20*screenRate),@"iamgetoname":@(20*screenRate),@"dimagew":@(18*screenRate),@"linew":@(49*screenRate),@"namesizeto":@(8*screenRate)};
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.categoryName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[l]-0-|" options:0 metrics:metrics1 views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[l(==0.5)]" options:0 metrics:metrics1 views:dict]];
}

#pragma mark - 懒加载
- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = RGBCOLOR(0xE5E5E5);
    }
    return _line;
}

- (UIImageView *)categoryIamge {
    if (_categoryIamge == nil) {
        _categoryIamge = [[UIImageView alloc]init];
        _categoryIamge.contentMode = UIViewContentModeScaleAspectFill;
        _categoryIamge.clipsToBounds = YES;
    }
    return _categoryIamge;
}

- (UILabel *)categoryName {
    if (_categoryName == nil) {
        _categoryName = [[UILabel alloc]init];
        _categoryName.textColor = [UIColor blackColor];
        _categoryName.font = [UIFont systemFontOfSize:14];
    }
    return _categoryName;
}

- (UIImageView *)directionImage {
    if (_directionImage == nil) {
        _directionImage = [[UIImageView alloc]init];
        _directionImage.image = [UIImage imageNamed:@"categorytabArrow"];
        _directionImage.contentMode = UIViewContentModeScaleAspectFill;
        _directionImage.hidden = YES;
        _directionImage.clipsToBounds = YES;
    }
    return _directionImage;
}

@end


#pragma mark - collectionViewCell
@implementation WWFilterRightSubCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    [self.contentView addSubview:self.subName];
    [self.subName sizeToFit];
    self.subName.left = 0;
    self.subName.top = 0;
    self.subName.width = self.bounds.size.width;
}

#pragma mark - 懒加载
- (UILabel *)subName {
    if (_subName == nil) {
        _subName = [[UILabel alloc]init];
        _subName.text = @"小分类";
        _subName.numberOfLines = 1;
        _subName.textAlignment = NSTextAlignmentCenter;
        _subName.textColor = [UIColor blackColor];
        _subName.font = [UIFont systemFontOfSize:12];
    }
    return _subName;
}

- (UIImageView *)categoryImage {
    if (_categoryImage == nil) {
        _categoryImage = [[UIImageView alloc]init];
        _categoryImage.clipsToBounds = YES;
        _categoryImage.contentMode = UIViewContentModeScaleAspectFit;
        _categoryImage.image = [UIImage imageNamed:@"allimageView"];
    }
    return _categoryImage;
}

@end
