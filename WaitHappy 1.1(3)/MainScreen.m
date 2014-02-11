//
//  MainScreen.m
//  WaitHappy
//
//  Created by gelgard on 25.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "MainScreen.h"
#import "MySingleton.h"


@interface MainScreen ()

@end

@implementation MainScreen 

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
    locationController = [[MyCLController alloc] init];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
    [[[MySingleton sharedMySingleton] getHomeController].view setCenter:[[MySingleton sharedMySingleton] getCentrePoint]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[MySingleton sharedMySingleton] isFourRetina])
    {
        NSLog( @"5 iphone");
        [bg_img setImage:[UIImage imageNamed:@"bg568.png"]];
    }
    [self.view addSubview:[[MySingleton sharedMySingleton] getNavController].view];
    [[[MySingleton sharedMySingleton] getNavController] pushViewController:[[MySingleton sharedMySingleton] getHomeController] animated:NO];
    [[MySingleton sharedMySingleton] setCurrentController:[[MySingleton sharedMySingleton] getHomeController]];
}


#pragma mark MyAction

-(void)addMainPanel
{
    [[[MySingleton sharedMySingleton] getMainPanel].view setFrame:CGRectMake(0, self.view.bounds.size.height-[[MySingleton sharedMySingleton] getMainPanel].view.bounds.size.height, 320, [[MySingleton sharedMySingleton] getMainPanel].view.bounds.size.height)];
    [self.view addSubview:[[MySingleton sharedMySingleton] getMainPanel].view];
}

-(void)addTopPanel
{    
    [[MySingleton sharedMySingleton] checkRegistered];
    [[[MySingleton sharedMySingleton] getTopPanel].view setFrame:CGRectMake(0, 0, 320, [[MySingleton sharedMySingleton] getTopPanel].view.bounds.size.height)];
    [self.view addSubview:[[MySingleton sharedMySingleton] getTopPanel].view];
}

#pragma mark Location

-(NSDictionary *)getCoordinates
{
    NSDictionary * resDict;
    
    if (kTested == 1) {
        resDict =[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"30.2577034",@"-97.7597931",nil] forKeys:[[NSArray alloc] initWithObjects:@"latitude",@"longitude",nil]];
    }
    else
    {
        resDict =[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",self.latitude],[NSString stringWithFormat:@"%f",self.longitude],nil] forKeys:[[NSArray alloc] initWithObjects:@"latitude",@"longitude",nil]];
        
    }
    return resDict;
}


- (void)locationUpdate:(CLLocation *)location {
	self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}

- (void)locationError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}
- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end