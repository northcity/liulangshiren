//
//  MainContentCell.m
//  NewRevenue
//
//  Created by 北城 on 16/8/31.
//  Copyright © 2016年 com.beicheng. All rights reserved.
//

#import "DongHuaTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define DEF_UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation DongHuaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self updateSubViewsFrame];
    }
    return self;
}

- (void)createSubViews{
    _label = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 50)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.cornerRadius = kAUTOWIDTH(4);
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];

    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ng_bps_fuceng_duigou"]];
    self.selectedImageView.hidden = YES;
    [self.label addSubview:self.selectedImageView];
}

// Layout布局
- (void)updateSubViewsFrame {

    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(kAUTOWIDTH(-22));
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedImageView.hidden = NO;
//        self.contentView.backgroundColor = PNCColorWithHex(0xF9FAFF);
        //        self.monthLabel.textColor = PNCColorWithHex(0x4586ff);

    }else{
        self.selectedImageView.hidden = YES;
        //        self.monthLabel.textColor = PNCColorWithHex(0x222222);
//        self.contentView.backgroundColor = PNCColorWithHex(0xFFFFFF);

    }
}

@end
