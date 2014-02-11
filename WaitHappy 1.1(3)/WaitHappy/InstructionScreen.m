//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "InstructionScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "SearchCell.h"
#import "HomeController.h"


@interface InstructionScreen ()
{
}

@end

@implementation InstructionScreen
@synthesize topLabel, lowerLabel;


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
     [topLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"1" forKey:@"IsInstructScreen"];
    [prefs synchronize];
    [[MySingleton sharedMySingleton] setHiddenMainPanel];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + 60)];
    [self.navigationController.view setFrame:CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, 700)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillDisappear:(BOOL)animated
{
  
    
}


- (void)viewDidUnload
{
    [self setLowerLabel:nil];
    [self setTopLabel:nil];
}

- (IBAction)pressCancelMyRequestButton:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Your party will not be added to the wait list." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

- (IBAction)removeBtnPress:(id)sender
{
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"IsInstructScreen"];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"instructionBusinessID"]);
        //[[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:[[NSUserDefaults standardUserDefaults] objectForKey:@"instructionBusinessID"]];
        [self removeBusinessFromWaitList];
        [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController]];
        [[MySingleton sharedMySingleton] unsetHiddenMainPanel];
        
        
    }
}

-(void)removeBusinessFromWaitList
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[DatabaseSingleton sharedDBSingleton] getWaitListIDwithBusinessID:[[NSUserDefaults standardUserDefaults] objectForKey:@"instructionBusinessID"]], nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kDeleteFromWaitList];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kDeleteFromWaitList parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        /*
         [searchArray removeAllObjects];
         
         NSArray *jsonArr = [[NSArray alloc] init];
         jsonArr = [JSON objectForKey:@"data"];
         */
        //     myEmail = [[NSUserDefaults standardUserDefaults]stringForKey:@"userEmail"];
        
        
        //  NSLog(@"myEmailUsDef %@",myEmail);
        
        if ([JSON objectForKey:@"success"])
        {
            //[[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDB:businessNameLbl.text];
            
            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:[[NSUserDefaults standardUserDefaults] objectForKey:@"instructionBusinessID"]];
            //[[MySingleton sharedMySingleton] backController];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}

@end
