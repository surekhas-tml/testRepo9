//
//  EGCustomerDetailModel.h
//  e-guru
//
//  Created by Apple on 08/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGCustomerDetailModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *contactNumber;
@property (nonatomic, copy) NSString *lob;
@property (nonatomic, copy) NSString *application;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *customer_id;
@end

NS_ASSUME_NONNULL_END
