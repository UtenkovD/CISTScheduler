//
//  ScheduleDataSource.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 14.06.13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSString *groupIndex;

- (id)initWithGroupIndex:(NSString *)groupIndex;

- (NSArray *)getClassesForGroup:(NSString *)groupIndex;

@end
