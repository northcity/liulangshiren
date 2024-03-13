//
//  BCGroupViewController.h
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/10.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//   分组管理 、选择分组   LZGroupViewController

#import "BCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^callBackBlock)(id model);


@interface BCGroupViewController : BCBaseViewController

@property (copy, nonatomic)callBackBlock callBack;

@end

NS_ASSUME_NONNULL_END
