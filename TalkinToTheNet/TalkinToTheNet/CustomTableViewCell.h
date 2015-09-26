//
//  CustomTableViewCell.h
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end
