//
//  AppDelegate.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "AppDelegate.h"
#import "TaskDetailViewController.h"
#import "Task.h"
#import "TaskListViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *detailNavigationController = [splitViewController.viewControllers lastObject];
    detailNavigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
//    NSArray* tasks = @[[ToDo toDoWithTitle:@"Do Every.Do assignment" description:@"Today's assignment" andPriority:5],
//                       [ToDo toDoWithTitle:@"Finish tableView tutorial" description:@"Because it's really good" andPriority:4],
//                       [ToDo toDoWithTitle:@"Do today's readings and questions" description:@"Because that's today's work" andPriority:3],
//                       [ToDo toDoWithTitle:@"Finish Mafia game" description:@"Being behind on assignments sucks" andPriority:2],
//                       [ToDo toDoWithTitle:@"Do Saturday's readings and questions" description:@"To catch up on readings" andPriority:1]
//                       ];
//    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
//    TaskListViewController* masterViewController = masterNavigationController.viewControllers[0];
//    masterViewController.toDos = tasks;
    
    
    UINavigationBar* navBarAppearance = [UINavigationBar appearance];
    [self.window setTintColor:[UIColor orangeColor]];
    //navBarAppearance.tintColor = [UIColor orangeColor];
    navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[TaskDetailViewController class]] && ([(TaskDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] toDo] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
