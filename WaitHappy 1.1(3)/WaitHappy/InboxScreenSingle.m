//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "InboxScreenSingle.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
//#import "InboxCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "TakeSurveyScreen.h"


@interface InboxScreenSingle ()
{
    UIImageView *im;
 //   WaitList *element;
}

@end

@implementation InboxScreenSingle

@synthesize date,message,messageID;

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
    //[deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message.png"] forState:UIControlStateNormal];
    //[deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_message_press.png"] forState:UIControlStateHighlighted];
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    [myFavoritesLbl setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [startSearchBtn setHidden:YES];
    
    NSLog(@"date %@",date);
    
   
    [messageLabel setText:message];
    
    
    //[dateLabel setText:@"dfdfdsfd"];
    
    [dateLabel setText:date];

    NSLog(@"date %@",dateLabel.text);

    
    CGSize messSize = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 600) lineBreakMode: UILineBreakModeWordWrap];
    [messageLabel setFrame:CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, messSize.height)];
    
    
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

- (IBAction)deleteMessagePress:(id)sender
{
    /*
    TakeSurveyScreen *takeSurvey = [[TakeSurveyScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:takeSurvey];
    */
    [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDB:messageID];
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
    deleteBtn = nil;
    messageLabel = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
