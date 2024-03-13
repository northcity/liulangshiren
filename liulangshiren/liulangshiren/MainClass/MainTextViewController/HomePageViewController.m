//
//  HomePageViewController.m
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "HomePageViewController.h"
#import "LZSqliteTool.h"
#import "EditingViewController.h" 
#import "GroupDetailViewController.h"
#import "BCGroupViewController.h"
#import "iCarousel.h"
#import "NSString+ShuPaiString.h"

#import "UIViewController+GLTransition.h"
#import "GLMiddlePageAnimation.h"

#import "GLOpenDoorAnimation.h"
#import "SettingViewController.h"


@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>{
    NSInteger _currentSection;
}

@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *groupArray;

@property (nonatomic, strong)iCarousel *myCarousel;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    
    self.navTitleLabel.text = @"流浪";
    self.navTitleLabel.textColor = PNCColorWithHex(0x000000);
    [self.setBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(pushSetting) forControlEvents:UIControlEventTouchUpInside];

    [self.rightButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(addAccountNumberAnimated:) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icarouselChangeStyle) name:STYLE_CHANGE object:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(void)icarouselChangeStyle{
    [self.myCarousel reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *style = [defaults objectForKey:CarouselStyle];

    if (!style) {
        _myCarousel.type = iCarouselTypeCoverFlow;
    }else{
        _myCarousel.type = [self yingSheCarouseStyle:style];
    }
}

- (NSInteger)yingSheCarouseStyle:(NSString *)style{
    //    @[@"线性主题",@"旋转主题",@"反向旋转主题",@"圆柱形主题",@"反向u圆柱形主题",@"瀑布流",@"经典瀑布流",@"时光机",@"反向时光机"]];


    if ([style isEqualToString:@"线性主题"]) {
        return 0;
    }else if ([style isEqualToString:@"旋转主题"]){
        return 1;
    }else if ([style isEqualToString:@"反向旋转主题"]){
        return 2;
    }else if ([style isEqualToString:@"圆柱形主题"]){
        return 3;
    }else if ([style isEqualToString:@"反向圆柱形主题"]){
        return 4;
    }else if ([style isEqualToString:@"瀑布流"]){
        return 7;
    }else if ([style isEqualToString:@"经典瀑布流"]){
        return 8;
    }else if ([style isEqualToString:@"时光机"]){
        return 9;
    }else if ([style isEqualToString:@"反向时光机"]){
        return 10;
    }else{
        return 1;
    }


}


- (void)pushSetting{
    SettingViewController *svc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _currentSection = -1;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sqliteValuesChangedNotification:) name:LZSqliteValuesChangedKey object:nil];

//    [self createMytableView];
    [self.view addSubview:self.myCarousel];
    [self initOtherUI];
    [self loadData];
    

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(50), ScreenHeight - kAUTOWIDTH(50), kAUTOWIDTH(30), kAUTOWIDTH(30));
//    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pushGroupSetting) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self)weakSelf = self;
    [self gl_registerToInteractiveTransitionWithDirection:GLPanEdgeRight eventBlcok:^{
        
        GroupDetailViewController *middlePageToVc = [[GroupDetailViewController alloc] init];
        GLMiddlePageAnimation *middlePageAnimation = [[GLMiddlePageAnimation alloc] init];
        middlePageAnimation.duration = 1;
        
        [weakSelf gl_pushViewControler:middlePageToVc withAnimation:middlePageAnimation];
        
    }];
    

}



- (void)pushGroupSetting{
    BCGroupViewController *group = [[BCGroupViewController alloc]init];
    group.flog = @"setting";
    [self.navigationController pushViewController:group animated:YES];
}

- (void)sqliteValuesChangedNotification:(NSNotification*)noti {
    
    //    for (NSMutableArray *array in self.dataArray) {
    //
    ////        [array removeAllObjects];
    //    }
}

- (void)loadData {
    NSArray *arr = [LZSqliteTool LZSelectAllGroupsFromTable:LZSqliteGroupTableName];
    
    if (self.groupArray.count > 0) {
        
        [self.groupArray removeAllObjects];
    }
    
    [self.groupArray addObjectsFromArray:arr];
    
    [self.myTableView reloadData];
    [self.myCarousel reloadData];
}

- (NSMutableArray *)groupArray {
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupArray;
}

#pragma mark -- 添加账号
-(void)addAccountNumberAnimated:(BOOL)isAnimation{
    EditingViewController *edit = [[EditingViewController alloc]init];
    edit.defaultGroup = [self.groupArray firstObject];
    [self.navigationController pushViewController:edit animated:isAnimation];
}


- (void)createMytableView {

        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCellID"];
       [self.view addSubview:_myTableView];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
//
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
//        cell.textLabel.textColor = LZColorGray;
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
   
    static NSString *identifier = @"tableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    LZGroupModel *model =  [self.groupArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GroupDetailViewController *single = [[GroupDetailViewController alloc]init];
    single.groupModel = [self.groupArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:single animated:YES];
    return;
}


- (iCarousel *)myCarousel {
    if (!_myCarousel) {
        _myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight)];
        _myCarousel.dataSource = self;
        _myCarousel.delegate = self;
        _myCarousel.bounces = NO;
        _myCarousel.pagingEnabled = YES;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *style = [defaults objectForKey:CarouselStyle];

        if (!style) {
            _myCarousel.type = iCarouselTypeCoverFlow;
        }else{
            _myCarousel.type = [self yingSheCarouseStyle:style];
        }
//        iCarouselTypeInvertedTimeMachine;
//        iCarouselTypeCoverFlow2;
        
        NSLog(@"%@",[BCUserDeafaults objectForKey:NOW_ZHUTI]);
        if ([[BCUserDeafaults objectForKey:NOW_ZHUTI] isEqualToString:@"0"]) {
            _myCarousel.backgroundColor = PNCColor(245, 245, 245);
        }else if([[BCUserDeafaults objectForKey:NOW_ZHUTI] isEqualToString:@"1"]){
            _myCarousel.backgroundColor = PNCColor(0, 0, 0);
        }else{
            _myCarousel.backgroundColor = PNCColor(245, 245, 245);

        }
    }
    return _myCarousel;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"1"]];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"2"]];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"3"]];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"4"]];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"5"]];
        [_dataSource addObject:[NSString stringWithFormat:@"style_%@.png",@"6"]];
    }
    return _dataSource;
}

#pragma mark - iCarouselDataSource

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.groupArray.count;
}



-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        CGFloat viewWidth = ScreenWidth - kAUTOWIDTH(100);
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, viewWidth, viewWidth)];
//        view.backgroundColor = [UIColor redColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
       
        LZGroupModel *model =  [self.groupArray objectAtIndex:index];

        NSString *varString = [model.groupName VerticalString];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth - kAUTOWIDTH(95), 0, kAUTOWIDTH(25), kAUTOHEIGHT(150))];
        label.textColor = [UIColor blackColor];
//        label.backgroundColor = [UIColor redColor];
        label.font = [UIFont fontWithName:@"MF-ChanYingNoncommercial-Regular" size:16];
//         [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label.text = [self chuLiShupaiStringWith:model.groupName];
        label.numberOfLines = 0;
        [view addSubview:label];
        label.tag = 100+index;
        
    }
    ((UIImageView *)view).image = [UIImage imageNamed:@"shuyinying"];
    
    
    return view;
}

- (NSString *)chuLiShupaiStringWith:(NSString *)string{
    NSArray * newArray = [string componentsSeparatedByString:@""];
    NSString *newString = [newArray componentsJoinedByString:@"\n"];
    return newString;
}

#pragma mark - iCarouselDelegate

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.myCarousel.itemWidth * 1.4, 0.0, 0.0);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

//    GroupDetailViewController *single = [[GroupDetailViewController alloc]init];
//    single.groupModel = [self.groupArray objectAtIndex:index];
//    [self.navigationController pushViewController:single animated:YES];
    
//    UIView *view = carousel.currentItemView;
//
//
//    view.layer.anchorPoint = CGPointMake(0, 0.5);
//    view.layer.position = CGPointMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame) + CGRectGetHeight(view.frame) * 0.5);
//
////    view.transform = CGAffineTransformMakeScale(1, 1);
//    [UIView animateWithDuration:1.0 delay:1 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
////        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
////        view.layer.anchorPoint = CGPointMake(0, 0);
//
//        view.layer.transform = [self getTransForm3DWithAngle:-55];
//
//
//
//    } completion:^(BOOL finished) {
//
//            GroupDetailViewController *single = [[GroupDetailViewController alloc]init];
//            single.groupModel = [self.groupArray objectAtIndex:index];
//            [self.navigationController pushViewController:single animated:NO];
    
//    GroupDetailViewController *middlePageToVc = [[GroupDetailViewController alloc] init];
//    GLMiddlePageAnimation *middlePageAnimation = [[GLMiddlePageAnimation alloc] init];
//    middlePageAnimation.duration = 1;
//    [self gl_pushViewControler:middlePageToVc withAnimation:middlePageAnimation];
//
//
//    }];

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"]; //选中的这个keyPath就是缩放
//        scaleAnimation.fromValue = [NSNumber numberWithDouble:1]; //一开始时是0.5的大小
//        scaleAnimation.toValue = [NSNumber numberWithDouble:0];  //结束时是1.5的大小
//        scaleAnimation.duration = 1; //设置时间
//        scaleAnimation.repeatCount = 0; //重复次数
//        scaleAnimation.removedOnCompletion = NO;
//        scaleAnimation.fillMode = kCAFillModeForwards;
//        [view.layer addAnimation:scaleAnimation forKey:@"CQScale"];
//        [self.view.layer addAnimation:scaleAnimation forKey:@"CQScale"];
//
//
//    });
    
    
    

    
//    GLOpenDoorAnimation *openDoorAnimation = [[GLOpenDoorAnimation alloc] init];
//    openDoorAnimation.duration = 0.5;
//
//    GroupDetailViewController *openDoorToVc = [[GroupDetailViewController alloc] init];
//    [self gl_presentViewControler:openDoorToVc withAnimation:openDoorAnimation];
//
    
    
    
    
//    GroupDetailViewController *middlePageToVc = [[GroupDetailViewController alloc] init];
//    GLMiddlePageAnimation *middlePageAnimation = [[GLMiddlePageAnimation alloc] init];
//    middlePageAnimation.duration = 1;
//
//    middlePageToVc.groupModel = [self.groupArray objectAtIndex:index];
//
//    [self gl_pushViewControler:middlePageToVc withAnimation:middlePageAnimation];
//
   
    GroupDetailViewController *middlePageToVc = [[GroupDetailViewController alloc] init];

    middlePageToVc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    middlePageToVc.groupModel = [self.groupArray objectAtIndex:index];
    [self.navigationController pushViewController:middlePageToVc animated:YES];

    
}


-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    
//    CATransform3D transform =CATransform3DIdentity;//获取一个标准默认的CATransform3D仿射变换矩阵
//
//    transform.m34=4.5/-2500;//透视效果
//
//    transform=CATransform3DRotate(transform,angle,0,1,0);//获取旋转angle角度后的rotation矩阵。
//
//    return transform;
    
    CATransform3D transform = CATransform3DIdentity;
    // 立体
    transform.m34 = -1/1000.0;
    // 旋转
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 0, 1, 0);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    //    CATransform3D moveTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0, y));
    CATransform3D scal = CATransform3DScale(rotateTransform, 2, 2, 1);
    // 合并
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, scal);
    return concatTransform;
    
}
@end
