//
//  AAAUserDataMO+CoreDataProperties.h
//  
//
//  Created by Apple on 08/03/19.
//
//

#import "AAAUserDataMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAUserDataMO (CoreDataProperties)

+ (NSFetchRequest<AAAUserDataMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *dealerCode;
@property (nullable, nonatomic, copy) NSString *dsmName;
@property (nullable, nonatomic, copy) NSString *employeeRowID;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *lobBUUnit;
@property (nullable, nonatomic, copy) NSString *lobName;
@property (nullable, nonatomic, copy) NSString *lobRowID;
@property (nullable, nonatomic, copy) NSString *lobServiceTaxFlag;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, copy) NSString *organisationName;
@property (nullable, nonatomic, copy) NSString *organizationID;
@property (nullable, nonatomic, copy) NSString *positionID;
@property (nullable, nonatomic, copy) NSString *positionName;
@property (nullable, nonatomic, copy) NSString *positionType;
@property (nullable, nonatomic, copy) NSString *primaryEmployeeCellNum;
@property (nullable, nonatomic, copy) NSString *primaryEmployeeID;
@property (nullable, nonatomic, copy) NSString *primaryPositionID;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userState;

@end

NS_ASSUME_NONNULL_END
