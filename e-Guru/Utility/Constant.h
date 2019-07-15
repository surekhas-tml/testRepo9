//
//  Constant.h
//  CRM_APP
//
//  Created by admin on 05/03/16.
//  Copyright © 2016 TataTechnologies. All rights reserved.
//
#import "GAConstants.h"
#ifndef Constant_h
#define Constant_h


// make it zero if you want to stop logs.
//#define NSLog if (0) NSLog


#if DEVELOPMENT
#define GAnalyticsTrackingID @"UA-98113563-1"//test google id to be DELETE
#else
#define GAnalyticsTrackingID  @"UA-76247847-1"// tata google ID ORIGINAL
#endif



#define PostionforDSE       @"DSE"
#define PostionforDSM       @"DSM"

#define GTME_APP       @"gtme"

#define MASTER_DB_FULL_NAME @"tml_sales_updated_version1.sqlite"
#define MASTER_DB @"tml_sales_updated_version1"
#define TEMP_MASTER_DB_FullName @"temp_offline_db.sqlite"

#define DBVERSION_KEY @"dbVersion"
#define LOGINDATEANDTIME @"Login date and time"


#define STATE_DISABLE  NO
#define STATE_ENABLE  YES

#define onRoadPricePattern             @"[0-9]"
#define panCardRegex                   @"[A-Z]{5}[0-9]{4}[A-Z]{1}"
#define pincodeRegx                    @"[0-9]{6}"
#define mobileNumberPattern            @"[0-9]{10}"
#define mobileNumberPatternNew         @"^[6-9]{10}$"  // new validation 
#define emailRegEx                     @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

#define dateFormatyyyyMMddTHHmmssZ      @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define dateFormatEODyyyyMMddTHHmmssZ   @"yyyy-MM-dd'T'23:59:59'Z'"
#define dateFormatSODyyyyMMddTHHmmssZ   @"yyyy-MM-dd'T'00:00:00'Z'"

#define dateFormatyyyyMMddThhmmssssssssZ @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'" //by shashi
#define dateFormatyyyyMMddThhmmss000Z   @"yyyy-MM-dd'T'hh:mm:ss.000'Z'"
#define timeFormathhmmss                @"hh:mm:ss"
#define dateFormatddMMyyyyThhmmssZ      @"dd-MM-yyyy'T'hh:mm:ss'Z'"
#define dateFormatyyyyMMddhyp           @"yyyy-MM-dd"
#define dateFormatddMMyyyy              @"dd/MM/yyyy"
#define dateFormatddMMyyyyHyphen        @"dd-MM-yyyy"
#define dateFormatddMMMyyyyHyphen       @"dd-MMM-yyyy"
#define dateFormatddMMyyyyHHmmss        @"dd/MM/yyyy HH:mm:ss"
#define activityListDateFormat          @"dd/MM/yyyy hh:mm a"

#define dateFormatMMddyyyyHHmmss        @"MM/dd/yyyy HH:mm:ss"

#define dateFormatddMMyyyyHHmm          @"dd/MM/yyyy HH:mm"
#define dateFormatNSDateDate            @"yyyy-MM-dd HH:mm:ss ZZZ"
#define timeFormatHHmm                  @"HH:mm"

#define createActivityDateFormat        @"MM/dd/yyyy"
#define currentDateFormat               @"dd-MMM-yyyy"
#define createActivityTimeFormat        @"HH:mm:ss"
#define pendingActivityTimeFormat       @"hh:mm a"

#define MSDayView  @"Day"
#define MSWeekView  @"Week"

#define C0  @"C0"
#define C1  @"C1"
#define C1A @"C1A"
#define C2  @"C2"
#define C3  @"C3"
#define LOST  @"Lost"

#define GTME_BB @"GTME_BB"
#define GTME_FE @"GTME_FE"
#define GTME_OT @"GTME_OT"
#define GTME_KC @"GTME_KC"
#define GTME_RV @"GTME_RV"



#define STATELIST @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,CREATEC1,NEWACT]
#define MICROMARKETLIST @[MMGEO1,MMGEO2,MMGEO3,MMGEO4,MMGEO5,MMGEO6]


#define NFASTATUSPending @"Pending"
#define NFASTATUSApproved @"Approved"
#define NFASTATUSRejected @"Rejected"
#define NFASTATUSExpired @"Expired"
#define NFASTATUSCancel @"Cancel"


#define CLOSEDLOST @"Closed Lost "
#define OPPTYACTIONFORLOST @[PENDINGACT]


#define OPPTYACTIONSDSEC0 @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,CREATEC1,NEWACT]
#define MYOPPTYACTIONSDSEC0 @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,CREATEC1,NEWACT,ASSIGN]

//for without financier
//#if WITHFINANCIER
#define OPPTYACTIONSDSEC1 @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,EMAIL_QUOTATION, RETAIL_FINANCIER]                  //new Changes
#define MYOPPTYACTIONSDSEC1 @[CREATE_NFA,UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN, EMAIL_QUOTATION, RETAIL_FINANCIER] //new Changes
#define MYOPPTYACTIONSDSEC1_NO_NFA @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN, EMAIL_QUOTATION, RETAIL_FINANCIER]
//#else
//#define OPPTYACTIONSDSEC1 @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,EMAIL_QUOTATION]      //
//#define MYOPPTYACTIONSDSEC1 @[CREATE_NFA,UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN, EMAIL_QUOTATION ] //
//#define MYOPPTYACTIONSDSEC1_NO_NFA @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN, EMAIL_QUOTATION ] //
//#endif

#define OPPTYACTIONSDSEC1A @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT] 

//for without financier
//#if WITHFINANCIER
#define OPPTYACTIONSDSEPREVIEWC1A @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT, PREVIEW] //new list for Preview option
//#else
//#define OPPTYACTIONSDSEPREVIEWC1A @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT] //
//#endif

#define MYOPPTYACTIONSDSEC1A @[CREATE_NFA,UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN]
#define MYOPPTYACTIONSDSEC1A_NO_NFA @[UPDATE,PENDINGACT,LINKCAMPAIGN,MARKLOST,NEWACT,ASSIGN]
#define OPPTYACTIONSDSEC2 @[PENDINGACT,LINKCAMPAIGN,MARKLOST]
#define MYOPPTYACTIONSDSEC2 @[CREATE_NFA,PENDINGACT,LINKCAMPAIGN,MARKLOST,ASSIGN]
#define MYOPPTYACTIONSDSEC2_NO_NFA @[PENDINGACT,LINKCAMPAIGN,MARKLOST,ASSIGN]
#define OPPTYACTIONSC3 @[@"No Action Found"]
#define OPPTYACTIONSDSEC3 @[]
#define OPPTYACTIONSDSM @[ASSIGN,PENDINGACT]

#define OPPTYACTIONSDSMC0 @[PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC1 @[CREATE_NFA,PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC1_NO_NFA @[PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC1A @[CREATE_NFA,PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC1A_NO_NFA @[PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC2 @[CREATE_NFA,PENDINGACT,ASSIGN]
#define OPPTYACTIONSDSMC2_NO_NFA @[PENDINGACT,ASSIGN]

#define OPPORTUNITYOPERATIONSLISTFORNONC0 @[PENDINGACT]

//Final Sprint

//#if WITHFINANCIER
#define DSEMENU @[HOME,MYPAGE,DASHBOARD,CREATEPROSPECT,CREATEOPTY,MANAGEOPTY,ACTIVITY, PDActivity,DRAFT,SYNC, NOTIFICATIONS, RETAIL_FINANCIER, REPORT, SERVICE_TOLL_FREE,LOGOUT]
#define DSMMENU @[HOME,MYPAGE,DASHBOARD,CREATEPROSPECT,CREATEOPTY,MANAGEOPTY,ACTIVITY, PDActivity,DRAFT,NFA,SYNC, NOTIFICATIONS, RETAIL_FINANCIER,BEATPLAN,LOGOUT]
//#else
//#define DSEMENU @[HOME,MYPAGE,DASHBOARD,CREATEPROSPECT,CREATEOPTY,MANAGEOPTY,ACTIVITY,DRAFT,SYNC, NOTIFICATIONS, LOGOUT]
//#define DSMMENU @[HOME,MYPAGE,DASHBOARD,CREATEPROSPECT,CREATEOPTY,MANAGEOPTY,ACTIVITY,DRAFT,NFA,SYNC, NOTIFICATIONS,LOGOUT]
//#endif


////Sprint One
//#define DSEMENU @[HOME,CREATEPROSPECT,CREATEOPTY,MANAGEOPTY,DRAFT,LOGOUT]
//#define DSMMENU @[HOME,MANAGEOPTY,LOGOUT]

#define APP_NAME [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"]


//SideMenu ITEMS
#define SYNC                        @"Sync Master"

#define DRAFT                       @"Drafts"
#define LISTVIEW                    @"listView"
#define MANAGEOPTY                  @"Manage Opportunity"
#define ACTIVITY                    @"Activity"
#define CREATEOPTY                  @"Create Opportunity"
#define TARGETS                     @"Targets"
#define LOGOUT                      @"Logout"
#define CREATEPROSPECT              @"Create New Prospect"
#define NFA                         @"NFA"
#define CREATENFA                   @"New NFA"
#define SEARCHNFA                   @"Search NFA"
#define NOTIFICATIONS               @"Notifications"
#define FINANCER                    @"Financier"
#define RETAIL_FINANCIER            @"Retail Financier"//changes
#define NON_PROCESSED               @"Non Processed"//new
#define PROCESSED                   @"Processed"//new

#define REPORT                      @"Report"
#define TOLL_FREE                   @"TollFree"
#define BEAT_PLAN                   @"BeatPlan"

#define SERVICE_TOLL_FREE           @"Service Toll Free Number"

#define BEATPLAN                    @"Beat Plan"






#define DASHBOARD                   @"Dashboard"
#define HOME                        @"Home"
#define MYPAGE                      @"My Page"
#define ACCOUNT                     @"Account"
#define CONTACT                     @"Contact"
#define MYPAGE                      @"My Page"
#define SEARCHRESULT                @"searchResult"
#define PENDINGACTIVITY             @"Activity Update"
#define PDActivity              @"Potential Drop Off"
#define DSM_OPTY                    @"Opportunities"

#define PROSPECT_ACCOUNT            @"Prospect Create Account"
#define PROSPECT_CONTACT            @"Prospect Create Contact"

//Financier Module
#define FINANCER_OPTYDETAIL         @"Retail Financier Opportunities"
#define FINANCER_Field_DETAIL       @"Retail Financier"
#define UPDATE_RETAIL_FINANCIER     @"Update Retail Financier"
#define FINANCIER_PREVIEW           @"Retail Financier Preview"

// Opportunity  and NFA Operations
#define CREATE_NFA                  @"Create NFA"
#define UPDATE                      @"Update"
#define COPY                        @"Copy"
#define CANCEL                      @"Cancel"
#define OPEN_SETTINGS               @"Open Settings"
#define LOCATION_DISABLED_MSG       @"Location services disabled. Please make sure that the location services are enabled and you have allowed %@ to access your location."
#define LOCATION_FETCH_FAILED_MSG   @"Failed to get your current location. Please make sure that the location services are enabled and you have allowed %@ to access your location."

#define ASSIGN           @"Assign"
#define PENDINGACT       @"Pending Activity"
#define LINKCAMPAIGN     @"Link Campaign"
#define MARKLOST         @"Mark as Lost"
#define CREATEC1         @"Create C1"
#define NEWACT           @"New Activity"
#define ASSIGN           @"Assign"
#define EMAIL_QUOTATION  @"Email Quotation"
#define RETAIL_FINANCIER @"Retail Financier"
#define PREVIEW          @"Retail Financier Preview"

#define INVOKED_FROM_CREATE_OPTY  @"From Create Opty"
typedef enum  {
    
    all = 0,
    PendingForSPMApproval = 1,
    PendingForRSMApproval = 2,
    PendingForRMApproval = 4,
    PendingForLOBHeadApproval = 8,
    PendingForMarketingHeadApproval = 16,
    RejectedBySPM = 32,
    RejectedByRSM = 64,
    RejectedByRM = 128,
    RejectedByLOBHead = 256,
    RejectedByMarketingHead = 512,
    ApproveBySPM = 1024,
    ApproveByLOBHead = 2048,
    ApproveByMarketingHead = 4096,
    ApproveByRSM = 8192,
    ApproveByRM = 16384,
    CancelledByDSM = 32768,
    CancelledByTSM = 65536,
    CancelledByUser = 131072,
    CancelledAsOptyClosedLost = 262144,
    Cancelled = 524288,
    Expired = 1048576 ,
    SubmittedByDealer = 2097152,
    Pending = (PendingForRMApproval | PendingForRSMApproval | PendingForLOBHeadApproval | PendingForMarketingHeadApproval | SubmittedByDealer | PendingForSPMApproval),
    Rejected = (RejectedByLOBHead | RejectedByMarketingHead | RejectedByRM | RejectedByRSM | RejectedBySPM),
    Approved = (ApproveByLOBHead | ApproveByMarketingHead | ApproveByRM | ApproveByRSM | ApproveBySPM),
    ExpiredOrCancelled = (Expired | Cancelled | CancelledByDSM | CancelledByTSM | CancelledByUser | CancelledAsOptyClosedLost)
}NFAStatusValue;

typedef enum {
    Home,
    MyPage,
    None,
    CreateOpportunity,
    UpdateOpportunity,
    Dashboard,
    Influencer,
    MyCustomer
}InvokedFrom;

typedef enum {
    
    TabpendingNFA,
    TabRejectedNFA,
    TabApprovedNFA,
    TabExpiredNFA
}NFATabName;

typedef enum {
    InvokeForCreateOpportunity,
    InvokeForUpdateOpportunity,
    InvokeForDraftEdit,
    InvokeFromPROSPECTEdit,
    InvokeFromProductApp,
}InvokeForOperation;

//typedef enum {
//    InvokeForNFACreateFromPullout,
//    InvokeForNFACreateFromManageOpty,
//    InvokeForUpdate
//}InvokeForNFAOperation;

typedef enum {
    MYACTIVITY=1,
    TEAMACTIVITY=2,
    BOTHACTIVITY=(MYACTIVITY | TEAMACTIVITY)
}DSMDSEACTIVITY;

typedef enum {
    MYOPTY=1,
    TEAMOPTY=2,
    BOTHOPTY=(MYOPTY | TEAMOPTY)
}DSMDSEOPTY;

typedef enum {
    PostRequestTypeMapped,
    PostRequestTypeUnMapped
}PostRequestType;


typedef enum {
    SearchResultFrom_HomePage,
    SearchResultFrom_OpportunityPage,
    SearchReferralResultFrom_OpportunityPage,
    SearchResultFrom_ManageOpportunity,
    SearchResultFrom_Prospect
}SearchResultFromPage;

//Create Prospect
#define CREATECONTACT @"Create Contact"
#define CREATEACCOUNT @"Create Account"
#define BASIC_INFO_SECTION @"BasicInfoSection"
#define ADDRESS_SECTION @"addressSection"
#define SAVE_AS_DRAFT @"  Save as Draft"
#define UPDATE_DRAFT @"  Update Draft"
#define ACTIVITY   @"Activity"
#define PENDINGSACTIVITY   @"PendingActivity"




//Entity Names
//retail Financier
#define F_NONPROCESSED          @"Non-Processed"
#define F_APPROVED              @"Approved"
#define F_PENDING               @"Pending"
#define F_REJECTED              @"Rejected"
#define F_ONHOLD                @"On Hold"
#define F_DATAISSUE             @"Data Issues"
#define F_SYSTEMERROR           @"System Error"

#define E_DRAFT                 @"Draft"
#define E_DRAFTACC              @"DraftAccount"
#define E_DRAFTCONTACT          @"DraftContact"
#define E_DRAFTFINANCIER        @"DraftFinancier" 
#define E_OPPORTUNITY           @"Opportunity"
#define E_ACCOUNT               @"Account"
#define E_CONTACT               @"Contact"
#define E_FINANCER              @"Retail Financier"  //no use
#define E_FINANCERINSERTQUOTES  @"FinancierInsertQuotes"
#define E_CAMPAIGN              @"Campaign"
#define E_ADDRESS               @"Address"
#define E_CONTACTADDRESS        @"Contact Address"
#define E_ACCOUNTADDRESS        @"Account Address"
#define E_ACTIVITY              @"Activity"
#define OPPORTUNITIES           @"Opportunities"
#define E_NOTIFICATION          @"Notification"

#define SEGUE                   @"_Segue"
#define NFASearch               @"NFASearch"
#define NFANew                  @"NFANew"

#define SEPARATOR_HEIGHT                    1
#define NO_OF_COLUMNS                       4
#define DYNAMIC_FIELD_VIEW_HEIGHT           60
#define DYNAMIC_CONTACT_ACCOUNT_VIEW_HEIGHT 80

#define RADIO_OPPORTUNITY_BUTTON    0
#define RADIO_CONTACT_BUTTON        1
#define RADIO_ACCOUNT_BUTTON        2

#define RADIO_GENDERMALE_BUTTON     0
#define RADIO_GENDERFEMALE_BUTTON   1
#define RADIO_MARRIED_BUTTON        2
#define RADIO_UNMARRIED_BUTTON      3
#define RADIO_OFFICE_BUTTON         4
#define RADIO_RESIDENT_BUTTON       5


#define CONTACTSEARCH_FROM_OPPORTUNITY @"contactSearchFromOpty"
#define CONTACTREFRRALSEARCH_FROM_OPPORTUNITY @"referalcontactSearchFromOpty"
#define ACCOUNTSEARCH_FROM_OPPORTUNITY @"accountSearchFromOpty"


#define DELAY_FOR_API                0.3f
#define DELAY_FOR_KEYBOARD_DISMISSAL 0.1f

#define LOGIN_PERFORMED_NOTIFICATION @"LoginPerformedNotification"

#define DATE_1970               @"01/01/1970"

#define KEY_START_DATE          @"start_date"
#define KEY_END_DATE            @"end_date"
#define KEY_OFFSET              @"offset"
#define SEARCH_STATUS           @"search_status"
#define KEY_SIZE                @"size"
#define POSITION_ID             @"position_id"
#define POSITION_TYPE           @"position_type"

#define DEFAULT_PAST_MONTH_COUNT 1

#define DEFAULT_ACTIVITY_MESSAGE                    @"Follow up activity for new opportunity"
#define OPPORTUNITY_SUCCESS_MESSAGE                 @"Opportunity created successfully!!"
#define DEFAULT_ACTIVITY_SUCCESS_MESSAGE            @"Follow up activity is created against the opportunity. Do you want to update the activity?"
#define FOLLOWUP_DATE_MESSAGE                       @"Currently the follow up date is"
#define OPTIONAL_FIELDS_CONFIRMATION_MESSAGE        @"Do you wish to fill the optional fields?"

#define SEARCH_FILTER_SALES_STAGE_C0                @"C0 (Prospecting)"
#define SEARCH_FILTER_SALES_STAGE_C1                @[@"C1 (Quote Tendered)"]


#pragma mark - NSNotifications
#define NOTIFICATION_NETWORK_NOT_AVAILABLE          @"NOTIFICATION_NETWORK_NOT_AVAILABLE"
#define NOTIFICATION_NETWORK_AVAILABLE              @"NOTIFICATION_NETWORK_AVAILABLE"

#define NOTIFICATION_DRAFT_VALUE_CHANGED            @"NOTIFICATION_DRAFT_VALUE_CHANGED"
#define NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED    @"NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED"
#define NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED    @"NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED"
#define NOTIFICATION_FINANCIER_DRAFT_VALUE_CHANGED  @"NOTIFICATION_FINANCIER_DRAFT_VALUE_CHANGED"

#define TITLE_LABEL_FONT                [UIFont fontWithName:@"Roboto-Regular" size:14]

//financier Select
#define NOTIFICATION_FINANCIER_VALUE_CHANGED        @"NOTIFICATION_FINANCIER_VALUE_CHANGED"
#define NOTIFICATION_DRAFT_VALUE_CHANGED        @"NOTIFICATION_DRAFT_VALUE_CHANGED"

#define ACTIVITY_CALENDER_SWITCH        @"ACTIVITY_CALENDER_SWITCH"

#pragma mark - Messages
#define MSG_INTERNET_NOT_AVAILBLE                   @"No Internet Connection"

#define TALUKA_DROP_DOWN_WIDTH  560
#define CUSTOMER_CATEGORY_DROP_DOWN_WIDTH  380

#define MSG_FETCHING_LOCATION                       @"Fetching location..."
#define LOCATION_FETCH_TIMEOUT              20
#define RECURRING_LOCATION_CAPTURE_INTERVAL 900 // 15 minutes
#define LOCATION_FETCH_FAILED_MESSAGE               @"Could not determine your location right now. Do you still want to create the opportunity?"
#define YES_ACTION_TITLE    @"Yes"
#define SAVE_DRAFT_ACTION_TITLE                     @"Save As Draft"
#define UPDATE_DRAFT_ACTION_TITLE                   @"Update Draft"

/**
 API Calls Failure Default Messages
 **/
#define CREATE_OPPORTUNITY_FAILED_MESSAGE   @"Failed to create opportunity."
#define UPDATE_OPPORTUNITY_FAILED_MESSAGE   @"Opportunity not updated."
#define CREATE_ACTIVITY_FAILED_MESSAGE      @"Failed to create activity."
#define UPDATE_ACTIVITY_FAILED_MESSAGE      @"Failed to update activity."
#define CREATE_ACCOUNT_FAILED_MESSAGE       @"Failed to create account."
#define CREATE_CONTACT_FAILED_MESSAGE       @"Failed to create contact."
#define CREATE_NFA_FAILED_MESSAGE           @"Failed to create NFA."
#define UPDATE_NFA_FAILED_MESSAGE           @"Failed to update NFA."
#define UPDATE_EVENT_NOT_ALLOWED(sale_stage)    [NSString stringWithFormat:@"Event update is not allowed in %@ sales stage.", sale_stage]

/**
 Activity Filter
 **/
#define TEXT_FILTER_APPLIED                 @"Filter Applied - "

/**Create NFA
 **/
#define HIGHER_DISCOUNT_ERROR_MESSAGE   @"Competitior Discount cannot be greater than Competitior Ex Showroom price"
#define DEFAULT_NFA_SEARCH_DAY_RANGE    30

/**
 Offline Master Sync
 **/

#define ALERT_TITLE_OFFLINE_MASTER_SYNC @"Offline Master Sync"
#define ALERT_TITLE_OFFLINE_MASTER_SYNC_INTERNET_LOST @"Internet Connection Lost"
#define MESSAGE_OFFLINE_MASTER_SYNC_STARTED @"Syncing the offline master database. Please do not turn off your internet connection."
#define MESSAGE_OFFLINE_MASTER_SYNC_COMPLETED @"Offline master database has been synced successfully."
#define MESSAGE_OFFLINE_MASTER_SYNC_FAILED @"Offline master database sync failed . Please logout and login again or use the \"Sync Master\" option from the side menu to restart the offline master database sync."
#define MESSAGE_OFFLINE_MASTER_SYNC_FAILED_DUE_TO_INTERNET @"Offline master database sync failed. After reconnecting to the internet logout and login again or use the \"Sync Master\" option from the side menu to restart the offline master database sync."

/**
 Duplicate Opportunity
 **/

#define DUPLICATE_OPTY_ERROR_CODE   109
#define CREATE_DUPLICATE_OPTY_CONFIRMATION  @" Do you still want to create another opportunity?"

#endif /* Constant_h */
