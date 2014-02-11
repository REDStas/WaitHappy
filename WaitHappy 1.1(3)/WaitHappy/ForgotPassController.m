//
//  ForgotPassController.m
//  WaitHappy
//
//  Created by gelgard on 27.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "ForgotPassController.h"
#import "MySingleton.h"

@interface ForgotPassController ()

@end

@implementation ForgotPassController

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
    
    
       
    [top_label setText:NSLocalizedString(@"top1_lbl_fog", nil)];
    [top_label2 setText:NSLocalizedString(@"top2_lbl_fog", nil)];
    
    [email_field setPlaceholder:NSLocalizedString(@"placeholder_email", nil)];
    [email_field setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)goForgotPassword:(id)sender
{
    
    
     [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"email", nil];
    
    NSArray *values = [[NSArray alloc] initWithObjects:email_field.text, nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    
    
    
    
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kForgot];
    
    
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:
                           dict, @"data", nil];
    
    NSLog(@"-- %@",[params description]);
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kMainUrl]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kForgot parameters:params];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSLog(@"%@", JSON);
        NSLog(@"== %@", [JSON objectForKey:@"success"]);
        int suc;
        suc = [[JSON objectForKey:@"success"] intValue];
        
        if (suc == 0)
        {
            NSString *txt;
            txt = [NSString stringWithFormat:@"%@",[JSON objectForKey:@"error"]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        } else
        {
           // [[MySingleton sharedMySingleton] setRegistered];
            
            
            
            [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
            
            [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getReactivateController]];
            
        }
      [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];   
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        NSString *txt;
        txt = [NSString stringWithFormat:@"%@ %@",[error localizedDescription], JSON];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
         [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
}

-(IBAction)keybDone:(id)sender
{
    [self goForgotPassword:nil];
}


-(IBAction)upCurrentView:(id)sender
{
    if (![[MySingleton sharedMySingleton] isFourRetina]) {
        [[MySingleton sharedMySingleton] moveCurrentView:-50];
        
    }
    
}

-(IBAction)downCurrentView:(id)sender
{
    if (![[MySingleton sharedMySingleton] isFourRetina]) {
        [[MySingleton sharedMySingleton] moveCurrentView:50];
        
    }
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
