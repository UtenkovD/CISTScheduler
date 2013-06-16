//
//  GroupPickerDataSource.m
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/16/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import "GroupPickerDataSource.h"

@implementation NSString (Extract)

- (NSString*)stringBetweenString:(NSString *)start andString:(NSString *)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

@end

@interface GroupPickerDataSource ()

@property (nonatomic, retain) NSMutableArray *groupNames;
@property (nonatomic, retain) NSMutableDictionary *groupsIndexes;

@end

@implementation GroupPickerDataSource

- (void)dealloc {
    [_groupsIndexes release];
    [_groupNames release];
    _delegate = nil;
    [super dealloc];
}

- (id)initWithFacultyKey:(NSString *)key {
    if (self = [super init]) {
        
        _groupsIndexes = [[NSMutableDictionary alloc] init];
        
        NSString *keyFilePath = [[NSBundle mainBundle] pathForResource:key ofType:@"txt" inDirectory:@"Groups keys"];
        NSError *error = nil;
        NSString *keyFileString = [NSString stringWithContentsOfFile:keyFilePath encoding:NSUTF8StringEncoding error:&error];
        
        NSMutableArray *keys = [NSMutableArray arrayWithArray:[keyFileString componentsSeparatedByString:@"\n"]];
        
        NSString *groupIndexesString = [keys lastObject];
        groupIndexesString = [groupIndexesString stringBetweenString:@"group=" andString:@"&"];
        NSArray *groupIndexes = [groupIndexesString componentsSeparatedByString:@"_"];
        [keys removeLastObject];
                
        for (int i = 0; i < keys.count; i++) {
            NSString *group = [keys objectAtIndex:i];
            NSString *index = [groupIndexes objectAtIndex:i];
            // Joint group name
            if ([group rangeOfString:@"+"].location != NSNotFound) {
                continue;
            }
            
            NSArray *groupNameParts = [group componentsSeparatedByString:@"-"];
            // Wrong group name
            if (groupNameParts.count > 3) {
                continue;
            }
            
            [_groupsIndexes setObject:index forKey:group];
            
//            NSString *groupName = [groupNameParts objectAtIndex:0];
//            if ([groupName hasSuffix:@"С"] || [groupName hasSuffix:@"М"]) {
//                
//                // Replace last character of current groupName with lowercase suffix
//                NSRange lastNameSymbol = NSMakeRange(groupName.length-1, 1);
//                NSString *replaceCharacter = [group substringWithRange:lastNameSymbol];
//                NSMutableString *correctName = [NSMutableString stringWithString:group];
//                [correctName replaceCharactersInRange:lastNameSymbol withString:[replaceCharacter lowercaseString]];
//                NSLog(correctName);
//                
//                NSData *data1 = [[keys objectAtIndex:keys.count-3] dataUsingEncoding:NSUTF8StringEncoding];
//                NSData *data2 = [correctName dataUsingEncoding:NSUTF8StringEncoding];
//                
//                if ([data1 isEqualToData:data2]) {
//                    
//                }
//                
//                // Groups with wrong suffix
////                if ([[keys objectAtIndex:keys.count-3] isEqualToString:v]) {
////                    [keysForRemove addObject:group];
////                    continue;
////                }
//            }
        }
        
        _groupNames = [[NSMutableArray arrayWithArray:[_groupsIndexes allKeys]] retain];
        [_groupNames sortUsingSelector:@selector(localizedCompare:)];
        
        
    }
    return self;
}

- (NSString *)indexForGroup:(NSString *)groupKey {
    return [[self groupsIndexes] objectForKey:groupKey];
}

#pragma mark - UIPickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self groupNames] count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *group = [[self groupNames] objectAtIndex:row];
    [[self delegate] didGroupPicked:group];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [[self groupNames] objectAtIndex:row];
}

@end
