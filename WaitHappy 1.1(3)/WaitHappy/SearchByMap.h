//
//  SearchByMap.h
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchByMap : UIViewController <MKMapViewDelegate>
{
    float visible_distance;
    BOOL firsShown;
    
    IBOutlet UIButton *backButton;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapSearch;

@property int maptype;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

-(void)getRestaurants:(NSString *)_distance;

-(void) addRestaurant:(float)_latitude longitude:(float)_longitude restName:(NSString *)_restName restLabel:(NSString *)_restLabel restId:(int)_restId;

-(IBAction)backBtn:(id)sender;
@end
