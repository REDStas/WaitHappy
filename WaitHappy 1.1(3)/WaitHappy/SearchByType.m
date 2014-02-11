//
//  SearchByType.m
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchByType.h"
#import "MySingleton.h"
#import "SearchCell.h"

@interface SearchByType ()

@end

@implementation SearchByType

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
    searchArray = [[NSMutableArray alloc] init];    
     [sorryLabel setText:NSLocalizedString(@"no_result_top", nil)];
    
    NSString *bottomTxt =[NSString stringWithFormat:@"%@",NSLocalizedString(@"no_result_bottom_fromtype", nil)];
    bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#MMM#" withString:@"20"] ;
    bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:@""];
  //  NSLog(@"current dist: %d",current_dist);
    
    [sorryBottomLabel setText:bottomTxt];
    NSLog(@"bottom txt: %@",bottomTxt);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[[MySingleton sharedMySingleton] getSearchPanel].view setFrame:CGRectMake(0, 8, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.width, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.height)];
    
    [centerView addSubview:[[MySingleton sharedMySingleton] getSearchPanel].view];
    
    [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    
    [section_lbl setText:NSLocalizedString(@"section_labels", nil)];
    
    [self getList];
    [centerView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
  //  [centerView setFrame:CGRectMake(0, 60, 320, self.view.frame.size.height - 60)];
    NSLog(@"Main frame %f",self.view.frame.size.height);
    NSLog(@"hello");
    [resultTable reloadData];
}


-(void)getList
{
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    [resultTable setAlpha:0];
    
    // old without longtitude
  //  NSArray *keys = [[NSArray alloc] initWithObjects:@"empty", nil];
  //  NSArray *values = [[NSArray alloc] initWithObjects:@"", nil];
    
    
//    NSArray *keys = [[NSArray alloc] initWithObjects:@"empty", @"lat", @"lng", nil];
//    NSArray *values = [[NSArray alloc] initWithObjects:@"",[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"], [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"], nil];
//    
    
    
    NSArray *keys = [[NSArray alloc] initWithObjects: @"latitude", @"longitude", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"], [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"], nil];
    
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kBusinessTypes];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessTypes parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSLog(@"%@", JSON);
      //  NSDictionary *BusinessSubtypeDic = [[NSDictionary alloc] initWithDictionary:[[JSON objectAtIndex:0] objectForKey:@"BusinessSubtype"]];
       // NSDictionary *BusinessSubtypeDic = [[NSDictionary alloc] initWithDictionary:[JSON objectForKey:@"BusinessSubtype"]];
        /*
        for (NSString* key in BusinessSubtypeDic )
        {   
            NSString *name=[[BusinessSubtypeDic objectForKey:key] objectForKey:@"name"];
            NSString *restarants_count=[NSString stringWithFormat:@"%i RESTAURANTS",[[[BusinessSubtypeDic objectForKey:key] objectForKey:@"Business"] count]];
            NSString *rest_id = [[BusinessSubtypeDic objectForKey:key] objectForKey:@"id"];
            
            NSArray *sub_keys = [[NSArray alloc] initWithObjects:@"name",@"restarants_count",@"rest_id", nil];
         
            
            NSArray *sub_values = [[NSArray alloc] initWithObjects:name,restarants_count,rest_id, nil];
            
            NSDictionary *sub_dict = [[NSDictionary alloc] initWithObjects:sub_values forKeys:sub_keys];
          
            [searchArray addObject:sub_dict];
        }
         */
    
    if ([JSON count]) {
        [searchArray removeAllObjects];
        NSArray *BusinessSubtypeArr = [[NSArray alloc] initWithArray:[[JSON objectAtIndex:0] objectForKey:@"BusinessSubtype"]];
        for (NSDictionary* dict in BusinessSubtypeArr)
            {
            NSString *name=[dict objectForKey:@"name"];
            NSString *restarants_count=[NSString stringWithFormat:@"%i Restaurants",[[dict objectForKey:@"Business"] count]];
            NSString *rest_id = [dict objectForKey:@"id"];
            NSArray *sub_keys = [[NSArray alloc] initWithObjects:@"name",@"restarants_count",@"rest_id", nil];
            NSArray *sub_values = [[NSArray alloc] initWithObjects:name,restarants_count,rest_id, nil];
            NSDictionary *sub_dict = [[NSDictionary alloc] initWithObjects:sub_values forKeys:sub_keys];
            [searchArray addObject:sub_dict];
            }
        NSLog(@"%@", [searchArray description]);
        [resultTable setAlpha:1];
        [noResultView setHidden:YES];
        [resultTable reloadData];
    }
    else{        
        [resultTable setAlpha:0];
        [noResultView setHidden:NO];
    }
    
    
    
    
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
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
    
    cell.nameLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.labelLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"restarants_count"];
    
    if (indexPath.row == [searchArray count]-1) {
        [cell setRoundedIm];
    }    
    else
    {
        [cell setRectangleIm];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [searchArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = (SearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == [searchArray count]-1)
        [cell setRoundedSelectedIm];
    else
        [cell setRectangleSelectedIm];
    
    NSLog(@"%@",[[searchArray objectAtIndex:indexPath.row] objectForKey:@"rest_id"]);
    
    [[MySingleton sharedMySingleton] setCurrentSearchIndex:1];
    
    
    UIViewController * temp = [[MySingleton sharedMySingleton] getCurrentSearchController];
    ((SearchByDistance *)temp).subtype_id = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectForKey:@"rest_id"]];
    ((SearchByDistance *)temp).subtype_name = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    ((SearchByDistance *)temp).current_dist = 2;
    
    
    [[MySingleton sharedMySingleton] popNewView:temp];
    
    
    
}
- (void)viewDidUnload {
    noResultView = nil;
    sorryLabel = nil;
    sorryBottomLabel = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
