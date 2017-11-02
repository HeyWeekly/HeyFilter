//
//  WWFilterView.h
//  YaoKe
//
//  Created by steaest on 2017/8/3.
//  Copyright © 2017年 YaoKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWFilterBarView;
@class WWFilterList;
@class WWFilterBrand;
@class WWPriceFilter;

@protocol WWFilterViewDelegate <NSObject>
///select category
@optional
- (void)categoryCatagoryID:(NSString *)catalogIds;
///select price
- (void)priceSureClickLowPrice:(NSString *)lowPrice andHighPrice:(NSString *)highPrice andPriceSort:(NSString *)priceSort;
///select all brand
- (void)didSelAllBrandClickList;
/// select brand
- (void)didSelectBrandGlobId:(NSString *)brandGlobId;
@end

@interface WWFilterView : UIView
///Touch Button
@property (nonatomic, strong) WWFilterBarView* controlBar;
///Category
@property (nonatomic, strong) WWFilterList* category_cb;
///Brand
@property (nonatomic, strong) WWFilterBrand *brandView;
///price
@property (nonatomic, strong) WWPriceFilter *priceView;
///delegate
@property (nonatomic, weak) id <WWFilterViewDelegate> delegate;
///构造方法
- (instancetype)initWithFrame:(CGRect)frame andWithShowSubFilter:(NSInteger )SubFilter andIsView:(BOOL)isView andCateGoryWithStoreId:(NSString *)storeId;
///close animation
- (void)closeFifter;
@end
