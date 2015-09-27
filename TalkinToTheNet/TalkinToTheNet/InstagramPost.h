//
//  InstagramPost.h
//  TalkinToTheNet
//
//  Created by Diana Elezaj on 9/26/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPost : NSObject

@property (nonatomic) NSArray *tags;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSDictionary *caption;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *avatarImageURL;

- (instancetype)initWithJSON:(NSDictionary *)json;


@end
