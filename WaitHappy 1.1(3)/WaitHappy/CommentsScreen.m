//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "CommentsScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"

@interface CommentsScreen ()
{
    UIImageView *im;
 //   WaitList *element;
}

@end

@implementation CommentsScreen

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
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/contact/subscribe"];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)FAQsButtonPress:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/faqs/"];    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)CommAndFeedButtonPress:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/support/"];
    [[UIApplication sharedApplication] openURL:url];
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
