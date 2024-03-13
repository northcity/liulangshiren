//
//  TextTableViewCell.m
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/7.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(170))];
        _bgView.backgroundColor = [UIColor whiteColor];
//        _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
//        _bgView.layer.shadowOffset=CGSizeMake(0, -1);
//        _bgView.layer.shadowOpacity = 0.4f;
//        _bgView.layer.shadowRadius = 1;
        
        _bgShaowView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(26), kAUTOWIDTH(31), ScreenWidth - kAUTOWIDTH(50), kAUTOWIDTH(170))];
//        _bgShaowView.backgroundColor = [UIColor whiteColr];
        _bgShaowView.image = [UIImage imageNamed:@"Rectangl"];
        [self.contentView addSubview:_bgShaowView];
        [self.contentView addSubview:_bgView];

        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(5), kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(60) - kAUTOWIDTH(10), kAUTOWIDTH(30))];
        _titleLabel.textColor = PNCColor(79, 79, 79);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        _titleLabel.numberOfLines = 0;
        [self.bgView addSubview:_titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(5), CGRectGetMaxY(_titleLabel.frame) + kAUTOWIDTH(0), ScreenWidth - kAUTOWIDTH(60) - kAUTOWIDTH(10), kAUTOWIDTH(80))];
        _detailLabel.textColor = PNCColor(134, 134, 134);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];
        _detailLabel.numberOfLines = 0;
//        _detailLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:_detailLabel];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        self.backgroundColor = [UIColor clearColor];
        
//
        _bgShaowView.layer.shadowOffset = CGSizeMake(0,0);
        _bgShaowView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bgShaowView.layer.shadowRadius = 9;
        _bgShaowView.layer.shadowOpacity = 0.4;
        
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15),kAUTOWIDTH(170) - kAUTOWIDTH(40), ScreenWidth - kAUTOWIDTH(60) - kAUTOWIDTH(30), 0.5)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.3;
        [self.bgView addSubview:_lineView];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15),kAUTOWIDTH(170) - kAUTOWIDTH(40), ScreenWidth - kAUTOWIDTH(60) - kAUTOWIDTH(30), kAUTOWIDTH(40))];
        _dateLabel.textColor = PNCColor(58, 58, 58);
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14];
        _dateLabel.numberOfLines = 0;
        _dateLabel.text = @"2016年6月16日 星期四 15:16";
        //        _detailLabel.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:_dateLabel];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
