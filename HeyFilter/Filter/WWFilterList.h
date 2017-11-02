//
//  WWFilterList.h
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XER_CollectionViewLayout.h"

@class WWFilterList;
@protocol WWFilterListDelegate <NSObject>
- (void)cateList:(NSString *)subName andCatagoryID:(NSString *)catalogIds;
@end

@interface WWFilterList : UIView<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,XER_CollectionViewLayoutDelegate>
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) XER_CollectionViewLayout *layout;
@property (nonatomic, weak) id <WWFilterListDelegate> delelgate;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) UITableView* tab;
@property (nonatomic, strong, readonly) NSNumber* selectedIndex;
@property (nonatomic, strong, readonly) NSNumber* sub_selectedIndex;
@property (nonatomic, assign) NSInteger clickTime;
@property (nonatomic, assign) NSInteger newIndexRow;
@property (nonatomic, strong) NSNumber *selectID;
@property (nonatomic, copy) NSString *fatherID;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *brandGlobalId;
@property (nonatomic, copy) NSString *cityId;

- (instancetype)initWithStoreID:(NSString *)storeId andHeight:(CGFloat) height andBrandID:(NSString *)brandID;

@end
