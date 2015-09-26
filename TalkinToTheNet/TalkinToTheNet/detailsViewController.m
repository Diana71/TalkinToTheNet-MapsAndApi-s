//
//  detailsViewController.m
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "detailsViewController.h"
#import "APIManager.h"
#import "InstaPost.h"
#import "InstaPostsTableViewCell.h"

@interface detailsViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation detailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.95 blue:0.98 alpha:1.0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchInstagramData];


}



-(void)fetchInstagramData{
    
    NSString *placeNameUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=a2c55d5958864f32a2b1af4f8b01c8db", self.placeName];
    
    NSURL *instagramURL = [NSURL URLWithString:placeNameUrl];
    
    [APIManager GETRequestWithURL:instagramURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *results = json[@"data"];
        
        self.searchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results){
            
            InstaPost *post = [[InstaPost alloc] initWithJSON:result];
            
            [self.searchResults addObject:post];
        }
        
        NSLog(@"json %@", json);
        
        [self.tableView reloadData];
        
    }];
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InstaPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstaIdentifier" forIndexPath:indexPath];
    
//    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    InstaPost *post = self.searchResults[indexPath.row];
    
    cell.userLabel.text = [NSString stringWithFormat:@"@%@", post.username];
//    cell.likesLabel.text = [NSString stringWithFormat:@"Likes: %ld",post.likeCount];
    
    cell.likesLabel.text = @"kot";

    cell.textCaptionLabel.text = post.caption[@"text"];
    
    cell.imageView.image = post.instaImage;
    
    return cell;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
