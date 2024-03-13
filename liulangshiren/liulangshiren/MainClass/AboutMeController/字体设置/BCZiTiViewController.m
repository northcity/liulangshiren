//
//  BCZiTiViewController.m
//  liulangshiren
//
//  Created by 北城 on 2019/3/19.
//  Copyright © 2019 com.beicheng. All rights reserved.
//

#import "BCZiTiViewController.h"
#import "MainContentCell.h"

@interface BCZiTiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation BCZiTiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"MF-ChanYingNoncommercial-Regular" size:15];
    }else{
        cell.textLabel.font =  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:14];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"愿无岁月可回头，且以深情共白首。";
    return cell;
    
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
