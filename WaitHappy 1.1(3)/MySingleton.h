//
//  MySingleton.h
//  WaitHappy
//
//  Created by apple on 02.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "StartScreen.h"
#import "MainPanel.h"
#import "TopPanel.h"
#import "ReactivateController.h"
#import "ForgotPassController.h"
#import "SearchByName.h"
#import "SearchByDistance.h"
#import "SearchByMap.h"
#import "SearchByType.h"
#import "SearchPanel.h"
#import "RestaurantDetaile.h"
#import "DatabaseSingleton.h"
#import "SingleItemScreen.h"
#import "REDTableReady.h"
#import "AFNetworking.h"



@interface MySingleton : NSObject
{    
    NSManagedObjectContext *managedObjectContext;
    StartScreen *_startScreen;
    MainScreen *mainScreen;
    UINavigationController * nav;
    MainPanel * mainPanel;
    TopPanel *topPanel;
    NSUserDefaults *prefs;
    CGPoint *centrePoint;
    RegisterController *registerController;
    ReactivateController *reactivateController;
    ForgotPassController *forgotPassController;
    RestaurantDetaile *restaurantDetaile;
    HomeController *homeController;
    SearchByName *searchByName;
    SearchByDistance *searchByDistance;
    SearchByMap *searchByMap;
    SearchByType *searchByType;
    SearchPanel *searchPanel;
    UIViewController *currentController;
    UIViewController *prevController;
    NSString *token;
    BOOL registerOpened;
    BOOL reactivateOpened;
    UIView *_blockerView;
    int currentSearchControllerIndex;
    NSArray *receivedWLArr;
    NSArray *receivedMessArr;
    NSMutableDictionary *pushDescriptions;
    SingleItemScreen *screen;
    
    __block NSString *subjectOfMessage;
    __block NSString *textOfMessage;
    __block NSString *bussinesOfMessage;

}

+(MySingleton*)sharedMySingleton;

-(void) setContext:(NSManagedObjectContext *)_context;
-(NSManagedObjectContext *)getContext;

-(void)setCurrentController:(UIViewController *)sourceController;
-(StartScreen *)getStartScreen;
-(MainScreen *)getMainScreen;
-(HomeController *)getHomeController;
-(void)push:(UIViewController *)targetView;
-(UIViewController *)getCurrentController;
-(RegisterController *)getRegisterController;
-(ReactivateController *)getReactivateController;
-(ForgotPassController *)getForgotPassController;
-(MainPanel *)getMainPanel;
-(TopPanel *)getTopPanel;
-(void)setToken:(NSString *)_token;
-(NSString *)getToken;
//
-(void)setRegistered;
-(BOOL)checkRegistered;
-(CGPoint)getCentrePoint;
-(BOOL)isFourRetina; //определяет 5ли айфон
-(void)unsetNavContrFramePicker;
-(NSString *)getStringForPostQuery:(NSDictionary *)params;
-(void)popNewView:(UIViewController *)targetView;
-(BOOL)getRegisterOpened;
-(BOOL)getReactiveteOpened;
-(void)setNavContrFramePicker;
-(void)moveCurrentView:(int)delta;
-(UIView *)getBlockerView;
-(UINavigationController *)getNavController;
-(UIViewController *)getCurrentSearchController;
-(UIViewController *)getSearchPanel;
-(int)getCurrentSearchIndex;
-(void)setCurrentSearchIndex:(int)_curIndex;
-(void)backController;
-(void)showSpecialScreen:(NSString *)restaurantId;
-(void)showRestaurantDetaile:(NSString *)restaurantId;
-(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(BOOL)delegate cancelTitle:(NSString*)cancelTitle otherTitle:(NSString*)otherTitle;
-(void)setHiddenMainPanel;
-(void)unsetHiddenMainPanel;
-(void)setHiddenTopPanel;
-(void)unsetHiddenTopPanel;
-(void)setPush:(NSDictionary*)info isOutPush:(BOOL)isOutPush;
//-(void)getWaitListAndMessageListAtStartApp;
-(void)noInternetConnection;
//-(void)getMessageList;

-(void)removeBusinessFromWaitList:(NSString*)businessID;


@end