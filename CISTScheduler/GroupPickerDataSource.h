//
//  GroupPickerDataSource.h
//  CISTScheduler
//
//  Created by Dmitry Utenkov on 6/16/13.
//  Copyright (c) 2013 Coderivium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GroupPickerDataSourceDelegate <NSObject>

- (void)didGroupPicked:(NSString *)groupName;

@end


@interface GroupPickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, retain) NSMutableDictionary *groupsIndexes;

@property (nonatomic, assign) id<GroupPickerDataSourceDelegate> delegate;

- (id)initWithFacultyKey:(NSString *)key;
- (NSString *)indexForGroup:(NSString *)groupKey;

@end
