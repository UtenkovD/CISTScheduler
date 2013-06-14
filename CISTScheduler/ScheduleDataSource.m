//
//  ScheduleDataSource.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 14.06.13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "ScheduleDataSource.h"
#import "NSString+CSVParsing.h"
#import "ScheduleCell.h"

#define a_0 @"2664907"

@interface ScheduleDataSource () 

@property (nonatomic, retain ) NSMutableArray *rows;

@end

@implementation ScheduleDataSource

- (void)dealloc {
    [_rows release];
    [_groupIndex release];
    [super dealloc];
}

- (id)initWithGroupIndex:(NSString *)groupIndex {
    if (self = [super init]) {
        _groupIndex = [groupIndex copy];
        _rows = [[NSMutableArray arrayWithArray:[self getClassesForGroup:_groupIndex]] retain];
        
        [self convertRows];
        
        [_rows sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"ClassTime"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)] ]];
    }
    return self;
}

- (NSArray *)getClassesForGroup:(NSString *)groupIndex {
    NSString *urlString = [NSString stringWithFormat:@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=3&Aid_group=%@&Aid_potok=0&ADateStart=01.02.2013&ADateEnd=30.07.2013&AMultiWorkSheet=0", groupIndex];
    
    NSError *error = nil;
    NSString *csvString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                   encoding:NSWindowsCP1251StringEncoding
                                                      error:&error];
    
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

- (void)convertRows {
    NSMutableArray *convertedClasses = [NSMutableArray array];
    for (NSDictionary *class in self.rows) {
        NSMutableDictionary *convertedClass = [NSMutableDictionary dictionary];
        [convertedClass setObject:[class objectForKey:@"Тема"] forKey:@"ClassName"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"dd.mm.yyyy"]; //04.03.2013
        NSString *dateString = [class objectForKey:@"Дата начала"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSString *timeString = [class objectForKey:@"Время начала"];
        [dateFormatter setDateFormat: @"hh:mm:ss"]; //07:40:00
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSDate *time = [dateFormatter dateFromString:timeString];
//        if (time == nil) {
//            [dateFormatter setDateFormat: @"h:mm:ss"]; //07:40:00
//            time = [dateFormatter dateFromString:[class objectForKey:@"Время начала"]];
//        }
        
        NSDate *combinedDate = [self combineDate:date time:time];
        
        [convertedClass setObject:combinedDate forKey:@"ClassTime"];
        [convertedClasses addObject:convertedClass];
    }
    [self setRows:convertedClasses];
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
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCellId";
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ScheduleCell alloc] init];
    }
    
    NSDictionary *class = [self.rows objectAtIndex:indexPath.row];
    
    cell.classNameLabel.text = [class objectForKey:@"ClassName"];
    cell.classNumberLabel.text = [[class objectForKey:@"ClassTime"] description];
    //cell.classTimeLabel.text = [class objectForKey:@"Время начала"];
    
    return cell;
}

@end