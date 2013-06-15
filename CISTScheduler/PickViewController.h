//
//  PickViewController.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/15/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickViewController : UIViewController

@property (nonatomic, copy) NSString *group;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@property (retain, nonatomic) IBOutlet UIButton *groupButton;
@property (retain, nonatomic) IBOutlet UIButton *startDateButton;
@property (retain, nonatomic) IBOutlet UIButton *endDateButton;

- (IBAction)groupPickButtonPressed:(id)sender;
- (IBAction)startDatePickButtonPressed:(id)sender;
- (IBAction)endDatePickButtonPressed:(id)sender;
- (IBAction)scheduleButtonPressed:(id)sender;

@end
