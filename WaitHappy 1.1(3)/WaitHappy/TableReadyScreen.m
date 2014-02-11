//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "TableReadyScreen.h"
#import "MySingleton.h"


@interface TableReadyScreen ()
{
    UIImageView *im;
    UILabel *label1;
  //  UILabel *label2;
}

@end

@implementation TableReadyScreen

@synthesize businessName, businessID, isRemovedWL;// restaurantLabel;

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
    [topLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
    [im setFrame:CGRectMake(8, 55, im.frame.size.width,124)];
    label1 = [[UILabel alloc] init];
    [label1 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    [label1 setNumberOfLines:0];
    [im addSubview:label1];
    [self.view addSubview:im];
}

-(void)viewWillAppear:(BOOL)animated
{
    isRemovedWL = YES;
    NSLog(@"businessName %@",businessName);
    [secondLabel setText:businessName];
    secondLabel.text = [secondLabel.text uppercaseString];
    label1.text = @"Thank you so much for waiting, Time Traveler! We sincerely hope you enjoy your stay. A private comment card will be sent to your phone to collect valuable feedback about your experience.\n\nEnjoy!";
    CGSize lbl1TextSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(180, 500) lineBreakMode:label1.lineBreakMode];
    [label1 setFrame:CGRectMake(35, 8, 232, lbl1TextSize.height)];
    [im setFrame:CGRectMake(im.frame.origin.x, im.frame.origin.y, im.frame.size.width, label1.frame.origin.y + label1.frame.size.height + 6)];
}


//-(void)removeBusinessFromWaitList:(id)contr
//{
//    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
//    NSArray *values = [[NSArray alloc] initWithObjects:[[DatabaseSingleton sharedDBSingleton] getWaitListIDwithBusinessID:businessID], nil];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//    NSString *cur_url;
//    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kDeleteFromWaitList];
//    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
//    NSLog(@"-- %@",[params description]);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kDeleteFromWaitList parameters:params];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"%@", JSON);
//        if ([JSON objectForKey:@"success"])
//        {
//          //  [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:businessID andType:@"4"];
//            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:businessID];
//            isRemovedWL = NO;
//            [[MySingleton sharedMySingleton] popNewView:contr];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
//    }];
//    [operation start];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)deleteMessagePress:(id)sender
{
    //if (isLoad) {
    [[DatabaseSingleton sharedDBSingleton] deleteMessageWithText:self.businessMessage];
    [[MySingleton sharedMySingleton] backController];
//    InboxScreen *takeSurvey = [[InboxScreen alloc] init];
//    [[MySingleton sharedMySingleton] popNewView:takeSurvey];
    //}
    //    else{
    //        //        NSString *bussIDstrAndType = [NSString stringWithFormat:@"%@%@andType%@",@"bussID", businessID,type];
    //        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //        NSString *bussIDstrAndType = [NSString stringWithFormat:@"%@%@andType%@",@"bussID", businessID,type];
    //        NSLog(@"buss %@", bussIDstrAndType);
    //        [prefs removeObjectForKey:bussIDstrAndType];
    //        [prefs synchronize];
    //
    //        NSLog(@"bussID %@ and type %@", businessID, type);
    //        [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:businessID andType:type];
    //        [self backBtn:nil];
    //    }
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (void)viewDidUnload {
    topLabel = nil;
    secondLabel = nil;
       [super viewDidUnload];
}
@end
