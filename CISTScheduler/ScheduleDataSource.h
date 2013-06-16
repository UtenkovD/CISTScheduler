//
//  ScheduleDataSource.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 14.06.13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScheduleDataSourceDelegate;

@interface ScheduleDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSString *groupIndex;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign, readonly) BOOL isEmpty;

@property (nonatomic, assign) id<ScheduleDataSourceDelegate> delegate;

- (id)initWithGroupIndex:(NSString *)groupIndex
               startDate:(NSDate *)startDate
                 endDate:(NSDate *)endDate;

- (void)fillSections;

@end

@protocol ScheduleDataSourceDelegate <NSObject>

- (void)dataSource:(ScheduleDataSource *)dataSource failedWithError:(NSError *)error;

@end
