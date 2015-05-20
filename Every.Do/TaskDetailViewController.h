//
//  DetailViewController.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"

@interface TaskDetailViewController : UIViewController

@property (strong, nonatomic) ToDo* toDo;
@property (weak, nonatomic) IBOutlet UILabel *todoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *todoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *todoPriorityLabel;

- (void)setDetailItem:(id)newDetailItem;

@end

