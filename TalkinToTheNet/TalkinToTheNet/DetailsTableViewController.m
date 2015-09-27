//
//  DetailsTableViewController.m
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/26/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "APIManager.h"
#import "InstagramPost.h"
#import "InstagramPostTableViewCell.h"
#import "InstagramPostHeaderView.h"
#import "searchViewController.h"


@interface DetailsTableViewController ()
@property (nonatomic) NSMutableArray *detailsResults;

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchInstagramData];
    NSLog(@"detailsss");
    
    // set up pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pulledToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // tell the table view to auto adjust the height of each cell
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
    
    // grab the nib from the main bundle
    UINib *nib = [UINib nibWithNibName:@"InstagramPostTableViewCell" bundle:nil];
    
    // register the nib for the cell identifer
    [self.tableView registerNib:nib forCellReuseIdentifier:@"InstagramCellIdentifier"];
    
    // grab the header nib from the main bundle
    UINib *headerNib = [UINib nibWithNibName:@"InstagramPostHeaderView" bundle:nil];
    
    // register the header nib for the header identifier
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"InstagramHeaderIdentifier"];
    
    
}
- (IBAction)refreshTapped:(id)sender {
    [self fetchInstagramData];
}


- (void)fetchInstagramData {
    
//    // create an instagram url
//    NSString *urlString = @"https://api.instagram.com/v1/tags/goldenretriever/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067";
//    
    
    self.placeName = @"cat";
    // create an instagram url
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=a2c55d5958864f32a2b1af4f8b01c8db", self.placeName];
    

    
//    NSString *placeNameUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=a2c55d5958864f32a2b1af4f8b01c8db", self.placeName];
//    
//    NSURL *instagramURL = [NSURL URLWithString:placeNameUrl];
//    
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSArray *results = responseObject[@"data"];
             
             // reset my array
             self.detailsResults = [[NSMutableArray alloc] init];
             
             // loop through all json posts
             for (NSDictionary *result in results) {
                 
                 // create new post from json
                 InstagramPost *post = [[InstagramPost alloc] initWithJSON:result];
                 
                 // add post to array
                 [self.detailsResults addObject:post];
             }
             
             [self.tableView reloadData];
             
         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             
         }];
    
}


- (void)pulledToRefresh:(UIRefreshControl *)sender {
    [self fetchInstagramData];
    [sender endRefreshing];
    
    // sender == self.refreshControl
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

#pragma mark - Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // dequeue the header view from the table view with InstagramHeaderIdentifier
    InstagramPostHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"InstagramHeaderIdentifier"];
    
    // grabbing the post from our search results that corresponds
    // with the section
    InstagramPost *post = self.detailsResults[section];
    
    // set the backgroundView and make it white
    headerView.backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
    headerView.backgroundView.backgroundColor = [UIColor whiteColor];
    
    // set the usernameLabel.text to the posts username;
    headerView.usernameLabel.text = post.username;
    
    // make the avatar a circle
    headerView.avatarImageView.layer.cornerRadius = 15.0;
    headerView.avatarImageView.layer.masksToBounds = YES;
    
    // create a url from the post avatartImageURL (originally a string)
    NSURL *avatarURL = [NSURL URLWithString:post.avatarImageURL];
    
    // using SDWebImage, load the avatar image into headerView.avatarImageView
    [headerView.avatarImageView sd_setImageWithURL:avatarURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        headerView.avatarImageView.image = image;
    }];
    
    // return the header view
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailsResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InstagramPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCellIdentifier" forIndexPath:indexPath];
    
    InstagramPost *post = self.detailsResults[indexPath.section];
    
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld likes", post.likeCount];
    
    cell.tagCountLabel.text = [NSString stringWithFormat:@"Tags: %ld", post.tags.count];
    
    cell.captionLabel.text = post.caption[@"text"];
    
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *image = [UIImage imageWithData:data];
    //
    //    cell.userMediaImageView.image = image;
    
    NSURL *url = [NSURL URLWithString:post.imageURL];
    
    [cell.userMediaImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.userMediaImageView.image = image;
    }];
    
    return cell;
}






@end
