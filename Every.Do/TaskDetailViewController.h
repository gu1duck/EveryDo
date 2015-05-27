//
//  DetailViewController.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface TaskDetailViewController : UIViewController 

@property (strong, nonatomic) Task* toDo;
@property (weak, nonatomic) IBOutlet UILabel *todoNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *todoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *todoPriorityLabel;

- (void)setDetailItem:(id)newDetailItem;

@end

