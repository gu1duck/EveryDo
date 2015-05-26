//
//  ToDoTableViewCell.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "ToDoTableViewCell.h"

@implementation ToDoTableViewCell

- (void)awakeFromNib {
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector (swipeToComplete:)];
    [self addGestureRecognizer:swipeGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)swipeToComplete:(UISwipeGestureRecognizer*)swipeGesture{
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight){
        [self.delegate toDoTableViewCellWasSwiped:self];
    }
}


@end;
