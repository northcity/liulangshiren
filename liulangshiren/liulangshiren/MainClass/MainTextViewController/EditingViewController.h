//
//  EditingViewController.h
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//编辑页面  LZEditViewController

#import "BCBaseViewController.h"
#import "LZDataModel.h"
#import "LZGroupModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface EditingViewController : BCBaseViewController

@property (strong, nonatomic)LZDataModel *model;
@property (strong, nonatomic)LZGroupModel *defaultGroup;

@end

NS_ASSUME_NONNULL_END
