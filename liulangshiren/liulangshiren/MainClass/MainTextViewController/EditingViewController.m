//
//  EditingViewController.m
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "EditingViewController.h"
#import "LZSqliteTool.h"
#import "UITextView+YLTextView.h"
#import "ShanNianVoiceSetCell.h"

@interface EditingViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    LZGroupModel *_groupModel;
}
@property (strong, nonatomic)NSArray *titleArray;
@property (strong, nonatomic)NSMutableArray *dataArray;
//内容
@property (nonatomic, strong)UITextView * textView;
//键盘高度
@property (nonatomic, assign) CGRect keyboardHeight;
//标题
@property (nonatomic ,strong)UITextField *titleField;
//展示时间
@property (nonatomic, strong)UILabel *dateLabel;
//展示分组
@property (nonatomic, strong)UILabel *showGroupLabel;
//提醒按钮
@property (nonatomic, strong)UIButton *remindBtn;
//提醒按钮
@property (nonatomic, strong)UIButton *addImageBtn;
//提醒按钮
@property (nonatomic, strong)UIButton *huatongBtn;
//提醒按钮
@property (nonatomic, strong)UIButton *shareBtn;
//功能View
@property (nonatomic,strong)UIView *functionView;
//功能View
@property (nonatomic,strong)UIImageView *functionImageView;
//分组的复式图
@property (nonatomic,strong)UIView *groupFatherView;
//模糊视图
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property(nonatomic,strong) UIImageView *blurImageView;

@property (nonatomic,strong)UIView *groupView;
@property (nonatomic,strong)UITableView *groupTableView;
//分组的数据源
@property (strong, nonatomic)NSMutableArray *groupArray;

//提醒按钮
@property (nonatomic, strong)UIButton *showGroupBtn;

@property (nonatomic, strong)NSIndexPath *seleIndex;
@end

@implementation EditingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navTitleLabel.text = @"诗";
    [self.setBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
    _showGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showGroupBtn setImage:[UIImage imageNamed:@"xuanzefenzu.png"] forState:UIControlStateNormal];
    _showGroupBtn.frame = CGRectMake(ScreenWidth - 29 - kAUTOWIDTH(30) - 29, 30, 25,25);
    [self.titleView addSubview:_showGroupBtn];
        [_showGroupBtn addTarget:self action:@selector(showGroupView) forControlEvents:UIControlEventTouchUpInside];
    if (PNCisIPHONEX) {
        _showGroupBtn.frame = CGRectMake(ScreenWidth - 29 - kAUTOWIDTH(30) - 29, 52,25,25);
    }
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.flog isEqualToString:@"edit"]) {
        [self createData];
    }else {
        for (int i = 0; i < self.titleArray.count; i++) {
            
            if (i == 5 && self.defaultGroup) {
                
                [self.dataArray addObject:self.defaultGroup.groupName];
            } else {
                
                [self.dataArray addObject:@""];
            }
        }
    }
    
    [self creeateTextView];
    [self initOtherUI];
    [self addNoticeForKeyboard];
}

- (void)addNoticeForKeyboard {
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(handleKeyboardDidShow:)
     
                                                name:UIKeyboardDidShowNotification
     
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(handleKeyboardDidHidden)
     
                                                name:UIKeyboardDidHideNotification
     
                                              object:nil];
    
}

#pragma mark 实现监听到键盘变化时的触发的方法

- (void)handleKeyboardDidHidden{
    
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.textView.contentInset = UIEdgeInsetsZero;
                     } completion:nil];
    
}
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification{
    
    NSLog(@"监听方法");
    
    //获取键盘高度
    
    NSValue *keyboardObject =[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    self.keyboardHeight = keyboardRect;
    
    float animationTime = [paramNotification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.textView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.textView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
                     } completion:nil];
    
}




//点击屏幕空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //回收键盘，两种方式
    //UITextView *textView = (UITextView*)[self.view viewWithTag:1001];
    //[textView resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"touch");
}







- (void)doneButtonClick {
    LZWeakSelf(ws)
    LZDataModel *model = nil;
    if (self.model != nil) {
        model = self.model;
    } else {
        model = [[LZDataModel alloc]init];
    }
    
//    LZDetailTableViewCell *cell0 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    model.userName = _textView.text;
//    cell0.detailField.text;
    
//    LZDetailTableViewCell *cell1 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    model.nickName = _titleField.text;
//    cell1.detailField.text;
    
    if (model.userName.length <= 0) {
        
        [SVProgressHUD showErrorWithStatus:@"内容不能为空!"];
        return;
    }
    
    if (model.nickName.length <= 0) {
        
        [SVProgressHUD showErrorWithStatus:@"标题不能为空!"];
        return;
    }
    
    model.dsc = [EditingViewController getCurrentTimes];
//    LZPasswordCell *cell2 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    model.password = cell2.detailField.text;
    
//    LZDetailTableViewCell *cell3 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//    model.urlString = cell3.detailField.text;
    
//    LZDetailTableViewCell *cell4 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
//    model.email = cell4.detailField.text;
    
//    LZDetailTableViewCell *cell5 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
//    model.groupName = cell5.detailField.text;
    
    if (_groupModel) {
        model.groupID = _groupModel.identifier;
    } else {
        model.groupName = self.defaultGroup.groupName;
    }
    
    if (model.groupID == nil || model.groupID.length <= 0) {
        model.groupID = self.defaultGroup.identifier;
    }
    
//    LZRemarkTableViewCell *cell6 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
//    model.dsc = cell6.textView.text;
    
    NSString *message = nil;
    if ([self.flog isEqualToString:@"edit"]) {
        message = @"恭喜,修改成功,是否保存?";
    } else {
        message = @"恭喜,添加成功,是否保存?";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([ws.flog isEqualToString:@"edit"]) {
            [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        } else {
            [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
            LZLog(@"添加了数据:%@",model.groupID);
        }
        
        [ws.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LZSqliteValuesChangedKey object:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)creeateTextView{
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(kAUTOWIDTH(30), PCTopBarHeight + kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(44))];
    [self.view addSubview:self.titleField];
    self.titleField.placeholder = @"标题";
    self.titleField.font = [UIFont fontWithName:@"HeiTi SC" size:18];
    self.titleField.text = self.model.nickName;
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(self.titleField.frame), ScreenWidth - kAUTOWIDTH(60), ScreenHeight - PCTopBarHeight - kAUTOWIDTH(124))];
    [self.view addSubview:_textView];
    _textView.placeholder = @"正文";
    _textView.placeholdFont = [UIFont fontWithName:@"HeiTi SC" size:15];
    _textView.delegate = self;
    _textView.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    _textView.textColor = [UIColor blackColor];
    _textView.text = self.model.userName;
    if(self.model.userName.length > 0){
        _textView.placeholder = @"";
    }
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.scrollEnabled = YES;
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(170), CGRectGetMaxY(_textView.frame) + kAUTOWIDTH(30), kAUTOWIDTH(150), kAUTOWIDTH(25))];
    self.dateLabel.text = [EditingViewController getCurrentTimes];
    self.dateLabel.textColor = PNCColorWithHex(0xdcdcdc);
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    [self.view addSubview:self.dateLabel];
    
    self.showGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(170), CGRectGetMaxY(_textView.frame), kAUTOWIDTH(150), kAUTOWIDTH(25))];
    self.showGroupLabel.text = _defaultGroup.groupName;
    self.showGroupLabel.textColor = PNCColorWithHex(0xdcdcdc);
    self.showGroupLabel.textAlignment = NSTextAlignmentRight;
    self.showGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    [self.view addSubview:self.showGroupLabel];
    self.showGroupLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGroupView)];
    [self.showGroupLabel addGestureRecognizer:tap];
    
    
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15),ScreenHeight - kAUTOWIDTH(70), kAUTOWIDTH(200), kAUTOWIDTH(70))];
//    self.functionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.functionView];
    
//    self.functionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), 0, kAUTOWIDTH(200), kAUTOWIDTH(70))];
//    self.functionView.backgroundColor = [UIColor whiteColor];
//    self.functionImageView.image = [UIImage imageNamed:@"funViewImge"];
//    [self.functionView addSubview:self.functionImageView];
    
    self.remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remindBtn.frame = CGRectMake(0, 0, kAUTOWIDTH(28), kAUTOWIDTH(28));
    
//    [self.functionView addSubview:self.remindBtn];
    [self.remindBtn setImage:[UIImage imageNamed:@"tixing1"] forState:UIControlStateNormal];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImageBtn.frame =CGRectMake(CGRectGetMaxX(self.remindBtn.frame) + kAUTOWIDTH(15), 0, kAUTOWIDTH(30), kAUTOWIDTH(30));
    
//    [self.functionView addSubview:self.addImageBtn];
    [self.addImageBtn setImage:[UIImage imageNamed:@"addtupian"] forState:UIControlStateNormal];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame =CGRectMake(CGRectGetMaxX(self.addImageBtn.frame) + kAUTOWIDTH(15), 0, kAUTOWIDTH(30), kAUTOWIDTH(30));
    
    [self.functionView addSubview:self.shareBtn];
    [self.shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];

    [self.shareBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareImage{
    
    NSString *text = _textView.text;
    NSString *text1 = _titleField.text;

    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1458873452?mt=8"];
    NSArray *activityItems = @[text1,text];
    
    
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

//获取当前的时间
+ (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}


//- (void)textViewDidChange:(UITextView *)textView{
//    CGSize size=[textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
//    CGRect frame=textView.frame;
//
//    if (size.height >= ScreenHeight - PCTopBarHeight - kAUTOWIDTH(64)) {
//        frame.size.height=ScreenHeight - PCTopBarHeight - kAUTOWIDTH(64);
//    }else{
//        frame.size.height=size.height;
//    }
//    textView.frame=frame;
//}

- (void)createData {
    [self.dataArray addObject:self.model.userName];
    [self.dataArray addObject:self.model.nickName];
    [self.dataArray addObject:self.model.password];
    [self.dataArray addObject:self.model.urlString];
    [self.dataArray addObject:self.model.email];
    [self.dataArray addObject:self.model.groupName];
    [self.dataArray addObject:self.model.dsc];
}


- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"用户名:", @"昵   称:", @"密   码:", @"网   址:", @"邮   箱:", @"分   类:", @"备   注:", nil];
    }
    
    return _titleArray;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}



- (void)showGroupView{
    
    if (_groupFatherView) {
        _groupFatherView.hidden = NO;
    }else{
    
    self.groupFatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blurImageView = [[UIImageView alloc]initWithFrame:self.groupFatherView.bounds];
    self.blurImageView.userInteractionEnabled = YES;
    UIImage *screenImage = [self imageWithScreenshot];
    self.blurImageView.image = [self blur:screenImage];
    [self.groupFatherView addSubview:self.blurImageView];
    self.blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurImageView.clipsToBounds = YES;
    self.blurImageView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.blurImageView.alpha = 1;
    }];
    
    CGFloat width = ScreenWidth - kAUTOWIDTH(60);
    CGFloat height = ScreenHeight - PCTopBarHeight - kAUTOWIDTH(250);

    
    self.groupView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), PCTopBarHeight + kAUTOWIDTH(100), ScreenWidth - kAUTOWIDTH(60), ScreenHeight - PCTopBarHeight - kAUTOWIDTH(250))];
    self.groupView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.groupView];
    self.groupView.userInteractionEnabled = YES;
    self.groupView.layer.cornerRadius = 6;
    self.groupView.layer.masksToBounds = YES;
    self.groupView.center = self.groupFatherView.center;
    [self.blurImageView addSubview:self.groupView];

    CALayer* groupViewSubLayer = [CALayer layer];
    CGRect fixBgframe=_groupView.layer.frame;
    groupViewSubLayer.frame = fixBgframe;
    groupViewSubLayer.cornerRadius = 9;
    groupViewSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    groupViewSubLayer.masksToBounds=NO;
    groupViewSubLayer.shadowColor=[UIColor grayColor].CGColor;
    groupViewSubLayer.shadowOffset=CGSizeMake(0,2);
    groupViewSubLayer.shadowOpacity=0.6f;
    groupViewSubLayer.shadowRadius = 7;
    [self.blurImageView.layer insertSublayer:groupViewSubLayer below:_groupView.layer];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, kAUTOWIDTH(40), width, height - kAUTOWIDTH(40));
//    self.groupView.bounds;
    effectView.userInteractionEnabled = YES;
    [_groupView addSubview:effectView];
    self.effectView.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        self.effectView.alpha = 0.5f;
    }];
    [self.view addSubview:self.groupFatherView];
    
  
    UIButton *addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addGroupButton.frame = CGRectMake(width - kAUTOWIDTH(60), height - kAUTOWIDTH(40),kAUTOWIDTH(55),kAUTOWIDTH(18));
    addGroupButton.layer.borderWidth = 0.5;
    addGroupButton.layer.borderColor = [UIColor blackColor].CGColor;
    addGroupButton.layer.cornerRadius = 3;
    [addGroupButton setTitle:@"新建分组" forState:UIControlStateNormal];
    [addGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addGroupButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:9];
//    [addGroupButton setImage:[UIImage imageNamed:@"tanchuangguanbi"] forState:UIControlStateNormal];
//    addGroupButton.backgroundColor = [UIColor redColor];
    [addGroupButton addTarget:self action:@selector(removeNeiGouView) forControlEvents:UIControlEventTouchUpInside];
//    [self.groupView addSubview:addGroupButton];
    
    UIButton *guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guanBiButton.frame = CGRectMake(ScreenWidth/2 - 15, CGRectGetMaxY(_groupView.frame)+kAUTOHEIGHT(15), 30, 30);
    [guanBiButton setImage:[UIImage imageNamed:@"tanchuangguanbi"] forState:UIControlStateNormal];
    guanBiButton.backgroundColor = [UIColor clearColor];
    [guanBiButton addTarget:self action:@selector(removeNeiGouView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurImageView addSubview:guanBiButton];
    
    
    UIButton *addNewGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addNewGroupButton.frame = CGRectMake(width - kAUTOWIDTH(45), 5, kAUTOWIDTH(30), kAUTOWIDTH(30));
    [self.groupView addSubview:addNewGroupButton];
    [addNewGroupButton setImage:[UIImage imageNamed:@"tianjiagroupbai"] forState:UIControlStateNormal];
    [addNewGroupButton addTarget:self action:@selector(insertNewGroup) forControlEvents:UIControlEventTouchUpInside];
    
    _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kAUTOWIDTH(40), width, height - kAUTOWIDTH(40)) style:UITableViewStyleGrouped];
    _groupTableView.backgroundColor = [UIColor whiteColor];
    _groupTableView.delegate = self;
    _groupTableView.dataSource = self;
    [self.groupView addSubview:_groupTableView];
    [_groupTableView registerNib:[UINib nibWithNibName:@"ShanNianVoiceSetCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellID"];
    
//    [self.groupView insertSubview:addGroupButton aboveSubview:_groupTableView];

    if (!_seleIndex) {
        [self.groupTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                         animated:YES
                                   scrollPosition:UITableViewScrollPositionNone];
    }else{
        [self.groupTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.seleIndex.row inSection:self.seleIndex.section]
                                         animated:YES
                                   scrollPosition:UITableViewScrollPositionNone];
    }
    }
    
    [self loadData];
}

- (void)insertNewGroup {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建分组" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *arr = alert.textFields;
        UITextField *text = arr[0];
        LZGroupModel *group = [[LZGroupModel alloc]init];
        group.groupName = text.text;
        [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group];
        
        [ws.groupArray addObject:group];
        //
        [ws.groupTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.groupArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入组名";
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) removeNeiGouView{
//    [self.groupFatherView removeFromSuperview];
    self.groupFatherView.hidden = YES;
//    self.groupFatherView = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShanNianVoiceSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        
        cell = [[ShanNianVoiceSetCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:13];
//        cell.iconImageView.image = [UIImage imageNamed:@"wenjianjia"];

//        cell.textLabel.textColor = [UIColor blackColor];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [cell addGestureRecognizer:longPress];
    }
    
    LZGroupModel *model = [self.groupArray objectAtIndex:indexPath.row];
    cell.monthLabel.text = model.groupName;
    return cell;
}

/// 2016.11.30 新增
/// by: LQQ
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    UITableViewCell *cell = (UITableViewCell*)gesture.view;
    NSIndexPath *indexPath = [self.groupTableView indexPathForCell:cell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改名称" message:@"您可以输入新的分组名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = cell.textLabel.text;
    }];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [[alert textFields] firstObject];
        LZGroupModel *model = [ws.dataArray objectAtIndex:indexPath.row];
        model.groupName = tf.text;
        
        [LZSqliteTool LZUpdateGroupTable:LZSqliteGroupTableName model:model];
        cell.textLabel.text = tf.text;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除分组及分组下的信息,无法恢复,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
        
        LZWeakSelf(ws)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LZGroupModel *group = [ws.dataArray objectAtIndex:indexPath.row];
            
            
            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:group];
            [ws.dataArray removeObject:group];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                
                NSArray *arr = [LZSqliteTool LZSelectGroupElementsFromTable:LZSqliteGroupTableName groupID:group.identifier];
                
                if (arr.count > 0) {
                    
                    for (LZDataModel *model in arr) {
                        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:model];
                    }
                }
            });
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return nil;
    }
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.flog isEqualToString:@"setting"]) {

        return;
    }

    LZGroupModel *model = [self.groupArray objectAtIndex:indexPath.row];
    _groupModel = model;

    _showGroupLabel.text = model.groupName;
    [self removeNeiGouView];

    self.seleIndex = indexPath;
    return;
   
//    if (self.callBack) {
//
//        LZGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
//        self.callBack(model);
//    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (void)loadData {
    if (self.groupArray.count > 0) {
        [self.groupArray removeAllObjects];
    }
    
    NSArray *array = [LZSqliteTool LZSelectAllGroupsFromTable:LZSqliteGroupTableName];
    [self.groupArray addObjectsFromArray:array];
    [self.groupTableView reloadData];
    
}

- (NSMutableArray *)groupArray {
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _groupArray;
}

- (UIImage *)imageWithScreenshot{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

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


@end
