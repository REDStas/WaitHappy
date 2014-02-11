//
//  HomeController.m
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "HomeController.h"
#import "MySingleton.h"
#import "WaitListsScreen.h"
#import "FavoritesScreen.h"
#import "TakeSurveyThanksScreen.h"
#import "TakeSurveyScreen.h"
#import "InstructionScreen.h"
#import "InboxScreen.h"

@interface HomeController ()
{
    InstructionScreen *instr;
    InboxScreen *inbox;
}

@end

@implementation HomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [red_lbl_1 setText:NSLocalizedString(@"red_lbl_1", nil)];
    [red_lbl_2 setText:NSLocalizedString(@"red_lbl_2", nil)];
    [red_lbl_3 setText:NSLocalizedString(@"red_lbl_3", nil)];
    
    [black_lbl_1 setText:NSLocalizedString(@"black_lbl_1", nil)];
    [black_lbl_2 setText:NSLocalizedString(@"black_lbl_2", nil)];
    [black_lbl_3 setText:NSLocalizedString(@"black_lbl_3", nil)];
    instr = [[InstructionScreen alloc] init];
    inbox = [[InboxScreen alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{ 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
   // [prefs setObject:@"0" forKey: @"IsInstructScreen"];
    
    NSString *isInWL = [prefs objectForKey:@"IsInstructScreen"];
    
    if ([isInWL isEqualToString:@"1"])
    {
        [[MySingleton sharedMySingleton] popNewView:instr];
    }
    NSLog(@"IsInstructScreen = %@", [prefs objectForKey:@"IsInstructScreen"]);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment card" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alert show];
    
  //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  //  [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *isGetMess = [pref objectForKey:@"IsGetMess"];
    
    if ([isGetMess isEqualToString:@"1"])
    {
    [[MySingleton sharedMySingleton] setPush:[pref objectForKey:@"pushInfo"] isOutPush:YES];
    
//        [[MySingleton sharedMySingleton] popNewView:inbox];
    
    
    [pref setObject:@"0" forKey:@"IsGetMess"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)waitListOpen:(id)sender
{
    if (![[MySingleton sharedMySingleton] checkRegistered])
    {
        [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can add yourself to this business’s wait list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
    }
    else
    {
        WaitListsScreen *wls = [[WaitListsScreen alloc] init];
        [[MySingleton sharedMySingleton] popNewView:wls];
    }    
}

-(IBAction)favoritesOpen:(id)sender
{
//    
//    TakeSurveyScreen *ts = [[TakeSurveyScreen alloc] init];
//    ts.businessID = @"2";
//    ts.businessName = @"hello world";
//    [[MySingleton sharedMySingleton] popNewView:ts];
//    
    
   // =============
//    
    if (![[MySingleton sharedMySingleton] checkRegistered])
    {
        [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can see your favorites list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
    }
    else
    {
        FavoritesScreen *fav = [[FavoritesScreen alloc] init];
        [[MySingleton sharedMySingleton] popNewView:fav];
    }
   // ====================================
  
//    
//    TakeSurveyScreen *takesurv = [[TakeSurveyScreen alloc] init];
//    [[MySingleton sharedMySingleton] popNewView:fav];

    
    
}

-(IBAction)openFind:(id)sender
{
    [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getCurrentSearchController]];
}


//
//-(void)getWaitListBusinesses
//{
//    
//    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
//    
//    // NSArray *values = [[NSArray alloc] initWithObjects:[[MySingleton sharedMySingleton] getToken], nil];
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", nil];
//    NSString *tken = [[MySingleton sharedMySingleton] getToken];
//  //  tken = [[tken stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
//    NSArray *values = [[NSArray alloc] initWithObjects:tken, nil];
//    //NSArray *values = [[NSArray alloc] initWithObjects:@"795954CCD13B79E1C49850022B52C0EC768625238C48A167FA2A472A3E164176", nil];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//    NSString *cur_url;
//    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetWaitListBusinesses];
//    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
//    NSLog(@"-- %@",[params description]);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetWaitListBusinesses parameters:params];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        NSLog(@"%@", JSON);
// //       receivedWLArr = [JSON objectForKey:@"data"];
//  //      NSLog(@"receivArr %@",[receivedWLArr description]);
////        if ([receivedWLArr count]) {
////            [self refreshWaitList:receivedWLArr];
////        }
////        else
////        {
////            [self loadDataFromDB];
////        }
////        
//        //  [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
//        NSString *txt;
//        txt = [NSString stringWithFormat:@"%@",@""];
//        NSLog(@"error  %@", error);
//        for (NSString* key in [JSON objectForKey:@"validationErrors"]) {
//            NSLog(@"key %@ value %@",key,[JSON objectForKey:key]);
//        }
//        //     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        //     [alert show];
//        //  [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//    }];
//    [operation start];
//}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}


@end
