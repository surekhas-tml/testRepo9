//
//  WebServiceConstants.h
//  e-Guru
//
//  Created by Juili on 22/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#ifndef WebServiceConstants_h
#define WebServiceConstants_h

#if SSL
    #if DEVELOPMENT
    #define  BaseURL @"https://skinapidev-elb-211172385.ap-south-1.elb.amazonaws.com/api/"
    #else
    #define  BaseURL @"https://eguruskin.api.tatamotors/api/"
//    #define  BaseURL @"https://skinpreprod.api.tatamotors/api/"  //use this URL for preproduction.

    #endif
#else
    #if DEVELOPMENT
    #define  BaseURL @"https://eguruskindev.api.tatamotors/api/"
//    #define  BaseURL @"https://skinpreprod.api.tatamotors/api/"  //use this URL for preproduction.// only working for sandbox user and with preprod certifcates
//    #define  BaseURL @"http://skinapidev-elb-211172385.ap-south-1.elb.amazonaws.com/api/"   //@"http://52.213.7.99/api/"
    #else
    #define  BaseURL @"http://eguruskin.api.tatamotors/api/"

    #endif
#endif


// Issue Reporting

#define REPORTISSUEURL @"send-mail/"

//Secondory URL
#define LOGOUTURL @"logout/"
#define LOGINURL @"login/"
#define GETACCESSTOKENURL @"refresh-token/"
#define OFFLINEMASTERQUERYURL @"offline/query/"


#define PLPIPELINEURL @"abc"
//#define PPLPIPELINEURL @"get/mm/pplwise/"
#define PPLPIPELINEURL @"v1/pplwise/"
//#define DSEWiseURL @"get/dsewise/dashboard/"
#define DSEWiseURL @"v2/get/dsewise/dashboard/"
#define ACTUALVSTARGETURL @"v2/get/dsewise/dashboard/"
#define DSEMisWiseURL @"v1/mis/sales_summary/"
#define DSEMisDetailsWiseURL @"v1/mis/sales_details/"
#define MMGEOPIPELINEURL @"get/mm/geowise/"
#define MMAPPPIPELINEURL @"get/mm/appswise/"
#define MISSALEURL @"abc"

#define CREATECONTACTURL @"create/contact/"
#define SEARCHCONTACTURL @"contacts/search/"


#define CREATEACCOUNTURL @"create/account/"
#define SEARCHACCOUNTURL @"search/accounts/"

#define CREATEOPTYURL @"opty/"
#define UPDATEOPTYURL @"opty/update/"
#define SEARCHOPTYURL @"opty/search/"
#define CREATC1URL @"opty/createC1/"
#define OPTYSALESSTAGEURL @"get/salestage/"

#define OPTYLOSTREASONURL @"mark_as_lost/reason_to_lost/"
#define OPTYLOSTMAKEURL @"mark_as_lost/make_lost_to/"
#define OPTYLOSTMODELURL @"ppl/"
#define MARKASLOSTURL @"mark_as_lost/"
#define CREATEQUOTE @"opty/create/quote/"

#define CREATEACTIVITYURL @"create/activity/"
#define UPDATEACTIVITYURL @"update/activity/"
#define GTMECREATEACTIVITYURL @"activity/create/GTME/"
#define GTMEUPDATEACTIVITYURL @"activity/update/GTME/"

#define SEARCHACTIVITYURL @"search/activity/"
#define SEARCHGTMEACTIVITYURL @"search/gtme/activity/"

#define DSELEAVEURL @"add/dsm/markleave/"
#define DSECANCELLEAVEURL @"delete/dse/leave/"

//Financier
#define searchFinancierOptyURL  @"opty/search/V2/"
#define SENDOTPURL              @"get/otp/"
#define VERIFYOTPURL            @"get/verify_otp/"
#define SEARCHFINANCIERURL      @"get/dealer_fin_branch_details/"
#define SEARCHBDMBranchURL      @"get/bdm_details/"
#define CREATEFINANCIERURL      @"financier/quote/insert/"
#define fetchFinancierURL       @"financier/quote/fetch/"
#define submitToCRM             @"opty/submit_to_crm/"
//NFA
#define SEARCHNFAURL @"nfa/search/"

//??
#define ACTIVITYTYPELISTURL @"get/activity-type/"

#define PENDINGACTIVITYLISTURL @"search/activity/"


#define PRODUCTCATURL @"competitor_products/"
#define STATELISTURL @"states/"
#define DISTRICTLISTURL @"districts/"
#define TALUKALISTURL @"talukas/"
#define LOCATIONBYTALUKALISTURL @"get/location/"
#define CITYLISTURL @"cities/"
#define PINCODELISTURL @"pincodes/"
#define PINCODELISTURLFROMGPS @"get/address/"


#define LOBLISTURL              @"lob/"
#define PPLLISTURL              @"ppl/"
#define PLLISTURL               @"pl/"
#define VCLISTURL               @"vc_number/"
#define VHAPPLICATIONURL        @"vehicle_application/"
#define CUSTOMERTYPEURL         @"customer/type/"
#define SOURCEOFCONTACTURL      @"source_of_contact/"
#define MMGEOLISTURL            @"mm_geographies/"
#define BODYTYPEURL             @"body_type/"
#define TGMURL                  @"tgm/"
#define BROKERDETAILURL         @"broker/details/"
#define EVENTURL                @"get_list_of_events/"

#define USAGECATLISTURL         @"usage_categories/"
#define REFERALTYPELISTURL      @"referral_type/"
#define REFERRALCUSTOMERLISTURL @"customer/referrals/"
#define FINANCERLISTURL         @"financier/"
#define CAMPAIGNLISTURL         @"campain/details/"
#define DSELISTURL              @"get/dse/list/"
#define CHASSISDETAILURL        @"get/chassis_details/"


#define LINKCAMPAIGNURL @"campaign/link/"
#define ASSIGNOPTYURL @"assign/opty/"
#define ASSIGNACTIVITYURL @"assign/activity/"
#define INFLUENCERLISTURL @"influencers/"
#define COMPETITORSLISTURL @"competitors/"

#define CouldnotFetchDataMessage    @"Could not fetch data."
#define UnableToProcessRequest      @"Unable to process the request. Please try again later."
#define NoDataFoundError            @"No data found.Please try again "
#define SomethingWentWrongError     @"Something went wrong. Please try again "
#define RequestTimeOutError         @"Your request has timed out. Cannot reach the server right now . Please try again "
#define ServerError                 @"Server Error ! Please Try Again "
#define INPUTJSONERROR              @"Invalid request body !! Please contact Admin !!"
#define NoNetworkError              @"No Internet Connection"
#define ServerNotForund401          @"HTTP Error 401 - Unauthorized: Access is denied due to invalid credentials."
#define EndpointReqTimedOut         @"Endpoint request timed out, Please Try again or contact your administrator"
#define ServerError412              @"error 412"

/**
 NFA
 **/
#define NFA_DEAL_TYPE_URL           @"nfa/deal-type/"
#define NFA_BILLING_URL             @"nfa/billing/"
#define NFA_CREATE_URL              @"nfa/create/"
#define NFA_UPDATE_URL              @"nfa/update/"
#define NFA_GET_USER_POSITION       @"user/position/"
#define NFA_GET_NEXT_AUTHORITY      @"senior/details/"

/**
 Email Quotation
 **/
#define GET_QUOTATION_DETAILS   @"quote/details/"
  
/**
 Push Notification
 **/
#define REGISTER_DEVICE         @"device/register/"
#define DEREGISTER_DEVICE       @"device/unregister/"
#define GET_NOTIFICATION_LIST   @"get/notifications/"
#define DELETE_NOTIFICATION     @"update/notifiaction_status/"

//BEATPLAN
#define MYTEAMEXTENTION             @"get/myteam/"
#define EXCLUSIONLISTURL            @"get/exclusions/"
#define PARAMETERSETTINGSURL        @"get/parameter_settings/"
#define GETSTATECODEBYSTATENAME     @"get/state_code/"
#define GETMMGEOLIST                @"get/mm_geo/location/"
#define GETDISTRICTLIST             @"get/district_list/"
#define GETCITYLIST                 @"get/city_list/"
#define ASSIGNLOCATIONTODSE         @"add/assign_dse/location/"
#define REMOVEMMGEOLOCATIONOFDSE    @"remove/assign_dse/location/"
#define REMOVEDSE                   @"myteam/delete/dse/"
//

/**
M Influencer
**/
#define MYINFLUENCERURL @"get/customers/"
#define ADD_CUSTOMER @"add/customer/"
#define UPDATE_CUSTOMER @"update/customer/"
#define MMGEO_DSE_LIST @"get/mm_geo/dse_list/"
#define LOB_LIST @"get/lobs/"


//Dse Wise MMGEO API
#define GET_DSE_WISE_MMGEO @"get/dse_wise_mmgeo/"
// All Channel Type API
#define GET_CHANNEL_TYPES @"/get/channel_types/"
// All Application Types API
#define GET_APPLICATIONS_TYPES @"/get/customer_applicationlist/"

#endif /* WebServiceConstants_h */
