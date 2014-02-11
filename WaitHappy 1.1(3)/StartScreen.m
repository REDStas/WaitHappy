//
//  StartScreen.m
//  WaitHappy
//
//  Created by gelgard on 24.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "StartScreen.h"
#import "MySingleton.h"
#import "Reachability.h"
#import "AppDelegate.h"


@interface StartScreen ()

@end

@implementation StartScreen

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[MySingleton sharedMySingleton] isFourRetina]) {
        NSLog( @"5 iphone");
        [bg_img setImage:[UIImage imageNamed:@"loading_ready-568h.png"]];
    } 
    else
    {
        [bg_img setImage:[UIImage imageNamed:@"loading_ready.png"]];
    }
    [[[MySingleton sharedMySingleton] getMainScreen].view setFrame:self.view.frame];        
}

-(IBAction)openMainWindow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [self.view addSubview:[[MySingleton sharedMySingleton] getMainScreen].view];
    [UIView commitAnimations];
    [[[MySingleton sharedMySingleton] getMainScreen] addMainPanel];
    [[[MySingleton sharedMySingleton] getMainScreen] addTopPanel];
}

#pragma mark AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] sendAction:SIGKILL to:[UIApplication sharedApplication] from:self forEvent:nil];
}

- (void)viewDidUnload {
    openMainWndBtn = nil;
    [super viewDidUnload];
}

@end















