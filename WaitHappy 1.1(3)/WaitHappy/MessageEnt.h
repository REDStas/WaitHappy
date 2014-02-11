//
//  MessageEnt.h
//  WaitHappy
//
//  Created by user on 21.05.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageEnt : NSManagedObject

@property (nonatomic, retain) NSString * businessID;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * token;
@property (nonatomic) BOOL isViewed;

@end
