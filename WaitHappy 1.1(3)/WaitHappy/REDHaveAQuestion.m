//
//  REDHaveAQuetion.m
//  WaitHappy
//
//  Created by Станислав Редреев on 08.08.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "REDHaveAQuestion.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "TakeSurveyScreen.h"
#import "InboxScreen.h"

@interface REDHaveAQuestion ()
{
    UIImageView *im;
    //   WaitList *element;
    
    BOOL isLoad;
}

@end

@implementation REDHaveAQuestion
@synthesize message, messageID, businessID, type, businessName, businessCellPhone, messageText;

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
    businessNameLabel.text = [self.businessName uppercaseString];
    NSLog(@"%@", businessName);
    //myTextView.text = [NSString stringWithFormat:@"While you are here, please provide feedback about your visit at %@. \n\nThis feedback will go directly to the store manager earn you WaitHappy points!", businessName];
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
    
    
    // Do any additional setup after loading the view from its nib.
    //    Do any additional setup after loading the view from its nib.
    //    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message.png"] forState:UIControlStateNormal];
    //    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message_press.png"] forState:UIControlStateHighlighted];
    //    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    //    [myFavoritesLbl setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
    
    //[deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message.png"] forState:UIControlStateNormal];
    //[deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message_press.png"] forState:UIControlStateHighlighted];
    
    myTextView.editable = NO;
    myTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [myTextView setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    //  [myTextView setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    
    [myTextView setTextColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1]];
    [callButton.titleLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:30.0]];
    
    
    //  [myTextView.text setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    //  [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    
    // message = @"We have a quick question. Please have a member of your party visit the A Test Business host stand or call (512) 335-2221.";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (IBAction)deleteMessagePress:(id)sender
{
    //if (isLoad) {
        [[DatabaseSingleton sharedDBSingleton] deleteMessageWithText:self.messageText];
        InboxScreen *takeSurvey = [[InboxScreen alloc] init];
        [[MySingleton sharedMySingleton] popNewView:takeSurvey];
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

- (IBAction)callButtonPress:(id)sender
{
    NSLog(@"%@", self.businessCellPhone);
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.businessCellPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)viewDidUnload {
    [self setBusinessName:nil];
    businessNameLabel = nil;
    callButton = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
