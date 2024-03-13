//
//  BCTextDetailViewController.m
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/10.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "BCTextDetailViewController.h"
#import "EditingViewController.h"
#import "LZSqliteTool.h"

@interface BCTextDetailViewController ()

@property (nonatomic, strong)UILabel *showLabel;

@end

@implementation BCTextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"详情";
    [self.rightButton addTarget:self action:@selector(pushToEditWithAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self createData];
}

- (void)createView{
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), PCTopBarHeight, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - PCTopBarHeight)];
    _showLabel.numberOfLines = 0;
    [self.view addSubview:_showLabel];
}

- (void)createData {
    
    self.model = [LZSqliteTool LZSelectElementFromTable:LZSqliteDataTableName identifier:self.identifier];
    _showLabel.text = self.model.userName;

    
}

- (void)pushToEditWithAnimate:(BOOL)animate {
    
    EditingViewController *edit = [[EditingViewController alloc]init];
    edit.model = self.model;
    edit.flog = @"edit";
    edit.defaultGroup = self.defaultGroup;
    [self.navigationController pushViewController:edit animated:animate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
