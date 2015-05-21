//
//  NewTaskTableViewController.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"
#import "PriorityPickerTableViewController.h"

@protocol NewTaskTableViewControllerDelegate <NSObject>

- (void) newTaskTableViewContreollerDidCancel;
- (void) newTaskTableViewContreollerDidSave:(ToDo*)toDo;

@end

@interface NewTaskTableViewController : UITableViewController <PriorityPickerViewControllerDelegate>

@property (weak, nonatomic) id<NewTaskTableViewControllerDelegate> delegate;

@end
