//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "InboxQuestScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "TakeSurveyScreen.h"
#import "InboxScreen.h"

@interface InboxQuestScreen ()
{
    UIImageView *im;
 //   WaitList *element;
    
    BOOL isLoad;
}

@end

@implementation InboxQuestScreen

@synthesize message,messageID, businessID, type;

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
//    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message.png"] forState:UIControlStateNormal];
//    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message_press.png"] forState:UIControlStateHighlighted];
//    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
//    [myFavoritesLbl setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
//
    
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message.png"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message_press.png"] forState:UIControlStateHighlighted];

    
    
    myTextView.editable = NO;
    myTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [myTextView setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
//    [myTextView setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    
    [myTextView setTextColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1]];
    
   // [myTextView.text setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    
    
    
  //  [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    
   // message = @"We have a quick question. Please have a member of your party visit the A Test Business host stand or call (512) 335-2221.";
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [startSearchBtn setHidden:YES];
//    
//    NSLog(@"date %@",date);
//    
//   
//    [messageLabel setText:message];
//    
//    
//    //[dateLabel setText:@"dfdfdsfd"];
//    
//    [dateLabel setText:date];
//
//    NSLog(@"date %@",dateLabel.text);
//
//    
//    CGSize messSize = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 600) lineBreakMode: UILineBreakModeWordWrap];
//    [messageLabel setFrame:CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, messSize.height)];
//
    
    
    if (![message isEqualToString:@""]) {
        [myTextView setText:message];
        isLoad = NO;
        
        [[DatabaseSingleton sharedDBSingleton] setViewedMessageWithbussID:businessID andType:type];
    }
    else{
        [self getMessageFromServer:messageID];
        isLoad = YES;
    }
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMessageFromServer:(NSString*)messID
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys;
    NSArray *values;
    NSString *tken = [[MySingleton sharedMySingleton] getToken];
    keys = [[NSArray alloc] initWithObjects:@"id",@"phone_id", nil];
    values = [[NSArray alloc] initWithObjects:messID ,tken, nil];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetMessage];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil]; 
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetMessage parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                         //  NSLog(@"userdef %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"]);
                                         
                                         NSLog(@"%@",JSON);
                                         
                                         NSLog(@"%@",[JSON objectForKey:@"success"]);
                                         
                                         
                                         
                                         if ([[JSON objectForKey:@"success"] integerValue] == 0)
                                             {
                                             
//                                             
//                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                             [alert show];
//                                             
//                                             
                                             
                                             }
                                         else
                                             {
                            
                                             
                                             }
                                         
                                         [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
                                         
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                             
                                             //   NSLog(@"hello world");
                                             
                                             NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
                                             
                                             [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
                                             
                                         }];
    [operation start];

}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (IBAction)deleteMessagePress:(id)sender
{
    if (isLoad) {
        [[DatabaseSingleton sharedDBSingleton] deleteMessageWithText:message];
        InboxScreen *takeSurvey = [[InboxScreen alloc] init];
        [[MySingleton sharedMySingleton] popNewView:takeSurvey];
    }
    else{
//        NSString *bussIDstrAndType = [NSString stringWithFormat:@"%@%@andType%@",@"bussID", businessID,type];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *bussIDstrAndType = [NSString stringWithFormat:@"%@%@andType%@",@"bussID", businessID,type];
        NSLog(@"buss %@", bussIDstrAndType);
        [prefs removeObjectForKey:bussIDstrAndType];
        [prefs synchronize];
        
        NSLog(@"bussID %@ and type %@", businessID, type);
        [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:businessID andType:type];
        [self backBtn:nil];
    }
}



-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}


- (void)viewDidUnload
{
    myFavoritesLbl = nil;
    startSearchBtn = nil;
    deleteBtn = nil;
    messageLabel = nil;
    myTextView = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
