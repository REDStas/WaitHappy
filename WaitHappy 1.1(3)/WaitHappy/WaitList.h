//
//  WaitList.h
//  WaitHappy
//
//  Created by user on 22.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WaitList : NSManagedObject

@property (nonatomic) BOOL isPending;
@property (nonatomic, retain) NSString * businessID;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * waitListID;

@end
