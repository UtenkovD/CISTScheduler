//
//  PickViewController.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/15/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "PickViewController.h"
#import "ScheduleViewController.h"

@interface PickViewController ()

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end

@implementation PickViewController

- (void)dealloc {
    [_datePicker release];
    [_dateFormatter release];
    [_endDate release];
    [_startDate release];
    [_endDate release];
    [_group release];
    [_groupButton release];
    [_startDateButton release];
    [_endDateButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    return self;
}

- (IBAction)groupPickButtonPressed:(id)sender {
}

- (IBAction)startDatePickButtonPressed:(id)sender {
    [self setDatePicker:[self createDatePicker]];
    [[self datePicker] setTag:100];
    if ([self startDate] == nil) {
        [[self datePicker] setDate:[[self datePicker] minimumDate]];
    } else {
        [[self datePicker] setDate:[self startDate]];
    }
    
    [self addHideButton:@selector(hideStartDatePicker:)];
    
    [[self view] addSubview:self.datePicker];
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.frame = CGRectMake(0, 480-280, 320, 218);
    }];
}

- (IBAction)endDatePickButtonPressed:(id)sender {
    [self setDatePicker:[self createDatePicker]];
    [[self datePicker] setTag:101];
    if ([self endDate] == nil) {
        [[self datePicker] setDate:[[self datePicker] maximumDate]];
    } else {
        [[self datePicker] setDate:[self endDate]];
    }
    
    [self addHideButton:@selector(hideEndDatePicker:)];
    
    [[self view] addSubview:self.datePicker];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 150;
        self.view.frame = viewFrame;
        self.datePicker.frame = CGRectMake(0, 350, 320, 218);
    }];
}

- (void)addHideButton:(SEL)selector {
    UIButton *hidePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hidePickerButton setFrame:[[self view] frame]];
    [hidePickerButton addTarget:self
                         action:selector
               forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:hidePickerButton];
}

- (void)hideStartDatePicker:(id)sender {
    [self setStartDate];
    [self hidePicker:sender];
}

- (void)hideEndDatePicker:(id)sender {
    [self setEndDate];
    [self hidePicker:sender];
}

- (void)setStartDate {
    [self setStartDate:[[self datePicker] date]];
    NSString *dateString = [[self dateFormatter] stringFromDate:[self startDate]];
    [[self startDateButton] setTitle:dateString forState:UIControlStateNormal];
}

- (void)setEndDate {
    [self setEndDate:[[self datePicker] date]];
    NSString *dateString = [[self dateFormatter] stringFromDate:[self endDate]];
    [[self endDateButton] setTitle:dateString forState:UIControlStateNormal];
}

- (void)hidePicker:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.frame = CGRectMake(0, 416, 320, 218);
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }];
    [sender removeFromSuperview];
    [self setDatePicker:nil];
}

- (UIDatePicker *)createDatePicker {

    NSDate *startDate = [[self dateFormatter] dateFromString:@"01.02.2013"];
    NSDate *endDate = [[self dateFormatter] dateFromString:@"30.06.2013"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [datePicker setFrame:CGRectMake(0, 416, 320, 218)];
    [datePicker setMinimumDate:self.startDate ? self.startDate : startDate];
    [datePicker setMaximumDate:self.endDate ? self.endDate : endDate];
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    return [datePicker autorelease];
}

- (void)dateChanged:(id)sender {
    switch ([[self datePicker] tag]) {
        case 100:
            [self setStartDate];
            break;
        case 101:
            [self setEndDate];
            break;
        default:
            break;
    }
}

- (IBAction)scheduleButtonPressed:(id)sender {
    NSDate *startDate = [self startDate];
    if (startDate == nil) {
        startDate = [[self dateFormatter] dateFromString:@"01.02.2013"];
    }
    NSDate *endDate = [self endDate];
    if (endDate == nil) {
        endDate = [[self dateFormatter] dateFromString:@"30.06.2013"];
    }
    
    ScheduleViewController *scheduleVC = [[ScheduleViewController alloc] init];
    [scheduleVC setStartDate:startDate];
    [scheduleVC setEndDate:endDate];
    [[self navigationController] pushViewController:scheduleVC animated:YES];
    [scheduleVC release];
}

- (void)viewDidUnload {
    [self setGroupButton:nil];
    [self setStartDateButton:nil];
    [self setEndDateButton:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}

@end