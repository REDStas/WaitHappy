//
//  SearchByMap.m
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchByMap.h"
#import "MySingleton.h"
#import "MyLocation.h"

@interface SearchByMap ()

@end

@implementation SearchByMap
@synthesize maptype;
@synthesize topLabel, detailLabel;
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
    [topLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    [super viewDidLoad];
    visible_distance = 5;
    [_mapSearch setDelegate:self];
    firsShown = YES;
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
    
    
    
    if (maptype==0) {
        
        [backButton setAlpha:0];
        UIViewController *searchPanel = [[MySingleton sharedMySingleton] getSearchPanel];
        [searchPanel.view setFrame:CGRectMake(0, 7, searchPanel.view.bounds.size.width, searchPanel.view.bounds.size.height)];
        
        [self.view addSubview:searchPanel.view];
        
        [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = [[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"] floatValue];
        zoomLocation.longitude= [[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"] floatValue];
        
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate =zoomLocation;
        annotationPoint.title = @"Position";
        
        
        [_mapSearch addAnnotation:annotationPoint];
        
        
        
        
        //[_mapSearch addAnnotation:pinView];
        
        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*visible_distance*kMetersInMiles, 0.5*visible_distance*kMetersInMiles);
        // 3
        MKCoordinateRegion adjustedRegion = [_mapSearch regionThatFits:viewRegion];
        // 4
        [_mapSearch setRegion:adjustedRegion animated:YES];
        
        [self getRestaurants:[NSString stringWithFormat:@"%f",visible_distance]];
    } else
    {
        [backButton setAlpha:1];
    }
    
    
    
    
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}



-(void) addRestaurant:(float)_latitude longitude:(float)_longitude restName:(NSString *)_restName restLabel:(NSString *)_restLabel restId:(int)_restId
{
    CLLocationCoordinate2D restaurantLoc;
    
    restaurantLoc.latitude = _latitude;
    restaurantLoc.longitude = _longitude;
    

    MyLocation *annotation = [[MyLocation alloc] initWithName:_restLabel address:_restLabel coordinate:restaurantLoc restarauntId:_restId] ;
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(restaurantLoc, 0.5*visible_distance*kMetersInMiles, 0.5*visible_distance*kMetersInMiles);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapSearch regionThatFits:viewRegion];
    // 4
    [_mapSearch setRegion:adjustedRegion animated:YES];

    
    [_mapSearch addAnnotation:annotation];
}

-(void)getRestaurants:(NSString *)_distance
{
    NSLog(@"DISTANCEOUR %@",_distance);
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"lat",@"lng",@"distance", nil];
    
    NSArray *values = [[NSArray alloc] initWithObjects:[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"] , [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"] ,_distance,nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    
    
    
    
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kRadiusSearch];
    
    
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:
                           dict, @"data", nil];
    
   // NSLog(@"-- %@",[params description]);
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kMainUrl]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kRadiusSearch parameters:params];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSLog(@"%@", JSON);
        
        for (NSDictionary * dict in JSON) {
                        
             CLLocationCoordinate2D restaurantLoc;
            
            restaurantLoc.latitude = [[[dict objectForKey:@"Business"] objectForKey:@"latitude"] floatValue];
            restaurantLoc.longitude = [[[dict objectForKey:@"Business"] objectForKey:@"longitude"] floatValue];
            
            
            NSString *restName = [[dict objectForKey:@"Business"] objectForKey:@"name"];
            NSString *restLabel = [[dict objectForKey:@"Business"] objectForKey:@"label"];
            int restId = [[[dict objectForKey:@"Business"] objectForKey:@"id"] intValue];
                          
         MyLocation *annotation = [[MyLocation alloc] initWithName:restName address:restLabel coordinate:restaurantLoc restarauntId:restId] ;
            
            [_mapSearch addAnnotation:annotation];
            
            NSLog(@"%@", [[dict objectForKey:@"Business"] objectForKey:@"latitude"]) ;
        }
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        firsShown = NO;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        firsShown = NO;
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
}

#pragma mark Map View delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!firsShown) {
    
        MKMapRect mapRect = _mapSearch.visibleMapRect;
        MKMapPoint cornerPointNW = MKMapPointMake(mapRect.origin.x, mapRect.origin.y );
        CLLocationCoordinate2D cornerCoordinate = MKCoordinateForMapPoint(cornerPointNW);
        CLLocation *left_corner = [[CLLocation alloc] initWithLatitude:cornerCoordinate.latitude longitude:cornerCoordinate.longitude];
        // Then get the center coordinate of the mapView (just a shortcut for convenience)
        CLLocationCoordinate2D centerCoordinate = _mapSearch.centerCoordinate;
        CLLocation *centr_point = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
        
        // And then calculate the distance
        CLLocationDistance dist = [left_corner distanceFromLocation:centr_point];
        NSLog(@"%f", dist );
        float dist_res;
        dist_res =2* (dist / kMetersInMiles);
        
        [self getRestaurants:[NSString stringWithFormat:@"%f",dist_res]];
        
   
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"sdfsdf");
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *kAnnotationReuseIdentifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationReuseIdentifier] ;
            annotationView.enabled = YES;
            
            
            annotationView.canShowCallout = YES;
            UIImage *pinImage = [UIImage imageNamed:@"map-pin.png"];
            /*
            UIImageView *imageView = [[UIImageView alloc] initWithImage:pinImage] ;
            
            imageView.frame = CGRectMake(-20, 0, 40, 30);
            
            [annotationView addSubview:imageView];
            */
            
            annotationView.image = pinImage;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //rightButton setTag:((MKMapPoint *)annotation).tag
            [rightButton setTag:((MyLocation *)annotation).rest_id];
            [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
       
        
        return annotationView;
    } else
    {
      MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationReuseIdentifier];
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}


-(void)writeSomething:(id)sender
{
    NSLog(@" clicked %i",((UIButton *)sender).tag);
    [[MySingleton sharedMySingleton] showRestaurantDetaile:[NSString stringWithFormat:@"%i",((UIButton *)sender).tag]];
    //[[MySingleton sharedMySingleton] backController];
}


- (void)viewDidUnload {
    [self setTopLabel:nil];
    [self setDetailLabel:nil];
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
