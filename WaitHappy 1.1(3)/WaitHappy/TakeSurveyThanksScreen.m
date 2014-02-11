//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "TakeSurveyThanksScreen.h"
#import "MySingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "InstructionScreen.h"

@interface TakeSurveyThanksScreen ()
{
    
}

//-(void)getSurveyData;
//-(void)getStaffMembers;
//-(void)setLabelOnMain;

@end

@implementation TakeSurveyThanksScreen

@synthesize businessName;

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
    [mainLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [businessNameLbl setText:[[NSString stringWithFormat:@"for %@",businessName] uppercaseString]];
    NSLog(@"hello");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

- (void)viewDidUnload
{
    businessNameLbl = nil;
    mainLbl = nil;
}

- (IBAction)subscribePress:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.waithappy.com/keep-me-posted"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)likeUsPress:(id)sender
{
    NSURL *facebookUrlString = [NSURL URLWithString:@"https://facebook.com/IWaitHappy"];
    [[UIApplication sharedApplication] openURL:facebookUrlString];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end