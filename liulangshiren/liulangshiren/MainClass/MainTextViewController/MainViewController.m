//
//  MainViewController.m
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/2/27.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "MainViewController.h"
//#import "SCNViewController.h"
#import "SettingViewController.h"
#import "TextTableViewCell.h"
#import "MyTableView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) MyTableView *tableView;

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *detailDataSource;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PNCColor(202, 198, 180);

//    PNCColor(178, 178, 174);
   
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOWIDTH(88), ScreenWidth - kAUTOWIDTH(40), ScreenHeight - kAUTOWIDTH(128))];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    label.text = @"我要给阿Q做正传，已经不止一两年了。但一面要做，一面又往回想，这足见我不是一个“立言”的人，因为从来不朽之笔，须传不朽之人，于是人以文传，文以人传——究竟谁靠谁传，渐渐的不甚了然起来，而终于归结到传阿Q，仿佛思想里有鬼似的。然而要做这一篇速朽的文章，才下笔，便感到万分的困难了。第一是文章的名目。孔子曰，“名不正则言不顺”。这原是应该极注意的。传的名目很繁多：列传，自传，内传，外传，别传，家传，小传……，而可惜都不合。“列传”么，这一篇并非和许多阔人排在“正史”里；“自传”么，我又并非就是阿Q。说是“外传”，“内传”在那里呢？倘用“内传”，阿Q又决不是神仙。“别传”呢，阿Q实在未曾有大总统上谕宣付国史馆立“本传”——虽说英国正史上并无“博徒列传”，而文豪迭更司也做过《博徒别传》这一部书，但文豪则可，在我辈却不可的。其次是“家传”，则我既不知与阿Q是否同宗，也未曾受他子孙的拜托；或“小传”，则阿Q又更无别的“大传”了。总而言之，这一篇也便是“本传”，但从我的文章着想，因为文体卑下，是“引车卖浆者流”所用的话，所以不敢僭称，便从不入三教九流的小说家所谓“闲话休题言归正传”这一句套话里，取出“正传”两个字来，作为名目，即使与古人所撰《书法正传》的“正传”字面上很相混，也顾不得了。第二，立传的通例，开首大抵该是“某，字某，某地人也”，而我并不知道阿Q姓什么。有一回，他似乎是姓赵，但第二日便模糊了。那是赵太爷的儿子进了秀才的时候，锣声镗镗的报到村里来，阿Q正喝了两碗黄酒，便手舞足蹈的说，这于他也很光采，因为他和赵太爷原来是本家，细细的排起来他还比秀才长三辈呢。其时几个旁听人倒也肃然的有些起敬了。那知道第二天，地保便叫阿Q到赵太爷家里去；太爷一见，满脸溅朱，喝道：“阿Q，你这浑小子！你说我是你的本家么？”阿Q不开口。";
    label.numberOfLines = 0;

    _dataSource = [[NSMutableArray alloc]initWithArray:@[@"Artifact – 翻拍老照片并自动剪裁",@"A Framework For Brainstorming Products",@"春になりました",@"Artifact – 翻拍老照片并自动剪裁",@"Artifact – 翻拍老照片并自动剪裁"]];
    
     _detailDataSource =  [[NSMutableArray alloc]initWithArray:@[@"Artifact 是一款非常简单易用的翻拍老照片工具，它能够自动剪裁翻拍的照片边缘，并且还能微调亮度、对比度、去红眼等细节。",@"Brainstorming is notorious for being unstructured and often unactionable. People get in a room with some Post-its and whiteboards and expect the great ideas.",@"最近はスタッドレスタイヤを外し、ノーマルタイヤへと履き替えるお客様が多数来店なさいます。",@"Artifact 是一款非常简单易用的翻拍老照片工具，它能够自动剪裁翻拍的照片边缘，并且还能微调亮度、对比度、去红眼等细节。",@"Artifact 是一款非常简单易用的翻拍老照片工具，它能够自动剪裁翻拍的照片边缘，并且还能微调亮度、对比度、去红眼等细节。"]];
    
    
    self.tableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PNCColor(247,247,247);

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TextTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kAUTOWIDTH(50), ScreenHeight/2 - kAUTOHEIGHT(80), ScreenWidth - kAUTOWIDTH(100), kAUTOHEIGHT(44));
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"黄金时代"forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];
    button.layer.cornerRadius = kAUTOHEIGHT(22);
//    button.layer.masksToBounds = YES;
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowColor = [UIColor grayColor].CGColor;
    button.layer.shadowRadius = 2;
    button.layer.shadowOpacity = 2;
    button.tag = 1;
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kAUTOWIDTH(50), ScreenHeight/2 - kAUTOHEIGHT(80) + kAUTOHEIGHT(74), ScreenWidth - kAUTOWIDTH(100), kAUTOHEIGHT(44));
    button2.backgroundColor = [UIColor blackColor];
    [button2 setTitle:@"刹车时代"forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];
    button2.layer.cornerRadius = kAUTOHEIGHT(22);
    //    button.layer.masksToBounds = YES;
    button2.layer.shadowOffset = CGSizeMake(0, 2);
    button2.layer.shadowColor = [UIColor grayColor].CGColor;
    button2.layer.shadowRadius = 2;
    button2.layer.shadowOpacity = 2;
    button2.tag = 2;

    [button2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button2];
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(kAUTOWIDTH(50), ScreenHeight/2 - kAUTOHEIGHT(80)  + kAUTOHEIGHT(148), ScreenWidth - kAUTOWIDTH(100), kAUTOHEIGHT(44));
    button3.backgroundColor = [UIColor blackColor];
    [button3 setTitle:@"逃逸时代"forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];
    button3.layer.cornerRadius = kAUTOHEIGHT(22);
    //    button.layer.masksToBounds = YES;
    button3.layer.shadowOffset = CGSizeMake(0, 2);
    button3.layer.shadowColor = [UIColor grayColor].CGColor;
    button3.layer.shadowRadius = 2;
    button3.layer.shadowOpacity = 2;
    button3.tag = 3;
    [button3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button3];
    
    
    [self initOtherUI];
    
    
    
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    
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
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(5), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"流浪地球";
    _navTitleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:20];
    _navTitleLabel.adjustsFontSizeToFitWidth = YES;
    _navTitleLabel.textColor = PNCColorWithHex(0xFB409C);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];

    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"关闭2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(16), kAUTOWIDTH(180), kAUTOHEIGHT(66));
    }
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
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setBtn setImage:[UIImage imageNamed:@"图钉.png"] forState:UIControlStateNormal];
    [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.setBtn.frame = CGRectMake(15, 30, 30, 30);
    //    self.setBtn.layer.masksToBounds = YES;
    //    self.setBtn.layer.cornerRadius = 25;
    [self.titleView addSubview:self.setBtn];
    [self.setBtn addTarget:self action:@selector(pushSettingViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:_setBtn];
    _setBtn.alpha = 1;
    if (PNCisIPHONEX) {
        self.setBtn.frame = CGRectMake(15, 50, 30, 30);
    }
    PNCWeakSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            weakSelf.setBtn.alpha = 1;
        }];
    });
}

- (void)pushSettingViewController:(UIButton *)sender{
//    [BCShanNianKaPianManager maDaQingZhenDong];
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
    } completion:nil];
    SettingViewController *svc = [[SettingViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
    //    [self.navigationController pushViewController:svc animated:YES];
}

- (void)btnClicked:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"模型加载中..." ];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
//        SCNViewController *scnVC = [[SCNViewController alloc]init];
//        if (sender.tag == 1) {
//            scnVC.titleString = @"黄金时代";
//        }else if (sender.tag == 2){
//            scnVC.titleString = @"刹车时代";
//            
//        }else if (sender.tag == 3){
//            scnVC.titleString = @"逃逸时代";
//            
//        }
//        
//        [self.navigationController pushViewController:scnVC animated:YES];
    
        
    });
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAUTOWIDTH(200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.detailLabel.text = self.detailDataSource[indexPath.row];

    return cell;
    
}





- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{

    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        completionHandler (YES);
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.detailDataSource removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
        

    }];
    [deleteRowAction setImage:[UIImage imageNamed:@"图钉"]];
    deleteRowAction.backgroundColor = PNCColor(247, 247, 247);



    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
//    config.performsFirstActionWithFullSwipe = NO;

    return config;
}


-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);

        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.detailDataSource removeObjectAtIndex:indexPath.row];

        [self.tableView reloadData];
        

        
    }];
    [deleteRowAction setImage:[UIImage imageNamed:@"shanchu"]];
    deleteRowAction.backgroundColor = PNCColor(247, 247, 247);
    
    
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    //    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}

//-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"1");
//}




- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (@available(iOS 11.0, *)) {
        for (UIView * subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                subView.backgroundColor = [UIColor clearColor];//如果自定义只有一个按钮就要去掉按钮默认红色背景
                //设置按钮frame
                for (UIView * sonView in subView.subviews) {
                    if ([sonView isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                        CGRect cRect = sonView.frame;
                        cRect.origin.y = sonView.frame.origin.y + 10;
                        cRect.size.height = sonView.frame.size.height - 20;
                        sonView.frame = cRect;
                    }
                }
                //自定义按钮的文字大小
                if (subView.subviews.count == 1 && section == 0) {//表示有一个按钮
                    UIButton * deleteButton = subView.subviews[0];
                    deleteButton.titleLabel.font = [UIFont systemFontOfSize:20];
                                        [deleteButton setImage:[UIImage imageNamed:@"图钉"] forState:UIControlStateNormal];;

                }

            }
        }
    }
}
//
////自定义多个左滑菜单选项
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *deleteAction;
//    deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//                        [self.dataSource removeObjectAtIndex:indexPath.row];
//        [self.detailDataSource removeObjectAtIndex:indexPath.row];
//
//        [self.tableView reloadData];
//        [tableView setEditing:NO animated:YES];//退出编辑模式，隐藏左滑菜单
//    }];
//
//    return @[deleteAction];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"自定义按钮";
//}
//

@end
