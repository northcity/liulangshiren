//
//  BCBaseViewController.m
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "BCBaseViewController.h"

@interface BCBaseViewController ()

@end

@implementation BCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOtherUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fontSizeChange) name:ALL_FONT_CHANGE object:nil];

}

-(void)fontSizeChange{
    
    
}


- (void)initOtherUI{
    self.navigationController.navigationBar.hidden = YES;
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(10), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"流浪地球";
    _navTitleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:18];
    _navTitleLabel.adjustsFontSizeToFitWidth = YES;
    _navTitleLabel.textColor = PNCColorWithHex(0x333333);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];

    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.setBtn setTitle:@"" forState:UIControlStateNormal];
    self.setBtn.frame = CGRectMake(kAUTOWIDTH(15), 26, 30, 30);
//    [self.setBtn addTarget:self action:@selector(pushSettingViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:_setBtn];
 

    if (PNCisIPHONEX) {
        self.setBtn.frame = CGRectMake(kAUTOWIDTH(15), 48, 30, 30);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(30), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(16), kAUTOWIDTH(180), kAUTOHEIGHT(66));
    }
    
    
    _setBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [self.setBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    });
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setImage:[UIImage imageNamed:@"图钉.png"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(ScreenWidth - 29- kAUTOWIDTH(15), 26, 29,29);
    //    self.setBtn.layer.masksToBounds = YES;
    //    self.setBtn.layer.cornerRadius = 25;
    [self.titleView addSubview:_rightButton];
//    [_rightButton addTarget:self action:@selector(addAccountNumberAnimated:) forControlEvents:UIControlEventTouchUpInside];
    if (PNCisIPHONEX) {
        _rightButton.frame = CGRectMake(ScreenWidth - 29- kAUTOWIDTH(15),48,29,29);
    }
}

@end
