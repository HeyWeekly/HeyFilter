//
//  ViewController.m
//  HeyFilter
//
//  Created by 王伟伟 on 2017/11/2.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "ViewController.h"
#import "WWFilterView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<WWFilterViewDelegate>
@property (nonatomic, strong) WWFilterView *fifterView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Filter";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.fifterView];
}

#pragma mark - 懒加载
- (WWFilterView *)fifterView {
    if (_fifterView == nil) {
        _fifterView = [[WWFilterView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) andWithShowSubFilter:300 andIsView:YES andCateGoryWithStoreId:nil];
        _fifterView.delegate = self;
    }
    return _fifterView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 75, kWidth-40, kHeight-100)];
        _tipLabel.text = @"       框架的第一部分，分类、价格、品牌功能的具体的代码已经编写完毕，代理以及回调也事先写好了，控制器所需要的属性及模型都可以自由传递。控制线显示几个筛选栏也可以自定义。等这一段时间忙完，我会把剩下细枝末节编写完毕上传。";
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
