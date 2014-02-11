//
//  DatabaseSingleton.m
//  WaitHappy
//
//  Created by user on 13.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "DatabaseSingleton.h"
#import "AppDelegate.h"
#import "RestaurantDetaile.h"
#import "WaitList.h"
#import "MessageEnt.h"

@implementation DatabaseSingleton
{
    NSInteger restID;
}

static DatabaseSingleton* _sharedDBSingleton = nil;


+(DatabaseSingleton*)sharedDBSingleton
{
	@synchronized([DatabaseSingleton class])
	{
		if (!_sharedDBSingleton)
			_sharedDBSingleton = [[DatabaseSingleton alloc]init];
        
		return _sharedDBSingleton;
	}
    
	return nil;
}

// ========= business entity =======

-(void)addObjectToDB:(NSString*)buisID name:(NSString*)name label:(NSString*)label
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    object = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:context];
    [object setValue: buisID  forKey:@"buisID"];
    [object setValue: name  forKey:@"name"];
    [object setValue: label  forKey:@"label"];
    [context save:&error];
}

-(void)deleteObjectFromDB:(NSString*)buisID
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"buisID == %@",buisID];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [context deleteObject:object];
    [context save:&error];
}

-(BOOL)isFavotite:(NSString*)buisID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"buisID == %@",buisID];    
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
  if ([idArr count] != 0)
        return YES;
    else
        return NO;
}

-(NSMutableArray*)getDataFromBusinessDB
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    NSLog(@"elemArray count %i", [elemArr count]);
    NSLog(@"elemArray descr %@", [elemArr description]);
    return elemArr;
}


// ============= "Waitlist Entity" ===============

-(void)addObjectToWaitListWithID:(NSString*)buisID waitListID:(NSString*)wlID label:(NSString*)label name:(NSString*)name
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    object = [NSEntityDescription insertNewObjectForEntityForName:@"WaitList" inManagedObjectContext:context];
    [object setValue:buisID forKey:@"businessID"];
    [object setValue:wlID forKey:@"waitListID"];
    [object setValue:label forKey:@"label"];
    [object setValue:name forKey:@"name"];
    [object setValue:[NSNumber numberWithBool:YES] forKey:@"isPending"];
    [context save:&error];
}

-(BOOL)isInWaitWaitList:(NSString*)businessID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSLog(@"%@", entityDescription);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    if ([elemArr count]>0){
        return YES;
    }
        return NO;
}


-(BOOL)isPendingInWL:(NSString*)businessID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    WaitList *wl = [elemArr objectAtIndex:0];
    NSLog(@"isPending %i", wl.isPending);
    return wl.isPending;
}

-(NSMutableArray*)getDataFromWaitList
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    return elemArr;
}

-(void)deleteAllFromWaitList
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    
    NSManagedObject *object;
    if (elemArr > 0) {
        for (int i = 0; i< [elemArr count]; i++) {
            object = [elemArr objectAtIndex:i];
            [context deleteObject:object];
        }
    [context save:&error];
    }    
}





-(NSString*)getIDFromWaitListWithName:(NSString*)name
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"name == %@",name];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    WaitList *wl = [elemArr objectAtIndex:0];
    return wl.waitListID;
}

-(NSString*)getWaitListIDwithBusinessID:(NSString*)bussID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",bussID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    WaitList *wl = [elemArr objectAtIndex:0];
    return wl.waitListID;
}

-(NSString*)getLabelFromWaitListWithBussID:(NSString*)businessID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSLog(@"%@", [entityDescription description]);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    NSLog(@"%@", [elemArr description]);
    WaitList *wl = [elemArr objectAtIndex:0];
    return wl.label;
}

-(NSString*)getNameFromWaitListWithBussID:(NSString*)businessID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    if ([elemArr count] > 0) {
        WaitList *wl = [elemArr objectAtIndex:0];
        NSLog(@"%@", wl.name); //./././
        return wl.name;
    }
    else{
        return nil;
    }
}

-(void)deleteObjectFromWaitListDB:(NSString*)name
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"name == %@",name];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [context deleteObject:object];
    [context save:&error];
}

-(void)deleteObjectFromWaitListDBwitBussID:(NSString*)bussID
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"businessID == %@",bussID];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    if ([idArr count] != 0) {
        object = [idArr objectAtIndex:0];
        [context deleteObject:object];
        [context save:&error];
    }
}

-(void)setNoPending:(NSString*)businessID
{
    NSManagedObject *object;
    NSManagedObject *object2;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    NSLog(@"businessID = %@",businessID);
    predicate = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    NSLog(@"arr count %i",[idArr count]);
    NSLog(@"arr count %i",[idArr count]);
    object = [idArr objectAtIndex:0];
    WaitList *wl = [idArr objectAtIndex:0];
    NSString *busnID = wl.businessID;
    NSString *wlistID = wl.waitListID;
    NSString *label = wl.label;
    NSString *name = wl.name;
    NSLog(@"bussID %@", wl.businessID);
    NSLog(@"bussID %@", wl.label);
    [context deleteObject:object];   
    [context save:&error];
    NSManagedObjectContext *context2 = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    object2 = [NSEntityDescription insertNewObjectForEntityForName:@"WaitList" inManagedObjectContext:context2];
    NSLog(@"bussID %@",busnID);
    NSLog(@"bussID %@",wlistID);
    NSLog(@"bussID %@",label);
    NSLog(@"bussID %@",name);
    [object2 setValue:busnID forKey:@"businessID"];
    [object2 setValue:wlistID forKey:@"waitListID"];
    [object2 setValue:label forKey:@"label"];
    [object2 setValue:name forKey:@"name"];
    [object2 setValue:[NSNumber numberWithBool:NO] forKey:@"isPending"];
    [context save:&error];
    WaitList *wl2 = (WaitList *)object2;
    NSLog(@"%i", wl2.isPending);
}

-(void)changeLabelTxtinWLwithBussID:(NSString*)businessID andLabelTxt:(NSString*)labelTxt
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    WaitList *wl = [elemArr objectAtIndex:0];
    wl.name = labelTxt;
    [context save:&error];
}

-(void)setTableReadyinWaitListWithBusinessID:(NSString*)businessID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WaitList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",businessID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    WaitList *wl = [elemArr objectAtIndex:0];
    wl.name = @"Your Table is Ready";
    [context save:&error];
}



// ============= "Message Entity" ===============

-(void)addObjectToMessagesWithID:(NSString*)messID title:(NSString*)title message:(NSString*)message date:(NSString*)date type:(NSString*)type businessID:(NSString*)bussID token:(NSString*)tken;
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    object = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEnt" inManagedObjectContext:context];
    [object setValue:tken forKey:@"token"];
    [object setValue:messID forKey:@"messID"];
    [object setValue:title forKey:@"title"];
    [object setValue:message forKey:@"message"];
    [object setValue:date forKey:@"date"];
    [object setValue:type forKey:@"type"];
    [object setValue:bussID forKey:@"businessID"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"isViewed"];
    [context save:&error];
    NSLog(@"error 67890 %@", error);
}

-(void)deleteMessageFromDB:(NSString*)messID
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"messID == %@",messID];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [context deleteObject:object];
    [context save:&error];
}
-(void)setViewedMessage:(NSString*)messID
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"messID == %@",messID];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [object setValue:[NSNumber numberWithBool:YES] forKey:@"isViewed"];
    [context save:&error];
}


-(void)deleteMessageWithText:(NSString*)messTxt
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"message == %@",messTxt];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [context deleteObject:object];
    [context save:&error];
}



-(void)setViewedMessageWithMessText:(NSString*)messTxt
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"message == %@",messTxt];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [object setValue:[NSNumber numberWithBool:YES] forKey:@"isViewed"];
    [context save:&error];
}

-(void)deleteMessageFromDBWithBusinessID:(NSString*)bussID andType:(NSString*)type
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"(businessID == %@) AND (type == %@)",bussID,type];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [context deleteObject:object];
    [context save:&error];
}

-(void)setViewedMessageWithbussID:(NSString*)busID andType:(NSString*)businessType
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSArray *idArr = [[NSArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"(businessID == %@) AND (type == %@)",busID,businessType];
    [request setPredicate:predicate];
    idArr = [context executeFetchRequest:request error:&error];
    object = [idArr objectAtIndex:0];
    [object setValue:[NSNumber numberWithBool:YES] forKey:@"isViewed"];
    [context save:&error];
}

-(NSMutableArray*)getAllMessages
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    NSLog(@"%@", elemArr);
    return elemArr;
}

-(NSMutableArray*)getAllMessagesWithbussID:(NSString*)busID andType:(NSString*)businessType
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MessageEnt" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [[NSPredicate alloc] init];
    predicate = [NSPredicate predicateWithFormat:@"(businessID == %@) AND (type == %@)",busID,businessType];
    [request setPredicate:predicate];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    NSLog(@"%@", elemArr);
    return elemArr;
}

// ============= "SendMail Entity" ===============

-(void)addBusinessToSendMail:(NSString*)bussID
{
    NSManagedObject *object;
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    object = [NSEntityDescription insertNewObjectForEntityForName:@"SendMail" inManagedObjectContext:context];
    [object setValue:bussID forKey:@"businessID"];
    [context save:&error];
}

-(BOOL)isMailSentForBusinessID:(NSString*)bussID
{
    NSError *error;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SendMail" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [[NSPredicate alloc] init];
    pred = [NSPredicate predicateWithFormat:@"businessID == %@",bussID];
    [request setEntity:entityDescription];
    [request setPredicate:pred];
    NSMutableArray *elemArr = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    if ([elemArr count]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end