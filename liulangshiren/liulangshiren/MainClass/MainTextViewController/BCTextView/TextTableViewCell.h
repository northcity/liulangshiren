//
//  TextTableViewCell.h
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/7.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextTableViewCell : UITableViewCell


@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *dateLabel;


@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgShaowView;

@property (nonatomic, strong) UIView *lineView;


@end

NS_ASSUME_NONNULL_END
