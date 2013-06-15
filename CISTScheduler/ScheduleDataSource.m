//
//  ScheduleDataSource.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 14.06.13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "ScheduleDataSource.h"
#import "ScheduleCell.h"

#define a_0 @"2664907"

@interface ScheduleDataSource () 

@property (nonatomic, retain ) NSMutableArray *sections;

@end

@implementation ScheduleDataSource

- (void)dealloc {
    [_groupIndex release];
    [_sections release];
    [_startDate release];
    [_endDate release];
    [super dealloc];
}

- (id)initWithGroupIndex:(NSString *)groupIndex
               startDate:(NSDate *)startDate
                 endDate:(NSDate *)endDate
{
    if (self = [super init]) {
        _groupIndex = [groupIndex copy];
        _sections = [[NSMutableArray alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        _startDate = startDate ? startDate : [[dateFormatter dateFromString:@"01.02.2013"] retain];
        _endDate = endDate ? endDate : [[dateFormatter dateFromString:@"30.06.2013"] retain];
        [dateFormatter release];
    }
    return self;
}

- (NSArray *)getClassesForGroup:(NSString *)groupIndex
                      startDate:(NSDate *)startDate
                        endDate:(NSDate *)endDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    
    NSString *urlString = [NSString stringWithFormat:@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=3&Aid_group=%@&Aid_potok=0&ADateStart=%@&ADateEnd=%@&AMultiWorkSheet=0", groupIndex, startDateString, endDateString];
    
    NSError *error = nil;
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                   encoding:NSWindowsCP1251StringEncoding
                                                      error:&error];
    
    if (error) {
        NSLog(@"Error occured: %@", [error localizedDescription]);
        return nil;
    }
    
    NSData *utfData = [csvString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *utfString = [[NSString alloc] initWithData:utfData encoding:NSUTF8StringEncoding];
    
    NSArray *array = [self parse:utfString];
    
    [utfString release];
        
    NSArray *keys = [array objectAtIndex:0];
    NSMutableArray *classes = [NSMutableArray array];
    
    for (NSUInteger i = 1; i < array.count-1; i++) {
        NSArray *class = [array objectAtIndex:i];
        NSMutableDictionary *classDictionary = [NSMutableDictionary dictionary];
        for (NSUInteger j = 0; j < class.count; j++) {
            [classDictionary setObject:[class objectAtIndex:j] forKey:[keys objectAtIndex:j]];
        }
        [classes addObject:classDictionary];
    }
    
    return [NSArray arrayWithArray:classes];
}

- (void)fillSections {
    NSArray *rows = [self getClassesForGroup:[self groupIndex]
                                   startDate:[self startDate]
                                     endDate:[self endDate]];
    NSMutableArray *convertedClasses = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSMutableDictionary *sections = [NSMutableDictionary dictionary];
    NSMutableArray *sectionKeys = [NSMutableArray array];
    
    // Remove redundant info from rows
    for (NSDictionary *class in rows) {
        
        // Transform two strings to single date with time
        NSString *dateString = [class objectForKey:@"Дата начала"];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        NSString *timeString = [class objectForKey:@"Время начала"];
        [dateFormatter setDateFormat: @"HH:mm:ss"];
        NSDate *time = [dateFormatter dateFromString:timeString];
        NSDate *combinedDate = [self combineDate:date time:time];
        
        NSMutableDictionary *convertedClass = [NSMutableDictionary dictionary];
        [convertedClass setObject:[class objectForKey:@"Тема"] forKey:@"ClassName"];
        [convertedClass setObject:combinedDate forKey:@"ClassTime"];
        [convertedClasses addObject:convertedClass];
        
        // Add date of class to section keys
        [sectionKeys addObject:date];
    }
    
    [dateFormatter release];
    
    // Remove duplicates
    NSArray *sectionsKeysNoRepeats = [[NSSet setWithArray:sectionKeys] allObjects];
    sectionKeys = [NSMutableArray arrayWithArray:sectionsKeysNoRepeats];
    [sectionKeys sortUsingSelector:@selector(compare:)];
    
    // Create arrays for each section
    for (NSDate *key in sectionKeys) {
        [sections setObject:[NSMutableArray array] forKey:key];
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Fill section's array with converted rows
    for (NSDictionary *class in convertedClasses) {
        NSDate *date = [class objectForKey:@"ClassTime"];
        NSDateComponents *components = [gregorianCalendar components:
                                                                NSYearCalendarUnit |
                                                                NSMonthCalendarUnit |
                                                                NSDayCalendarUnit
                                                             fromDate:date];
        date = [gregorianCalendar dateFromComponents:components];
        [[sections objectForKey:date] addObject:class];
    }
    
    [gregorianCalendar release];
    
    // Sort sections array by class time
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[sections allKeys]];
    [keys sortUsingSelector:@selector(compare:)];
    
    for (NSDate *key in keys) {
        NSMutableArray *sectionArray = [sections objectForKey:key];
        [sectionArray sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"ClassTime"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)] ]];
        [self.sections addObject:sectionArray];
    }
    
    // Sort all rows array by class date
    [convertedClasses sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"ClassTime"
                                                                            ascending:YES
                                                                             selector:@selector(compare:)] ]];
}

- (NSDate *)combineDate:(NSDate *)date time:(NSDate *)time  {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    // Extract date components into components1
    NSDateComponents *components1 = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                         fromDate:date];
    
    // Extract time components into components2
    NSDateComponents *components2 = [gregorianCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                         fromDate:time];
    
    // Combine date and time into components3
    NSDateComponents *components3 = [[NSDateComponents alloc] init];
    
    [components3 setYear:components1.year];
    [components3 setMonth:components1.month];
    [components3 setDay:components1.day];
    
    [components3 setHour:components2.hour];
    [components3 setMinute:components2.minute];
    [components3 setSecond:components2.second];
    
    // Generate a new NSDate from components3.
    NSDate *combinedDate = [gregorianCalendar dateFromComponents:components3];
    [components3 release];
    [gregorianCalendar release];
    return combinedDate;
}

- (NSArray *)parse:(NSString *)csvString {
    NSArray *lines = [csvString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    
    NSMutableArray *parsedArray = [NSMutableArray array];
    
    for (NSString *line in lines) {
        NSArray *values = [line componentsSeparatedByString:@"\","];
        
        NSMutableArray *changedValues = [NSMutableArray array];
        
        for (NSString *value in values) {
            [changedValues addObject:[value stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        }
        [parsedArray addObject:changedValues];
    }
    
    return parsedArray;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (NSString *)titleForSection:(NSUInteger)section {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    NSDictionary *row = [[self.sections objectAtIndex:section] objectAtIndex:0];
    NSDate *date = [row objectForKey:@"ClassTime"];
    NSString *title = [formatter stringFromDate:date];
    [formatter release];
    return title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexes = [NSMutableArray array];
    for (int i = 0; i < self.sections.count; i++) {
        [indexes addObject:[self titleForSection:i]];
    }
    return [NSArray arrayWithArray:indexes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCellId";
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[ScheduleCell alloc] init] autorelease];
    }
    
    NSDictionary *class = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.classNameLabel.text = [class objectForKey:@"ClassName"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    cell.classNumberLabel.text = [formatter stringFromDate:[class objectForKey:@"ClassTime"]];
    //cell.classTimeLabel.text = [class objectForKey:@"Время начала"];
    [formatter release];
    return cell;
}

@end