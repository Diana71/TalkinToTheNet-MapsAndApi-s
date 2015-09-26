//
//  searchResults.h
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>//for images


@interface searchResults : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString * formattedPhone;
@property (nonatomic) NSString * formattedAddress;


@property (nonatomic) NSString *fullAddress;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString * coordinates;
@property (nonatomic) NSString * checkIns;
@property (nonatomic) NSString * url;


@end
