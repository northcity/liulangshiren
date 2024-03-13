//
//  GroupDetailViewController.m
//  LiuLangDiQiu
//
//  Created by chenxi on 2019/3/8.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"
#import "BCTextDetailViewController.h"
#import "EditingViewController.h"
#import "TextTableViewCell.h"

#import "UIViewController+GLTransition.h"

@interface GroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) UIImageView *kongView;
@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = self.groupModel.groupName;
    self.view.backgroundColor = PNCColor(202, 198, 180);
    [self.rightButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(pushEditController) forControlEvents:UIControlEventTouchUpInside];
    [self.setBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
//    __weak typeof(self)weakSelf = self;
//    [self gl_registerBackInteractiveTransitionWithDirection:GLPanEdgeLeft eventBlcok:^{
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    }];
    
//    __weak typeof(self)weakSelf = self;
//    [self gl_registerBackInteractiveTransitionWithDirection:GLPanEdgeLeft eventBlcok:^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
    [self createKongImageView];
}

- (void)createKongImageView{
    self.kongView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 250)];
    self.kongView.image = [UIImage imageNamed:@"762708.jpg"];
    self.kongView.contentMode = UIViewContentModeScaleAspectFill;
    self.kongView.center = self.view.center;
    [self.view addSubview:self.kongView];
    self.kongView.hidden = YES;
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushEditController{
    EditingViewController *edit = [[EditingViewController alloc]init];
    edit.defaultGroup = self.groupModel;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)loadData {
    
    NSArray* array = [LZSqliteTool LZSelectGroupElementsFromTable:LZSqliteDataTableName groupID:self.groupModel.identifier];

    if (array.count == 0 || !array) {
        self.kongView.hidden = NO;
        self.view.backgroundColor = PNCColor(255, 255, 255);

    }else{

    if (self.dataArray.count > 0) {
        
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
        [self.tableView reloadData];

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.backgroundColor = PNCColor(247,247,247);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAUTOHEIGHT(210);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZGroupSingleViewController"];
    if (cell == nil) {
        
        cell = [[TextTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LZGroupSingleViewController"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.textColor = LZColorGray;
        cell.textLabel.font = LZFontDefaulte;
    }
    
    LZDataModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.nickName;
    cell.detailLabel.text = model.userName;
    cell.dateLabel.text = model.dsc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZDataModel *model = [self.dataArray objectAtIndex:indexPath.row];

    EditingViewController *edit = [[EditingViewController alloc]init];
    edit.model = model;
    edit.flog = @"edit";
    edit.defaultGroup = self.groupModel;
    [self.navigationController pushViewController:edit animated:YES];
    
    
    
//    BCTextDetailViewController *detail = [[BCTextDetailViewController alloc]init];
//    
//    LZDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    
//    detail.identifier = model.identifier;
//    detail.defaultGroup = self.groupModel;
//    
//    [self.navigationController pushViewController:detail animated:YES];
    
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        completionHandler (YES);
        LZDataModel *model = self.dataArray[indexPath.row];
        
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:model];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.detailDataSource removeObjectAtIndex:indexPath.row];
        
        
    
        [self.tableView reloadData];
        
        
    }];
    [deleteRowAction setImage:[UIImage imageNamed:@"删除"]];
    deleteRowAction.backgroundColor = PNCColor(247, 247, 247);
    
    
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    //    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}


-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        
        LZDataModel *model = self.dataArray[indexPath.row];
        
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:model];
        
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.detailDataSource removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
        
      
        
        
    }];
    [deleteRowAction setImage:[UIImage imageNamed:@"删除"]];
    deleteRowAction.backgroundColor = PNCColor(247, 247, 247);
    
    
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    //    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}

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
                    [deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];;
                    
                }
                
            }
        }
    }
}


@end
