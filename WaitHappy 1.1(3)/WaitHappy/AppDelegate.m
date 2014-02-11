//
//  AppDelegate.m
//  WaitHappy
//
//  Created by gelgard on 23.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "AppDelegate.h"
#import "MySingleton.h"
#import "Airship/Library/AirshipLib/UAirship.h"
#import "Airship/Library/PushLib/UAPush.h"
#import "Reachability.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    
    // -------- Airship --------
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [UAirship takeOff:takeOffOptions];
    // -------- Airship --------
    
    // -- register --
    [[UAPush shared]  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    // --------------
    [[MySingleton sharedMySingleton] setContext:[self managedObjectContext]];
    self.window.rootViewController = [[MySingleton sharedMySingleton] getStartScreen];
    [self.window makeKeyAndVisible];
    
   
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
   // NSLog(@"push description %@", [remoteNotif description]);
    
    if (remoteNotif) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[remoteNotif description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//        [alert show];
        
       // [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:remoteNotif];
        
//        we_have_a_question
        //if ([[remoteNotif objectForKey:@"type"] isEqualToString:@"we_have_a_question"]) {
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            [pr setObject:@"1" forKey:@"IsGetMess"];
            [pr setObject:remoteNotif forKey:@"pushInfo"];
            [pr synchronize];
        //}
//        if ([[remoteNotif objectForKey:@"type"] isEqualToString:@"table_is_ready"]) {
//            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
//            [pr setObject:@"1" forKey:@"IsGetMess"];
//            [pr setObject:remoteNotif forKey:@"pushInfo"];
//            [pr synchronize];
//        }
    }
    return YES;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"failed to regiser %@", err);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    isOutPush = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    Reachability *waitHappyReachability = [Reachability reachabilityWithHostName:@"www.waithappy.com"];
    NetworkStatus status = waitHappyReachability.currentReachabilityStatus;
    if (status == NotReachable)
    {
        [[MySingleton sharedMySingleton] noInternetConnection];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
    isOutPush = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.   
    [UAirship land];
    [self saveContext];
    [FBSession.activeSession close];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"uesrinfo %@",[userInfo description]);
    NSLog(@"push Alert %@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    if (isOutPush) {
        [[MySingleton sharedMySingleton] setPush:userInfo isOutPush:YES];
    }
    else
    {
        [[MySingleton sharedMySingleton] setPush:userInfo isOutPush:NO];
    }
    isOutPush = NO;
    
#if !TARGET_IPHONE_SIMULATOR
    
    //NSString *sound = [apsInfo objectForKey:@"sound"];
    //NSLog(@"Received Push Sound: %@", sound);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
#endif
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    static int i = 0;
    if (!i) {       
        //	NSLog(@"My token is: %@", deviceToken);
        NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *someString = [[deviceToken description] stringByTrimmingCharactersInSet:charsToRemove];
        [[MySingleton sharedMySingleton] setToken:someString];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
        
        // --- airship ---
        [[UAPush shared] registerDeviceToken:deviceToken];
        NSLog(@"token %@",someString);
        NSLog(@"hello");
        i++;
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WaitHappy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WaitHappy.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
