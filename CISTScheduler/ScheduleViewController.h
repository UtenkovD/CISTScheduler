//
//  ScheduleViewController.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/14/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UITableViewController

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, copy) NSString *groupIndex;

@end
