//
//  ScheduleViewController.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/14/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleCell.h"
#import "ScheduleDataSource.h"


@interface ScheduleViewController () <UITableViewDelegate>

@property (nonatomic, retain) ScheduleDataSource *dataSource;

@end

@implementation ScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[ScheduleDataSource alloc] initWithGroupIndex:@"2664907"];
        self.tableView.dataSource = _dataSource;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ScheduleCellId"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
