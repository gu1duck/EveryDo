//
//  ToDo.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "ToDo.h"

@interface ToDo () <NSCoding>

@end

@implementation ToDo

+(instancetype)toDoWithTitle: (NSString*) title description:(NSString*) description andPriority: (int) priority{
    ToDo* todo = [[ToDo alloc] init];
    todo.taskTitle = title;
    todo.taskDescription = description;
    todo.taskPriority = priority;
    todo.completed = NO;
    return todo;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.taskTitle forKey:@"taskTitle"];
    [encoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [encoder encodeInt:self.taskPriority forKey:@"taskPriority"];
    [encoder encodeBool:self.completed forKey:@"completed"];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self){
        self.taskTitle = [decoder decodeObjectForKey:@"taskTitle"];
        self.taskDescription = [decoder decodeObjectForKey:@"taskDescription"];
        self.taskPriority = [decoder decodeIntForKey:@"taskPriority"];
        self.completed = [decoder decodeBoolForKey:@"completed"];
    }
    return self;
}

@end
