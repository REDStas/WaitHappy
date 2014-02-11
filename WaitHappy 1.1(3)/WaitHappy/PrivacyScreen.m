//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "PrivacyScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
//#import "DatabaseSingleton.h"
//#import "WaitList.h"
//#import "Buisness.h"

@interface PrivacyScreen ()
{
    UIImageView *im;
 //   WaitList *element;
}

@end

@implementation PrivacyScreen

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
//    element = [[WaitList alloc] init];
     searchArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [searchArray removeAllObjects];
    [startSearchBtn setHidden:YES];
    
//    [self loadData];
//    [self loadDataFromDB];
    [resultTable reloadData];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToLink:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/privacy"];
    [[UIApplication sharedApplication] openURL:url];
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}



//-(void)loadDataFromDB
//{
//    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", nil];
//    NSArray *values = [[NSArray alloc] initWithObjects:[[MySingleton sharedMySingleton] getToken], nil];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//    NSString *cur_url;
//    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetMessageList];
//    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
//    NSLog(@"-- %@",[params description]);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetMessageList parameters:params];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"%@", JSON);
//        /*
//        if ([JSON objectForKey:@"success"])
//        {
//            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDB:businessNameLbl.text];
//            [[MySingleton sharedMySingleton] backController];
//            
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }        
//         */
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        //  NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
//        //  [resultTable setAlpha:0];
//        
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//    }];
//    [operation start];
//    //
//    /*
//    else
//    {
//        [resultTable setAlpha:0];
//        startSearchBtn.hidden = NO;
//        im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noWaitLists.png"]];
//        [im setFrame:CGRectMake(8, 55, im.frame.size.width,im.frame.size.height)];
//        UILabel *label1 = [[UILabel alloc] init];
//        UILabel *label2 = [[UILabel alloc] init];
//        
//        label1.text = @"Inbox is empty.";
//        [label1 setFrame:CGRectMake(30, 25, 200, 20)];
//        [label1 setFont:[UIFont fontWithName:@"Arial" size:20.0]];
//        [label1 setTextAlignment:NSTextAlignmentLeft];
//        [label1 setBackgroundColor:[UIColor clearColor]];
//        
//        label2.text = @"Your inbox is where comment cards, promoyions, and manager responses can be founs and saved.";
//        [label2 setFrame:CGRectMake(30, 30, im.frame.size.width - 60, 100)];
//        label2.numberOfLines = 3;
//        [label2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
//        [label2 setTextAlignment:NSTextAlignmentLeft];
//        [label2 setBackgroundColor:[UIColor clearColor]];
//        
//        [im addSubview:label1];
//        [im addSubview:label2];
//        [self.view addSubview:im];
//    }
//    */
//}


-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}


- (void)viewDidUnload
{
    myFavoritesLbl = nil;
    startSearchBtn = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
