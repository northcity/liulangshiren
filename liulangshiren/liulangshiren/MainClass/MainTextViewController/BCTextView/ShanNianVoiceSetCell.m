//
//  ShanNianSetTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/6.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import "ShanNianVoiceSetCell.h"

@implementation ShanNianVoiceSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 50)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.cornerRadius= 6;
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
//    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
//    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    [self createSubViews];
    [self updateSubViewsFrame];
    
}

- (void)createSubViews{
   
    self.monthLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.monthLabel.textAlignment = NSTextAlignmentLeft;
    self.monthLabel.textColor = [UIColor blackColor];
    self.monthLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:13];
    [self.contentView addSubview:self.monthLabel];
    
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wancheng"]];
    self.selectedImageView.hidden = YES;
    [self.contentView addSubview:self.selectedImageView];
    
    self.iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenjianjia"]];
    self.iconImageView.hidden = NO;
    [self.contentView addSubview:self.iconImageView];
}


// Layout布局
- (void)updateSubViewsFrame {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kAUTOWIDTH(15));
        make.width.mas_offset(22);
        make.height.mas_offset(22);
    }];
    
    
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(kAUTOWIDTH(10));
        make.right.equalTo(self).offset(-kAUTOWIDTH(50));
        make.height.mas_offset(kAUTOWIDTH(200));
    }];
    
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(kAUTOWIDTH(-22));
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        if (selected) {
            self.selectedImageView.hidden = NO;
            self.contentView.backgroundColor = PNCColorWithHex(0xF9FAFF);
        }else{
            self.selectedImageView.hidden = YES;
            self.contentView.backgroundColor = PNCColorWithHex(0xFFFFFF);
        }
}



@end

