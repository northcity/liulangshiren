//
//  MEEEEViewController.m
//  leisure
//
//  Created by qianfeng0 on 16/3/3.
//  Copyright © 2016年 陈希. All rights reserved.
//

#import "SettingViewController.h"
#import "MainContentCell.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "BCZiTiViewController.h"

//#import "BCMiMaYuJieSuoViewController.h"
#import "LZBaseNavigationController.h"
#import "LZiCloudViewController.h"
#import "ZJViewShow.h"
#import <StoreKit/StoreKit.h>
//#import "RewardSuccess.h"

#import "BCGroupViewController.h"
#import "BCMiMaYuJieSuoViewController.h"
#import "DongHuaSetViewController.h"
#import "BCAboutMeViewController.h"

const CGFloat kNavigationBarHeight = 44;
const CGFloat kStatusBarHeight = 20;

@interface SettingViewController ()<UITableViewDataSource,SKStoreProductViewControllerDelegate, UITableViewDelegate,MFMailComposeViewControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString *selectProductID;
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat scale;

@property(nonatomic,strong)UIAlertController *alert;
@property(nonatomic,strong)UIImageView * backGroundImage;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property(nonatomic,strong)UILabel *desginLabel;

@property(nonatomic,strong)UILabel *zhuTiDetailLabel;
@property(nonatomic,strong)UISwitch *zhuTiKaiGuanButon;

@property (nonatomic, strong) UIView *neiGouView;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *huiFuButton;
@end

@implementation SettingViewController

- (void)initOtherUI{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(5), kAUTOWIDTH(150), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"通用设置";
    _navTitleLabel.font =  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:18];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 30, 22, 22) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 50, 22, 22);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    [_titleView addSubview:_backBtn];
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *pin = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 60, 30)];
    pin.image = [UIImage imageNamed:@"pin"];
    [self.navigationController.navigationBar addSubview:pin];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    image.image = [UIImage imageNamed:@"titlebar_shadow"];
    //信息内容
    [self createUI];
    [self.view insertSubview:image aboveSubview:self.tableView];
    [self initOtherUI];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight+300) style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    if (PNCisIPHONEX) {
        self.tableView.sectionFooterHeight = 0;
    }
    if (PNCisIPAD) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = false;
    }
    
    self.desginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - kAUTOHEIGHT(60), ScreenWidth - 40, 44)];
    self.desginLabel.text = @"- - Create By NorthCity - -";
    self.desginLabel.textColor = PNCColorWithHex(0xdcdcdc);
    self.desginLabel.textAlignment = NSTextAlignmentCenter;
    self.desginLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:9];
    self.desginLabel.alpha = 0.9;
    [self.view addSubview:self.desginLabel];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return UITableViewAutomaticDimension;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"基本通用设置";
    }else if (section == 1){
        return @"使用设置";
    }
    else {
        
        return @"更多设置";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (PNCisIPHONEX) {
        if (section == 0) {
            return 55;
        } else {
            return 35;
        }
    }else{
    if (section == 0) {
        return 35;
    } else {
        return 35;
    }
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if(section == 1){
        return 2;
    }else{
        return 3;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row == 4 && indexPath.section == 2) {
//        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
//        if ([statusString isEqualToString:@"关"]) {
//            return 1;
//            
//        }else if ([statusString isEqualToString:@"开"]){
//            return 62;
//        }else{
//            return 1;
//        }
//    }
//    
//    
//    return 62;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
    NSLog(@"现在的状态%@",statusString);
    if (indexPath.row == 0 && indexPath.section == 0) {
        if ([statusString isEqualToString:@"关"]) {
            return 1;
        }else if ([statusString isEqualToString:@"开"]){
            return 62;
        }else{
            return 1;
        }
    }else if (indexPath.section == 2 && indexPath.row == 2){
        return 190;
    }else{
        return 62;
    }
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MainContentCell";
    
    MainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MainContentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.textLabel.font =  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:14];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"fankui"];
        cell.textLabel.text = @"发送意见";
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"fenxiang1"];
        cell.textLabel.text = @"分享给朋友";
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"dianzan"];
        cell.textLabel.text = @"给个小心心";
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
        if ([statusString isEqualToString:@"开"]) {
            cell.contentView.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if ([statusString isEqualToString:@"关"]){
            cell.contentView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.contentView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.imageView.image = [UIImage imageNamed:@"guanyu"];
        cell.textLabel.text = @"关于北城";
    }
 
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"huiyuan"];
        cell.textLabel.text = @"请喝杯茶吧，不请拉倒。";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"mima"];
        cell.textLabel.text = @"密码与解锁";
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"yun"];
        cell.textLabel.text = @"iCloud设置";
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
       
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"fenzuguanli"];
        cell.textLabel.text = @"分组管理";
    }
  
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"donghuashezhi"];
        cell.textLabel.text = @"动画设置";
    }
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.contentView.frame = CGRectMake(0,0, ScreenWidth, 190);
        cell.label.frame = CGRectMake(10, 10, ScreenWidth-20, 180);
        if (!_backGroundImage) {
            _backGroundImage = [[UIImageView alloc]initWithFrame:cell.label.bounds];
        }
        [cell.label addSubview:_backGroundImage];
        _backGroundImage.backgroundColor = [UIColor clearColor];
        _backGroundImage.image = [UIImage imageNamed:@"IMG_0704.JPG"];
        _backGroundImage.layer.cornerRadius = 6;
        _backGroundImage.layer.masksToBounds = YES;
        _backGroundImage.alpha = 0.6;
        _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;

        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];

        self.effectView.frame = cell.label.bounds;

        self.effectView.alpha = 1.f;
        self.effectView.userInteractionEnabled = YES;
        [_backGroundImage addSubview:self.effectView];

        UILabel * label2 = [Factory createLabelWithTitle:@"* 这就是我心里的一座城池，其他人眼中的一片废墟。" frame:CGRectMake(5,20 ,ScreenWidth-40,55) fontSize:12.f];
        label2.numberOfLines = 0;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor whiteColor];
        //        [cell addSubview:label2];

        UILabel * label1 = [Factory createLabelWithTitle:NSLocalizedString(@"春日傍晚\n落日西斜\n远海的岛屿渐渐看不见了\n忽然岛上亮起了一盏盏灯火\n指明了它们的所在\n— 正冈子规", nil) frame:CGRectMake(0,20 ,ScreenWidth-20,170) fontSize:12.f];
        label1.numberOfLines = 0;

        label1.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
        label1.textAlignment = NSTextAlignmentCenter;
        //        label1.backgroundColor = [UIColor redColor];
        label1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:label1];

        //        cell.label.backgroundColor = [UIColor blackColor];
        cell.label.alpha = 0.5f;



        cell.label.layer.shadowColor=[UIColor grayColor].CGColor;
        cell.label.layer.shadowOffset=CGSizeMake(0, 4);
        cell.label.layer.shadowOpacity=0.6f;
        cell.label.layer.shadowRadius=12;
        //        [self.contentView addSubview:cell.label];
        cell.label.alpha = 0.8;
    }
    
//
//    if (indexPath.section == 2 && indexPath.row == 3) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.imageView.image = [UIImage imageNamed:@"fenzuguanli"];
//        cell.textLabel.text = @"黑白主题";
//    }

    
  
   
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section == 0 && indexPath.row == 0){
        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
        if ([statusString isEqualToString:@"开"]) {
            BCAboutMeViewController * ab = [[BCAboutMeViewController alloc]init];
            [self presentViewController:ab animated:YES completion:nil];
        }
    }
 
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self pushEmail];
    }
    
    if (indexPath.section == 0 && indexPath.row == 4) {
        [self shareImage];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1450722748?mt=8&action=write-review";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }
    if (indexPath.section == 0 && indexPath.row == 3){
        [self initNeiGouView];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        BCMiMaYuJieSuoViewController *bvc = [[BCMiMaYuJieSuoViewController alloc]init];
        LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];

        [self presentViewController:nav animated:YES completion:nil];

    }
    
    
    if (indexPath.section ==  1 &&indexPath.row == 1) {
        LZiCloudViewController *bvc = [[LZiCloudViewController alloc]init];
        LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
//    if (indexPath.section == 2 && indexPath.row == 0) {
//        BCZiTiViewController *bvc = [[BCZiTiViewController alloc]init];
//        [self.navigationController pushViewController:bvc animated:YES];
//    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self pushGroupSetting];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self pushDongHuaSetting];
    }
}


- (void)pushDongHuaSetting{
    DongHuaSetViewController *dVc = [[DongHuaSetViewController alloc]init];
    [self.navigationController pushViewController:dVc animated:YES];
}

- (void)pushGroupSetting{
    BCGroupViewController *group = [[BCGroupViewController alloc]init];
    group.flog = @"setting";
    [self.navigationController pushViewController:group animated:YES];
}


- (void)shareImage{
    
    NSString *text = @"流浪诗人";
   
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1458873452?mt=8"];
    NSArray *activityItems = @[text,urlToShare];
    

    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    // 分享类型
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        // 显示选中的分享类型
        NSLog(@"当前选择分享平台 %@",activityType);
        if (completed) {
            [SVProgressHUD showInfoWithStatus:@"分享成功"];
            NSLog(@"分享成功");
        }else {
            [SVProgressHUD showInfoWithStatus:@"分享失败"];
            
            NSLog(@"分享失败");
        }
        
    }];
    
}

-(void)pushEmail{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (!controller) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        NSLog(@"设备还没有添加邮件账户");
    }else{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

        controller.mailComposeDelegate = self;
        [controller setSubject:@"流浪诗人(iOS版)反馈"];
        NSString * device = [[UIDevice currentDevice] model];
        NSString * ios = [[UIDevice currentDevice] systemVersion];
        NSString *body = [NSString stringWithFormat:@"请留下您的宝贵建议和意见：\n\n\n以下信息有助于我们确认您的问题，建议保留。\nDevice: %@\nOS Version: %@\n inVersion: %@", device, ios,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        [controller setMessageBody:body isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:@"506343891@qq.com"];
        [controller setToRecipients:toRecipients];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的反馈发送成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNeiGouView{
    self.neiGouView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //    self.neiGouView.backgroundColor = PNCColorWithHexA(0x000000, 0.3);
    
    self.blurImageView = [[UIImageView alloc]initWithFrame:self.neiGouView.bounds];
    self.blurImageView.userInteractionEnabled = YES;
    UIImage *screenImage = [self imageWithScreenshot];
    self.blurImageView.image = [self blur:screenImage];
    [self.neiGouView addSubview:self.blurImageView];
    self.blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurImageView.clipsToBounds = YES;
    self.blurImageView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.blurImageView.alpha = 1;
    }];
    
    UIView *mohuView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), 0, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - kAUTOHEIGHT(200))];
    
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        mohuView.frame = CGRectMake(kAUTOWIDTH(30), 0, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - kAUTOHEIGHT(400));
    }
    
    
    mohuView.layer.cornerRadius = 10;
    mohuView.layer.masksToBounds = YES;
    mohuView.center = self.neiGouView.center;
    [self.blurImageView addSubview:mohuView];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = mohuView.bounds;
    effectView.userInteractionEnabled = YES;
    [mohuView addSubview:effectView];
    self.effectView.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        self.effectView.alpha = 0.5f;
    }];
    [self.view addSubview:self.neiGouView];
    
    UIImageView *VipImageView = [[UIImageView alloc]init];
    VipImageView.frame = CGRectMake(mohuView.frame.size.width/2 - kAUTOWIDTH(25), kAUTOHEIGHT(40), kAUTOWIDTH(50), kAUTOHEIGHT(50));
    VipImageView.image = [UIImage imageNamed:@"奖励"];
    VipImageView.backgroundColor = [UIColor clearColor];
    [mohuView addSubview:VipImageView];
    VipImageView.layer.shadowOffset = CGSizeMake(1, 1);
    VipImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
    VipImageView.layer.shadowRadius = 9;
    VipImageView.layer.shadowOpacity = 0.5;
    
    UIButton *guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guanBiButton.frame = CGRectMake(ScreenWidth/2 - 12.5, CGRectGetMaxY(mohuView.frame)+kAUTOHEIGHT(10), 30, 30);
    [guanBiButton setImage:[UIImage imageNamed:@"tanchuangguanbi"] forState:UIControlStateNormal];
    guanBiButton.backgroundColor = [UIColor clearColor];
    [guanBiButton addTarget:self action:@selector(removeNeiGouView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurImageView addSubview:guanBiButton];
    
    UIView *listView1 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(VipImageView.frame) + kAUTOHEIGHT(25), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(60))];
    listView1.layer.cornerRadius = 8;
    listView1.layer.masksToBounds = YES;
    listView1.layer.borderColor = [UIColor redColor].CGColor;
    listView1.layer.borderWidth = 1;
    //    [mohuView addSubview:listView1];
    
    UILabel *label0 =  [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(VipImageView.frame) + kAUTOHEIGHT(5), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(40))];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
        label0.frame = CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(VipImageView.frame) + kAUTOHEIGHT(5), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(60));
    }
    label0.numberOfLines = 0;
    label0.textColor = [UIColor blackColor];
    label0.text = @"流浪诗人高级功能";
    label0.font =  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:16];
    label0.textAlignment = NSTextAlignmentCenter;
    [mohuView addSubview:label0];
    
    UILabel *label1 =  [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(label0.frame) + kAUTOHEIGHT(5), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(180))];
    label1.numberOfLines = 0;
    label1.textColor = [UIColor redColor];
    label1.text = @"流浪诗人是一款免费软件，易用的同时还没有广告。\n然而开发者需要花费很多时间和精力维护。\n你可以给App一个评价，或者给开发者送个便宜的冰棍\n我也会更加有动力持续优化App。";
    label1.font =  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [mohuView addSubview:label1];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake(kAUTOWIDTH(40), mohuView.frame.size.height - kAUTOHEIGHT(76), mohuView.frame.size.width - kAUTOWIDTH(90), kAUTOHEIGHT(40));
    NSString *jiaGeString = [BCUserDeafaults objectForKey:@"NEI_GOU_JIA_QIAN"];
    
    [_buyButton setTitle: [NSString stringWithFormat:@"浪费您一秒钟点个赞,谢谢",@""] forState:UIControlStateNormal];
    _buyButton.layer.cornerRadius = 8;
    _buyButton.layer.masksToBounds = YES;
    _buyButton.layer.borderColor = [UIColor redColor].CGColor;
    _buyButton.layer.borderWidth = 0.5;
    _buyButton.tag = 100;
    _buyButton.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:13];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyButton addTarget:self action:@selector(showAppStoreReView) forControlEvents:UIControlEventTouchUpInside];
    [mohuView addSubview:_buyButton];
    _buyButton.backgroundColor = [UIColor blackColor];
    
    _huiFuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _huiFuButton.frame = CGRectMake(kAUTOWIDTH(40), mohuView.frame.size.height - kAUTOHEIGHT(130), mohuView.frame.size.width - kAUTOWIDTH(90), kAUTOHEIGHT(40));
    [_huiFuButton setTitle:@"送一根老冰棍 ¥ 1" forState:UIControlStateNormal];
    _huiFuButton.layer.cornerRadius = 8;
    _huiFuButton.tag = 101;
    _huiFuButton.layer.masksToBounds = YES;
    _huiFuButton.layer.borderColor = [UIColor redColor].CGColor;
    _huiFuButton.layer.borderWidth = 0.5;
    _huiFuButton.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:13];
    [_huiFuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_huiFuButton addTarget:self action:@selector(testWith:) forControlEvents:UIControlEventTouchUpInside];
    
    [mohuView addSubview:_huiFuButton];
}


- (void)showAppStoreReView{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ISBUYVIP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    
    if ([systemVersion doubleValue] > 10.3) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
}


/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}


//生成一张毛玻璃图片
- (UIImage*)blur:(UIImage*)theImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:18.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

- (void) removeNeiGouView{
    [self.neiGouView removeFromSuperview];
    self.neiGouView = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark 恢复购买(主要是针对非消耗产品)
-(void)replyToBuy{
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_buyButton.frame.size.width/2 - 22,0, 44, 44)];
    //设置显示位置
    _indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    //    _indicator.center = CGPointMake(22, kAUTOWIDTH(110));
    //将这个控件加到父容器中。
    [self.huiFuButton addSubview:_indicator];
    [self.huiFuButton setTitle:@"" forState:UIControlStateNormal];
    [_indicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
#pragma mark 测试内购
-(void)testWith:(UIButton *)button{
    
    
    if([SKPaymentQueue canMakePayments]){
        
        // productID就是你在创建购买项目时所填写的产品ID
        if (button.tag == 100) {
            selectProductID = [NSString stringWithFormat:@"%@",@"com.chenxi.liulangshiren.binggun"];
            _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_buyButton.frame.size.width/2 - 22,0, 44, 44)];
            //设置显示位置
            _indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
            //    _indicator.center = CGPointMake(22, kAUTOWIDTH(110));
            //将这个控件加到父容器中。
            [self.buyButton addSubview:_indicator];
            [self.buyButton setTitle:@"" forState:UIControlStateNormal];
            [_indicator startAnimating];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
        if (button.tag == 101) {
            selectProductID = [NSString stringWithFormat:@"%@",@"com.chenxi.liulangshiren.binggun"];
            
            _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_huiFuButton.frame.size.width/2 - 22,0, 44, 44)];
            //设置显示位置
            _indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
            //    _indicator.center = CGPointMake(22, kAUTOWIDTH(110));
            //将这个控件加到父容器中。
            [self.huiFuButton addSubview:_indicator];
            [self.huiFuButton setTitle:@"" forState:UIControlStateNormal];
            [_indicator startAnimating];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
        
        [self requestProductID:selectProductID];
        
    }else{
        
        // NSLog(@"不允许程序内付费");
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"请先开启应用内付费购买功能。"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles: nil];
        [alertError show];
    }
}

#pragma mark 1.请求所有的商品ID
-(void)requestProductID:(NSString *)productID{
    
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc]initWithArray:productIDArray];
    
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
    
}
#pragma mark 2.苹果那边的内购监听
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"可卖商品的数量=%ld",response.products.count);
    
    NSArray *product = response.products;
    if([product count] == 0){
        
        NSLog(@"没有商品");
        return;
    }
    
    for (SKProduct *sKProduct in product) {
        
        NSLog(@"pro info");
        NSLog(@"SKProduct 描述信息：%@", sKProduct.description);
        NSLog(@"localizedTitle 产品标题：%@", sKProduct.localizedTitle);
        NSLog(@"localizedDescription 产品描述信息：%@",sKProduct.localizedDescription);
        NSLog(@"price 价格：%@",sKProduct.price);
        NSLog(@"productIdentifier Product id：%@",sKProduct.productIdentifier);
        
        if([sKProduct.productIdentifier isEqualToString: selectProductID]){
            
            [self buyProduct:sKProduct];
            
            break;
            
        }else{
            
            //NSLog(@"不不不相同");
        }
        
    }
    
}

#pragma mark 内购的代码调用
-(void)buyProduct:(SKProduct *)product{
    
    // 1.创建票据
    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
    
    // 3.添加观察者，监听用户是否付钱成功(不在此处添加观察者)
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

#pragma mark 4.实现观察者监听付钱的代理方法,只要交易发生变化就会走下面的方法
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    /*
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买
     SKPaymentTransactionStateFailed,        购买失败
     SKPaymentTransactionStateRestored,      回复购买中
     SKPaymentTransactionStateDeferred       交易还在队列里面，但最终状态还没有决定
     */
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:{
                
                NSLog(@"正在购买");
            }break;
            case SKPaymentTransactionStatePurchased:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                NSLog(@"购买成功");
                //                NSLog(@"回复购买中,也叫做已经购买");
                //                [_bgView removeFromSuperview];
                //                [_bgViews removeFromSuperview];
                //                [_bgImageView removeFromSuperview];
                //                [_effectViewT removeFromSuperview];
                
                [self removeNeiGouView];
                //                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                
                //                ZJViewShow * showEndView =  [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:NSLocalizedString( @"购买成功", nil) WithIamgeName:@"c122"];
                //                [win addSubview:showEndView];
                //
//                [RewardSuccess show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [showEndView removeFromSuperview];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ISBUYVIP"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.tableView reloadData];
                    
                });
                
                // 购买后告诉交易队列，把这个成功的交易移除掉
                [queue finishTransaction:transaction];
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:transaction];
            }break;
            case SKPaymentTransactionStateFailed:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                //                [_bgView removeFromSuperview];
                //                [_bgViews removeFromSuperview];
                //                [_bgImageView removeFromSuperview];
                //                [_effectViewT removeFromSuperview];
                //
                [self removeNeiGouView];
                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                
                ZJViewShow * showbeginView = [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:NSLocalizedString( @"谢谢您！", nil) WithIamgeName:@"c13"];
                [win addSubview:showbeginView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [showbeginView removeFromSuperview];
                });
                NSLog(@"谢谢您！");
                // 购买失败也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                NSLog(@"回复购买中,也叫做已经购买");
                //                [_bgView removeFromSuperview];
                //                [_bgViews removeFromSuperview];
                //                [_bgImageView removeFromSuperview];
                //                [_effectViewT removeFromSuperview];
                
                [self removeNeiGouView];
                
                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                
                ZJViewShow * showEndView =  [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:NSLocalizedString( @"恢复购买成功", nil) WithIamgeName:@"c122"];
                [win addSubview:showEndView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [showEndView removeFromSuperview];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ISBUYVIP"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                });
                // 回复购买中也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateDeferred:{
                
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
            }break;
            default:
                break;
        }
    }
}


// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)paymentTransactionp {
    
    NSString * productIdentifier = paymentTransactionp.payment.productIdentifier;
    // NSLog(@"productIdentifier Product id：%@", productIdentifier);
    NSString *transactionReceiptString= nil;
    
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    NSString *version = [UIDevice currentDevice].systemVersion;
    if([version intValue] >= 7.0){
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        NSURLRequest * appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }else{
        
        NSData * receiptData = paymentTransactionp.transactionReceipt;
        //  transactionReceiptString = [receiptData base64EncodedString];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    // 去验证是否真正的支付成功了
    [self checkAppStorePayResultWithBase64String:transactionReceiptString];
    
}

- (void)checkAppStorePayResultWithBase64String:(NSString *)base64String {
    
    /* 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明 */
    /*
     注意：
     自己测试的时候使用的是沙盒购买(测试环境)
     App Store审核的时候也使用的是沙盒购买(测试环境)
     上线以后就不是用的沙盒购买了(正式环境)
     所以此时应该先验证正式环境，在验证测试环境
     
     正式环境验证成功，说明是线上用户在使用
     正式环境验证不成功返回21007，说明是自己测试或者审核人员在测试
     */
    /*
     苹果AppStore线上的购买凭证地址是： https://buy.itunes.apple.com/verifyReceipt
     测试地址是：https://sandbox.itunes.apple.com/verifyReceipt
     */
    //    NSNumber *sandbox;
    NSString *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    //sandbox = @(0);
    sandbox = @"0";
#else
    //sandbox = @(1);
    sandbox = @"1";
#endif
    
    NSMutableDictionary *prgam = [[NSMutableDictionary alloc] init];;
    [prgam setValue:sandbox forKey:@"sandbox"];
    [prgam setValue:base64String forKey:@"reciept"];
    /*
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     0 代表沙盒  1代表 正式的内购
     最后最验证后的
     */
    /*
     内购验证凭据返回结果状态码说明
     21000 App Store无法读取你提供的JSON数据
     21002 收据数据不符合格式
     21003 收据无法被验证
     21004 你提供的共享密钥和账户的共享密钥不一致
     21005 收据服务器当前不可用
     21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
     21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
     21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
     */
    
    NSLog(@"字典==%@",prgam);
    
}

#pragma mark 客户端验证购买凭据
- (void)verifyTransactionResult
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSError *error;
    // 转换为 JSON 格式
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    // 不存在
    if (!requestData) { /* ... Handle error ... */ }
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    // 国内访问苹果服务器比较慢，timeoutInterval 需要长一点
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    // 在后台对列中提交验证请求，并获得官方的验证JSON结果
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"链接失败");
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       NSLog(@"验证失败");
                                   }
                                   
                                   // 比对 jsonResponse 中以下信息基本上可以保证数据安全
                                   /*
                                    bundle_id
                                    application_version
                                    product_id
                                    transaction_id
                                    */
                                   
                                   NSLog(@"验证成功");
                               }
                           }];
    
}

@end


