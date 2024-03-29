//
//  LZGestureSetupViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGestureSetupViewController.h"

#import "LZGestureSettingViewController.h"
#import "LZGestureIntroduceViewController.h"


// 10.18
#import "LZGestureTool.h"

static NSString *cellReuseIdentifier = @"com.cellReuseIdentifier";

@interface LZGestureSetupViewController ()<
UITableViewDataSource,
UITableViewDelegate>
{
    UITableView * _tableView;
}

@end

@implementation LZGestureSetupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupMainView];
    [self initOtherUI];
    self.navTitleLabel.text = @"加锁状态";
    [self.setBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)setupNaviBar {
//    LZWeakSelf(ws)
//    [self lzSetNavigationTitle:@"加锁状态"];
//    [self lzSetLeftButtonWithTitle:nil selectedImage:@"关闭2" normalImage:@"关闭2" actionBlock:^(UIButton *button) {
//        [ws.navigationController popViewControllerAnimated:YES];
//    }];
//}

- (void)setupMainView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
//    [_tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    if (PNCisIPAD) {
        _tableView.cellLayoutMarginsFollowReadableWidth = false;
    }
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIdentifier";
    MainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[MainContentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    if (![cell.contentView viewWithTag:147258])
    {
        UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-kAUTOWIDTH(100), 0, kAUTOWIDTH(60),62)];
        lb.text = nil;
        lb.textColor = [UIColor redColor];
        lb.textAlignment = NSTextAlignmentRight;
        lb.tag = 147258;//请勿更改这个。
        lb.hidden = YES;
        lb.font = [UIFont fontWithName:@"HeiTi SC" size:13];
        [cell.contentView addSubview: lb];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString * textLock = @"手势锁定";
    
    cell.textLabel.text = textLock; //手势这行单元格
    
    
    if ([LZGestureTool isGestureEnable])
    {
        UILabel * lb = (UILabel *)[cell.contentView viewWithTag:147258];
        lb.text = @"开启";//开启了手势锁屏
        lb.textColor = [UIColor redColor];
        lb.hidden = NO;
    }
    else if (![LZGestureTool isGesturePswSavedByUser])
    {
        UILabel * lb = (UILabel *)[cell.contentView viewWithTag:147258];
        lb.text = @"未设置";//还没有设置手势密码
        lb.textColor = [UIColor grayColor];
        
        lb.hidden = NO;
    }
    else if (![LZGestureTool isGestureEnableByUser])
    {
        UILabel * lb = (UILabel *)[cell.contentView viewWithTag:147258];
        lb.text = @"关闭";//关闭了手势
        lb.textColor = [UIColor grayColor];
        
        lb.hidden = NO;
    }
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL isHasGestureSavedInNSUserDefaults = [LZGestureTool isGesturePswSavedByUser];
    
    if (isHasGestureSavedInNSUserDefaults)
    {
        
        LZGestureSettingViewController * gsVC = [[LZGestureSettingViewController alloc]init];
        __weak UITableView * ___tableView = _tableView;
        
        gsVC.popBackBlock = ^{
            [___tableView reloadData];
        };
        
        gsVC.title = @"手势设置";
        
        [self.navigationController pushViewController:gsVC animated:YES];
    }
    else
    {
        /**
         手势密码介绍页面
         */
        LZGestureIntroduceViewController *giVC = [[LZGestureIntroduceViewController alloc]init];
        giVC.title = @"手势密码锁定";
        [self.navigationController pushViewController:giVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return @"手势密码作为密码保护的主要验证方式,设置后请妥善保管!";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
}

- (void)dealloc {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
