//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SettingsScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "CommentsScreen.h"
#import "PrivacyScreen.h"
#import "AboutScreen.h"


@interface SettingsScreen ()
{
    UIImageView *im;
 //   WaitList *element;
}

@end

@implementation SettingsScreen

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
    // Do any additional setup after loading the view from its nib.
    
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [self loadData];
//    [self loadDataFromDB];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)myInformationPress:(id)sender
{
    accountSettingsView = [[AccountSettings alloc] init];
    [[MySingleton sharedMySingleton] popNewView:accountSettingsView];
}

- (IBAction)commentsPress:(id)sender
{
    CommentsScreen *com = [[CommentsScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:com];
}

- (IBAction)privacyPress:(id)sender
{
    PrivacyScreen *com = [[PrivacyScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:com];
}

- (IBAction)aboutPress:(id)sender
{
    AboutScreen *about = [[AboutScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:about];
}




-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}



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
