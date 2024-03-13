//
//  BCBaseViewController.h
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCBaseViewController : UIViewController

@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic,copy)NSString *flog;

- (void)initOtherUI;

@end

NS_ASSUME_NONNULL_END
