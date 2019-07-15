//
//  AAAUserDataMO+CoreDataProperties.m
//  
//
//  Created by Apple on 08/03/19.
//
//

#import "AAAUserDataMO+CoreDataProperties.h"

@implementation AAAUserDataMO (CoreDataProperties)

+ (NSFetchRequest<AAAUserDataMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserData"];
}

@dynamic dealerCode;
@dynamic dsmName;
@dynamic employeeRowID;
@dynamic latitude;
@dynamic lob;
@dynamic lobBUUnit;
@dynamic lobName;
@dynamic lobRowID;
@dynamic lobServiceTaxFlag;
@dynamic longitude;
@dynamic organisationName;
@dynamic organizationID;
@dynamic positionID;
@dynamic positionName;
@dynamic positionType;
@dynamic primaryEmployeeCellNum;
@dynamic primaryEmployeeID;
@dynamic primaryPositionID;
@dynamic userName;
@dynamic userState;

@end
