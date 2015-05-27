//
//  Task.h
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-26.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * taskTitle;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic) int16_t taskPriority;
@property (nonatomic) BOOL completed;

@end
