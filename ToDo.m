//
//  ToDo.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "ToDo.h"

@implementation ToDo

+(instancetype)toDoWithTitle: (NSString*) title description:(NSString*) description andPriority: (int) priority{
    ToDo* todo = [[ToDo alloc] init];
    todo.taskTitle = title;
    todo.taskDescription = description;
    todo.taskPriority = priority;
    todo.completed = NO;
    return todo;
}

@end
