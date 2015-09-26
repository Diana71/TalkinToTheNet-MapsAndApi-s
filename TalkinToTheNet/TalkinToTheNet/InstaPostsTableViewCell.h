//
//  InstaPostsTableViewCell.h
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstaPostsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
//@property (weak, nonatomic) IBOutlet UIView *image;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCaptionLabel;



@end
