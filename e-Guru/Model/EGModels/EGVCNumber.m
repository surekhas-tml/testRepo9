//
//  EGVCNumber.m
//  e-Guru
//
//  Created by MI iMac04 on 06/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGVCNumber.h"

@implementation EGVCNumber
@synthesize lob;
@synthesize ppl;
@synthesize pl;
@synthesize vcNumber;
@synthesize productDescription;
@synthesize productID;
@synthesize productType;
@synthesize productCatagory;
@synthesize quantity;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.productType = @"";
        self.lob = @"";
        self.ppl = @"";
        self.pl = @"";
        self.vcNumber = @"";
        self.productDescription = @"";
        self.productID = @"";
        self.productType = @"";
        self.productCatagory = @"";
        self.quantity = @"";
        self.productName = @"";
        self.productName1 = @"";
    }
    return self;
}

-(_Nullable instancetype)initWithObject:(AAAVCNumberMO *_Nullable)object{
    self = [super init];
    if (self) {
        self.productType = object.productType? : @"";
        self.lob = object.lob? : @"";
        self.ppl = object.ppl? : @"";
        self.pl = object.pl? : @"";
        self.vcNumber = object.vcNumber? : @"";
        self.productDescription = object.productDescription? : @"";
        self.productID = object.productID? : @"";
        self.productType = object.productType? : @"";
        self.productName = object.productName? : @"";
        self.productName1 = object.productName1? : @"";
    }
    return self;
}
@end
