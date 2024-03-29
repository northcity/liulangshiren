 //
//  LZPasswordViewController.m
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZPasswordViewController.h"
#import "LZNumberView.h"
#import "LZNumberTool.h"

#import "IQKeyboardManager.h"

@interface LZPasswordViewController ()<LZNumberViewDelegate>
{
    BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasNavitationController;//是否含有导航
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) successBlock successed;
@end

@implementation LZPasswordViewController

- (void)dealloc {
    LZLog(@"%@--dealloc",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isHasNavitationController == YES) {
        if (self.navigationController.navigationBarHidden == YES) {
            _isHiddenNavigationBarWhenDisappear = NO;
        } else {
            self.navigationController.navigationBarHidden = YES;
            _isHiddenNavigationBarWhenDisappear = YES;
        }
    }
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    for (int i = 0;  i < 3; i ++) {
        LZNumberView *view = [self.scrollView viewWithTag:100 + i];
        [view becomeFirstRespond];
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:gesture];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isHiddenNavigationBarWhenDisappear == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
   
}

- (void)tapGesture{
    for (int i = 0;  i < 3; i ++) {
        LZNumberView *view = [self.scrollView viewWithTag:100 + i];
        [view becomeFirstRespond];
    }
}
- (void)showInViewController:(UIViewController *)vc style:(LZPasswordStyle)style {
    
    self.style = style;
    [vc presentViewController:self animated:YES completion:^{

    }];
}

//- (void)numberViewShowWithStyle:(LZPasswordStyle)style{
//      self.style = style;
//}


- (void)dismiss {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.style == LZPasswordStyleScreen) {
        
    } else {
        
        [self initOtherUI];
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(10, 20, 44, 44);
//        [backBtn setTitle:@"╳" forState:UIControlStateNormal];
//        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:backBtn];
    }
    [self setupScroll];
    [self.view insertSubview:self.titleView aboveSubview:self.scrollView];
    for (int i = 0;  i < 3; i ++) {
        LZNumberView *view = [self.scrollView viewWithTag:100 + i];
        [view becomeFirstRespond];
    }
}


#pragma mark -- 自定义导航

- (void)initOtherUI{
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(5), kAUTOWIDTH(150), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"密码与解锁";
    _navTitleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:18];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backBtnClick)];
    [_backBtn setImage:[UIImage imageNamed:@"关闭2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));

    }
    [_titleView addSubview:_backBtn];
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];
        
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    });
}



- (void)backBtnClick {
    [self dismiss];
}

- (void)veritySuccess:(successBlock)success {
    
    self.successed = success;
}

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.view.bounds;
        
        // 注释掉此行代码,显示时会有bug,原因未知
        _scrollView.scrollEnabled = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake((self.view.frame.size.width - 200)/2.0, 20, 200, 44);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setupScroll {
    
    switch (self.style) {
        case LZPasswordStyleSetting:
        {
            
            self.navTitleLabel.text = @"设置密码";
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 2, CGRectGetHeight(self.view.frame));
            
            LZNumberView *first = [[LZNumberView alloc]init];
            first.tag = 100;
            first.delegate = self;
            first.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [first addSubview:first.lineView];
            [self.scrollView addSubview:first];
            first.warnLabel.text = @"请输入密码";
            
            LZNumberView *second = [[LZNumberView alloc]init];
            second.tag = 101;
            second.delegate = self;
            second.frame = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:second];
            second.warnLabel.text = @"请确认密码";
        }  break;
        case LZPasswordStyleVerity:
        {
            self.navTitleLabel.text = @"验证密码";
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            
            LZNumberView *first = [[LZNumberView alloc]init];
             first.tag = 100;
            first.delegate = self;
            first.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:first];
            first.warnLabel.text = @"请输入密码";
            [first becomeFirstRespond];

        }  break;
        case LZPasswordStyleUpdate:
        {
            self.navTitleLabel.text = @"重置密码";
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 3, CGRectGetHeight(self.view.frame));
            
            LZNumberView *first = [[LZNumberView alloc]init];
            first.tag = 100;
            first.delegate = self;
            first.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:first];
            first.warnLabel.text = @"请输入旧密码";
            
            LZNumberView *second = [[LZNumberView alloc]init];
            second.tag = 101;
            second.delegate = self;
            second.frame = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:second];
            second.warnLabel.text = @"请输入新密码";
            
            LZNumberView *third = [[LZNumberView alloc]init];
            third.tag = 102;
            third.delegate = self;
            third.frame = CGRectMake(CGRectGetWidth(self.view.frame) * 2, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:third];
            third.warnLabel.text = @"请确认新密码";
            
        }  break;
        case LZPasswordStyleScreen:
        {
            LZNumberView *first = [[LZNumberView alloc]init];
            
            first.delegate = self;
            first.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.scrollView addSubview:first];
            first.warnLabel.text = @"请输入密码";
            [first becomeFirstRespond];
        } break;
        default:
            break;
    }
    
//    [self.view bringSubviewToFront:self.navTitleLabel];
}

#pragma mark - LZNumberViewDelegate
- (void)numberView:(LZNumberView *)view didInput:(NSString *)string {
    
    if (self.style == LZPasswordStyleSetting) {
        
        static NSString* firstString = nil;
        // 设置时, 第一次输入密码结束
        if (view.tag == 100) {
            
            [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
            firstString = string;
            
            LZNumberView *second = [self.scrollView viewWithTag:101];
            [second becomeFirstRespond];
            // 第二次输入结束
        } else if (view.tag == 101) {
            // 两次输入一致
            if ([firstString isEqualToString:string]) {
                
                [LZNumberTool saveNumberPasswordValue:string];
                view.subWarnLabel.text = @"设置成功";
                view.subWarnLabel.textColor = [UIColor colorWithRed:25/255.0 green:177/255.0 blue:29/177.0 alpha:1.0];
                [self performSelector:@selector(done:) withObject:string afterDelay:0.6];
            } else {
                
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                firstString = nil;
                
                LZNumberView *first = [self.scrollView viewWithTag:100];
                [first becomeFirstRespond];
                [first reset];
                [view reset];
                first.subWarnLabel.text = @"两次输入不一致,请重新输入!";
                first.subWarnLabel.textColor = [UIColor redColor];
            }
        }
    } else if (self.style == LZPasswordStyleVerity) {
        
        if ([LZNumberTool isEqualToSavedPassword:string]) {
            [view becomeFirstRespond];
            if (self.successed) {
                self.successed();
            }
            
            [self dismiss];
        } else {
            
            view.subWarnLabel.text = @"密码错误";
            view.subWarnLabel.textColor = [UIColor redColor];
            [view.subWarnLabel.layer shake];
            [view reset];
        }
    } else if (self.style == LZPasswordStyleUpdate) {
        
        static NSString *firstString = nil;
        if (view.tag == 100) {
            
            if ([LZNumberTool isEqualToSavedPassword:string]) {
                
                // 密码正确,进入重置页
                [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
                
                LZNumberView *second = [self.scrollView viewWithTag:101];
                [second becomeFirstRespond];
            } else {
                
                view.subWarnLabel.text = @"密码错误";
                view.subWarnLabel.textColor = [UIColor redColor];
                [view.subWarnLabel.layer shake];
                [view reset];
            }
            
        } else if (view.tag == 101) {
            
            firstString = string;
            [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*2, 0) animated:YES];
            LZNumberView *third = [self.scrollView viewWithTag:102];
            [third becomeFirstRespond];
        } else if (view.tag == 102) {
            
            if ([firstString isEqualToString:string]) {
                
                [LZNumberTool saveNumberPasswordValue:string];
                view.subWarnLabel.text = @"重置成功";
                view.subWarnLabel.textColor = [UIColor colorWithRed:25/255.0 green:177/255.0 blue:29/177.0 alpha:1.0];
                [self performSelector:@selector(done:) withObject:string afterDelay:0.6];
            } else {
                
                [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
                firstString = nil;
                
                LZNumberView *second = [self.scrollView viewWithTag:101];
                [second becomeFirstRespond];
                [second reset];
                [view reset];
                second.subWarnLabel.text = @"两次输入不一致,请重新输入!";
                second.subWarnLabel.textColor = [UIColor redColor];
            }
        }
    } else {
        
        if ([LZNumberTool isEqualToSavedPassword:string]) {
            
            [self dismiss];
        } else {
            
            view.subWarnLabel.text = @"密码错误";
            view.subWarnLabel.textColor = [UIColor redColor];
            [view.subWarnLabel.layer shake];
            [view reset];
        }
    }
    
}
- (void)done:(NSString *)string {
    
    [self dismiss];
}

- (void)numberView:(LZNumberView *)view shouldInput:(NSString *)string {
    
    
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
