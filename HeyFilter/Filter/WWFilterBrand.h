//
//  WWFilterBrand.h
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BrandViewClickedCellAction)(id brandDidModel);

@protocol BrandListViewDelegate <NSObject>
- (void)allBrandClickList;
@end

@interface WWFilterBrand : UIView
@property (nonatomic ,strong )UITableView *tableView;
@property (nonatomic, strong) id model;
@property (nonatomic, copy) BrandViewClickedCellAction clickCellAction;
@property (nonatomic, strong) UIButton *allBrandList;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, weak) id <BrandListViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame andIsPhoto:(BOOL )isPhoto;
@end
