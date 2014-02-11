//
//  DatabaseSingleton.h
//  WaitHappy
//
//  Created by user on 13.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseSingleton : NSObject
{
    NSManagedObjectContext *managedObjectContext;
}
+(DatabaseSingleton*)sharedDBSingleton;

// ========= Business =========
-(BOOL)isFavotite:(NSString*)buisID; //
-(void)addObjectToDB:(NSString*)buisID name:(NSString*)name label:(NSString*)label;
-(NSMutableArray*)getDataFromBusinessDB;
-(void)deleteObjectFromDB:(NSString*)buisID;

// ========= WaitList =========
-(void)addObjectToWaitListWithID:(NSString*)buisID waitListID:(NSString*)wlID label:(NSString*)label name:(NSString*)name;
-(NSMutableArray*)getDataFromWaitList;
-(NSString*)getIDFromWaitListWithName:(NSString*)name;
-(void)deleteObjectFromWaitListDB:(NSString*)name;
-(void)setNoPending:(NSString*)businessID;
-(NSString*)getNameFromWaitListWithBussID:(NSString*)businessID;
-(NSString*)getLabelFromWaitListWithBussID:(NSString*)businessID;
-(BOOL)isInWaitWaitList:(NSString*)businessID;
-(NSString*)getWaitListIDwithBusinessID:(NSString*)bussID;
-(void)deleteObjectFromWaitListDBwitBussID:(NSString*)bussID;
-(BOOL)isPendingInWL:(NSString*)businessID;
-(void)changeLabelTxtinWLwithBussID:(NSString*)businessID andLabelTxt:(NSString*)labelTxt;
-(void)setTableReadyinWaitListWithBusinessID:(NSString*)businessID;
-(void)deleteAllFromWaitList;


// ============ Message ============
-(void)addObjectToMessagesWithID:(NSString*)messID title:(NSString*)title message:(NSString*)message date:(NSString*)date type:(NSString*)type businessID:(NSString*)bussID token:(NSString*)tken;
-(void)deleteMessageFromDB:(NSString*)messID;
-(NSMutableArray*)getAllMessages;
-(void)deleteMessageFromDBWithBusinessID:(NSString*)bussID andType:(NSString*)type;
-(void)setViewedMessage:(NSString*)messID;

-(void)setViewedMessageWithbussID:(NSString*)busID andType:(NSString*)businessType;


-(void)setViewedMessageWithMessText:(NSString*)messTxt;
-(void)deleteMessageWithText:(NSString*)messTxt;
-(NSMutableArray*)getAllMessagesWithbussID:(NSString*)busID andType:(NSString*)businessType;

// ============= SendMail ======
-(void)addBusinessToSendMail:(NSString*)bussID;
-(BOOL)isMailSentForBusinessID:(NSString*)bussID;




@end
