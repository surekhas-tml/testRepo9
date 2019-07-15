//
//  AAAFinancierContactMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 03/10/18.
//  retainright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierContactMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierContactMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierContactMO *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSString *relationship_type;
@property (nullable, nonatomic, retain) NSString *taluka;
@property (nullable, nonatomic, retain) NSString *contact_id;
@property (nullable, nonatomic, retain) NSString *date_of_birth;
@property (nullable, nonatomic, retain) NSString *gender;

@property (nullable, nonatomic, retain) NSString *pan_number_individual;
@property (nullable, nonatomic, retain) NSString *address2;
@property (nullable, nonatomic, retain) NSString *address1;
@property (nullable, nonatomic, retain) NSString *occupation;

@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *district;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *area;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *pincode;
@property (nullable, nonatomic, retain) NSString *mobileno;
@property (nullable, nonatomic, retain) NSString *citytownvillage;

@property (nullable, nonatomic, retain) NSSet<AAAFinancierOpportunityMO *> *toOpportunity;

@end

NS_ASSUME_NONNULL_END
