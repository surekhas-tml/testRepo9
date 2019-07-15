//
//  EGRKWebserviceRepository.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilityMethods.h"
#import "WebServiceConstants.h"

#import "AppDelegate.h"
#import "EGRestKitSetupManager.h"
#import "EGRKObjectMapping.h"
#import "EGRKResponseDescriptor.h"
#import "EGPagination.h"
#import "Login.h"
#import "EGReversePincode.h"
#import "NFAUserPositionModel.h"
#import "NFANextAuthorityModel.h"

@class EGState,EGTaluka, EGQuotation;

@interface EGRKWebserviceRepository : NSObject

+(EGRKWebserviceRepository *)sharedRepository;

- (void)searchAccount:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)searchContactWithContactNumber:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)searchOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)searchActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


- (void)getStates:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSArray *statesArray))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getDistrictFromState:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getCityFromDistrict:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getListOfDSEs:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)assignOptyDSM:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)assignActivityDSM:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getDSEwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock;

- (void)getActualVsTargetPipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock;

- (void)getDSEMisDetailswisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock;

- (void)getDSEMiswisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getDSElist:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader;


- (void)getTalukaFromCityDistrict:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getAllTaluka:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact,EGRKWebserviceRepository *repo ))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getAllPIN:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGReversePincode* reversePinData))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)pplList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getPinFromTalukaCityDistrictState:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createContact:(NSDictionary *)queryDictionary withShowLoading:(BOOL)shouldShowLoading andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


- (void)createContact:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createAccount:(NSDictionary *)queryDictionary withShowLoading:(BOOL)shouldShowLoading andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


- (void)createAccount:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createC1:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

#pragma mark - Create Activity

- (void)createActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)createActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getPendingActivityListForGivenOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getActivityTypeListForGivenOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id type))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)opprtunityLostResoneList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)opprtunityLostMakeList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)opprtunityLostModelList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)mark_as_lost:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock;


- (void)updateActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

#pragma mark - Financier
    
-(void)fetchFinancier:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)searchFinancierOpty:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

-(void)searchFinancier:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id financierArray))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock;

-(void)searchFinancierTMFBranch:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id tmfBranchArray))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock;

-(void)sendOTP:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id otp))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock;

-(void)verifyOTP:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id verifiedMsg))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock;

-(void)createFinancier:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id response))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock;

- (void)crmSubmitCall:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *resArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


#pragma mark - Create Opportunity

- (void)getListOfLOBsandSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


- (void)getListOfPPL:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getListOfPL:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getVehicleApplication:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getCustomerType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getSourceOfContactSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getMMGeography:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getBodyType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getListOfCampaigns:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getUsageCategory:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getFinancierList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)getRegistrationDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock; //new

- (void)getCampaignList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)get_Campaign_List:(NSDictionary *)queryDictionary withblock:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getDSElist:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;


- (void)getInfluencersListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getCompetitorListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getProductCategoryList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getReferralCustomer:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getReferralType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)linkCampaign:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

//- (void)updateOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)updateOpportunity:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)crmSubmitCall:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSArray *responseArray))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createOpportunity:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createOpportunity:(NSDictionary *)requestDictionary withShowLoading:(BOOL)shouldShowLoading andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getTGMList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getBrokerDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getVCList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getSalesStageSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailureAction:(void (^)(NSError *error))failureBlock;

- (void)getEventListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailureAction:(void (^)(NSError *error))failureBlock;

#pragma mark - Logout Operation

- (void)performLogoutWithSuccessAction:(void (^)(id response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock;

#pragma mark - Login

- (void)performLogin:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(Login *response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock;

#pragma mark - Access Token

- (void)setAccessToken:(RKObjectManager *)objectManager;

#pragma mark - Dashboard

- (void)getPPLwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getMMGeowisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getMMAPPwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

# pragma marak - NFA

- (void)searchNFA:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getDealTypeSuccessAction:(void (^)(NSArray *dealsArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getBillingSuccessAction:(void (^)(NSArray *billingTypeArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)createNFA:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)updateNFA:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getUserPosition:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *array))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getNextAuthority:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NFANextAuthorityModel *nextAuthorityModel))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)getOfflineSyncInformation:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSDictionary *response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock;


#pragma mark - Push Notifications

- (void)registerDeviceForNotification:(NSDictionary *)queryDictionary
                     andSuccessAction:(void (^)(NSDictionary *response))successBlock
                     andFailureAction:(void (^)(NSError *error))failureBlock;

- (void)deRegisterDeviceFromNotification:(NSDictionary *)queryDictionary
                        andSuccessAction:(void (^)(NSDictionary *response))successBlock
                        andFailureAction:(void (^)(NSError *error))failureBlock;

- (void)getNotificationList:(NSDictionary *)queryDictionary
           andSuccessAction:(void (^)(EGPagination *))successBlock
           andFailuerAction:(void (^)(NSError *))failuerBlock;

- (void)deleteNotification:(NSDictionary *)queryDictionary
           andSucessAction:(void (^)(NSDictionary *responseDict))sucessBlock
          andFailuerAction:(void (^)(NSError *error))failuerBlock;

#pragma mark - Email Quotation

- (void)getQuotationDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGQuotation *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

#pragma mark - Exclusion

- (void)applyLeave:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)getExclusionlist:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader;

#pragma mark - Parameter Settings
- (void)getParameterSettings:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary* parameters))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader;

#pragma mark - My Influencer API
//- (void)getMyInfluencerAPI:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *responseDict))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)getMyInfluencerAPI:(NSDictionary *)queryDictionary andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock;

- (void)addCustomerAPI:(NSDictionary *)queryDictionary isUpdate:(BOOL)isUpdate andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock;

#pragma mark - My Team API
- (void)getMyTeamDetailsAPI:(NSString*)extensionName :(NSDictionary *)queryDictionary andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock;

- (void)createGTMEActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)updateGTMEActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
- (void)searchGTMEActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;

- (void)cancelLeave:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock ;
@end
