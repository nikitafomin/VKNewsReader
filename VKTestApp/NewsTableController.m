//
//  NewsTableController.m
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import "NewsTableController.h"

@interface NewsTableController ()

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic) BOOL isFetching;

@end

@implementation NewsTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add pull-to-refresh
    
    UIRefreshControl *refreshControll = [[UIRefreshControl alloc] init];
    [refreshControll addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControll];
    
    // get feeds
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch feeds

- (void)fetchFeedsNext:(BOOL)nexFeeds
{
    if (_isFetching) {
        return;
    } else {
        _isFetching = YES;
    }
    
    
    NSDictionary *param;
    if (nexFeeds) {
        NewsItem *item = [_newsArray lastObject];
        NSLog(@"\n\naaaaaasdasdasdasdasd       %@\n\n",item.date);
        param = @{VK_API_COUNT: @"15", @"start_time": item.date};
    } else {
        //NSString *feedsCount = [NSString stringWithFormat:@"%lu",([_newsArray count] == 0 ? 15 : [_newsArray count] > 100 ? 100 : [_newsArray count])];
        NSString *feedsCount = [NSString stringWithFormat:@"%lu",MIN(MAX([_newsArray count], 15), 100)];
        param = @{VK_API_COUNT: feedsCount};
    }
    NSLog(@"\n\n%@\n\n",param);
    
    
    VKRequest * getWall = [VKRequest requestWithMethod:@"newsfeed.get" andParameters:param andHttpMethod:@"GET"];
    
    [getWall executeWithResultBlock:^(VKResponse * response) {
        
        //        (
        //         "new_from",
        //         items,
        //         groups,
        //         profiles,
        //         "new_offset"
        //         )
        
        NSLog(@"\n\nresponse:\n%@\n\n",response.json);
        NSLog(@"\n\nfirst feed:\n%@\n\n",[[response.json objectForKey:@"items"] firstObject]);
        
        NewsItem *item;
        
        if (!nexFeeds) {
            _newsArray = [NSMutableArray arrayWithCapacity:[(NSArray *)[response.json objectForKey:@"items"] count]];
        }
        
        // parse and create items
        for (NSDictionary *itemDict in [response.json objectForKey:@"items"]) {
            item = [[NewsItem alloc] init];
            item.text = [itemDict objectForKey:@"text"];
            item.date = [itemDict objectForKey:@"date"];
            
            //find 2 photo
            NSInteger photoCount = 0;
            for (NSDictionary *attachment in [itemDict objectForKey:@"attachments"]) {
                if ([[attachment objectForKey:@"type"] isEqualToString:@"photo"]) {
                    if (photoCount == 0) {
                        item.firstImageURL = [[attachment objectForKey:@"photo"] objectForKey:@"photo_130"];
                    } else {
                        item.secondImageURL = [[attachment objectForKey:@"photo"] objectForKey:@"photo_130"];
                    }
                    photoCount++;
                }
                if (photoCount == 2) {
                    break;
                }
            }
            [_newsArray addObject:item];
        }
        
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        if (nexFeeds) {
            NSInteger coutnOfNewItems = [(NSArray *)[response.json objectForKey:@"items"] count];
            NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:coutnOfNewItems];
            for (int i = ((int)[_newsArray count] - 1); i > ([_newsArray count] - 1 - coutnOfNewItems); i--) {
                [indexPathes insertObject:[NSIndexPath indexPathForRow:i inSection:0] atIndex:0];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        _isFetching = NO;
        
    } errorBlock:^(NSError * error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось связаться с VK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        
        _isFetching = NO;
    }];
}

#pragma mark - Actions

- (void)refresh
{
    [self fetchFeedsNext:NO];
}

- (void)fetchNextFeeds
{
    [self fetchFeedsNext:YES];
}

- (IBAction)logoutClick:(id)sender
{
    [VKSdk forceLogout];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"\n\nrows count:   %lu\n\n",[_newsArray count]);
    return [_newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NewsItem *item = [_newsArray objectAtIndex:indexPath.row];
    [cell configureWithItem:item];
    
    if (indexPath.row == ([_newsArray count] - 4)) {
        [self fetchNextFeeds];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
