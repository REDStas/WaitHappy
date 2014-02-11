//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "WaitListsScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "SearchCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "SingleItemScreen.h"
#import "TableReadyScreen.h"


@interface WaitListsScreen ()
{
    UIImageView *im;
 //   WaitList *element;
    NSArray *receivedWLArr;
    int numObjectFromServer;
}

@end

@implementation WaitListsScreen

@synthesize restaurantId, topLabel;// restaurantLabel;

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
//    element = [[WaitList alloc] init];
     searchArray = [[NSMutableArray alloc] init];
     receivedWLArr = [[NSArray alloc] init];
     [topLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
     screen = [[SingleItemScreen alloc] init];
    // Do any additional setup after loading the view from its nib.
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromDB) name:@"load_data_waitlist_observer" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    refreshButton.hidden = YES;
    startSearchBtn.hidden = YES;
    [resultTable setHidden:YES];
    [im setHidden:YES];
    
   // [super viewWillAppear:YES];
   // [searchArray removeAllObjects];
  
    [self getWaitListBusinesses];
    numObjectFromServer = 0;
    //[[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startSearchTap:(id)sender {
    SearchByName *sbn = [[SearchByName alloc] init];
    [[MySingleton sharedMySingleton] popNewView:sbn];
}

-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}


-(void)loadDataFromDB
{
    searchArray = [[DatabaseSingleton sharedDBSingleton] getDataFromWaitList];
    NSLog(@"search count %d",[searchArray count]);
    NSLog(@"search description %@",[searchArray description]);
    if ([searchArray count])
    {
        [refreshButton setHidden:NO];
        [resultTable setHidden:NO];
        [resultTable reloadData];
    }
    else
    {
        [refreshButton setHidden:YES];
        [resultTable setHidden:YES];
        // если запрос ничео не возвращает
        // добавляем пустое окно и кнопку
        
        startSearchBtn.hidden = NO;
        
       // im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noWaitLists.png"]];
        im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
       // [im setFrame:CGRectMake(8, 55, im.frame.size.width,im.frame.size.height)];
        
        [im setFrame:CGRectMake(8, 55, im.frame.size.width,140)];
        
        UILabel *label1 = [[UILabel alloc] init];
        UILabel *label2 = [[UILabel alloc] init];
        
        label1.text = @"No wait lists.";
        [label1 setFrame:CGRectMake(35, 22, 180, 24)];
        [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
        [label1 setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
        [label1 setTextAlignment:NSTextAlignmentLeft];
        [label1 setBackgroundColor:[UIColor clearColor]];
        
        label2.text = @"You are not currently on any wait lists, so start searching for a restaurant and get on the list to skip the line!";
        
        [label2 setFrame:CGRectMake(35, 34, 232, 100)];
        label2.numberOfLines = 4;
        [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        [label2 setTextAlignment:NSTextAlignmentLeft];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
        [im addSubview:label1];
        [im addSubview:label2];
        [self.view addSubview:im];
        [im setHidden:NO];
    }
    [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview]; //*
}


#pragma mark Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCell";
    
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   // NSLog(@"searcharray description %@",[searchArray description]);
    
    WaitList *element = [searchArray objectAtIndex:indexPath.row];
    
    NSLog(@"wait lst el businessID  %@",element.businessID);
    
    cell.nameLbl.text = element.name;
    cell.labelLbl.text = element.label;
    
    if (indexPath.row == [searchArray count]-1) {
        [cell setRoundedIm];
    }
    else
    {
        [cell setRectangleIm];
    }
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"searchArray count %i", [searchArray count]);
    return [searchArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaitList *element = [searchArray objectAtIndex:indexPath.row];
    NSLog(@"%@", [element description]);
    if ([element.name isEqualToString:@"Your Table is Ready"])
    {
        TableReadyScreen *tableReady = [[TableReadyScreen alloc] init];
        tableReady.businessName = element.label;
        tableReady.businessID = element.businessID;
        NSLog(@"label %@", tableReady.businessName);
        NSLog(@"nonlabel %@", element.label);
        [[MySingleton sharedMySingleton] popNewView:tableReady];
    }
    else
    {        
        screen.restaurantId = ((WaitList*)[searchArray objectAtIndex:indexPath.row]).businessID;
        NSLog(@"elem  %@",element.label);
        NSLog(@"elem  %@",element.name);        
        [[MySingleton sharedMySingleton] popNewView:screen];
    }
}


#pragma mark getWL from server



-(void)getWaitListBusinesses
{
    //[[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"phone_id", nil];
    NSString *tken = [[MySingleton sharedMySingleton] getToken];
   // tken = [[tken stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    NSArray *values = [[NSArray alloc] initWithObjects:tken, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kGetWaitListBusinesses];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kGetWaitListBusinesses parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        receivedWLArr = [JSON objectForKey:@"data"];
        NSLog(@"receivArr %@",[receivedWLArr description]);
        if ([receivedWLArr count]) {
            [self refreshWaitList:receivedWLArr];
            [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview]; //*
        }
        else
        {
  
        //[self loadDataFromDB];
        
        
        [[DatabaseSingleton sharedDBSingleton] deleteAllFromWaitList];
//        void)deleteAllFromWaitList
        
            [resultTable setHidden:YES];
            // если запрос ничео не возвращает
        
            // добавляем пустое окно и кнопку
            
            startSearchBtn.hidden = NO;
            
            // im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noWaitLists.png"]];
            im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
            // [im setFrame:CGRectMake(8, 55, im.frame.size.width,im.frame.size.height)];
            
            [im setFrame:CGRectMake(8, 55, im.frame.size.width,140)];
            
            UILabel *label1 = [[UILabel alloc] init];
            UILabel *label2 = [[UILabel alloc] init];
            
            label1.text = @"No wait lists.";
            [label1 setFrame:CGRectMake(35, 22, 180, 24)];
            [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
            [label1 setTextColor:[UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1]];
            [label1 setTextAlignment:NSTextAlignmentLeft];
            [label1 setBackgroundColor:[UIColor clearColor]];
            
            label2.text = @"You are not currently on any wait lists, so start searching for a restaurant and get on the list to skip the line!";
            
            [label2 setFrame:CGRectMake(35, 34, 232, 100)];
            label2.numberOfLines = 4;
            [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
            [label2 setTextAlignment:NSTextAlignmentLeft];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
            [im addSubview:label1];
            [im addSubview:label2];
            [self.view addSubview:im];
            [im setHidden:NO];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview]; //*

        
        }
        
          [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        NSString *txt;
        txt = [NSString stringWithFormat:@"%@",@""];
        NSLog(@"error  %@", error);
        for (NSString* key in [JSON objectForKey:@"validationErrors"]) {
            NSLog(@"key %@ value %@",key,[JSON objectForKey:key]);
        }
        //     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:txt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //     [alert show];
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    }];
    [operation start];
}


-(void)refreshWaitList:(NSArray*)waitlists // что с сервера
{
    NSMutableArray *localWLArr = [[NSMutableArray alloc] init];
    localWLArr = [[DatabaseSingleton sharedDBSingleton] getDataFromWaitList]; // те что сохранены  локально 
    
    NSMutableDictionary *mt = [[NSMutableDictionary alloc] init];
    
    WaitList *wl;
    NSLog(@"descr %@",[waitlists description]);
    NSLog(@"descr %@",[[waitlists objectAtIndex:0] objectForKey:@"business_id"]);
    
    
    NSMutableArray *wlData = [[NSMutableArray alloc] init];
    wlData =[[DatabaseSingleton sharedDBSingleton] getDataFromWaitList]; // второй лок
    
    NSLog(@"descrwlData %@",[wlData description]);
     
     // -- удаляем из базы если на сервере нет в списке
    for (int i = 0; i<[wlData count]; i++)
    {
        wl = [wlData objectAtIndex:i];
        BOOL isHer = NO;
        for (int j = 0; j<[waitlists count]; j++)
            {
            [waitlists objectAtIndex:j];
            NSLog(@" localWL %@ serverWL %@",[[waitlists objectAtIndex:j] objectForKey:@"business_id"],wl.businessID);
            if ([[[waitlists objectAtIndex:j] objectForKey:@"business_id"] isEqual: wl.businessID])
                {
                isHer = YES;
                break;
                }
            }
        if (!isHer) {
            [[DatabaseSingleton sharedDBSingleton] deleteObjectFromWaitListDBwitBussID:wl.businessID];
        }
    }
    
    // -- подтягиваем table ready    
    
    for (int i = 0; i<[waitlists count]; i++)
    {
        for (int j = 0; j<[localWLArr count]+1; j++) {
            if (j == [localWLArr count])
            {
                [mt setObject:[[waitlists objectAtIndex:i] objectForKey:@"wait_list_id"] forKey:[[waitlists objectAtIndex:i] objectForKey:@"business_id"]];
                break;
            }
            wl = [localWLArr objectAtIndex:j];
            
            NSLog(@" localWL %@ serverWL %@",[[waitlists objectAtIndex:i] objectForKey:@"business_id"],wl.businessID);
            if ([[[waitlists objectAtIndex:i] objectForKey:@"business_id"] isEqual: wl.businessID])
            {
                break;
            }
        }
    }

    
    
     numObjectFromServer = [mt count];
    NSLog(@"c elem %d",numObjectFromServer);

    
    [self addObjectsInter:mt];
    //numObjectFromServer = [mt count];
    
}


-(void)addObjectsInter:(NSMutableDictionary*)arr
{
    if ([arr count] == 0) {
        [self loadDataFromDB];
    }
    else
    {
        for (int i = 0; i<[arr count]; i++)
        {
            [self addObjectToLocalWatLstwithID:[[arr allKeys] objectAtIndex:i] andWLid:[arr objectForKey:[[arr allKeys] objectAtIndex:i]]];
        }
    }
}



-(void)addObjectToLocalWatLstwithID:(NSString*)businessID andWLid:(NSString*)waitlistID;
{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:businessID, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kBusinessInfo];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessInfo parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        
        numObjectFromServer --;
        [[DatabaseSingleton sharedDBSingleton] addObjectToWaitListWithID:businessID waitListID:waitlistID label:[[JSON objectForKey:@"Business"] objectForKey:@"label"] name:[[JSON objectForKey:@"Business"] objectForKey:@"name"]];
        
        NSLog(@"c elem %d",numObjectFromServer);
        
        if (numObjectFromServer == 0) {
            [self loadDataFromDB];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        numObjectFromServer --;
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview]; //*
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    [operation start];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}


- (void)viewDidUnload {
    startSearchBtn = nil;
    refreshButton = nil;
    [super viewDidUnload];
}
@end
