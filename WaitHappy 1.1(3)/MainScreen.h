//
//  MainScreen.h
//  WaitHappy
//
//  Created by gelgard on 25.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HomeController.h"
#import "RegisterController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyCLController.h"


@interface MainScreen : UIViewController <MyCLControllerDelegate>
{
    IBOutlet UIImageView *bg_img;
    MyCLController *locationController;
}


-(void)addMainPanel;
-(void)addTopPanel;

@property  double latitude;
@property  double longitude;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
-(NSDictionary *)getCoordinates;

@end
