//
//  WWFilterBrand.m
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWFilterBrand.h"
#import "UIView+SDAutoLayout.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface WWFilterBrand ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@end

@implementation WWFilterBrand
- (instancetype)initWithFrame:(CGRect)frame andIsPhoto:(BOOL )isPhoto{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.allBrandList];
        [self.allBrandList sizeToFit];
        self.allBrandList.left = 15;
        self.allBrandList.top = 7;
        self.tableView.frame = CGRectMake(0, self.allBrandList.bottom, kWidth, self.height-self.allBrandList.bottom);
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"brandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSString *name = @"这是一个很大的品牌！";
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 40)];
        label.tag = 990;
        label.text = name;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        UILabel *label = [cell.contentView viewWithTag:990];
        label.text = name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 34)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 34)];
    grayView.backgroundColor = [UIColor whiteColor];
    [view addSubview:grayView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, kWidth/2, 34)];
    label.text = @"选择品牌";
    label.textColor = [UIColor blackColor];
    [grayView addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath;
    if (self.clickCellAction) {
        self.clickCellAction(nil);
    }
}

- (void)clearAllBrand {
    self.selectedIndex = nil;
}

- (void)allBrandListClick {
    if ([self.delegate respondsToSelector:@selector(allBrandClickList)]) {
        [self.delegate allBrandClickList];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)allBrandList {
    if (_allBrandList == nil) {
        _allBrandList = [[UIButton alloc]init];
        [_allBrandList setTitle:@"所有品牌" forState:UIControlStateNormal];
        [_allBrandList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _allBrandList.titleLabel.font = [UIFont fon]
        [_allBrandList addTarget:self action:@selector(allBrandListClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBrandList;
}

@end
