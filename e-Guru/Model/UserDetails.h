//
//  UserDetails.h
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject
@property (strong,atomic) NSString * position;
@property (strong,atomic) NSString * positionID;
@property (strong,atomic) NSString * name;
@property (strong,atomic) NSString * contact;
@property (strong,atomic) NSString * org;
@property (strong,atomic) NSString * username;


+(UserDetails *)sharedobject;

@end
