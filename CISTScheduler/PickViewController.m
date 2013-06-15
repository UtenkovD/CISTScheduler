//
//  PickViewController.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/15/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()

@property (nonatomic, retain) UIDatePicker *startDatePicker;
@property (nonatomic, retain) UIDatePicker *endDatePicker;

@end

@implementation UIButton (FirstResponder)

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end

@implementation PickViewController

- (void)dealloc {
    [_startDatePicker release];
    [_endDate release];
    [_startDate release];
    [_endDate release];
    [_group release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)groupPickButtonPressed:(id)sender {
}

- (IBAction)startDatePickButtonPressed:(id)sender {
    [self setStartDatePicker:[self createDatePicker]];
    UIButton *hidePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hidePickerButton setFrame:[[self view] frame]];
    [hidePickerButton addTarget:self
                         action:@selector(hidePicker:)
               forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:hidePickerButton];
    
    [[self view] addSubview:self.startDatePicker];
    [UIView animateWithDuration:0.5 animations:^{
        self.startDatePicker.frame = CGRectMake(0, 480-280, 320, 218);
    }];
}

- (void)hidePicker:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.startDatePicker.frame = CGRectMake(0, 480, 320, 218);
        self.endDatePicker.frame = CGRectMake(0, 480, 320, 218);
    }];
    [sender removeFromSuperview];
}

- (UIDatePicker *)createDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    datePicker.frame = CGRectMake(0, 416, 320, 218);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *startDate = [formatter dateFromString:@"01.02.2013"];
    NSDate *endDate = [formatter dateFromString:@"30.06.2013"];
    [datePicker setMinimumDate:startDate];
    [datePicker setMaximumDate:endDate];
    return [datePicker autorelease];
}

- (IBAction)endDatePickButtonPressed:(id)sender {
}

- (IBAction)scheduleButtonPressed:(id)sender {
}

@end