//
//  TopPanel.m
//  WaitHappy
//
//  Created by gelgard on 26.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "TopPanel.h"
#import "MySingleton.h"
#import "SettingsScreen.h"

@interface TopPanel ()

@end

@implementation TopPanel

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
    [registeredPanel setFrame:CGRectMake(self.view.bounds.size.width-registeredPanel.bounds.size.width, 0, registeredPanel.bounds.size.width, registeredPanel.bounds.size.height)];
    [nonRegisteredPanel setFrame:CGRectMake(self.view.bounds.size.width-nonRegisteredPanel.bounds.size.width, 0, nonRegisteredPanel.bounds.size.width, nonRegisteredPanel.bounds.size.height)];
    if ([[MySingleton sharedMySingleton] checkRegistered] )
    {
        [self.view addSubview:registeredPanel];
    } else
    {
        [self.view addSubview:nonRegisteredPanel];
    }
}


- (IBAction)settingPress:(id)sender
{
    SettingsScreen *settings = [[SettingsScreen alloc] init];
    [[MySingleton sharedMySingleton] popNewView:settings];
}

-(IBAction)openRegister:(id)sender
{
    
    if (![[MySingleton sharedMySingleton] getRegisterOpened]) {
        [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
        [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getRegisterController]];
        
    } else
    {
        /*[[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
        [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController].view direction:1 sourceView:[[MySingleton sharedMySingleton] getCurrentController].view];
        
        [[MySingleton sharedMySingleton] setCurrentController:[[MySingleton sharedMySingleton] getHomeController]];*/
    }
}


-(IBAction)openReactivate:(id)sender
{
    
     if (![[MySingleton sharedMySingleton] getReactiveteOpened])
     {
         [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
         [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getReactivateController]];
         
     }
     else
     {
       /*  [[[MySingleton sharedMySingleton] getCurrentController].view endEditing:YES];
         [[MySingleton sharedMySingleton] popNewView:[[MySingleton sharedMySingleton] getHomeController].view direction:1 sourceView:[[MySingleton sharedMySingleton] getCurrentController].view];
         
         [[MySingleton sharedMySingleton] setCurrentController:[[MySingleton sharedMySingleton] getHomeController]] ; */
     }
}

-(void)refreshPanels
{
    [registeredPanel removeFromSuperview];
    [nonRegisteredPanel removeFromSuperview];
    if ([[MySingleton sharedMySingleton] checkRegistered] )
    {
        [self.view addSubview:registeredPanel];
    } else
    {
        [self.view addSubview:nonRegisteredPanel];
    }
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
