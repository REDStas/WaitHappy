
//
//  RestaurantDetaile.m
//  WaitHappy
//
//  Created by gelgard on 18.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "RestaurantDetaile.h"
#import "MySingleton.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "AppDelegate.h"
#import "Buisness.h"
#import "DatabaseSingleton.h"
#import "WaitListsScreen.h"
#import "PartyDetails.h"
//#import ""

@interface RestaurantDetaile ()
{
    CGRect initFrame;
    //float origin;
    BOOL makeReservIsGoURL;
    NSString *reservationURL;
    BOOL canShareAnyhow;
}
@end

@implementation RestaurantDetaile
@synthesize restaurantId, to_go_phone, phone;


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
    initFrame = [[MySingleton sharedMySingleton] getNavController].view.frame;
    
    specialScreen = [[SpecialScreen alloc] init];
    searchMap = [[SearchByMap alloc] init];
    searchMap.maptype = 1;
    
    
    //[noWaitListLabelNA setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:31.0f]];
    
    [restName setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    //[notInList setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:36.0f]];
    [notInList setText:NSLocalizedString(@"wait_list_labl", nil)];
    
    
    //[noWaitListLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:31.0f]];
    [noWaitListLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:40.0f]];
    
    
    [noWaitListLabelNA setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:31.0f]];
    [curWaitMins setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:36.0f]];
    [curWaitMinsNA setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:36.0f]];
    [curWait setText:NSLocalizedString(@"cur_wait", nil)];
    [curWaitNA setText:NSLocalizedString(@"cur_wait", nil)];
    [curWait setText:@"Current wait for"];
    [curWaitNA setText:@"Current wait for"];
    [curWait2 setText:@"a party of:"];
    [curWait2NA setText:@"a party of:"];
    [currNoWait1Label setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:36.0f]];
    //[currNoWait2Label setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:16.0f]];
    //[currNoWait3Label setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:16.0f]];
    [curentlyClosedLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:36.0f]];
    [curentlyClosedLabel setText:NSLocalizedString(@"currently_closed", nil)];
    [curentlyClosedDetailLabel setText:NSLocalizedString(@"currently_closed_detail", nil)];
    //[curentlyClosedDetailLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:16.0f]];
    //[sorryLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:18.0f]];
    [cantWait setText:NSLocalizedString(@"cant_wait", nil)];
    [cantWait2 setText:NSLocalizedString(@"cant_wait", nil)];
    loginview = [[FBLoginView alloc] initWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends];

    for (id obj in loginview.subviews)
    {        
        if ([obj isKindOfClass:[UIButton class]])            
        {
            UIButton * loginButton =  obj;
            //UIImage *loginImage = [UIImage imageNamed:@"map-pin.png"];
            [loginButton setBackgroundImage:nil forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            //[loginButton sizeToFit]
        }
        
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            [loginLabel setTextColor:[UIColor clearColor]];
            //loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 100, 271, 37);
        }
    }
    loginview.hidden = YES;
    dialogViewText.layer.cornerRadius = 5.0;
    dialogViewText.layer.masksToBounds = YES;
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        [dialogView setFrame:CGRectMake(dialogView.frame.origin.x, dialogView.frame.origin.y, dialogView.frame.size.width, 264)]; //264
    }
    else {
        [dialogView setFrame:CGRectMake(dialogView.frame.origin.x, dialogView.frame.origin.y, dialogView.frame.size.width, 352)];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self clearData];
    NSLog(@"Restaurant Detaile %@",self.restaurantId);
    [self fillInfo];
    if ([[DatabaseSingleton sharedDBSingleton] isMailSentForBusinessID:restaurantId]) {
        [letUsBtn setImage:[UIImage imageNamed:@"thanks_btn"] forState:UIControlStateNormal];
    }
    else
    {
        [letUsBtn setImage:[UIImage imageNamed:@"let_us_btn"] forState:UIControlStateNormal];
    }
}





-(void)setFavoritesOn:(BOOL)isFav
{
    if (isFav)
        [favBtn setImage:[UIImage imageNamed:@"rest_btn_fav_on.png"] forState:UIControlStateNormal];
}

-(void)showBottomMenu:(UIView *)_viewBottom
{
    [order_1 removeFromSuperview];
    [order_2 removeFromSuperview];
    [order_3 removeFromSuperview];
    if (_viewBottom) {
        [_viewBottom setFrame:CGRectMake(0, containerView.frame.size.height-_viewBottom.frame.size.height-10, containerView.frame.size.width, _viewBottom.frame.size.height)];
        [containerView addSubview:_viewBottom];
        curentlyClosedView.hidden = YES;
        
    }
    else
    {
        curentlyClosedView.hidden = NO;
        [curentlyClosedView setAlpha:1];
        inListView.hidden = YES;
        notInListView. hidden = YES;
        getOnLstAndNoAddView.hidden = YES;
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)favBtnAction:(id)sender
{
    if ([favBtn imageForState:UIControlStateNormal] == [UIImage imageNamed:@"rest_btn_fav.png"]) //
    {
        //[[DatabaseSingleton sharedDBSingleton] addObjectToDB:[self.restaurantId integerValue]];
        
        NSLog(@"restIDstr %@",restaurantId);
        
       // NSLog(@"restIDint %d",[restaurantId integerValue]);
        
        
        [[DatabaseSingleton sharedDBSingleton] addObjectToDB:self.restaurantId name:[restInfo objectForKey:@"name"] label: [restInfo objectForKey:@"label"]];
        [favBtn setImage:[UIImage imageNamed:@"rest_btn_fav_on.png"] forState:UIControlStateNormal];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = [[DatabaseSingleton sharedDBSingleton] getDataFromBusinessDB];
        
        
        NSLog(@"arr description  %@",[arr description]);
        
        for (Buisness *bs in arr)
        {
            NSLog(@"businessID %@", bs.buisID);
            NSLog(@"name %@", bs.name);
            NSLog(@"label %@", bs.label);
            
        }
    }
    else
    {
        [[DatabaseSingleton sharedDBSingleton] deleteObjectFromDB:self.restaurantId];
        [favBtn setImage:[UIImage imageNamed:@"rest_btn_fav.png"] forState:UIControlStateNormal];
    }
}





-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

// переход на WL
- (IBAction)viewTheWLPress:(id)sender
{
    WaitListsScreen *wl = [[WaitListsScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:wl];
}

- (IBAction)letUsBtnPress:(id)sender {
    
    if (![[DatabaseSingleton sharedDBSingleton] isMailSentForBusinessID:restaurantId])
    {
        
       
        MFMailComposeViewController *contr = [[MFMailComposeViewController alloc] init];
         NSLog(@"controller %@", [contr description]);
        contr.mailComposeDelegate = self;
        
        
        [contr setSubject:@"This business needs WaitHappy!"];
         NSString *messBody = [NSString stringWithFormat:@"Dear WaitHappy,\nThis business needs your help!\n\n%@\n%@\n\nINSTRUCTIONS:\nPlease hit \"Send\" and we will contact this business to see if we can get them on board!\nIf you are a frequent patron tell the manager and if they sign up we'll send you cash!\n\nThanks,\nTeam WaitHappy",[restInfo objectForKey:@"name"],[restInfo objectForKey:@"address"]];
        
        
        [contr setMessageBody:messBody isHTML:NO];
        [contr setToRecipients:[[NSArray alloc] initWithObjects:@"letusknow@waithappy.com", nil]];
        // [contr setToRecipients:[[NSArray alloc] initWithObjects:@"olewk@ukr.net", nil]];
        
        NSLog(@"controller %@", [contr description]);
        [[MySingleton sharedMySingleton] setHiddenMainPanel];
        [[MySingleton sharedMySingleton] setHiddenTopPanel];
        [self presentModalViewController:contr animated:YES];
    }
}



- (IBAction)signFreePress:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/claim-business/"];    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)makeReservRedPress:(id)sender
{
    [self makeCall:sender];
}


-(IBAction)switchWaitListBtn:(id)sender
{
    
  NSLog(@"is registered   %i", [[MySingleton sharedMySingleton] checkRegistered]);
    
    
    if (![[MySingleton sharedMySingleton] checkRegistered])
    {
        [[MySingleton sharedMySingleton]showAlertViewWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can add yourself to this business’s wait list.  Do you want to register your phone now?"  delegate:YES cancelTitle:@"No, thanks" otherTitle:@"Register Now"];
        
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoa Now" message:@"You have to register your phone with WaitHappy before you can add yourself to this business’s wait list.  Do you want to register your phone now?" delegate:self cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Register Now", nil];
        [alert show];
         */
    }
    
    else
    {
        /*
        if (((UIButton *)sender).tag == 1000) {
            [notInListView setAlpha:0];
            [inListView setAlpha:1];
        
        } else
        {
            [notInListView setAlpha:1];
            [inListView setAlpha:0];
        }
         */
        /*
        WaitListsScreen *wls = [[WaitListsScreen alloc] init];
        
        
        [self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
        */

       /*
        WaitListsScreen *wls = [[WaitListsScreen alloc] init];
        wls.restaurantId = self.restaurantId;        
        [[MySingleton sharedMySingleton] popNewView:wls];        
        */
        
        
        // переход на PartyDetails
        
        PartyDetails *pd = [[PartyDetails alloc] init];
       // pd.restaurantId = restaurantId;
         pd.JSON = Json;
        pd.restaurantId = restaurantId;
        [[MySingleton sharedMySingleton] popNewView:pd];        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // nil
            break;
        case 1:
            // switch to other view
            break;
    }
}



- (IBAction)shareButtonAction:(id)sender {
    if (!sharedActionSheet) {
        sharedActionSheet = [[UIActionSheet alloc] initWithTitle:@"Shared with" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", nil];
        //[sharedActionSheet showFromBarButtonItem:sender animated:YES];
    }
    [sharedActionSheet showInView:[[[MySingleton sharedMySingleton] getMainScreen] view]];    
    CGRect frame = [[[sharedActionSheet subviews] objectAtIndex:1] frame];
    loginview.frame = CGRectMake(frame.origin.x +2, frame.origin.y +1, frame.size.width - 4, frame.size.height);
    loginview.delegate = self;
    [sharedActionSheet addSubview:loginview];
}

-(void)clearData
{
   // [restImage setImage:nil];
    [restName setText:@""];
    [restLabel setText:@""];
    [restPhone setText:@""];
}


-(IBAction)makeCall:(id)sender
{
    NSString *phoneNumber;
    if (((UIButton *)sender).tag == 300)
    {
        if (makeReservIsGoURL)
        {
            NSLog(@"http %@",[reservationURL substringToIndex:4]);
            if (![[reservationURL substringToIndex:4] isEqualToString:@"http"])
            {
                reservationURL = [NSString stringWithFormat:@"http://%@",reservationURL];
            }
            NSLog(@"url %@",reservationURL);
            NSURL *url = [NSURL URLWithString:reservationURL];
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
        else
        {
            phoneNumber = restPhone.text;
        }
    }
    
    
    // ====== old =======
    if (((UIButton *)sender).tag == 100) {
        phoneNumber = restPhone.text;
    }
    
    if (((UIButton *)sender).tag == 200) {
        phoneNumber = self.to_go_phone;
    }
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
    
     NSLog(@"restinfo description %@", [restInfo description]);
    
}


- (IBAction)openSpecial:(id)sender
{   
    specialScreen.restaurantId = self.restaurantId;
    // [restaurantDetaile.view setFrame:CGRectMake(0, 0, 100, 100)];
    
    [[MySingleton sharedMySingleton] popNewView:specialScreen];
  //  [specialScreen.restaurantName setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:31.0f]];

   
    
    // [restLabel setFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:17.0f]];
    [specialScreen.restaurantLabel setText:@"SPECIALS & PROMOTIONS"];
    [specialScreen.restaurantName setText:restName.text];
}

- (IBAction)openMap:(id)sender
{
    [[MySingleton sharedMySingleton] push:searchMap];
    //[[MySingleton sharedMySingleton] popNewView:searchMap];
    //[self.navigationController pushViewController:searchMap animated:YES];
    [searchMap addRestaurant:[[restInfo objectForKey:@"latitude"] floatValue] longitude:[[restInfo objectForKey:@"longitude"] floatValue] restName:[restInfo objectForKey:@"name"] restLabel:[restInfo objectForKey:@"label"] restId:[[restInfo objectForKey:@"id"] intValue]];
    searchMap.topLabel.hidden = NO;
    searchMap.detailLabel.hidden = NO;
    searchMap.topLabel.text = restName.text;
    searchMap.detailLabel.text = restLabel.text;
}

- (IBAction)refreshButtonAction:(id)sender {
    [super viewWillAppear:YES];
    [self clearData];
    
    NSLog(@"Restaurant Detaile %@",self.restaurantId);
    // [self showBottomMenu:order_3];
    [self fillInfo];
}



-(void)fillInfo
{
    [currentlyNoWaitView setFrame:CGRectMake(currentlyNoWaitView.frame.origin.x, 216, currentlyNoWaitView.frame.size.width, currentlyNoWaitView.frame.size.height)];
    correction = 0;
    NSLog(@" -- %@",self.restaurantId);
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:self.restaurantId, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kBusinessInfo];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessInfo parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        Json = JSON;
        
        
        NSLog(@"kBusinessInfo %@",JSON);
        NSDictionary *waitList = [[NSDictionary alloc] init];
        waitList = [JSON objectForKey:@"WaitList"];
        if ([waitList count] > 0) {            
            [noWaitListLabel setHidden:YES];
            [noWaitListLabelNA setHidden:YES];
            
            [curWait setHidden:NO];
            [curWaitNA setHidden:NO];
            [curWait2 setHidden:NO];
            [curWait2NA setHidden:NO];
          
            [curWaitMins setHidden:NO];
            [curWaitMinsNA setHidden:NO];
            [curWait setText:@"Current wait for"];
            [curWaitNA setText:@"Current wait for"];
            
            [curWait2 setText:[NSString stringWithFormat:@"a party of %@:",[waitList objectForKey:@"last_party_size"]]];
            [curWait2NA setText:[NSString stringWithFormat:@"a party of %@:",[waitList objectForKey:@"last_party_size"]]];
            
            if ([waitList objectForKey:@"estimated_wait"])
            {
                [curWaitMins setText:[NSString stringWithFormat:@"%@%@",[waitList objectForKey:@"estimated_wait"],NSLocalizedString(@"curWaitMin", nil)]];
                 [curWaitMinsNA setText:[NSString stringWithFormat:@"%@%@",[waitList objectForKey:@"estimated_wait"],NSLocalizedString(@"curWaitMin", nil)]];
            }
            else
            {
                [curWaitMins setText:[NSString stringWithFormat:@"0%@",NSLocalizedString(@"curWaitMin", nil)]];
                [curWaitMinsNA setText:[NSString stringWithFormat:@"0%@",NSLocalizedString(@"curWaitMin", nil)]];
            }
        }
        else
        {
            [noWaitListLabel setHidden:NO];
            [noWaitListLabelNA setHidden:NO];
            
            [curWait setHidden:YES];
            [curWaitNA setHidden:YES];
        
            [curWait2 setHidden:YES];
            [curWait2NA setHidden:YES];
        
            [curWaitMins setHidden:YES];
            [curWaitMinsNA setHidden:YES];
        }
        
        restInfo = [[NSDictionary alloc]  initWithDictionary:[JSON objectForKey:@"Business"]];
        NSDictionary *restState = [[NSDictionary alloc]  initWithDictionary:[JSON objectForKey:@"State"]];
        NSDictionary *restWaitListSystem = [[NSDictionary alloc]  initWithDictionary:[JSON objectForKey:@"WaitListSystem"]];

        NSLog(@"dict %@", [restInfo description]);
        
        // set reservURL
        if ((![[restInfo objectForKey:@"reservations_url"] isEqual:[NSNull null]]) && (![[restInfo objectForKey:@"reservations_url"] isEqualToString:@""]))
        {
            //***
            reservationURL = [restInfo objectForKey:@"reservations_url"];
            makeReservIsGoURL = YES;
        }
        else
        {
            makeReservIsGoURL = NO;
        }
        
        [self setFavoritesOn:[[DatabaseSingleton sharedDBSingleton] isFavotite:restaurantId]];
        BOOL to_go_phone_bool = YES;
        if ([[restInfo objectForKey:@"to_go_phone"] isKindOfClass:[NSNull class]])
        {
            to_go_phone_bool = NO;
        }
        else
        {
            if ([[restInfo objectForKey:@"to_go_phone"] length]==0)
            {
                to_go_phone_bool = NO;
            }
        }
        NSLog(@"%@",[JSON objectForKey:@"WaitListSystem"]);
        NSLog(@"%@",[restWaitListSystem objectForKey:@"name"]);
        
        [order_1 removeFromSuperview];
        [order_2 removeFromSuperview];
        [order_3 removeFromSuperview];
        
        [curentlyClosedView setHidden:YES];
        [notInListView setHidden:YES];
        [inListView setHidden:YES];
        [notInListView setHidden:YES];
        [pricingPlanView setHidden:YES];
        [currentlyNoWaitView setHidden:YES];
        [getOnLstAndNoAddView setHidden:YES];
        [reservationOnlyView setHidden:YES];
        NSLog(@"inListView %f", inListView.frame.origin.y);
        [inListView setFrame:CGRectMake(inListView.frame.origin.x, 229, inListView.frame.size.width, inListView.frame.size.height)];
        
        [currentlyNoWaitView setAlpha:0];
        [curentlyClosedView setAlpha:0];
        [notInListView setAlpha:0];
        [inListView setAlpha:0];
        [notInListView setAlpha:0];
        [pricingPlanView setAlpha:0];
        [getOnLstAndNoAddView setAlpha:0];
        [reservationOnlyView setAlpha:0];
        
        
        
        if ([[DatabaseSingleton sharedDBSingleton] isInWaitWaitList:restaurantId]) // если в листе ожидания
        {
            [notInListView setHidden:NO];
            [notInListView setAlpha:1];
            if(to_go_phone_bool)
            {
                // показываешь order-to-go
                [self showBottomMenu:order_2];
            }
        }
        else
        {
            //***
            if ([[[JSON objectForKey:@"PricingPlan"] objectForKey:@"name"] isEqual:[NSNull null]] ||[[[JSON objectForKey:@"PricingPlan"] objectForKey:@"name"] isEqualToString:@"No Plan"]) 
            {                
                [pricingPlanView setHidden:NO];
                [pricingPlanView setAlpha:1];
//                if(to_go_phone_bool)
//                {
//                    // показываешь order-to-go
//                    [self showBottomMenu:order_2];
//                }
            }
            else
            {
#pragma mark Pricing Plan Mission Control Plus
            
                if([[[JSON objectForKey:@"PricingPlan"] objectForKey:@"name"] isEqualToString:@"Mission Control Plus"])
                {
                    //***
                    if([[restWaitListSystem objectForKey:@"name"] isEqualToString:@"Wait List Only"])  // waitListOnly
                    {
                        if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                        {
                            [self showBottomMenu:nil];
                        }
                        else
                        {
                        
                        if ([waitList count] == 0)
                        {
                        
                        [currentlyNoWaitView setHidden:NO];
                        [currentlyNoWaitView setAlpha:1];

                        }
                        else
                        {
                            if ([[restInfo objectForKey:@"allow_mobile_wait_list_add"] isEqualToString:@"0"] || [[restInfo objectForKey:@"allow_mobile_wait_list_add"] isEqual:[NSNull null]]){
                                [getOnLstAndNoAddView setHidden:NO]; // no Add bButton
                                [getOnLstAndNoAddView setAlpha:1];
                            }
                            else{
                                [inListView setHidden:NO]; // with Add button
                                [inListView setAlpha:1]; ///заходит сюда
                                correction++;
                            }
                        }
                            if(to_go_phone_bool)
                            {
                                [currentlyNoWaitView setFrame:CGRectMake(currentlyNoWaitView.frame.origin.x, 216, currentlyNoWaitView.frame.size.width, currentlyNoWaitView.frame.size.height)];
                            
                            // показываешь order-to-go
                                [self showBottomMenu:order_2];   // заходит сюда
                                if (correction == 1) {
                                    NSLog(@"1-%f", inListView.frame.origin.y);
                                    NSLog(@"2-%f", currentlyNoWaitView.frame.origin.y);
                                    [inListView setFrame:CGRectMake(inListView.frame.origin.x, 219, inListView.frame.size.width, inListView.frame.size.height)];
                                    [currentlyNoWaitView setFrame:CGRectMake(currentlyNoWaitView.frame.origin.x, 203, currentlyNoWaitView.frame.size.width, currentlyNoWaitView.frame.size.height)];
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"dfljjsdf" message:@"dlhsgisg" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                    [alert show];
                                }
                            }
                            else{
                                [currentlyNoWaitView setFrame:CGRectMake(currentlyNoWaitView.frame.origin.x, 230, currentlyNoWaitView.frame.size.width, currentlyNoWaitView.frame.size.height)];
                            }
                        }
                    }
                    else
                    {
                        if ([[restWaitListSystem objectForKey:@"name"] isEqualToString:@"Reservations and Wait List"]) // Reserv and WL
                        {
                            NSLog(@"crash here");
                            NSLog(@"restInfo %@", [restInfo description]);
                            NSLog(@"is_now_open %@", [restInfo objectForKey:@"is_now_open"]);
                            
                            if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                            {
                                [self showBottomMenu:nil];
                            }
                            else
                            {
                            //***
                                if ([waitList count] == 0)
                                {
                                    [currentlyNoWaitView setHidden:NO];
                                    [currentlyNoWaitView setAlpha:1];
                                }
                                else
                                {
                                    //***                                    
//                                    [getOnLstAndNoAddView setHidden:NO]; // no Add bButton
//                                    [getOnLstAndNoAddView setAlpha:1];
                                    [inListView setFrame:CGRectMake(inListView.frame.origin.x, 220, inListView.frame.size.width, inListView.frame.size.height)];
                                    [inListView setHidden:NO];
                                    [inListView setAlpha:1];
                                }
                                
                                if(to_go_phone_bool)
                                {
                                    //***
                                    // показываешь order-to-go и reservion
                                    [self showBottomMenu:order_1];
                                }
                                else
                                {
                                    // показываешь make reservion
                                    [self showBottomMenu:order_3];
                                }
                            }
                        }
                        else  // reservations only
                        {
                            if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                            {
                                [self showBottomMenu:nil];
                            }
                            else
                            {
                            
                                if(to_go_phone_bool)
                                {
                                    // показываешь order-to-go и reservion
                                    [self showBottomMenu:order_2];
                                }
                                [reservationOnlyView setAlpha:1];
                                [reservationOnlyView setHidden:NO];
                            }
                        }
                    }
                }
                else // plan Mission Control
                {
                    if([[restWaitListSystem objectForKey:@"name"] isEqualToString:@"Wait List Only"]) // waitlist only
                    {
                        if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                        {
                            [self showBottomMenu:nil];
                        }
                        else
                        {
                            if ([waitList count] == 0)
                            {
                                [currentlyNoWaitView setHidden:NO];
                                [currentlyNoWaitView setAlpha:1];
                                
                            }
                            else
                            {
                                [getOnLstAndNoAddView setHidden:NO]; // no Add bButton
                                [getOnLstAndNoAddView setAlpha:1];
                            }
                        
                        
                            if(to_go_phone_bool)
                            {
                                // показываешь order-to-go
                                [self showBottomMenu:order_2];
                                // если у нас только current no wait
                            }
                            else
                            {
                                [currentlyNoWaitView setFrame:CGRectMake(currentlyNoWaitView.frame.origin.x, 222, currentlyNoWaitView.frame.size.width, currentlyNoWaitView.frame.size.height)];

                            }
                        }
                    }
                    else
                    {                        
                        if ([[restWaitListSystem objectForKey:@"name"] isEqualToString:@"Reservations and Wait List"]) // reserv and WL
                        {
                            if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                            {
                                [self showBottomMenu:nil];
                            }
                            else
                            {
//                                if ([[restInfo objectForKey:@"allow_mobile_wait_list_add"] isEqualToString:@"0"] || [[restInfo objectForKey:@"allow_mobile_wait_list_add"] isEqual:[NSNull null]])
//                                {
//                                    [getOnLstAndNoAddView setHidden:NO];
//                                    [getOnLstAndNoAddView setAlpha:1];
//                                }
//                                else
//                                {
//                                    [inListView setHidden:NO];
//                                    [inListView setAlpha:1];
//                                }
                            
                            
                            if ([waitList count] == 0)
                                {
                                
                                [currentlyNoWaitView setHidden:NO];
                                [currentlyNoWaitView setAlpha:1];
                                
                                }
                            else
                                {
                                [getOnLstAndNoAddView setHidden:NO]; // no Add bButton
                                [getOnLstAndNoAddView setAlpha:1];
                                
                                }
                            
                            
                                if(to_go_phone_bool)
                                {
                                    // показываешь order-to-go и reservion
                                    [self showBottomMenu:order_1];
                                }
                                else
                                {
                                    // показываешь make reservion
                                    [self showBottomMenu:order_3];
                                }                            
                            }
                        }
                        else  // Reservations only
                        {
                            if(![[restInfo objectForKey:@"is_now_open"] boolValue])
                            {
                                [self showBottomMenu:nil];
                            }
                            else
                            {
                                if(to_go_phone_bool)
                                {
                                // показываешь order-to-go и reservion
                                    [self showBottomMenu:order_2];
                                }
                                [reservationOnlyView setAlpha:1];
                                [reservationOnlyView setHidden:NO];
                            
                            }
                        }
                    }
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // ==============
        
        self.to_go_phone = [restInfo objectForKey:@"to_go_phone"];
        self.phone = [restInfo objectForKey:@"phone"];
        NSString *imgPath;
        imgPath = [NSString stringWithFormat:@"%@",[restInfo objectForKey:@"image"]];
        NSString *adress_1 = [NSString stringWithFormat:@"%@\n%@, %@ %@\n",[restInfo objectForKey:@"address"],[restInfo objectForKey:@"city"],[restState objectForKey:@"abbreviation"],[restInfo objectForKey:@"zipcode"]];
        
        // ======== устанавливаем изображение слева  =======
        if (![imgPath isEqualToString:@"<null>"] && ![imgPath isKindOfClass:[NSNull class]])
        {
            NSLog(@"%@",imgPath);
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imgPath]] ;
            [restImage setImage:[UIImage imageNamed:@"wh-app-business-default-img.png"]];
            [restImage setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                NSLog(@"sucess");
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"fail download image");
            }];
        }
        else
        {
            [restImage setImage:[UIImage imageNamed:@"wh-app-business-default-img.png"]];
        }
        // ======== устанавливаем изображение слева  =======
        
        [restName setText:[[restInfo objectForKey:@"name"] uppercaseString]];
        [restLabel setText:[NSString stringWithFormat:@"%@", [[restInfo objectForKey:@"label"] uppercaseString]]];
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        [restAdress setText:adress_1];
        [restPhone setText:[[restInfo objectForKey:@"phone"] uppercaseString]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    
    [operation start];
}

#pragma mark - actionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([choice isEqualToString:@"Facebook"])
    {
        if (canShareAnyhow)
        {
            BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self initialText:[NSString stringWithFormat:@"Getting ready for a good time at %@ \n http://www.waithappy.com/download/", restName.text] image:nil url:nil handler:^(FBNativeDialogResult result, NSError *error) {
                        if (error) {
                             /* handle failure */
                             } else {
                                 if (result == FBNativeDialogResultSucceeded) {
                                     /* handle success */
                                     } else {
                                         /* handle user cancel */
                                        }
                                }
                         }];
            if (!displayedNativeDialog)
            {
                /*
                            Fallback to web-based Feed Dialog:
                            https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/
                            */
                }
            //[self postOnFacebookWithMassage:[NSString stringWithFormat:@"%@", [dialogViewText text]]];
        }
        else
        {
            NSLog(@"Facebook");
            [dialogView setHidden:NO];
            [dialogViewText setText:[NSString stringWithFormat:@"Getting ready for a good time at %@ \n http://www.waithappy.com/download/", restName.text]];
            [dialogViewText becomeFirstResponder];
            socialPost = 1;
        }
    }
    else
    {
        if ([choice isEqualToString:@"Twitter"]) {
            NSLog(@"Twitter");
            [dialogView setHidden:NO];
            
            //if ([[restInfo objectForKey:@"twitter_handle"] isEqual:[NSNull null]] || [[restInfo objectForKey:@"twitter_handle"] isEqualToString:@""])
            //{
                [dialogViewText setText:[NSString stringWithFormat:@"I am here and I'm happy at %@. #iWaitHappy", [restName text]]];
            //}
            //else
            //{
            //    [dialogViewText setText:[NSString stringWithFormat:@"I am here and I'm happy at %@. #iWaitHappy", [restInfo objectForKey:@"twitter_handle"]]];
            //}
            
            [dialogViewText becomeFirstResponder];
            socialPost = 2;
        }
    }
}



#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // first get the buttons set for login mode
    loginView.hidden = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    NSLog(@"%@",[NSString stringWithFormat:@"Hello %@!", user.first_name]);
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    self.loggedInUser = user;
    //[self postOnFacebookWithMassage:@"Wait Happy"];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
    loginview.hidden = canShareAnyhow;
    self.loggedInUser = nil;
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error
{
    
    NSLog(@"error %@",error.localizedDescription);
    NSLog(@"error %@",[error.userInfo description]);
    
  //  NSLog(@"%@",error);
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error)
    {
        @try
        {
            alertMsg = [[[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"] objectForKey:@"message"];
            NSRange range = [alertMsg rangeOfString:@")"];
            if (range.length != 0)
            {
                alertMsg = [NSString stringWithString:[alertMsg substringFromIndex:range.location+1]];
            }
        }
        @catch (NSException *exception)
        {
             alertMsg = @"The operation couldn’t be completed";
        }
        alertTitle = @"Error";
    }
    else
    {
        NSDictionary *resultDict = (NSDictionary *)result;
        NSLog(@"result description %@",[resultDict description]);
        NSLog(@"mesage %@", message);
        alertMsg = @"Successfully posted";
        //alertMsg = [NSString stringWithFormat:@"Successfully posted %@", message];
        //alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@", message, [resultDict valueForKey:@"id"]];
        NSLog(@"alert msg%@",alertMsg);
        alertTitle = @"Success";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)postOnFacebookWithMassage:(NSString *)massage
{
    
    NSLog(@"message %@",massage);
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self initialText:nil image:nil url:nil handler:nil];
    
    if (!displayedNativeDialog) {
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            NSString *message = [NSString stringWithFormat:@"%@.", massage];            
            [FBRequestConnection startForPostStatusUpdate:message completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self showAlert:message result:result error:error];
                                            });
                                            //self.buttonPostStatus.enabled = YES;
                                        }];
            //self.buttonPostStatus.enabled = NO;
        }];
    }
}

#pragma mark - Twitter

- (void)shareTW {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    UIAlertView *alertViewSorry = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         // Did user allow us access?
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             // Sanity check
             if ([arrayOfAccounts count] > 0)
             {
                 // Keep it simple, use the first account available
                 ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                 TWRequest *postRequest;
                 // Build a twitter request
                 postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@", [dialogViewText text]] forKey:@"status"] requestMethod:TWRequestMethodPOST];
                 NSLog(@"restInfo%@", [restInfo description]);
                 // Post the request
                 [postRequest setAccount:acct];
                 // Block handler to manage the response
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                          [self alertShow:[urlResponse statusCode] andMessage:[dialogViewText text]];
                          
                      });
                  }];
             }
         }else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [alertViewSorry show];;
             });
         }
     }];
}



-(void)alertShow:(NSInteger)statusCode andMessage:(NSString*)message
{
    NSLog(@"alsh");
    switch (statusCode) {
        case 200:
        {
            //UIAlertView *alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Successful" message:[NSString stringWithFormat:@"Succesfully posted %@", message] delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Successful" message: @"Succesfully posted" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            
            [alertViewSuccess show];
            break;
        }
        
        case 403:
        {
            UIAlertView *alertViewAlready = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"You have already tweet this message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertViewAlready show];
            break;
        }
            
        default:
        {
            UIAlertView *alertViewFail = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Tweet failed"  delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertViewFail show];
            break;
        }
    }
}


//-(void)alertShow:(NSInteger)statusCode
//{
//    
//    
//    switch (statusCode) {
//        case 200:{
//            UIAlertView *alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Tweet Successful" message:@"1"
//                                             delegate:nil // self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//            //[self.view addSubview:alertViewSuccess];
//            [alertViewSuccess show];
//            break;}
//        case 403:{
//            UIAlertView *alertViewAlready = [[UIAlertView alloc]
//                                             initWithTitle:@"You have already tweet this message"
//                                             message:@"2"
//                                             delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//            [alertViewAlready show];
//            break;}
//            
//        default:{
//            UIAlertView *alertViewFail = [[UIAlertView alloc]
//                                          initWithTitle:@"Tweet failed"
//                                          message:@"3"
//                                          delegate:nil  // self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//            [alertViewFail show];
//            break;}
//    }
//}

# pragma mark MailController Delegate 

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *message = nil;
    
    switch (result)
    {
            case MFMailComposeResultCancelled:
                message = @"Result: canceled";
                break;
            case MFMailComposeResultSaved:
                message = @"Result: saved";
            break;
            case MFMailComposeResultSent:
            {
                message = @"Result: sent";
                [[DatabaseSingleton sharedDBSingleton] addBusinessToSendMail:restaurantId];
                [letUsBtn setImage:[UIImage imageNamed:@"thanks_btn"] forState:UIControlStateNormal];
            }
            break;
            case MFMailComposeResultFailed:
                message = @"Result: failed";
            break;
            default:
                message = @"Result: not sent";
            break;
    }
    NSLog(@"%@", message);
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    [[MySingleton sharedMySingleton] unsetHiddenTopPanel];
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
    [[[[MySingleton sharedMySingleton] getNavController] view] setFrame:initFrame];
     NSLog(@"nav frame %f",[[MySingleton sharedMySingleton] getNavController].view.frame.origin.y);
}






- (void)viewDidUnload {
    curentlyClosedLabel = nil;
    curentlyClosedDetailLabel = nil;
    curentlyClosedView = nil;
    favBtn = nil;
    favBtn = nil;
    favBtn = nil;
    pricingPlanView = nil;
    letUsBtn = nil;
    noWaitListLabel = nil;
    noWaitListLabelNA = nil;
    currentlyNoWaitView = nil;
    currentlyNoWaitView = nil;
    currNoWait1Label = nil;
    currNoWait2Label = nil;
    
    curWait2 = nil;
    curWait2NA = nil;
    
    getOnLstAndNoAddView = nil;
    reservationOnlyView = nil;
    currNoWait3Label = nil;
    sorryLabel = nil;
    [super viewDidUnload];
}




-(void)viewWillDisappear:(BOOL)animated
{
    [favBtn setImage:[UIImage imageNamed:@"rest_btn_fav.png"] forState:UIControlStateNormal];
   // [favBtn imageForState:UIControlStateNormal] == [UIImage imageNamed:@"rest_btn_fav.png"];
    
    [pricingPlanView setHidden: YES];
    
    [dialogView setHidden:YES];
    
    [dialogViewText resignFirstResponder];
   /*
    [order_1 removeFromSuperview];
    [order_2 removeFromSuperview];
    [order_3 removeFromSuperview];
    */
}


#pragma mark facebook


- (IBAction)dialogViewCanselButtonPress:(id)sender
{
    [dialogView setHidden:YES];
    [dialogViewText resignFirstResponder];
}

- (IBAction)dialogViewPostButtonPress:(id)sender {
    [dialogView setHidden:YES];
    [dialogViewText resignFirstResponder];
    if (socialPost == 1) {
        [self postOnFacebookWithMassage:[NSString stringWithFormat:@"%@", [dialogViewText text]]];
    }
    if (socialPost == 2)
    {
        [self shareTW];
    }
}


- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
