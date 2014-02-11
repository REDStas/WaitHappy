//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "CommentCardScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
//#import "DatabaseSingleton.h"
//#import "WaitList.h"
//#import "Buisness.h"

@interface CommentCardScreen ()
{
    UIImageView *im;
 //   WaitList *element;
}

@end

@implementation CommentCardScreen
@synthesize bussIdentStr;

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
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // [searchArray removeAllObjects];
    
//    [self loadData];
//    [self loadDataFromDB];
   // [resultTable reloadData];
    
    [[DatabaseSingleton sharedDBSingleton] setViewedMessageWithbussID:bussIdentStr andType:@"3"];
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

- (IBAction)deleteBtnPress:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString *bussIDstrAndType = [NSString stringWithFormat:@"%@%@andType%@",@"bussID", bussIdentStr,@"3"];

    NSString *bussIDstrAndType =  [NSString stringWithFormat:@"bussID%@andType%@",bussIdentStr,@"3"];
    NSLog(@"buss %@", bussIDstrAndType);
    
    [prefs removeObjectForKey:bussIDstrAndType];
    [prefs synchronize];
    
    NSLog(@"bu %@", bussIdentStr);
    
    
    NSLog(@"bussID %@ and type %@", bussIdentStr, @"3");
    
    [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:bussIdentStr andType:@"3"];
    
    [self backBtn:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}

- (void)viewDidUnload
{
    myFavoritesLbl = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
