//
//  GroupDetailViewController.h
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//  分组内数据  LZGroupSingleViewController

#import "BCBaseViewController.h"
#import "LZGroupModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailViewController : BCBaseViewController

@property (nonatomic, strong) LZGroupModel *groupModel;

@end

NS_ASSUME_NONNULL_END
