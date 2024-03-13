//
//  DongHuaSetViewController.m
//  liulangshiren
//
//  Created by 北城 on 2019/3/19.
//  Copyright © 2019 com.beicheng. All rights reserved.
//

#import "DongHuaSetViewController.h"
#import "DongHuaTableViewCell.h"

@interface DongHuaSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation DongHuaSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitleLabel.text = @"动画设置";
    [self.setBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews{

    NSInteger indexRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"STYLE"];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth,ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor clearColor];

    self.dataSource = [NSMutableArray arrayWithArray:@[@"线性主题",@"旋转主题",@"反向旋转主题",@"圆柱形主题",@"反向圆柱形主题",@"瀑布流",@"经典瀑布流",@"时光机",@"反向时光机"]];

    if (indexRow) {

        [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifi = @"cellID";
    DongHuaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if(cell == nil){
        cell = [[DongHuaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dataSource[indexPath.row] forKey:CarouselStyle];
    [defaults setInteger:indexPath.row forKey:@"STYLE"];
    [defaults synchronize];

    [[NSNotificationCenter defaultCenter]postNotificationName:STYLE_CHANGE object:nil];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
