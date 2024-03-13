//
//  BCTextDetailViewController.h
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/10.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "BCBaseViewController.h"
#import "LZDataModel.h"
#import "LZGroupModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface BCTextDetailViewController : BCBaseViewController

@property (strong, nonatomic)LZDataModel *model;
@property (strong, nonatomic)LZGroupModel *defaultGroup;
@property (copy, nonatomic)NSString *identifier;

@end

NS_ASSUME_NONNULL_END
