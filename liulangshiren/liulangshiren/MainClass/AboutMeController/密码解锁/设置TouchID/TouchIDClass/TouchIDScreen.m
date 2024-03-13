//
//  TouchIDScreen.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/8.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import "TouchIDScreen.h"
#import "LZGestureViewController.h"
#import "TouchIdUnlock.h"
//#import "BCShanNianKaPianManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchIDScreen ()<LZGestureViewDelegate>
{
    LZGestureViewController *_gestureVC;
}
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) LAContext *LAContent;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *labelTitle;

@end

@implementation TouchIDScreen
+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static TouchIDScreen *share = nil;
    dispatch_once(&onceToken, ^{
        share = [[self alloc]init];
    });
    
    return share;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self changeForTouchID];
        _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.windowLevel = UIWindowLevelStatusBar;
        
        _vc = [[UIViewController alloc]init];
        _window.rootViewController =_vc;
        
        
        UIImageView *touchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(70)/2, PCTopBarHeight + kAUTOHEIGHT(50), kAUTOWIDTH(70), kAUTOHEIGHT(70))];
        
        [_vc.view addSubview:touchImageView];
        touchImageView.image = [UIImage imageNamed:@"liulangshiren"];
        _vc.view.backgroundColor = [UIColor whiteColor];
       
        touchImageView.layer.cornerRadius = kAUTOHEIGHT(7);
        touchImageView.layer.masksToBounds = YES;
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe=touchImageView.layer.frame;
        subLayer.frame = fixframe;
        subLayer.cornerRadius = kAUTOHEIGHT(7);
        subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        subLayer.masksToBounds=NO;
        subLayer.shadowColor=[UIColor grayColor].CGColor;
        subLayer.shadowOffset=CGSizeMake(0,5);
        subLayer.shadowOpacity=0.6f;
        subLayer.shadowRadius= 12;
        [_vc.view.layer insertSublayer:subLayer below:touchImageView.layer];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(70), CGRectGetMaxY(touchImageView.frame) + kAUTOHEIGHT(30), kAUTOWIDTH(55), kAUTOHEIGHT(55));
        button.center = _vc.view.center;
        [button setTitle:@"指纹" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(showTouchID) forControlEvents:UIControlEventTouchUpInside];
        [_vc.view addSubview:button];
        
        UILabel *label =[[UILabel alloc]init];
        label.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, CGRectGetMaxY(button.frame) + kAUTOHEIGHT(20), kAUTOWIDTH(150), 30);
        label.text = self.labelTitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"HeiTi SC" size:14];
        [_vc.view addSubview:label];
    }
    return self;
}

- (void)changeForTouchID{
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        self.LAContent = [[LAContext alloc] init];
        
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [self.LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (self.LAContent.biometryType) {
                        case LABiometryNone:
                        {
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            self.imageName = @"指纹icon";
                            self.labelTitle = @"点击使用指纹解锁";
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            self.imageName = @"人脸对比icon";
                            self.labelTitle = @"点击使用FaceId解锁";
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // Fallback on earlier versions
                    NSLog(@"iOS 11之前不需要判断 biometryType");
                    // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                }
                
            } else {
            }
        }
        
    } else {
        // Fallback on earlier versions
    }
}




- (void)showTouchID{
    [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
        [self dismiss];
    }];
}

- (void)show {
    
    [self showTouchID];
    self.window.hidden = NO;
    [self.window makeKeyWindow];
    self.window.windowLevel = UIWindowLevelStatusBar;
    

    
    
//    LZGestureViewController *viV = [[LZGestureViewController alloc]init];
//    viV.delegate = self;
//    [viV showInViewController:self.window.rootViewController type:LZGestureTypeScreen];
//    _gestureVC = viV;
}

- (void)dismiss {
    
//    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
    
//    [BCShanNianKaPianManager maDaQingZhenDong];
    LZWeakSelf(ws);
    [UIView animateWithDuration:0.3 animations:^{
        ws.vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window resignKeyWindow];
        self.window.windowLevel = UIWindowLevelNormal;
        self.window.hidden = YES;
        ws.vc.view.alpha = 1;
    }];
    
//    }];
}

- (void)dealloc {
    if (self.window) {
        self.window = nil;
    }
}



//- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
//    [self performSelector:@selector(hide) withObject:nil afterDelay:0.6];
//}
//
//- (void)hide {
//    [self.window resignKeyWindow];
//    self.window.windowLevel = UIWindowLevelNormal;
//    self.window.hidden = YES;
//}







@end
