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
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

- (id)initWithGroupIndex:(NSString *)groupIndex
               startDate:(NSDate *)startDate
                 endDate:(NSDate *)endDate;

- (void)fillSections;

@end
