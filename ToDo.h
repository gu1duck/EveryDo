//
//  ToDo.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDo : NSObject
@property (nonatomic) NSString* taskTitle;
@property (nonatomic) NSString* taskDescription;
@property (nonatomic) int taskPriority;
@property (nonatomic) BOOL completed;

+(instancetype)toDoWithTitle: (NSString*) title description:(NSString*) description andPriority: (int) priority;

@end
