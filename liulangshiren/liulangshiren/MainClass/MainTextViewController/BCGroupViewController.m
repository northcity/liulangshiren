//
//  BCGroupViewController.m
//  LiuLangDiQiu
//
//  Created by 北城 on 2019/3/10.
//  Copyright © 2019 com.beicheng1. All rights reserved.
//

#import "BCGroupViewController.h"
#import "LZGroupModel.h"
#import "LZSqliteTool.h"
#import "LZDataModel.h"
#import "MainContentCell.h"


@interface BCGroupViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation BCGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [LZSqliteTool LZSelectAllGroupsFromTable:LZSqliteGroupTableName];
    [self.dataArray addObjectsFromArray:array];
    [self tableView];
    [self setNav];
    [self.setBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:[UIImage imageNamed:@"tianjiafenzu"] forState:UIControlStateNormal];


//    _rightButton.frame = CGRectMake(ScreenWidth - 29- kAUTOWIDTH(15), 30, 29,29);
//
//    if (PNCisIPHONEX) {
//        _rightButton.frame = CGRectMake(ScreenWidth - 29- kAUTOWIDTH(15), 52,29,29);
//    }
}


- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setNav{
    if ([self.flog isEqualToString:@"setting"]) {
        
        self.navTitleLabel.text = @"分组管理";
    } else {
        self.navTitleLabel.text = @"选择分组";
    }
    
//    LZWeakSelf(ws)
//    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
//
//        if (ws.navigationController) {
//
//            [ws.navigationController popViewControllerAnimated:YES];
//        } else {
//
//            [ws dismissViewControllerAnimated:YES completion:nil];
//        }
//
//    }];
    
    
    
//    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
//
//        [ws insertNewGroup];
//    }];
    [self.rightButton addTarget:self action:@selector(insertNewGroup) forControlEvents:UIControlEventTouchUpInside];

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
        
        [ws.dataArray addObject:group];
        //
        [ws.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入组名";
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
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
        [self.view addSubview:_tableView];
        self.tableView.backgroundColor = [UIColor clearColor];

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"分组"];
    //    NSArray *titles = @[@"安全设置",@"设置验证选项",@"关于"];
    return titles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (PNCisIPHONEX) {
        return 55;
    }else{
        return 35;
    }

    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identifier = @"MainContentCell";
    MainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MainContentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [cell addGestureRecognizer:longPress];
    }
    cell.backgroundColor = [UIColor clearColor];
    LZGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

/// 2016.11.30 新增
/// by: LQQ
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    UITableViewCell *cell = (UITableViewCell*)gesture.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
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
        
        return @"不能删除最后一组";
    }
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.flog isEqualToString:@"setting"]) {
        
        return;
    }
    
    if (self.callBack) {
        
        LZGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.callBack(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 1;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
