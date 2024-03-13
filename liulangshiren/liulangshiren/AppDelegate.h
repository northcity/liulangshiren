//
//  AppDelegate.h
//  liulangshiren
//
//  Created by 北城 on 2019/3/14.
//  Copyright © 2019 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MFSideMenuContainerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) MFSideMenuContainerViewController *sideMenu;

- (void)saveContext;


@end

