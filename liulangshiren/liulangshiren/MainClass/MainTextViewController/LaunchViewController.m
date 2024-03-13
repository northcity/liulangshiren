//
//  LaunchViewController.m
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "LaunchViewController.h"

#import "MainViewController.h"

#import "HomePageViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createImageView];
    
    self.navigationController.navigationBar.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HomePageViewController *lvc = [[HomePageViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:NO];
    });
}

- (void)createImageView{
   
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liulangshiren"]];
    iconImageView.frame = CGRectMake(0, 0, 80, 80);
    iconImageView.center = self.view.center;
    [self.view addSubview:iconImageView];
    iconImageView.layer.cornerRadius = 7;
    iconImageView.layer.masksToBounds = YES;
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=iconImageView.layer.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 7;
    subLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=[UIColor whiteColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,0);
    subLayer.shadowOpacity = 0.7f;
    subLayer.shadowRadius = 5;
//    [self.view.layer insertSublayer:subLayer below:iconImageView.layer];
    
    
    UILabel * label = [Factory createLabelWithTitle:@"Create BY NorthCity 北城出品" frame:CGRectMake(30, ScreenHeight - kAUTOHEIGHT(74), ScreenWidth - 60, 44)];
    [self.view addSubview:label];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:7.5f];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        subLayer.shadowColor = [UIColor clearColor].CGColor;
        subLayer.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            iconImageView.alpha = 0;
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 0;
            }];
        }];
    });
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
