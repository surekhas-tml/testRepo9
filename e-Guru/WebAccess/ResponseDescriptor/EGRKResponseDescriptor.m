//
//  EGRKResponseDescriptor.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "EGPagination.h"

#import "EGRKResponseDescriptor.h"
static EGRKResponseDescriptor *_sharedDescriptor;
@implementation EGRKResponseDescriptor

+(EGRKResponseDescriptor *)sharedDescriptor{
    @synchronized([EGRKResponseDescriptor class])
    {
        if (!_sharedDescriptor)
            _sharedDescriptor=[[self alloc] init];
        
        return _sharedDescriptor;
    }
    return nil;
}
+(id)alloc
{
    @synchronized([EGRKResponseDescriptor class])
    {
        NSAssert(_sharedDescriptor == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedDescriptor = [super alloc];
        return _sharedDescriptor;
    }
    
    return nil;
}

- (instancetype )init
{
    self = [super init];
    if (self) {
        [self setupAllMappingsAndResponseDescriptors];
    }
    return self;
}

-(void)setupAllMappingsAndResponseDescriptors{
    
    //SEARCHACCOUNTURL
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchAccountURLPaginatedMapping] ForPathPattern:SEARCHACCOUNTURL andKeyPath:nil];
    //SEARCHCONTACTURL
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchContactURLPaginatedMapping] ForPathPattern:SEARCHCONTACTURL andKeyPath:nil];
    //STATELISTURL
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] stateListURLMapping] ForPathPattern:STATELISTURL andKeyPath:nil];
    
    //#define LOCATIONBYTALUKALISTURL @"get/location/"
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] locationByTalukaListURLMapping] ForPathPattern:LOCATIONBYTALUKALISTURL andKeyPath:nil];
    
    //#define PINCODELISTURL @"pincodes/"
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] PINCODELISTURLMapping] ForPathPattern:PINCODELISTURL andKeyPath:nil];
    
    //#define PINCODELISTURL @"get/address/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] pincodelistURLFROMGPSMapping] ForPathPattern:PINCODELISTURLFROMGPS andKeyPath:nil];

    
    //#define TALUKALISTURL @"talukas/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] talukaListURLMapping] ForPathPattern:TALUKALISTURL andKeyPath:@"talukas"];
    
    //#define ACTIVITYTYPELISTURL @"abc"
    
    //CampaignList
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] campaignList] ForPathPattern:CAMPAIGNLISTURL andKeyPath:nil];

    //#define SEARCHACTIVITYURL @"search/activity/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchActivityURLMapping] ForPathPattern:SEARCHACTIVITYURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchActivityURLMapping] ForPathPattern:SEARCHGTMEACTIVITYURL andKeyPath:nil];
    
    
//    //SEARCHOPTYURL
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchOpportunityURLMappingForOpportunity] ForPathPattern:SEARCHOPTYURL andKeyPath:nil];

    /******************/
    
    //SEARCHFINANCIEROPTY
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchOptyFinancierURLMapping] ForPathPattern:searchFinancierOptyURL andKeyPath:nil];

    //FETCHFINANCIERDETAILS
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] fetchFinancierQuotesURLMapping] ForPathPattern:fetchFinancierURL andKeyPath:nil];

    
    /******************/
    
    //    //SEARCHNFAURL
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] searchNFAURLMapping] ForPathPattern:SEARCHNFAURL andKeyPath:nil];
   
//
//    //#define DISTRICTLISTURL @"districts/"
//    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] districtListURLMapping] ForPathPattern:DISTRICTLISTURL andKeyPath:@"districts"];
//    
//    


//    //CampaignList
//    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] campaignList] ForPathPattern:CAMPAIGNLISTURL andKeyPath:nil];

    //#define CITYLISTURL @"cities/"
    //#define PINCODELISTURL @"pincodes/"
    
    //#define CREATECONTACTURL @"contacts/"
    //#define CREATEACCOUNTURL @"accounts/"

    
    
    
    
    
//#define LOGINURL @"login/LoginValidate"
//    
//#define PPLPIPELINEURL @"abc"
//#define PLPIPELINEURL @"abc"
//#define MMGEOPIPELINEURL @"abc"
//#define VHAPPPIPELINEURL @"abc"
//#define MISSALEURL @"abc"
//    
//#define LINKCONTACTURL @"abc"
//    
//#define CREATEACCOUNTURL @"accounts/"
//#define SEARCHACCOUNTURL @"abc"
//#define LINKACCOUNTURL @"abc"
//    
//#define CREATEOPTYURL @"abc"
//#define UPDATEOPTYURL @"abc"
//#define UPGREADOPTYSALESTAGEURL @"abc"
//#define CREATC1URL @"opty/createC1/"
//#define OPTYSALESSTAGEURL @"abc"
//#define OPTYLOSTREASONURL @"abc"
//#define OPTYMAKEURL @"abc"
//#define OPTYMODELURL @"abc"
//    
//#define CREATEACTIVITYURL @"abc"
//#define UPDATEACTIVITYURL @"abc"

    
    


//#define PENDINGACTIVITYLISTURL @"abc"
//#define MISSEDACTIVITYLISTURL @"abc"
//    
//#define PRODUCTCATURL @"abc"

    //#define LOBLISTURL              @"lob/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] lobListURLMapping] ForPathPattern:LOBLISTURL andKeyPath:nil];
    
    
    //DSEList
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] DSEList] ForPathPattern:DSELISTURL andKeyPath:nil];
    

    
    
    //#define PPLLISTURL              @"ppl/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] pplListURLMapping] ForPathPattern:PPLLISTURL andKeyPath:nil];
    
    //#define PLLISTURL              @"pl/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] plListURLMapping] ForPathPattern:PLLISTURL andKeyPath:nil];
    
    //#define MMGEOLISTURL            @"mm_geographies/"
    //[EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] mmGeoListURLMapping] ForPathPattern:MMGEOLISTURL andKeyPath:nil];
    
    //#define FINANCERLISTURL         @"financier/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] financierURLMapping] ForPathPattern:FINANCERLISTURL andKeyPath:nil];
    
    //#define CAMPAIGNLISTURL           @"campain/details/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] campaignURLMapping] ForPathPattern:CAMPAIGNLISTURL andKeyPath:nil];
    
    //#define REFERRALCUSTOMERLISTURL   @"customer/referrals/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] referralCustomerURLMapping] ForPathPattern:REFERRALCUSTOMERLISTURL andKeyPath:nil];
    
    //#define BROKERDETAILURL         @"broker/details/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] brokerDetailsURLMapping] ForPathPattern:BROKERDETAILURL andKeyPath:nil];
    
    //#define TGMURL                  @"tgm/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] tgmURLMapping] ForPathPattern:TGMURL andKeyPath:nil];
    
    //#define VCLISTURL               @"vc_number/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] vcListURLMapping] ForPathPattern:VCLISTURL andKeyPath:nil];
    
    //#define EVENT
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] eventMapping] ForPathPattern:EVENTURL andKeyPath:nil];
   
    //for exchangeDetails
//    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] exchangeDetailsKeyMapping] ForPathPattern:nil andKeyPath:nil];
    

    //#define LOGINURL @"login/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] loginURLMapping] ForPathPattern:LOGINURL andKeyPath:nil];
    
    //#define GETACCESSTOKENURL @"refresh-token/"
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] accessTokenMapping] ForPathPattern:GETACCESSTOKENURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] dashboardMapping] ForPathPattern:MMGEOPIPELINEURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] dashboardMapping] ForPathPattern:MMAPPPIPELINEURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] PPLwisePipelineURLMapping] ForPathPattern:PPLPIPELINEURL andKeyPath:nil];
    
     [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] DSEwisePipelineURLMapping] ForPathPattern:DSEWiseURL andKeyPath:nil];
    
    //[EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] ActualVsTargetURLMapping] ForPathPattern:ACTUALVSTARGETURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] DSEMiswisePipelineURLMapping] ForPathPattern:DSEMisWiseURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] DSEMisDetailswisePipelineURLMapping] ForPathPattern:DSEMisDetailsWiseURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] PPLwisePipelineURLMapping] ForPathPattern:PPLPIPELINEURL andKeyPath:nil];
    
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] opportunityResponseMapping] ForPathPattern:CREATEOPTYURL andKeyPath:nil];
    
    //#define NFA_GET_USER_POSITION
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] userPositionURLMapping] ForPathPattern:NFA_GET_USER_POSITION andKeyPath:nil];
    
    //#define NFA_GET_NEXT_AUTHORITY
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] nextAuthorityURLMapping] ForPathPattern:NFA_GET_NEXT_AUTHORITY andKeyPath:nil];
    
    //#define GET_QUOTATION_DETAILS
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] getQuoteDetailURLMapping] ForPathPattern:GET_QUOTATION_DETAILS andKeyPath:nil];
    
    //#define GET_NOTIFICATION_LIST
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] getNotificationListURLMapping] ForPathPattern:GET_NOTIFICATION_LIST andKeyPath:nil];
    
    //#define GET_EXCLUSIONLIST
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] exclusionListURLMapping] ForPathPattern:EXCLUSIONLISTURL andKeyPath:nil];
    
    //#define GET_PARAMETERSETTING
    [EGRKResponseDescriptor setupResponseDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] parameterSettingListURLMapping] ForPathPattern:PARAMETERSETTINGSURL andKeyPath:nil];
}




+(void)setupResponseDescriptorForMappingForPOSTMethod:(RKObjectMapping *)mapping ForPathPattern:(NSString *)pathPattern andKeyPath:(NSString *)keyPath{
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:pathPattern
                                                keyPath:keyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

@end
