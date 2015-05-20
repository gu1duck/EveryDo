//
//  MasterViewController.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailViewController;

@interface TaskListViewController : UITableViewController

@property (strong, nonatomic) TaskDetailViewController *detailViewController;
@property (strong, nonatomic) NSArray* toDos;


@end

