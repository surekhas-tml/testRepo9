//
//  GAConstants.h
//  e-guru
//
//  Created by Juili on 25/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#ifndef GAConstants_h
#define GAConstants_h


/*
 * Commented as the this is incorrect ID. Correct one defined in Constant.h
#if DEVELOPMENT
#define GAnalyticsTrackingID  @"UA-98113563-1"// tata google ID ORIGINAL
#else
#define GAnalyticsTrackingID @"UA-91160556-1"//test google id to be DELETE
#endif
*/


//------------------Google Analytics screen name and event names------------------//
#define GA_SN_Login                                         @"Login"
#define GA_SN_MyPage                                        @"My Page"
#define GA_SN_HomePage                                      @"Home Page"
#define GA_SN_CalenderPage                                  @"Calendar"

#define GA_SN_CreateNewProspect_Contact                     @"Create New Prospect-Contact"
#define GA_SN_CreateNewProspect_Account                     @"Create New Prospect-Account"

#define GA_SN_Dashboard_MisSales                            @"Dashboard-MISSales"
#define GA_SN_Dashboard_TargetVSActual                      @"Dashboard-TargetVSActual"
#define GA_SN_Dashboard_Activity                            @"Dashboard-Activity"
#define GA_SN_Dashboard_PPLWisePipeline                     @"Dashboard-PPLWisePipeline"
#define GA_SN_Dashboard_MMGeoWisePipeline                   @"Dashboard-MMGeoWisePipeline"
#define GA_SN_Dashboard_MMAppWisePipeline                   @"Dashboard-MMAppWisePipeline"
#define GA_SN_Dashboard_DSEWise                             @"Dashboard-DSEWise"
#define GA_SN_Dashboard_BEAT_PLAN                           @"BeatPlan-ParentViewController"
#define GA_SN_Dashboard_BEAT_PLAN_MYTEAM                    @"BeatPlan-MyTeam"
#define GA_SN_Dashboard_BEAT_PLAN_INFLUENCER                @"BeatPlan-Influencer"
#define GA_SN_Dashboard_BEAT_PLAN_CUSTOMER                  @"BeatPlan-Customer"
#define GA_SN_Dashboard_BEAT_PLAN_PARAMETERSETTINGS         @"BeatPlan-ParameterSettings"
#define GA_SN_Dashboard_BEAT_PLAN_EXCLUSION                 @"BeatPlan-Exclusion"

#define GA_SN_Activities                                    @"Activities"
#define GA_SN_Pending_Activities                            @"Pending Activities"
#define GA_SN_Update_Activity                               @"Update Activity"
#define GA_SN_Create_Activity                               @"Create Activity"

#define GA_SN_Drafts_Opportunity                            @"Drafts-Opportunity"
#define GA_SN_Drafts_Account                                @"Drafts-Account"
#define GA_SN_Drafts_Contact                                @"Drafts-Contact"
#define GA_SN_Drafts_Update                                 @"Update Draft"


#define GA_SN_Create_Opportunity                            @"Create Opportunity"
#define GA_SN_Opportunity_Details                           @"Opportunity Details"
#define GA_SN_Update_Opportunity                            @"Update Opportunity"
#define GA_SN_Lost_Opportunity                              @"Lost Opportunity"
#define GA_SN_Manage_Opportunity                            @"Manage Opportunity"
#define GA_SN_Financier_Manage_Opportunity                  @"Financier Manage Opportunity"
#define GA_SN_FinancierField                                @"FinancierField"


#define GA_SN_Create_NFA                                    @"Create NFA"
#define GA_SN_Search_NFA                                    @"Search NFA"
#define GA_SN_NFA_Details                                   @"NFA Details"
#define GA_SN_Update_NFA                                    @"Update NFA"
#define GA_SN_ChooseType_NFA                                @"Choose NFA Type"
#define GA_SN_ChooseDSMPosition_NFA                         @"Choose DSM-Position"
#define GA_SN_SearchOpportunity_NFA                         @"Search Opportunity For NFA"
#define GA_SN_Form_NFA                                      @"NFA Details Form"
#define GA_SN_SearchPending_NFA                             @"Search Pending NFA"
#define GA_SN_SearchApproved_NFA                            @"Search Approved NFA"
#define GA_SN_SearchExpired_NFA                             @"Search Expired NFA"
#define GA_SN_SearchRejected_NFA                            @"Search Rejected NFA"

#define GA_SN_Report                                        @"Report"
#define GA_SN_ServiceTollFree                               @"Service Toll free"

//----------------------Google Analytics event names---Authentication---------------------//
#define GA_EA_Login                                                    @"Login"
#define GA_EA_Logout                                                   @"Logout"

//contact -----Prospect
#define GA_EA_CreateNewContact_SaveDraft_Button_Click                         @"Create New Contact-Save As Draft"
#define GA_EA_CreateNewContact_UpdateDraft_Button_Click                       @"Create New Contact-Update Draft"
#define GA_EA_CreateNewContact_Submit_Button_Click                            @"Create New Contact-Submit Button Click"
#define GA_EA_CreateNewContact_ContinuetoOpportunity_Button_Click             @"Create New Contact-Continue to Opportunity Button Click"

//account

#define GA_EA_CreateNewAccount_SaveDraft_Button_Click                        @"Create New Account-Save As Draft"
#define GA_EA_CreateNewAccount_UpdateDraft_Button_Click                      @"Create New Account-Update Draft"
#define GA_EA_CreateNewAccount_Submit_Button_Click                           @"Create New Account-Submit Button Click"
#define GA_EA_CreateNewAccount_ContinuetoOpportunity_Button_Click            @"Create New Account-Continue To Opportunity Button Click"
#define GA_EA_CreateNewAccount_SearchContact_Button_Click                    @"Create New Account-Search Contact Button Click"

//search
#define GA_EA_SearchAccount_Search_Button_Click                              @"Search Account-Search Button Click"
#define GA_EA_SearchAccount_ContinueToOpportunity_Button_Click               @"Search Account-Continue To Opportunity Button Click"

#define GA_EA_SearchContact_Search_Button_Click                              @"Search Contact-Search Button Click"
#define GA_EA_SearchContact_ContinueToOpportunity_Button_Click               @"Search Contact-Continue To Opportunity Button Click"

//-------Opportunity
#define GA_EA_CreateOpportunity_Search_Contact_Button_Click                   @"Create Opportunity-Search Contact Button Click"
#define GA_EA_CreateOpportunity_Create_New_Contact_Button_Click               @"Create Opportunity-Create New Contact Button Click"
#define GA_EA_CreateOpportunity_Create_New_Referral_Contact_Button_Click      @"Create Opportunity-Create New Refferal Contact Button Click"
#define GA_EA_CreateOpportunity_Search_Account_Button_Click                   @"Create Opportunity-Search Account Button Click"
#define GA_EA_CreateOpportunity_Create_New_Account_Button_Click               @"Create Opportunity-Create New Account Button Click"
#define GA_EA_CreateOpportunity_SaveDraft_Button_Click                        @"Create Opportunity-Save As Draft"
#define GA_EA_CreateOpportunity_UpdateDraft_Button_Click                      @"Create Opportunity-Update Draft"
#define GA_EA_CreateOpportunity_Submit_Button_Click                           @"Create Opportunity-Submit Button Click"

#define GA_EA_CreateOpportunity_SearchBy_LOB_PPL_PL                           @"Create Opportunity-Search by LOB, PPL & PL"
#define GA_EA_CreateOpportunity_Search_by_PL_VC_Description                  @"Create Opportunity-Search by PL or VC Description"
#define GA_EA_CreateOpportunity_Invocation_From_Product_App                   @"Create Opportunity-Invocation from Product App"

#define GA_EA_UpdateOpportunity_Submit_Button_Click                           @"Update Opportunity-Submit Button Click"

#define GA_EA_Opportunity_Details_Update_Button_Click                         @"Opportunity Details-Update Button Click"
#define GA_EA_Opportunity_Details_Pending_Activity_Button_Click               @"Opportunity Details-Pending Activity Button Click"
#define GA_EA_Opportunity_Details_Link_Campaign_Button_Click                  @"Opportunity Details-Link Campaign Button Click"
#define GA_EA_Opportunity_Details_Mark_as_Lost_Button_Click                   @"Opportunity Details-Mark as Lost Button Click"
#define GA_EA_Opportunity_Details_Create_C1_Button_Click                      @"Opportunity Details-Create C1 Button Click"
#define GA_EA_Opportunity_Details_New_Activity_Button_Click                   @"Opportunity Details-New Activity Button Click"
#define GA_EA_Opportunity_Details_Assign_To_DSE_Button_Click                   @"Opportunity Details-Assign To DSE Button Click"

#define GA_EA_ManageOpportunity_Search_Button_Click                           @"Manage Opportunity-Search Button Click"
#define GA_EA_ManageOpportunity_Search_Filter_Change                           @"Manage Opportunity-Search Filter Change"

#define GA_EA_ManageOpportunity_Update_Button_Click                            @"Manage Opportunity-Update Button Click"
#define GA_EA_ManageOpportunity_Pending_Activity_Button_Click                   @"ManageOpportunity-Pending Activity Button Click"
#define GA_EA_ManageOpportunity_Link_Campaign_Button_Click                      @"ManageOpportunity-Link Campaign Button Click"
#define GA_EA_ManageOpportunity_MarkAs_Lost_Button_Click                       @"ManageOpportunity-Mark as Lost Button Click"
#define GA_EA_ManageOpportunity_Create_C1_Button_Click                          @"ManageOpportunity-Create C1 Button Click"
#define GA_EA_ManageOpportunity_New_Activity_Button_Click                       @"ManageOpportunity-New Activity Button Click"
#define GA_EA_ManageOpportunity_Assign_To_DSE_Button_Click                       @"Manage Opportunity-Assign To DSE Button Click"
#define GA_EA_ManageOpportunity_Financier_Button_Click                            @"Manage Opportunity-Financier Button Click"

//---------Activity
#define GA_EA_Search_Activity_Search_Button_Click                             @"Search Activity-Search Button Click"
#define GA_EA_Search_Activity_Clear_Button_Click                              @"Search Activity-Clear Button Click"
#define GA_EA_Activity_Create_Opportunity_Button_Click                        @"Activity-Create-Opportunity Button Click"
#define GA_EA_Activity_Create_Referral_Opportunity_Button_Click                        @"Activity-Create-Referral-Opportunity Button Click"
//--------Drafts
#define GA_EA_Drafts_Delete_Button_Click                                      @"Drafts-Delete Button Click"

#define GA_EA_CreateNewActivity_Submit_Button_Click                         @"Create New Activity-Submit Button Click"
#define GA_EA_UpdateActivity_Submit_Button_Click                            @"Update Activity-Submit Button Click"
#define GA_EA_UpdateActivity_Assign_To_DSE_Button_Click                     @"Update Activity-Assign To DSE Button Click"

//offline
#define GA_EA_Offline_Opportunity_Sync_Started                          @"Offline Opportunity-Sync Started"
#define GA_EA_Offline_Opportunity_Sync_Finished                         @"Offline Opportunity-Sync Finished"

#define GA_EA_Link_Campaign_Link_Campaign_Button_Click                  @"Link Campaign-Link Campaign Button Click"
#define GA_EA_Assign_Opportunity_To_DSE_Assign_To_DSE_Button_Click            @"Assign Opportunity To DSE-Assign To DSE Button Click"
#define GA_EA_Assign_Activity_To_DSE_Assign_To_DSE_Button_Click               @"Assign Activity To DSE-Assign To DSE Button Click"

//---------Retail Financier Views-----------
//#define GA_EA_FinancierManageOpty_Cell_Click                        @"FinancierManageOpty_Cell_Click"
//#define GA_EA_FinancierManageOptyV2_Call                            @"FinancierManageOptyV2_Call"
#define GA_EA_Financier_InsertQuote_Submit_Button_Click               @"Financier_InsertQuote_Submit_Button_Click"
#define GA_EA_Financier_Select_Click                                  @"Financier_Select_Click"
//#define GA_EA_Financier_ValidateOTP                                 @"Financier_ValidateOTP"
//#define GA_Financier_FetchQuote                                     @"Financier_FetchQuote"
#define GA_SubmitToCRM_Button_Click                                   @"SubmitToCRM_Button_Click"
#define GA_RefreshCRM_Button_Click                                    @"SubmitToCRM_Button_Click"

#define GA_EA_Personal_Details          @"Personal Details Screen"
#define GA_EA_Contact_Details           @"Contact Details Screen"
#define GA_EA_Account_Details           @"Account Details Screen"
#define GA_EA_Vehicle_Details           @"Vehicle Details Screen"
#define GA_EA_Retail_Financier          @"Retail Financier Details Screen"




//successful failed message for GA
//------Financier Module ---------------------
#define GA_EA_Financier_Selected        @"Financier Selected :"
#define GA_EA_InsertQuote_Successful    @"Quote submitted to Financier"
#define GA_EA_InsertQuote_Failed        @"Failed to submit Quote Financier"
#define GA_EA_SubmitToCRM_Successful    @"Quote submitted to CRM"
#define GA_EA_SubmitToCRM_Failed        @"Failed to submit Quote to CRM"
#define GA_EA_SubmitToCRM_Refresh       @"Financier Update Refresh"

#define GA_EA_LoginSuccessful @"Login Successful"
#define GA_EA_LoginFailed @"Login Failed"

#define GA_EA_Create_Opportunity_Successful @"Opportunity Creation Successful"
#define GA_EA_Create_Opportunity_Failed @"Opportunity Creation Failed"
#define GA_EA_Update_Opportunity_Successful @"Update Opportunity Successful"
#define GA_EA_Update_Opportunity_Failed @"Update Opportunity Failed"

#define GA_EA_Create_Activity_Successful @"Activity Creation Successful"
#define GA_EA_Create_Activity_Failed @"Activity Creation Failed"
#define GA_EA_Update_Activity_Successful @"Update Activity Successful"
#define GA_EA_Update_Activity_Failed @"Update Activity Failed"

#define GA_EA_Create_Contact_Successful @"Contact Creation Successful"
#define GA_EA_Create_Contact_Failed @"Contact Creation Failed"
#define GA_EA_Create_Account_Successful @"Account Creation Successful"
#define GA_EA_Create_Account_Failed @"Account Creation Failed"

#define GA_EA_Link_Campaign_Successful @"Link Campaign Successful"
#define GA_EA_Link_Campaign_Failed @"Link Campaign Failed"
#define GA_EA_AssignToDSE_Successful @"Assign To DSE Successful"
#define GA_EA_AssignToDSE_Failed @"Assign To DSE Failed"

#define GA_EA_IssueReport_Successful @"Application Issue Reportd"
#define GA_EA_IssueReportingFailed @"Application Issue Report Failed"

#define GA_EA_NFASearch_Successful @"Search NFA Sucsessful"
#define GA_EA_NFASearch_Failed @"Search NFA Failed"

#define GA_EA_Update_NFA_Successful @"Update NFA Sucsessful"
#define GA_EA_Update_NFA_Failed @"Update NFA Failed"

#define GA_EA_Create_NFA_Successful @"Create NFA Sucsessful"
#define GA_EA_Create_NFA_Failed @"Create NFA Failed"

#define GA_EA_ChoosePosition_NFA_Successful @"Choose Position for NFA Sucsessful"
#define GA_EA_ChoosePosition_NFA_Failed @"Choose Position for NFA Failed"

#define GA_EA_GetNextAuthority_NFA_Successful @"Get Next Authority for Position Sucsessful"
#define GA_EA_GetNextAuthority_NFA_Failed @"Get NextAuthority for Position Failed"

#define GA_EA_SearchOpportunity_NFA_Successful @"Search Opportunity for NFA Sucsessful"
#define GA_EA_SearchOpportunity_NFA_Failed @"Search Opportunity for NFA Failed"
//------ Report Issue

#define GA_EA_ReportIssue_Button_Click @"Report Issue"

//------ NFA
#define GA_EA_Open_SearchNFAFilter_Button_Click @"Open Search NFA Filter"
#define GA_EA_Close_SearchNFAFilter_Button_Click @"Close Search NFA Filter"
#define GA_EA_NewNFA_Button_Click @"Create New NFA Button"
#define GA_EA_SearchNFA_Button_Click @"Search NFA"
#define GA_EA_NFA_Clear_Button_Click @"Clear NFA Filter"
#define GA_EA_Update_NFA_Button_Click @"Update NFA"
#define GA_EA_Update_NFADetails_Button_Click @"Update NFA From NFA Details"
#define GA_EA_Create_NFA_Button_Click @"Create/Update New"

#define GA_EA_Choose_Position_NFA_Button_Click @"Choose Position for NFA"

#define GA_EA_Search_Opportunity_NFA_Button_Click @"Search Opportunity for NFA"

//------Dashboard
#define GA_EA_Dashboard_MisSales_Details @"Dashboard MIS Sales Details Viewed"

#define GA_EA_Dashboard_MisSales_Search @"Dashboard MIS Sales Searched"

#define GA_EA_Dashboard_MisSales_Search_Successful @"Mis Sales_Search Successful"
#define GA_EA_Dashboard_MisSales_Search_Failed @"Mis Sales_Search Failed"

//category Labels
#define GA_CL_Authentication @"Authentication"
#define GA_CL_Prospect @"Prospect"
#define GA_CL_Opportunity @"Opportunity"
#define GA_CL_Activity @"Activity"
#define GA_CL_Drafts @"Drafts"
#define GA_CL_OfflineOpportunity @"Offline Opportunity"
#define GA_CL_ReportIssue @"Report Issue"
#define GA_CL_NFA @"NFA"
#define GA_CL_Dashboard @"Dashboard"
#define GA_CL_Financier @"Financier"

#endif /* GAConstants_h */
