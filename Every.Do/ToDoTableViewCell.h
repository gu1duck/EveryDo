//
//  ToDoTableViewCell.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoTableViewCell;
@protocol ToDoTableViewCellDelegate <NSObject>

-(void)toDoTableViewCellWasSwiped:(ToDoTableViewCell*)cell;

@end

@interface ToDoTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel* priorityLabel;
@property (nonatomic, weak) id<ToDoTableViewCellDelegate> delegate;
@end
