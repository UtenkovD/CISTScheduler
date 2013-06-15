//
//  PickViewController.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/15/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()

@end

@implementation UIButton (FirstResponder)

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end

@implementation PickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)groupPickButtonPressed:(id)sender {
}

- (IBAction)startDatePickButtonPressed:(id)sender {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    datePicker.frame = CGRectMake(0, 480, 320, 218);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *startDate = [formatter dateFromString:@"01.02.2013"];
    NSDate *endDate = [formatter dateFromString:@"30.06.2013"];
    [datePicker setMinimumDate:startDate];
    [datePicker setMaximumDate:endDate];
    [[self view] addSubview:datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        [datePicker setFrame:CGRectMake(0, 200, 320, 218)];
    }];
    [datePicker release];

}

- (IBAction)endDatePickButtonPressed:(id)sender {
}

- (IBAction)scheduleButtonPressed:(id)sender {
}
@end
