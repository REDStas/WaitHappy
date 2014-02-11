//
//  MySingleton.m
//  WaitHappy
//
//  Created by apple on 02.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MySingleton.h"
#import "Constants.h"
#import "WaitListsScreen.h"
#import "SingleItemScreen.h"
#import "PartyDetails.h"
#import "FavoritesScreen.h"
#import "InboxScreenSingle.h"
#import "InboxScreen.h"
#import "AccountSettings.h"
#import "WaitList.h"
#import "TableReadyScreen.h"
#import "InstructionScreen.h"
#import "InboxQuestScreen.h"
#import "REDHaveAQuestion.h"
#import "REDFeedBack.h"
#import "REDSurvayEmail.h"

@implementation MySingleton

static MySingleton* _sharedMySingleton = nil;

+(MySingleton*)sharedMySingleton
{
	@synchronized([MySingleton class])
	{
		if (!_sharedMySingleton)
			_sharedMySingleton = [[MySingleton alloc]init];        
		return _sharedMySingleton;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([MySingleton class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
     	// initialize stuff here
        _startScreen = [[StartScreen alloc] init];
        mainPanel = [[MainPanel alloc] init];
        topPanel = [[TopPanel alloc] init];
        prefs = [NSUserDefaults standardUserDefaults];
        if ([prefs integerForKey:@"registered"] != 1)
        {
            [prefs setInteger:0 forKey:@"registered"];
        }
        registerController = [[RegisterController alloc] init];
        reactivateController = [[ReactivateController alloc] init];
        forgotPassController = [[ForgotPassController alloc] init];
        restaurantDetaile = [[RestaurantDetaile alloc] init];
        mainScreen = [[MainScreen alloc] init];
        homeController = [[HomeController alloc] init];
        nav = [[UINavigationController alloc] init];
        [nav setNavigationBarHidden:YES];
        registerOpened = NO;
        reactivateOpened = NO;
        _blockerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)] ;
        _blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.6];
        _blockerView.alpha = 1.0;
        UILabel	*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, _blockerView.bounds.size.width, 20)];
        label.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2+30);
        label.text = NSLocalizedString(@"sending_msg", nil);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize: 15];
        [_blockerView addSubview: label];
        UIActivityIndicatorView	*spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2+10);
        [_blockerView addSubview: spinner];
        [spinner startAnimating];
        [nav.view setFrame:CGRectMake(0, topPanel.view.bounds.size.height,10+ [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-topPanel.view.bounds.size.height-mainPanel.view.bounds.size.height )];
        currentSearchControllerIndex = kcurrentSearchByName;
        searchPanel = [[SearchPanel alloc] init];
        prevController = nil;
        receivedWLArr = [[NSArray alloc] init];
        receivedMessArr = [[NSArray alloc] init];
        pushDescriptions = [[NSMutableDictionary alloc] init];
	}
	return self;
}


-(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(BOOL)delegate cancelTitle:(NSString*)cancelTitle otherTitle:(NSString*)otherTitle
{
    id del;
    
    if (delegate)
        del = self;
    else
        del = nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:del cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    [alert show];
}


-(BOOL)getRegisterOpened
{
    return registerOpened;
}


-(BOOL)getReactiveteOpened
{
   return reactivateOpened;
}

-(void) setContext:(NSManagedObjectContext *)_context
{
    managedObjectContext = _context;
}

-(NSManagedObjectContext *)getContext
{
    return managedObjectContext;
}


-(StartScreen *)getStartScreen
{
    return _startScreen;
}


-(MainScreen *)getMainScreen
{
    return mainScreen;
}


-(HomeController *)getHomeController
{
    return homeController;
}

-(void)setCurrentController:(UIViewController *)sourceController
{
    currentController = sourceController;
}

-(UIViewController *)getCurrentController
{
    return currentController;
}

-(RegisterController *)getRegisterController
{
    
    return registerController;
}

-(ReactivateController *)getReactivateController
{
    return reactivateController;
}

-(ForgotPassController *)getForgotPassController
{
    return forgotPassController;
}

-(MainPanel *)getMainPanel
{
    return mainPanel;
}

-(TopPanel *)getTopPanel
{
    return topPanel;
}


-(BOOL)isFourRetina //определяет 5ли айфон
{
    return [[UIScreen mainScreen] bounds].size.height == 568;
}

-(void)setToken:(NSString *)_token
{
    token = [NSString stringWithFormat:@"%@",_token];
}
-(NSString *)getToken
{
    if (kDeviceToken == 0) {
       return @"test_id_2";
    }
    else
    {
        return [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
 //   return @"D6C9EB1355AAC4816AAD635CE5901AF05EFE80BFAD4BE91C7B2FD86C7EBF10BE";
}

-(NSString *)getStringForPostQuery:(NSDictionary *)params  //определяем строку для запроса
{
    NSString *res;
    res = [NSString stringWithFormat:@"%@",@"{"];
    int count;
    count = 0;
    for (NSString * key in params)
    {
        if (count >0)
        {
            res = [res stringByAppendingFormat:@"%@",@","];
        }
        res = [res stringByAppendingFormat:@"%@:\"%@\"",key,[params objectForKey:key]];
        count++;
    }
    res = [res stringByAppendingFormat:@"%@",@"}"];
    return  res;
}

-(void)setRegistered
{
    [prefs setInteger:1 forKey:@"registered"];
    [topPanel refreshPanels];
}

-(BOOL)checkRegistered
{
    return [prefs integerForKey:@"registered"] == 1;
}

-(CGPoint)getCentrePoint
{
    CGPoint resPoint;
    resPoint = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, ([[UIScreen mainScreen] bounds].size.height - topPanel.view.bounds.size.height-mainPanel.view.bounds.size.height)/2+topPanel.view.bounds.size.height-5);
    return resPoint;
}

-(void)backController
{
    UIViewController *temp;
    temp = currentController;
    
    NSLog(@"curr class %@", [currentController class]);
    NSLog(@"prev class %@", [prevController class]);
    
//    if ([currentController isKindOfClass:[InstructionScreen class]]) // переставляем контроллеры
//    {
//        UINavigationController *navigation =  [[MySingleton sharedMySingleton] getNavController];
//        NSMutableArray *contrlollers = [[NSMutableArray alloc] initWithArray:navigation.viewControllers];
//        [contrlollers removeObjectAtIndex:[contrlollers count] - 2];
//        InstructionScreen *instr = [contrlollers objectAtIndex:[contrlollers count] - 1];
//        [contrlollers removeObjectAtIndex:[contrlollers count] - 1];
//        WaitListsScreen *wls = [[WaitListsScreen alloc] init];
//        [contrlollers addObject:wls];
//        [contrlollers addObject:instr];
//        [navigation setViewControllers:[[NSArray alloc] initWithArray:contrlollers]];
//    }
//    
    
    
    
    
    if ([prevController isKindOfClass:[searchByMap class]])
    {
        [nav.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-mainPanel.view.bounds.size.height )];
        [topPanel.view setAlpha:0];
    } else
    {
        [nav.view setFrame:CGRectMake(0, topPanel.view.bounds.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-topPanel.view.bounds.size.height-mainPanel.view.bounds.size.height )];
        [topPanel.view setAlpha:1];
    }
    [nav popViewControllerAnimated:YES];
    [self setCurrentController:[[nav viewControllers] objectAtIndex:[[nav viewControllers] count]-1]];
    prevController = temp;
    if ([currentController isKindOfClass:[SearchByName class]]) {
        [[MySingleton sharedMySingleton] setCurrentSearchIndex:kcurrentSearchByName];
        [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    }
    if ([currentController isKindOfClass:[SearchByType class]]) {
        [[MySingleton sharedMySingleton] setCurrentSearchIndex:kcurrentSearchBytype];
        [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    }
    if ([currentController isKindOfClass:[SearchByDistance class]]) {
        [[MySingleton sharedMySingleton] setCurrentSearchIndex:kcurrentSearchByDistance];
        [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    }
    if ([currentController isKindOfClass:[SearchByMap class]]) {
        [[MySingleton sharedMySingleton] setCurrentSearchIndex:kcurrentSearchByMap];
        [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    }
    [self updateMainPanelSelected];
}

-(void)updateMainPanelSelected
{
    int sel_ind;
    sel_ind=-1;
    if ([currentController isKindOfClass:[HomeController class]]) {
        sel_ind = 0;
    }
    NSLog(@"class of controller  %@",[[[MySingleton sharedMySingleton] getCurrentController] class]);
    
  if ([[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByName class]] || [[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByDistance class]] || [[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByMap class]]  || [[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[SearchByType class]] || [[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[PartyDetails class]] || [[[MySingleton sharedMySingleton] getCurrentController] isKindOfClass:[RestaurantDetaile class]])
    {
        sel_ind = 4;
    }
    
    if([[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[WaitListsScreen class]] || [[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[TableReadyScreen class]] || [[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[SingleItemScreen class]])
    {
        sel_ind = 3;
    }
    
    if ([[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[InboxScreenSingle class]] || [[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[InboxScreen class]])
    {
        sel_ind = 2;
    }

    if ([[[MySingleton sharedMySingleton] getCurrentController] isMemberOfClass:[FavoritesScreen class]])
    {
        sel_ind = 1;
    }
    
    mainPanel.selController = sel_ind;
    [mainPanel setSelected];
}

-(void)showRestaurantDetaile:(NSString *)restaurantId
{
    restaurantDetaile.restaurantId = [NSString stringWithFormat:@"%@",restaurantId];
    NSLog(@"restID = %@",restaurantId);
    [self popNewView:restaurantDetaile];
}


-(void)showSpecialScreen:(NSString *)restaurantId
{
   
}

-(void)push:(UIViewController *)targetView
{
    [nav.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 10+[[UIScreen mainScreen] bounds].size.height-mainPanel.view.bounds.size.height )];
    [topPanel.view setAlpha:0];
    prevController = currentController;
    [nav pushViewController:targetView animated:YES];
}

-(void)popNewView:(UIViewController *)targetView
{
    // удаляем бизнес если прешли c экрана table Ready
//    
//    if ([currentController isKindOfClass:[TableReadyScreen class]] && [(TableReadyScreen*)currentController isRemovedWL])
//    {
//        [(TableReadyScreen*)currentController removeBusinessFromWaitList:targetView];
//        return;
//    }
    
    if ([targetView isKindOfClass:[SearchByMap class]] || [targetView isKindOfClass:[AccountSettings class]])
    {
        [nav.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 10+[[UIScreen mainScreen] bounds].size.height-mainPanel.view.bounds.size.height )];
        [topPanel.view setAlpha:0];
    }
    else if ([targetView isKindOfClass:[InstructionScreen class]])
    {
        [nav.view setFrame:CGRectMake(0, topPanel.view.bounds.size.height, [[UIScreen mainScreen] bounds].size.width, 640)];
        NSLog(@"mainScreen %f - %f - ", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    else
    {
        [nav.view setFrame:CGRectMake(0, topPanel.view.bounds.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-topPanel.view.bounds.size.height-mainPanel.view.bounds.size.height )];
        [topPanel.view setAlpha:1];
    }
    prevController = currentController;
    [self setCurrentController:targetView];
    [targetView.view endEditing:YES];
  
    if (targetView == [[MySingleton sharedMySingleton] getRegisterController])
    {
        registerOpened = YES;
    }
    else
    {
        registerOpened = NO;
    }
    
    if (targetView == [[MySingleton sharedMySingleton] getReactivateController])
    {
        reactivateOpened = YES;
    }
    else
    {
        reactivateOpened = NO;
    }
    
    NSLog(@"class of target  %@",[targetView class]);
    NSLog(@"navcontrollers arr %@",[nav.viewControllers description]);
    
    for (UIViewController *contrl in nav.viewControllers) {
        if ([contrl isKindOfClass:[targetView class]])
        {
            if ([targetView isKindOfClass:[InboxScreen class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"load_data_inbox_observer" object:nil];
            }
            
            if ([targetView isKindOfClass:[WaitListsScreen class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"load_data_waitlist_observer" object:nil];
            }
            [nav popToViewController:contrl animated:YES];
            [self updateMainPanelSelected];
            return;
        }
    }
    
    [targetView.view setFrame:nav.view.frame];
    NSLog(@"targetView %f - %f - ", targetView.view.frame.size.width, targetView.view.frame.size.height);

    if (nav)
        NSLog(@"nav controller exist");
    else
        NSLog(@"nav controller not exist");
    NSLog(@"Views in hierarchy: %d",[nav.viewControllers count]);
    NSLog(@"class of targetController  %@", [targetView class]);
    NSLog(@"count of nav %d",[nav.viewControllers count]);
    [nav pushViewController:targetView animated:YES];
   [self updateMainPanelSelected];
}

-(void)setNavContrFramePicker
{
    [nav.view setFrame:CGRectMake(nav.view.frame.origin.x, nav.view.frame.origin.y, nav.view.frame.size.width, nav.view.frame.size.height + 69)];
}

-(void)unsetNavContrFramePicker
{
    [nav.view setFrame:CGRectMake(nav.view.frame.origin.x, nav.view.frame.origin.y, nav.view.frame.size.width, nav.view.frame.size.height - 69)];
}

-(void)moveCurrentView:(int)delta
{
    NSLog(@"y = %f",currentController.view.frame.origin.y);
   
    [[[currentController parentViewController] view] setFrame:CGRectMake([currentController parentViewController].view.frame.origin.x, [currentController parentViewController].view.frame.origin.y+delta, [currentController parentViewController].view.frame.size.width, [currentController parentViewController].view.frame.size.height)];
    
    if ([topPanel view].hidden == NO)
        [topPanel.view setHidden:YES];
    else
        [topPanel.view setHidden:NO];
}

-(UIView *)getBlockerView
{
    return _blockerView;
}

-(UINavigationController *)getNavController
{
    return nav;
}

-(UIViewController *)getCurrentSearchController
{
    UIViewController *res;
    res = nil;
    switch (currentSearchControllerIndex) {
        case kcurrentSearchByName:
        {
            if (!searchByName) {
                searchByName = [[SearchByName alloc] init];
            }
             res = searchByName;
        }
            break;
        case kcurrentSearchByDistance:
        {
            if (!searchByDistance) {
                searchByDistance = [[SearchByDistance alloc] init];
            }
            res = searchByDistance;
            searchByDistance.subtype_id = @"";
        }
            break;
        case kcurrentSearchByMap:
        {
            if (!searchByMap) {
                searchByMap = [[SearchByMap alloc] init];
                searchByMap.maptype = 0;
            }
            res = searchByMap;
        }
            break;
        case kcurrentSearchBytype:
        {
            if (!searchByType) {
                searchByType = [[SearchByType alloc] init];
            }
            res = searchByType;
        }
            break;
            
        default:
            break;
    }
    
    [res.view setFrame:nav.view.frame];
    return res;
}

-(UIViewController *)getSearchPanel
{
    return searchPanel;
}

-(int)getCurrentSearchIndex
{
    return currentSearchControllerIndex;
}

-(void)setCurrentSearchIndex:(int)_curIndex
{
    currentSearchControllerIndex = _curIndex;
}

-(void)setHiddenMainPanel
{
    [mainPanel.view setHidden:YES];
}

-(void)unsetHiddenMainPanel
{
    [mainPanel.view setHidden:NO];
}

-(void)setHiddenTopPanel
{
    [topPanel.view setHidden:YES];
}

-(void)unsetHiddenTopPanel
{
    [topPanel.view setHidden:NO];
}

-(void)setPush:(NSDictionary*)info isOutPush:(BOOL)isOutPush
{
    int type;
    
    
    NSLog(@"push description %@",[info description]);
    NSString *tp = [info objectForKey:@"type"];
    NSLog(@"type %@",tp);
    __block UIAlertView *alert;
    __block BOOL isOutPushLocal = isOutPush;
    NSLog(@"isOutPushLocal %i", isOutPushLocal);
    
//    UIAlertView *alert = [[UIAlertView alloc]init];
//    [alert setMessage:nil];
//    [alert setDelegate:self];
//    
//    
    
    
    if ([tp isEqualToString:@"waitlistAccept"]) {
        type = 2;  // подтверждаем WaitList
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have been added to the wait list" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        NSString *messageText = [NSString stringWithFormat:@"Hooray! %@ Please check in with a host at least 10-15 minutes early.", [[info objectForKey:@"aps"] objectForKey:@"alert"]];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:messageText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    
    
    if ([tp isEqualToString:@"comment_card"]) {
        //type = 3;  // вопрос
        type = 5;
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"Comment card" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        NSString *bussinesName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
        NSString *messageText = [NSString stringWithFormat:@"You're awesome and the manager of %@ wants your feedback!", bussinesName];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:messageText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    
    if ([tp isEqualToString:@"table_is_ready"]) {
        type = 4;  // Table Ready
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your table is ready" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
   
    if ([tp isEqualToString:@"seated"])
    {
        type = 5;  // seated
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"User is seated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:@"User is seated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    
    if ([tp isEqualToString:@"we_have_a_question"]) 
    //if ([tp isEqualToString:@"comment_card"])
    {
        type = 6;  // question
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"We have a question" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    
    if ([tp isEqualToString:@"survey_email"])
    {
        type = 7;  // survey email
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"Survey email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        __block NSString *bussinesName = @"";
        NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", @"id", nil];
        NSArray *values = [[NSArray alloc] initWithObjects:[[MySingleton sharedMySingleton] getToken], [info objectForKey:@"id"], nil];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        
        NSString *cur_url;
        cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetMessage];
        NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
        NSLog(@"-- %@",[params description]);
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetMessage parameters:params];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"zz - %@", JSON);
            bussinesOfMessage = [JSON objectForKey:@"business_name"];
            subjectOfMessage = [JSON objectForKey:@"subject"];
            textOfMessage = [JSON objectForKey:@"message"];
            /*
            if ([JSON objectForKey:@"success"])
            {
                [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDB:businessNameLbl.text];
                [[MySingleton sharedMySingleton] backController];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
             */
            //[[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
            alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:[NSString stringWithFormat:@"You've received a message from %@.", bussinesOfMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            alert.tag = type;
            if (isOutPushLocal) {
                [self getPushFurther:alert.tag];
            }
            else
            {
                [alert show];
            }

        }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {

            NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
            NSLog(@"xx - %@", JSON);
            //  [resultTable setAlpha:0];
            
            //[[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        }];
        [operation start];
        
        //alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Note From %@", bussinesName] message:@"Survey email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
    }
    
    if ([tp isEqualToString:@"set_onsite"])
    {
        //NSString *businesName = @"";
        NSDictionary *params2 =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", [info objectForKey:@"business_id"]], @"id", nil];
        NSLog(@"%@", [info objectForKey:@"business_id"]);
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessInfo parameters:params2];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"%@", JSON);
            //feedBack.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
            
            //[self popNewView:feedBack];
        }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
         {
             NSLog(@"%@", error);
         }];
        [operation start];
        type = 8;  // посажен
        //alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have been set on site" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        NSString *bussinesName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:[NSString stringWithFormat:@"Thanks for checking in! Your party has been confirmed on-site at %@.", bussinesName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    
    if ([tp isEqualToString:@"guest_notification"]) // обычный пушш без типа (просто выводим алерт)
    {
        type = 88;  // посажен
        alert = [[UIAlertView alloc] initWithTitle:[info objectForKey:@"title"] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
    }
    
    if (type != 0) {
        alert.tag = type;
        NSString *typeStr = [NSString stringWithFormat:@"%d",type];
        [pushDescriptions setObject:info forKey: typeStr];
        
        if (isOutPushLocal) {
            [self getPushFurther:alert.tag];
        }
        else
        {
            [alert show];
        }
    }
}

-(void)getPushFurther:(int)type
{    
    NSLog(@"type %d",type);
    NSString *typeStr = [NSString stringWithFormat:@"%d",type];
    NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[pushDescriptions objectForKey:[NSString stringWithFormat:@"%d",type]]];
    NSLog(@"pushDescriptions %@", [pushDescriptions description]);
    NSLog(@"info %@", [info description]);
    [pushDescriptions removeObjectForKey:[NSString stringWithFormat:@"%d",type]];
  
    switch (type) {
        case 1: // сохраняем сообщение в БД
        {
            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:[[info objectForKey:@"aps"] objectForKey:@"id"] title:[[info objectForKey:@"aps"] objectForKey:@"title"] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] date:[[info objectForKey:@"aps"] objectForKey:@"date"] type:[[info objectForKey:@"aps"] objectForKey:@"type"] businessID:nil token:nil];
        
        InboxScreen *inbox = [[InboxScreen alloc]init];
        [self popNewView:inbox];
        }
            break;
        case 2: // подтверждаем waitlist
        {
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
         // [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:nil message:nil date:nil type:[[info objectForKey:@"aps"] objectForKey:@"type"] businessID:[[info objectForKey:@"aps"] objectForKey:@"businessID"]];
        
            //**[[DatabaseSingleton sharedDBSingleton] setNoPending:[info objectForKey:@"business_id"]];
            NSLog(@"setnopend");
            // ==========
            UINavigationController *navigation =  [[MySingleton sharedMySingleton] getNavController];
            NSMutableArray *contrlollers = [[NSMutableArray alloc] initWithArray:navigation.viewControllers];
      //      [contrlollers removeObjectAtIndex:[contrlollers count] - 1];
            [contrlollers removeAllObjects];
        
            WaitListsScreen *wals = [[WaitListsScreen alloc] init];
            [contrlollers addObject:homeController];
            [contrlollers addObject:wals];
        
            [navigation setViewControllers:[[NSArray alloc] initWithArray:contrlollers]];
            // ==========
        
            NSString *bussID = [info objectForKey:@"business_id"];
            [self unsetHiddenMainPanel];
        
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            [pr setObject:@"0" forKey:@"IsInstructScreen"];
            [pr synchronize];
            
            NSLog(@"IsInstructScreen = %@", [pr objectForKey:@"IsInstructScreen"]);
        
            SingleItemScreen *wls = [[SingleItemScreen alloc] init];
            wls.restaurantId = bussID;
            wls.waitListLabel.text = [[DatabaseSingleton sharedDBSingleton] getLabelFromWaitListWithBussID:bussID];
            wls.businessNameLbl.text = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:bussID];
            [self popNewView:wls];
            [wls doSomething];
            
            
//        InstructionScreen *instr = [contrlollers objectAtIndex:[contrlollers count] - 1];
//        [contrlollers removeObjectAtIndex:[contrlollers count] - 1];
//        WaitListsScreen *wals = [[WaitListsScreen alloc] init];
//        [contrlollers addObject:wals];
//        [contrlollers addObject:instr];
        // ==========
        
        
//        if ([currentController isKindOfClass:[InstructionScreen class]]) // переставляем контроллеры
            //    {
            //        UINavigationController *navigation =  [[MySingleton sharedMySingleton] getNavController];
            //        NSMutableArray *contrlollers = [[NSMutableArray alloc] initWithArray:navigation.viewControllers];
            //        [contrlollers removeObjectAtIndex:[contrlollers count] - 2];
            //        InstructionScreen *instr = [contrlollers objectAtIndex:[contrlollers count] - 1];
            //        [contrlollers removeObjectAtIndex:[contrlollers count] - 1];
            //        WaitListsScreen *wls = [[WaitListsScreen alloc] init];
            //        [contrlollers addObject:wls];
            //        [contrlollers addObject:instr];
            //        [navigation setViewControllers:[[NSArray alloc] initWithArray:contrlollers]];
            //    }

        
            return;
        
        }
            break;
        case 3:// оставить отзыв
        {
        
       // NSLog(@"bussID %@",[[info objectForKey:@"aps"]  objectForKey:@"business_id"]);
       // NSLog(@"token %@",[[info objectForKey:@"aps"]  objectForKey: @"token"]);
            //[[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:nil message:nil date:nil type:[[info objectForKey:@"aps"] objectForKey:@"type"] businessID:[[info objectForKey:@"aps"] objectForKey:@"business_id"]];
        //    [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:nil message:nil date:nil type:typeStr businessID:[[info objectForKey:@"aps"] objectForKey:@"business_id"] token:[[info objectForKey:@"aps"]objectForKey:@"token"]];
        // удаление бзнеса на сервере
//        [[MySingleton sharedMySingleton] removeBusinessFromWaitList:[info objectForKey:@"business_id"]];
         //   [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:[[info objectForKey:@"aps"] objectForKey:@"businessID"]];
        
        
        if ([[DatabaseSingleton sharedDBSingleton] isInWaitWaitList:[info objectForKey:@"business_id"]]){
            // === сохр
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            NSString *testName = [pr objectForKey:[NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"5"]];
            NSString *bussIDstrAndType = [NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"3"]; // save name
            if ([testName isEqual: [NSNull null]]) {
            NSLog(@"bussID %@", [info objectForKey:@"business_id"]);
            NSString *name = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
            [pr setObject:name forKey:bussIDstrAndType];
         //==
                [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:[info objectForKey:@"business_id"]];
                
            }
            else{
                [pr setObject:testName forKey:bussIDstrAndType];
            }
            [pr synchronize];

            // ===============
            NSLog(@"rtpeStr %@", typeStr);
            NSLog(@"bussID %@ and type %@", [info objectForKey:@"business_id"], @"3");
            
            // ========
            
            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]] message:nil date:nil type:typeStr businessID:[info objectForKey:@"business_id"] token:[info objectForKey:@"token"]];
            
            InboxScreen *inbox = [[InboxScreen alloc]init];
            [self popNewView:inbox];
            
            
          }
        else{
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            NSString *testName = [pr objectForKey:[NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"3"]];
            NSString *bussIDstrAndType = [NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"5"]; // save name
            if (testName) {
                [pr setObject:testName forKey:bussIDstrAndType];
                [pr synchronize];
                InboxScreen *inbox = [[InboxScreen alloc]init];
                [self popNewView:inbox];
            }
            else{
     //           [self getBusinessInfo:[info objectForKey:@"business_id"] andType:@"3"];
                [self getBusinessInfo:[info objectForKey:@"business_id"] andType:@"3" andToken:[info objectForKey:@"token"]];
            }
        }
        
        
        }
            break;
        case 4:// table is ready 
        {
            NSLog(@"get mess %@", [[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"4"]);
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"4"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"4"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"1"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"1"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"8"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"8"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"6"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
            
            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:[info objectForKey:@"business_name"] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] date:nil type:typeStr businessID:[info objectForKey:@"business_id"] token:nil];
            //[[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:[info objectForKey:@"business_name"] message:nil date:nil type:[info objectForKey:@"type"] businessID:[info ojectForKey:@"business_id"]];
            //[[DatabaseSingleton sharedDBSingleton] setTableReadyinWaitListWithBusinessID:[info objectForKey:@"business_id"]];
//            WaitListsScreen *wls = [[WaitListsScreen alloc] init];
//            [self popNewView:wls];
            [self unsetHiddenMainPanel];
            REDTableReady *tableReady = [[REDTableReady alloc] init];
            
            NSLog(@"table is ready push unfo %@", [info objectForKey:@"business_name"]);
            NSLog(@"table is ready push unfo %@", info);
            [self popNewView:tableReady];
            NSString *upperBisinessName = [[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]] uppercaseString];
            [tableReady.lowerLabel setText:upperBisinessName];
            
            NSString *businessCellPhone = @"";
            NSString *alert = [[info objectForKey:@"aps"] objectForKey:@"alert"];
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}" options:0 error:nil];
            NSArray *number = [regular matchesInString:alert options:0 range:NSMakeRange(0, [alert length])];
            if ([number count] > 0) {
                NSTextCheckingResult *checkingResult = [number objectAtIndex:0];
                
                NSRange matchRange = [checkingResult rangeAtIndex:0];
                businessCellPhone = [alert substringWithRange:matchRange];
            }
            
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [tableReady setCellPhoneNumber:businessCellPhone];
            
            return;
        }
            break;
  
        case 5:// seated push
        {
//            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:nil message:nil date:nil type:[[info objectForKey:@"aps"] objectForKey:@"type"] businessID:[[info objectForKey:@"aps"] objectForKey:@"businessID"]];
        
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"4"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"4"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"1"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"1"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"6"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"8"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"8"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
        NSLog(@"rtpeStr %@", typeStr);
        
            NSLog(@"seat info %@", info);
        //if ([[DatabaseSingleton sharedDBSingleton] isInWaitWaitList:[info objectForKey:@"business_id"]])
        //{
            NSLog(@"bussID %@ and type %@", [info objectForKey:@"business_id"], @"5");
            
            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]] message:@"User has been seated" date:nil type:typeStr businessID:[info objectForKey:@"business_id"] token:[info objectForKey:@"token"]];
            NSLog(@"bussID %@", [info objectForKey:@""]);
            
            // === сохр
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            NSString *testName = [pr objectForKey:[NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"], @"3"]];
            NSString *bussIDstrAndType = [NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"], @"5"]; // save name
            if ([testName isEqual: [NSNull null]]) {
                NSLog(@"bussID %@", [info objectForKey:@"business_id"]);
                NSString *name = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
                [pr setObject:name forKey:bussIDstrAndType];
                [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:[info objectForKey:@"business_id"]];
            }
            else{
                [pr setObject:testName forKey:bussIDstrAndType];
            }
            [pr synchronize];
            
            // ===============
//            InboxScreen *inbox = [[InboxScreen alloc]init];
//            [self popNewView:inbox];
            REDFeedBack *feedBack = [[REDFeedBack alloc] init];
            NSLog(@"token 1 - %@", [info objectForKey:@"token"]);
            feedBack.businessLink = [info objectForKey:@"token"];
            
            NSDictionary *params2 =[NSDictionary dictionaryWithObjectsAndKeys: [info objectForKey:@"business_id"], @"id", nil];
            AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
            NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessInfo parameters:params2];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"%@", JSON);
                feedBack.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
                
                [self popNewView:feedBack];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                 
            }];
            [operation start]; // вот 
            
            feedBack.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
            
            [self popNewView:feedBack];
        }
//        else{
//            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
//            NSString *testName = [pr objectForKey:[NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"3"]];
//            NSString *bussIDstrAndType = [NSString stringWithFormat:@"bussID%@andType%@",[info objectForKey:@"business_id"],@"5"]; // save name
//            
//            NSLog(@"testName %@", testName);
//            
//            
//            
//            
//            if (testName) {
//                [pr setObject:testName forKey:bussIDstrAndType];
//                [pr synchronize];
//                
//                InboxScreen *inbox = [[InboxScreen alloc]init];
//                [self popNewView:inbox];
//                
//            }
//            else{
//                [self getBusinessInfo:[info objectForKey:@"business_id"] andType:@"5" andToken:nil];
//            }
//        }
        
      
        
//        }
            break;
            
        case 6: // we have a question 
        {
            NSLog(@"get mess %@", [[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"]);
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"6"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"1"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"1"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"4"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"4"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
            
            //NSString *businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];
            NSString *businessCellPhone = @"";
            NSString *alert = [[info objectForKey:@"aps"] objectForKey:@"alert"];
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}" options:0 error:nil];
            NSArray *number = [regular matchesInString:alert options:0 range:NSMakeRange(0, [alert length])];
            if ([number count] > 0) {
               NSTextCheckingResult *checkingResult = [number objectAtIndex:0];
                
                NSRange matchRange = [checkingResult rangeAtIndex:0];
                businessCellPhone = [alert substringWithRange:matchRange];
            }
            
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            businessCellPhone= [businessCellPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSLog(@"%@", businessCellPhone);
            [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:@"We have a question" message:[[info objectForKey:@"aps"] objectForKey:@"alert"] date:nil type:typeStr businessID:[info objectForKey:@"business_id"] token:nil];
            
            //InboxScreen *imbox = [[InboxScreen alloc] init];
            //imbox.message = [[info objectForKey:@"aps"] objectForKey:@"alert"];
//            [self popNewView:imbox];
            
            REDHaveAQuestion *haveAQuetion = [[REDHaveAQuestion alloc] init];
            haveAQuetion.businessName = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]];;
            haveAQuetion.businessCellPhone = businessCellPhone;
            haveAQuetion.messageText = [[info objectForKey:@"aps"] objectForKey:@"alert"];
            [self popNewView:haveAQuetion];
            

            return;
        }
            
        case 7: // survey email
        {
        
            NSLog(@"get mess %@", [[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"]);
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"6"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"1"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"1"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"4"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"4"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"7"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"7"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"8"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"8"];
            }
        NSLog(@"id %@", [info description]);
            
            
            NSString *subjectAndTextMessage = [NSString stringWithFormat:@"%@--separator--%@--separator--%@", subjectOfMessage, textOfMessage, bussinesOfMessage];
                [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:[info objectForKey:@"id"] title:[info objectForKey:@"title"] message:subjectAndTextMessage  date:nil type:typeStr businessID:nil token:nil];
                REDSurvayEmail *surveyEmailView = [[REDSurvayEmail alloc] init];
            //[surveyEmailView setMy]
                surveyEmailView.title = [info objectForKey:@"title"];
                [surveyEmailView setMessageText:subjectAndTextMessage];
                [[MySingleton sharedMySingleton] popNewView:surveyEmailView];
                 //  [resultTable setAlpha:0];
                 
                 //[[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
                
            
            
//        InboxScreen *inbox = [[InboxScreen alloc]init];
//        [self popNewView:inbox];
//        WaitListsScreen *waitScreen = [[WaitListsScreen alloc] init];
//        [self popNewView:waitScreen];
//        screen = [[SingleItemScreen alloc] init];
//        screen.restaurantId = [info objectForKey:@"business_id"];
//        [[MySingleton sharedMySingleton] popNewView:screen];
//            TableReadyScreen *tableReady = [[TableReadyScreen alloc] init];
//            //tableReady.businessName = element.label;
//            tableReady.businessID = [info objectForKey:@"business_id"];
//            //NSLog(@"label %@", tableReady.businessName);
//            //NSLog(@"nonlabel %@", element.label);
//            [[MySingleton sharedMySingleton] popNewView:tableReady];
            
        }
            break;
        
        case 8: // пользователь посажен set onsite
        {
            NSLog(@"get mess %@", [[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"]);
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"6"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"6"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"1"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"1"];
            }
            if ([[[DatabaseSingleton sharedDBSingleton] getAllMessagesWithbussID:[info objectForKey:@"business_id"] andType:@"5"] count] > 0) {
                [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:[info objectForKey:@"business_id"] andType:@"5"];
            }
            
            //попросили не записывать/сохранять в инбокс
            //[[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:[[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:[info objectForKey:@"business_id"]] message:[[info objectForKey:@"aps"] objectForKey:@"alert"] date:nil type:@"1" businessID:[info objectForKey:@"business_id"] token:nil];
            
            
//            WaitListsScreen *waitScreen = [[WaitListsScreen alloc] init];
            [[DatabaseSingleton sharedDBSingleton] setNoPending:[info objectForKey:@"business_id"]];
//            //[self popNewView:waitScreen];
//            screen = [[SingleItemScreen alloc] init];
//            screen.restaurantId = [info objectForKey:@"business_id"];
//            [self popNewView:screen];
//            [screen doSomething];
            
            UINavigationController *navigation =  [[MySingleton sharedMySingleton] getNavController];
            NSMutableArray *contrlollers = [[NSMutableArray alloc] initWithArray:navigation.viewControllers];
            //      [contrlollers removeObjectAtIndex:[contrlollers count] - 1];
            [contrlollers removeAllObjects];
            
            WaitListsScreen *wals = [[WaitListsScreen alloc] init];
            [contrlollers addObject:homeController];
            [contrlollers addObject:wals];
            
            [navigation setViewControllers:[[NSArray alloc] initWithArray:contrlollers]];
            // ==========
            
            NSString *bussID = [info objectForKey:@"business_id"];
            [self unsetHiddenMainPanel];
            
            SingleItemScreen *wls = [[SingleItemScreen alloc] init];
            wls.restaurantId = bussID;
            wls.waitListLabel.text = [[DatabaseSingleton sharedDBSingleton] getLabelFromWaitListWithBussID:bussID];
            wls.businessNameLbl.text = [[DatabaseSingleton sharedDBSingleton] getNameFromWaitListWithBussID:bussID];
            [self popNewView:wls];
            [wls doSomething];

        return;
        }
            
        default:
            break;
    }
  
}

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

-(void)getBusinessInfo:(NSString*)businessID andType:(NSString*)type andToken:(NSString*)mytoken
{
   
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"query", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"", nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kSearchByName];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:
                           dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kSearchByName parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@",JSON);
       // name = [[JSON objectForKey:@"Business"] objectForKey:@"name"];

         NSString * name = [[NSString alloc] init];
        
        
        for (int i = 0; i < [JSON count]; i++) {
            if ([[[[JSON objectAtIndex:i] objectForKey:@"Business"] objectForKey:@"id"] isEqualToString:businessID]) {
                name = [NSString stringWithFormat:@"%@",[[[JSON objectAtIndex:i] objectForKey:@"Business"] objectForKey:@"name"]];
            }
        }
        // === сохр  
            NSUserDefaults *pr = [NSUserDefaults standardUserDefaults];
            NSString *testName = [NSString stringWithFormat:@"%@",[pr objectForKey:[NSString stringWithFormat:@"bussID%@andType%@",businessID,type]]];
            [pr setObject:name forKey:testName];
            [pr synchronize];

            if ([type isEqualToString:@"3"] ) {
                [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:name message:nil date:nil type:@"3" businessID:businessID token:mytoken];
            }
            else{
                [[DatabaseSingleton sharedDBSingleton] addObjectToMessagesWithID:nil title:name message:@"User has been seated" date:nil type:@"5" businessID:businessID token:nil];
            }
            
            InboxScreen *inbox = [[InboxScreen alloc]init];
            [self popNewView:inbox];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    
    [operation start];
}

-(void)noInternetConnection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!  Internet/Data connectivity is required to access your business and waitlist information.  Please connect to resume full functionality." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self getPushFurther: alertView.tag]; //getPushFurther
        }
            break;
        case 1:
            [self popNewView:registerController];
            break;
    }
}

-(void)removeBusinessFromWaitList:(NSString*)businessID
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[DatabaseSingleton sharedDBSingleton] getWaitListIDwithBusinessID:businessID], nil];
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
        if ([JSON objectForKey:@"success"])
            {
            //  [[DatabaseSingleton sharedDBSingleton] deleteMessageFromDBWithBusinessID:businessID andType:@"4"];
            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:businessID];          
        //    [[MySingleton sharedMySingleton] popNewView:contr];
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

#pragma mark - Status Bar Hidden Method

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end