//
//  PriorityPickerTableViewController.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriorityPickerTableViewController;
@protocol PriorityPickerViewControllerDelegate <NSObject>

-(void) priorityPickerTableViewController: (PriorityPickerTableViewController*)controller didSelectPriority: (int)priority;

@end

@interface PriorityPickerTableViewController : UITableViewController

@property (nonatomic) int selectedIndex;
@property (nonatomic) NSString* priorityString;
@property (nonatomic) id<PriorityPickerViewControllerDelegate> delegate;

@end
