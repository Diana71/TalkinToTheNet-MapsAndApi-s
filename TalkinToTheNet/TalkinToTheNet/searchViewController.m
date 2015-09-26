//
//  searchViewController.m
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "searchViewController.h"
#import "APIManager.h"
#import "searchResults.h"
#import "detailsViewController.h"
#import "ViewController.h"
#import "CustomTableViewCell.h"
 
@interface searchViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;


@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchTextField.delegate = self;
    self.locationTextField.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.95 blue:0.98 alpha:1.0];
}

-(void) makeNewAPIRequestWithSearchTerm:(NSString *)searchTerm
                                  andLocation:(NSString*) searchLocation
                                callBackBlock:(void(^)())block {
    
     if ([searchLocation isEqualToString:@""] && [searchTerm isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results!"
                                                        message:@"Please fill out the textfields"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"both empty");
    }
     else {
         if ([searchLocation isEqualToString:@""]) {
         searchLocation = @"New York";
         NSLog(@"location is empty");
     }
        NSLog(@"that's ok!");

    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?near=%@&query=%@&client_id=HFUCKJHNO0CLHVKGCCVDZXSLNAERSCXTMAJY35DQOHYRVWXV&client_secret=OACRH5SEMEHGRHE2PKPJY0DLR5NLKLBM202DEHL3HFKNWCDU&v=20150924",searchLocation, searchTerm];
    
    //encoded url
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"encodedString  %@",encodedString);
    
    //convert urlString to url
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *results = [[json objectForKey:@"response"] objectForKey:@"venues"];
        
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                NSString *placeName = [result objectForKey:@"name"];
                NSString *address = [[result objectForKey:@"location"] objectForKey:@"address"];
                NSString *city = [[result objectForKey:@"location"] objectForKey:@"city"];
                NSString *state = [[result objectForKey:@"location"] objectForKey:@"state"];
                NSString *postalCode = [[result objectForKey:@"location"] objectForKey:@"postalCode"];
                NSString *phoneNumber = [[result objectForKey:@"contact"] objectForKey:@"formattedPhone"];
                NSString *urlDone = [result objectForKey:@"url"];
                
                searchResults *newObject = [[searchResults alloc] init];
                newObject.name = placeName;
                newObject.formattedPhone = phoneNumber;
                newObject.fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, postalCode];
                newObject.url = urlDone;
                newObject.checkIns = [[[result objectForKey:@"stats"] objectForKey:@"checkinsCount"] stringValue];
                
                 [self.searchResults addObject:newObject];
            }
            block();
        }
    }];
}
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark -tableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    searchResults * result = [self.searchResults objectAtIndex:indexPath.row];

    cell.nameLabel.text = result.name;
    cell.phoneLabel.text = [NSString stringWithFormat:@"Phone: %@", result.formattedPhone];
    cell.addressLabel.text = [NSString stringWithFormat:@"Address: %@",result.fullAddress];
    cell.urlLabel.text = [NSString stringWithFormat:@"Website: %@",result.url];

    return cell;
}

# pragma mark - text field delegate methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    NSString * query = self.searchTextField.text;
    
    [self makeNewAPIRequestWithSearchTerm:query andLocation:textField.text callBackBlock:^{
        [self.tableView reloadData];
    }];
    return YES;
}
 
#pragma mark Cells color
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = indexPath.row % 2
    ? [UIColor colorWithRed:0.91 green:0.95 blue:0.98 alpha:1.0]
    : [UIColor whiteColor];
    
}

#pragma mark Convert Name to tag

- (NSString *)convertNameToTag: (NSString *)name{
    
    NSString *removeApostrophe = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *removeAmpersand = [removeApostrophe stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    NSString *removeDash = [removeAmpersand stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *fixE = [removeDash stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    NSString *removeSpaces = [fixE stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tagName = [removeSpaces lowercaseString];
    
    return tagName;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    searchResults *userSelection = self.searchResults [indexPath.row];
    
    NSString *currentResultTagName = [self convertNameToTag:userSelection.name];
    
    detailsViewController *vc = segue.destinationViewController;
    
    vc.placeName = currentResultTagName;
    
}

@end
