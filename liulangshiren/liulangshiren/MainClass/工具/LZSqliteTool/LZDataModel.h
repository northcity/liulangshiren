//
//  LZDataModel.h
//  SqliteTest
//
//  Created by Artron_LQQ on 16/4/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LZDataModel : NSObject
//内容
@property (copy, nonatomic) NSString *nickName;
//组名
@property (copy, nonatomic) NSString *groupName;
//标题
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *urlString;
//日期
@property (copy, nonatomic) NSString *dsc;
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *groupID;
@property (copy, nonatomic) NSString *email;
@end
