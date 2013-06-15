//
//  ScheduleCell.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/14/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *classNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *classTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *classNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *classTimeLabel;

@end
