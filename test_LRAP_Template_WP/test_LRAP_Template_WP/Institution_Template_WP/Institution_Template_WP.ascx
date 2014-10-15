<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Institution_Template_WP.ascx.cs" Inherits="test_LRAP_Template_WP.Institution_Template_WP.Institution_Template_WP" %>

<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.21/angular.min.js"></script>
<link type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
<script type="text/javascript" src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script type="text/javascript">

    $(document).ready(function () {
        $('#demo').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="example"></table>');

        $('#example').dataTable({
            "data": ASP_InstitutionDocuments,
            "columns": [
                { "title": "Document", "width": "20%" },
                
            ],
            "lengthMenu": [[100, 50, 25, 10], [100, 50, 25, 10]]
        });
    });

</script>
<asp:Literal ID="InstitutionInformation" runat="server"></asp:Literal>
<asp:Literal ID="InstitutionLrapHistory" runat="server"></asp:Literal>
<asp:Literal ID="InstitutionDocuments" runat="server"></asp:Literal>
<asp:Literal ID="CohortOptions" runat="server"></asp:Literal>

<asp:GridView ID="GridView1" runat="server"></asp:GridView>
<style type="text/css">
      .smart-form section {
           margin-bottom: 0px;
      }

      .smart-form section * {
           margin-bottom: 0px;
      }

      /*//#InstitutioninformationFieldset div*/ 
</style>






<script type="text/javascript">

    function LrapController($scope, $filter) {

        $scope.InstitutionInformation = angular.copy(ASP_InstitutionInformation);
        $scope.InstitutionLrapHistory = angular.copy(ASP_InstitutionLrapHistory);
       
        //$scope.InstitutionDocuments = angular.copy(ASP_InstitutionDocuments);
        $scope.CohortOptions = angular.copy(ASP_CohortOptions);

        $scope.InstitutionLrapHistoryForm = {};
        $scope.InstitutionInformationForm = {};

        $scope.FreshmanFeeTypeOptions = [
             {
                 "id": "Selective Freshmen",
                 "label": "Selective Freshmen"
             },
             {
                 "id": "All Freshmen",
                 "label": "All Freshmen"
             }
        ];

        $scope.InstitutionStatusOptions = [
             {
                 "id": "Active",
                 "label": "Active"
             },
             {
                 "id": "Not Active",
                 "label": "Not Active"
             }
        ];

        $scope.ClearModal = function (jqueryTargetModal) {

            $(jqueryTargetModal + " input").val('');

            $(jqueryTargetModal + " select").val('');

            $(jqueryTargetModal + " input").each(function (index) {
                $(this).select2("val", null);
            });
        };

        $scope.HideModal = function (jqueryTargetModal) {
            $(jqueryTargetModal).modal('hide');
            //SuccessToast();
        }
        //Institution LRAP History Functions
        $scope.AddInstitutionLrapHistory = function () {

            //if ($scope.InstitutionLrapHistorys == null)
            //    $scope.InstitutionLrapHistorys = [];


            var formId = parseInt($scope.InstitutionLrapHistoryForm.ModalFormId);

            var InstitutionLrapHistoryObject = angular.copy($scope.InstitutionLrapHistoryForm);
            InstitutionLrapHistoryObject["INSTITUTION_ID"] = $scope.InstitutionInformation.INSTITUTION_ID;
            //    FRESHMEN_FEE_TYPE: "" + $scope.InstitutionLrapHistoryForm.FRESHMEN_FEE_TYPE,
            //    UPPER_INCOME_LIMIT: "" + $scope.InstitutionLrapHistoryForm.UPPER_INCOME_LIMIT,
            //    LOWER_INCOME_LIMIT: "" + $scope.InstitutionLrapHistoryForm.LOWER_INCOME_LIMIT,
            //    introAnnualFee: "" + $scope.InstitutionLrapHistoryForm.introAnnualFee,
            //    introNumberOfInstitutions: "" + $scope.InstitutionLrapHistoryForm.introNumberOfInstitutions,
            //    transferAnnualFee: "" + $scope.InstitutionLrapHistoryForm.transferAnnualFee,
            //    transferAnnualReserve: "" + $scope.InstitutionLrapHistoryForm.transferAnnualReserve,
            //    transferGradReserve: "" + $scope.InstitutionLrapHistoryForm.transferGradReserve,
            //    freshmenAnnualFee: "" + $scope.InstitutionLrapHistoryForm.freshmenAnnualFee,
            //    freshmenAnnualReserve: "" + $scope.InstitutionLrapHistoryForm.freshmenAnnualReserve,
            //    freshmenGradReserve: "" + $scope.InstitutionLrapHistoryForm.freshmenGradReserve,
            //    retentionAnnualFee: "" + $scope.InstitutionLrapHistoryForm.retentionAnnualFee,
            //    retentionAnnualReserve: "" + $scope.InstitutionLrapHistoryForm.retentionAnnualReserve,
            //    retentionGradReserve: "" + $scope.InstitutionLrapHistoryForm.retentionGradReserve
            //};

            //$scope.InstitutionLrapHistoryForm = {};

            showToaster('Institution Lrap History: ' + InstitutionLrapHistoryObject["DESCRIPTION"], 'Updating...');

            if (formId >= 0) {


                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_INSTITUTION_LRAP_HISTORY&" + GenerateQueryString(InstitutionLrapHistoryObject);
                
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {
                        //alert("success");
                        $scope.InstitutionLrapHistory.splice(formId, 1, InstitutionLrapHistoryObject);
                        ShowToasterSuccess('Institution Lrap History: ' + InstitutionLrapHistoryObject["DESCRIPTION"], "Update History Complete");
                        $scope.InstitutionLrapHistoryForm = {};
                        $scope.$apply();
                    }
                    else if (storedProcedureResult == "failure") {
                        showToasterError('Institution Lrap History: ' + InstitutionLrapHistoryObject["DESCRIPTION"], "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Institution LRAP History: " + InstitutionLrapHistoryObject["DESCRIPTION"], "Consult Kyle");
                    }
                });

                
            }
            else {
                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=NEW_INSTITUTION_LRAP_HISTORY&" + GenerateQueryString(InstitutionLrapHistoryObject);

                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {

                       
                        var newIds = $("#response1").text().split('|');
                        //alert($("#response1").text());
                        InstitutionLrapHistoryObject.INSTITUTION_LRAP_HISTORY_ID = newIds[0] ;
                        InstitutionLrapHistoryObject.INTRO_INSTITUTION_LRAP_FEE_ID = (newIds[1] == "-1" ? null : newIds[1]);
                        InstitutionLrapHistoryObject.FRESHMEN_INSTITUTION_LRAP_FEE_ID = (newIds[2] == "-1" ? null : newIds[2]);
                        InstitutionLrapHistoryObject.RETENTION_INSTITUTION_LRAP_FEE_ID = (newIds[3] == "-1" ? null : newIds[3])
                        InstitutionLrapHistoryObject.TRANSFER_INSTITUTION_LRAP_FEE_ID = (newIds[4] == "-1" ? null : newIds[4])
                        $scope.InstitutionLrapHistory.push(InstitutionLrapHistoryObject);

                        //alert("success");
                        ShowToasterSuccess("Institution LRAP History: " + InstitutionLrapHistoryObject["DESCRIPTION"], "New History Complete");
                        $scope.InstitutionLrapHistoryForm = {};
                        $scope.$apply();
                    }
                   
                    else if (storedProcedureResult == "failure") {
                        showToasterError("Institution LRAP History: " + InstitutionLrapHistoryObject["DESCRIPTION"], "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Institution LRAP History: " + InstitutionLrapHistoryObject["DESCRIPTION"], "Consult Kyle");
                    }
                });


               
            }
          
            //ShowToasterSuccess("Institution Lrap History ", "Update Complete!");

        };

        $scope.EditModalInstitutionLrapHistory = function (itemId, jqueryTargetModal) {

            if (itemId == '-1') {
                //alert("new modal");
                $scope.ClearModal(jqueryTargetModal);
                $scope.ClearInstitutionLrapHistoryForm();
            }
            else if ($scope.InstitutionLrapHistoryForm.ModalFormId != itemId) {

                
                $scope.InstitutionLrapHistoryForm = angular.copy($scope.InstitutionLrapHistory[itemId]);
                $scope.InstitutionLrapHistoryForm.ModalFormId = itemId;

                ////$scope.ClearModal(jqueryTargetModal);
                ////$scope.ClearInstitutionLrapHistoryForm();

                //var index;
                ////alert("OLD obj value: " + "" + $scope.InstitutionLrapHistory[itemId].FRESHMEN_FEE_TYPE);
                ////alert("OLD display value: " + $scope.InstitutionLrapHistoryForm.FRESHMEN_FEE_TYPE);

                //$scope.InstitutionLrapHistoryForm = {
                //    FRESHMEN_FEE_TYPE: "" + $scope.InstitutionLrapHistory[itemId].FRESHMEN_FEE_TYPE,
                //    UPPER_INCOME_LIMIT: "" + $scope.InstitutionLrapHistory[itemId].UPPER_INCOME_LIMIT,
                //    LOWER_INCOME_LIMIT: "" + $scope.InstitutionLrapHistory[itemId].LOWER_INCOME_LIMIT,
                //    ModalFormId: itemId
                //};

                ////alert("obj value: " + "" + $scope.InstitutionLrapHistory[itemId].FRESHMEN_FEE_TYPE);
                ////alert("display value: " + $scope.InstitutionLrapHistoryForm.FRESHMEN_FEE_TYPE);
                //for (index = 0; index < $scope.InstitutionLrapHistory[itemId].LRAP_FEES.length; ++index) {
                //    var fee = angular.copy($scope.InstitutionLrapHistory[itemId].LRAP_FEES[index]);
                //    switch (fee.FEE_TYPE) {
                //        case "Intro":
                //            $scope.InstitutionLrapHistoryForm.introAnnualFee = "" + fee.ANNUAL_FEE_AMOUNT;
                //            $scope.InstitutionLrapHistoryForm.introNumberOfInstitutions = "" + $scope.InstitutionLrapHistory[itemId].INTRO_InstitutionS;
                //            break;
                //        case "Transfer":
                //            $scope.InstitutionLrapHistoryForm.transferAnnualFee = "" + fee.ANNUAL_FEE_AMOUNT;
                //            $scope.InstitutionLrapHistoryForm.transferAnnualReserve = "" + fee.RESERVE_ANNUAL;
                //            $scope.InstitutionLrapHistoryForm.transferGradReserve = "" + fee.RESERVE_ATGRAD;
                //            break;
                //        case "Freshmen":
                //            $scope.InstitutionLrapHistoryForm.freshmenAnnualFee = "" + fee.ANNUAL_FEE_AMOUNT;
                //            $scope.InstitutionLrapHistoryForm.freshmenAnnualReserve = "" + fee.RESERVE_ANNUAL;
                //            $scope.InstitutionLrapHistoryForm.freshmenGradReserve = "" + fee.RESERVE_ATGRAD;
                //            break;
                //        case "Retention":
                //            $scope.InstitutionLrapHistoryForm.retentionAnnualFee = "" + fee.ANNUAL_FEE_AMOUNT;
                //            $scope.InstitutionLrapHistoryForm.retentionAnnualReserve = "" + fee.RESERVE_ANNUAL;
                //            $scope.InstitutionLrapHistoryForm.retentionGradReserve = "" + fee.RESERVE_ATGRAD;
                //            break;
                //    }
                
            }

        };

        $scope.ClearInstitutionLrapHistoryForm = function () {
            $scope.InstitutionLrapHistoryForm = {};
        };


        /* StudnetStatus Functions */
        $scope.AddStudentStatuses = function () {
            try {
                showToaster('Student Information', 'Updating...');
                var STATUS_PERIOD = $scope.StudentStatusesForm.STATUS_PERIOD_YEAR.concat($scope.StudentStatusesForm.STATUS_PERIOD_MONTH);

                if (STATUS_PERIOD.length != 8) {
                    throw new Error("Please select both radio and dropdown option for Status Period");
                }

                var RETRO_PERIOD = "";
                if ($scope.StudentStatusesForm.RETRO_PERIOD_YEAR && $scope.StudentStatusesForm.RETRO_PERIOD_MONTH) {
                    RETRO_PERIOD = $scope.StudentStatusesForm.RETRO_PERIOD_YEAR.concat($scope.StudentStatusesForm.RETRO_PERIOD_MONTH);
                }


                var CALC_FEE = "0";
                if (("" + $scope.StudentStatusesForm.BORROWING) == "Y") {
                    CALC_FEE = "" + $scope.StudentLrapDetails.ANNUAL_FEE_AMOUNT;
                }
                else if (("" + $scope.StudentStatusesForm.BORROWING) == "N") {
                    CALC_FEE = "0";
                }
                else {
                    throw new Error("Please select an option for Borrowing");
                }



                var StudentStatusesObject =
                    {
                        STATUS_PERIOD: "" + STATUS_PERIOD,
                        RETRO_PERIOD: "" + RETRO_PERIOD,
                        STATUS: "" + $scope.StudentStatusesForm.STATUS,
                        CURRENT_CLASS: "" + $scope.StudentStatusesForm.CURRENT_CLASS,
                        BORROWING: "" + $scope.StudentStatusesForm.BORROWING,
                        CALC_FEE: "" + CALC_FEE
                    };


                var formId = parseInt($scope.StudentStatusesForm.ModalFormId);
                if (formId >= 0) {
                    StudentStatusesObject["STUDENT_STATUS_ID"] = "" + $scope.StudentStatusesForm.STUDENT_STATUS_ID;
                    $scope.StudentStatusesObject = angular.copy(StudentStatusesObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_STATUS&" + GenerateQueryString($scope.StudentStatusesObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {
                            //alert("success");
                            //$scope.StudentInformation.STUDENT_ID = "" + StudentInformationObject["STUDENT_ID"];
                            //$scope.StudentInformation.INSTITUTION_ID = "" + StudentInformationObject["INSTITUTION_ID"];
                            //$scope.StudentInformation.FIRST_NAME = "" + StudentInformationObject["FIRST_NAME"];
                            //$scope.StudentInformation.LAST_NAME = "" + StudentInformationObject["LAST_NAME"];
                            //$scope.StudentInformation.LRAP_STUDENT_ID = "" + StudentInformationObject["LRAP_STUDENT_ID"];
                            //$scope.StudentInformation.INSTITUTION_STUDENT_ID = "" + StudentInformationObject["INSTITUTION_STUDENT_ID"];
                            //$scope.StudentInformation.MIDDLE_NAME = "" + StudentInformationObject["MIDDLE_NAME"];
                            //$scope.StudentInformation.MAIDEN_LAST_NAME = "" + StudentInformationObject["MAIDEN_LAST_NAME"];
                            //$scope.StudentInformation.PHONE_1 = "" + StudentInformationObject["PHONE_1"];
                            //$scope.StudentInformation.PHONE_2 = "" + StudentInformationObject["PHONE_2"];
                            //$scope.StudentInformation.EMAIL_1 = "" + StudentInformationObject["EMAIL_1"];
                            //$scope.StudentInformation.EMAIL_2 = "" + StudentInformationObject["EMAIL_2"];
                            //$scope.StudentInformation.PARENT_EMAIL_1 = "" + StudentInformationObject["PARENT_EMAIL_1"];
                            //$scope.StudentInformation.PARENT_EMAIL_2 = "" + StudentInformationObject["PARENT_EMAIL_2"];
                            //$scope.StudentInformation.ADMITTED_CLASS = "" + StudentInformationObject["ADMITTED_CLASS"];
                            //$scope.StudentInformation.GRADUATION_DATE_ACTUAL = FormatDate("" + StudentInformationObject["GRADUATION_DATE_ACTUAL"]);
                            $scope.StudentStatusesObject["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatusesObject["STATUS_PERIOD"]);
                            $scope.StudentStatusesObject["RETRO_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatusesObject["RETRO_PERIOD"]);
                            $scope.StudentStatuses.splice(formId, 1, $scope.StudentStatusesObject);
                            ShowToasterSuccess("Student Status", "Update Status Complete");
                            $scope.StudentStatusesForm = {};
                            $scope.$apply();
                        }
                        else if (storedProcedureResult == "warning") {
                            showToasterWarning("Student Status", "" + $("#response1").text());
                        }
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Status", "" + $("#response1").text());
                        }
                        else {
                            showToasterError("Student Status", "CONSULT KYLE");
                        }
                    });


                }
                else {
                    StudentStatusesObject["CREATED_DATE"] = "" + $scope.GetCurrentDate();
                    StudentStatusesObject["STUDENT_ID"] = "" + $scope.StudentInformation.STUDENT_ID;
                    $scope.StudentStatusesObject = angular.copy(StudentStatusesObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=NEW_STUDENT_STATUS&" + GenerateQueryString($scope.StudentStatusesObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {


                            //$scope.StudentInformation.INSTITUTION_ID = "" + StudentInformationObject["INSTITUTION_ID"];
                            //$scope.StudentInformation.FIRST_NAME = "" + StudentInformationObject["FIRST_NAME"];
                            //$scope.StudentInformation.LAST_NAME = "" + StudentInformationObject["LAST_NAME"];
                            //$scope.StudentInformation.LRAP_STUDENT_ID = "" + StudentInformationObject["LRAP_STUDENT_ID"];
                            //$scope.StudentInformation.INSTITUTION_STUDENT_ID = "" + StudentInformationObject["INSTITUTION_STUDENT_ID"];
                            //$scope.StudentInformation.MIDDLE_NAME = "" + StudentInformationObject["MIDDLE_NAME"];
                            //$scope.StudentInformation.MAIDEN_LAST_NAME = "" + StudentInformationObject["MAIDEN_LAST_NAME"];
                            //$scope.StudentInformation.PHONE_1 = "" + StudentInformationObject["PHONE_1"];
                            //$scope.StudentInformation.PHONE_2 = "" + StudentInformationObject["PHONE_2"];
                            //$scope.StudentInformation.EMAIL_1 = "" + StudentInformationObject["EMAIL_1"];
                            //$scope.StudentInformation.EMAIL_2 = "" + StudentInformationObject["EMAIL_2"];
                            //$scope.StudentInformation.PARENT_EMAIL_1 = "" + StudentInformationObject["PARENT_EMAIL_1"];
                            //$scope.StudentInformation.PARENT_EMAIL_2 = "" + StudentInformationObject["PARENT_EMAIL_2"];
                            //$scope.StudentInformation.ADMITTED_CLASS = "" + StudentInformationObject["ADMITTED_CLASS"];
                            //$scope.StudentInformation.GRADUATION_DATE_ACTUAL = FormatDate("" + StudentInformationObject["GRADUATION_DATE_ACTUAL"]);
                            $scope.StudentStatusesObject["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatusesObject["STATUS_PERIOD"]);
                            $scope.StudentStatusesObject["RETRO_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatusesObject["RETRO_PERIOD"]);
                            $scope.StudentStatusesObject["STUDENT_STATUS_ID"] = "" + $("#response1").text();
                            $scope.StudentStatuses.push($scope.StudentStatusesObject);

                            //alert("success");
                            ShowToasterSuccess("Student Status", "New Status Complete");
                            $scope.StudentStatusesForm = {};
                            $scope.$apply();
                        }
                        else if (storedProcedureResult == "warning") {
                            showToasterWarning("Student Status", "" + $("#response1").text());
                        }
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Status", "" + $("#response1").text());
                        }
                        else {
                            //alert("CONSULT KYLE");
                        }
                    });



                }
            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };

        $scope.EditModalStudentStatuses = function (itemId, jqueryTargetModal) {

            if (itemId == '-1') {
                //alert("new modal");
                $scope.ClearModal(jqueryTargetModal);
                $scope.ClearStudentStatusesForm();
            }
            else if ($scope.StudentStatusesForm.ModalFormId != itemId) {

                var STATUS_PERIOD_YEAR = ($scope.StudentStatuses[itemId].STATUS_PERIOD.length == 8 ? $scope.StudentStatuses[itemId].STATUS_PERIOD.substring(0, 4) : "");

                var STATUS_PERIOD_MONTH = ($scope.StudentStatuses[itemId].STATUS_PERIOD.length == 8 ? $scope.StudentStatuses[itemId].STATUS_PERIOD.substring(4, 8) : "");

                var RETRO_PERIOD_YEAR = ($scope.StudentStatuses[itemId].RETRO_PERIOD.length == 8 ? $scope.StudentStatuses[itemId].RETRO_PERIOD.substring(0, 4) : "");
                var RETRO_PERIOD_MONTH = ($scope.StudentStatuses[itemId].RETRO_PERIOD.length == 8 ? $scope.StudentStatuses[itemId].RETRO_PERIOD.substring(4, 8) : "");

                var StudentStatusesForm =
                    {
                        STATUS_PERIOD_YEAR: "" + STATUS_PERIOD_YEAR,
                        RETRO_PERIOD_YEAR: "" + RETRO_PERIOD_YEAR,
                        STATUS_PERIOD_MONTH: "" + STATUS_PERIOD_MONTH,
                        RETRO_PERIOD_MONTH: "" + RETRO_PERIOD_MONTH,
                        STATUS: "" + $scope.StudentStatuses[itemId].STATUS,
                        CURRENT_CLASS: "" + $scope.StudentStatuses[itemId].CURRENT_CLASS,
                        BORROWING: "" + $scope.StudentStatuses[itemId].BORROWING,
                        STUDENT_STATUS_ID: "" + $scope.StudentStatuses[itemId].STUDENT_STATUS_ID
                    };

                $scope.StudentStatusesForm = angular.copy(StudentStatusesForm);
                $scope.StudentStatusesForm.ModalFormId = itemId;


            }

        };

        $scope.ClearStudentStatusesForm = function () {
            $scope.StudentStatusesForm = {};
        };
        /* END StudnetStatus Functions */


        $scope.EditModalInstitutionInformation = function (itemId, jqueryTargetModal) {
        
            if ($scope.InstitutionInformationForm.INSTITUTION_ID != itemId) {
               
                $scope.InstitutionInformationForm = angular.copy($scope.InstitutionInformation);

            }

        };

        function GenerateQueryString(obj) {
            var returnStr = "";
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    if (!isNullOrWhiteSpace(obj[key])) {
                        //alert(key + ": " + fields[key]);
                        //var str = "" + obj[key];
                        returnStr += ("" + key + "=" + obj[key] + "&");
                    }
                }
            }

            returnStr = returnStr.substring(0, returnStr.length - 1);
            //alert(returnStr);
            return returnStr;
        }

        function FormatDate(date) {
            var returnString = "";
            if (!isNullOrWhiteSpace(date)) {
                var year = date.substring(0, 4);
                var month = date.substring(4, 6);
                var day = date.substring(6, 8);

                returnString = month + "/" + day + "/" + year;
            }
            return returnString;
        }
        function FormatSqlDate(date) {
            var returnDate = "";
            var zero = "0";
            var twenty = "20";
            try {
                if (!isNullOrWhiteSpace(date)) {
                    var dates = date.split('/');
                    var year = (dates[2].length == 2 ? twenty.concat(dates[2]) : dates[2]);
                    var month = (dates[0].length != 2 ? zero.concat(dates[0]) : dates[0]);
                    var day = (dates[1].length != 2 ? zero.concat(dates[1]) : dates[1]);

                    returnDate = year + month + day;
                }
            }
            catch (err) {
                throw new Error("Error Parsing SqlDate From Display Date: Date must be in the format of MM/dd/YYYY " + err);
            }

            return returnDate;
        }

        $scope.UpdateInstitutionInformation = function () {

            try {
                showToaster('Institution Information', 'Updating...');
                var InstitutionInformationObject = {
                    INSTITUTION_ID: "" + $scope.InstitutionInformationForm["INSTITUTION_ID"],
                    INSTITUTION_NAME: "" + $scope.InstitutionInformationForm["INSTITUTION_NAME"],                   
                    CITY: "" + $scope.InstitutionInformationForm["CITY"],
                    STATE_PROVINCE: "" + $scope.InstitutionInformationForm["STATE_PROVINCE"],
                    SHORT_NAME: "" + $scope.InstitutionInformationForm["SHORT_NAME"],
                    STATUS: "" + $scope.InstitutionInformationForm["STATUS"],
                    CONTRACT_DATE: FormatSqlDate("" + $scope.InstitutionInformationForm["CONTRACT_DATE"]),
                    IPEDS_ID: "" + $scope.InstitutionInformationForm["IPEDS_ID"],
                 };

                $scope.InstitutionInformationObject = angular.copy(InstitutionInformationObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_INSTITUTION&" + GenerateQueryString($scope.InstitutionInformationObject);

                //$http({ method: 'GET', url: 'http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?test=1&blah=blob' }).
                //success(function (data, status, headers, config) {
                //    alert("success: " + data);
                //}).
                //error(function (data, status, headers, config) {
                //    alert("error: " + status);
                //    });
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    //alert("success");
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {      $scope.InstitutionInformation.Institution_ID = "" + InstitutionInformationObject["Institution_ID"];
                      
                        $scope.InstitutionInformation.INSTITUTION_NAME = "" + InstitutionInformationObject["INSTITUTION_NAME"];
                        $scope.InstitutionInformation.SHORT_NAME = "" + InstitutionInformationObject["SHORT_NAME"];
                        $scope.InstitutionInformation.CITY = "" + InstitutionInformationObject["CITY"];
                        $scope.InstitutionInformation.STATE_PROVINCE = "" + InstitutionInformationObject["STATE_PROVINCE"];
                        $scope.InstitutionInformation.STATUS = "" + InstitutionInformationObject["STATUS"];
                        $scope.InstitutionInformation.IPEDS_ID = "" + InstitutionInformationObject["IPEDS_ID"];
                        $scope.InstitutionInformation.CONTRACT_DATE = FormatDate("" + InstitutionInformationObject["CONTRACT_DATE"]);
                       
                        ShowToasterSuccess("Institution Information", "Update Complete");
                        $scope.InstitutionInformationForm = {};
                        $scope.$apply();
                    }
           
                    else if (storedProcedureResult == "failure") {
                        showToasterError("Institution Information", "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Institution Information", "Consult Kyle");
                    }
                });





            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }
            //$scope.InstitutionInformation = angular.copy($scope.InstitutionInformationForm);
 
            //$scope.InstitutionInformationForm = {};

            //showToaster('Institution Information', 'Updating...');
            //clearToasts();
            //ShowToasterSuccess("Institution Information", "Update Complete!");
        };

        $scope.CohortChanged = function() 
        {
            var index;
            for (index = 0;index < $scope.CohortOptions.length; ++index)
            {
                if($scope.InstitutionLrapHistoryForm.DESCRIPTION == "" + $scope.CohortOptions[index].id)
                {
                    //alert("EQUALS " + $scope.CohortOptions[index].id);
                    $scope.InstitutionLrapHistoryForm.COHORT_ID = "" + $scope.CohortOptions[index].cohortId;
                }
            }
        }

        
    }
</script>

<script type="text/javascript">

    toastr.options.timeOut = "10000000000";
    toastr.options.closeButton = true;
    function showToaster(title, message) {

        toastr.info(message, title);
    }

    function ShowToasterSuccess(title, message) {
        toastr.success(message, title);
    }

    function clearToasts() {
        toastr.clear();
    }

    function showToasterError(title, message) {
        toastr.error(message, title);
    }

    function ShowDialog_Click(modalUrl, title) {
        var options = {
            url: modalUrl,
            title: title,
            allowMaximize: false,
            showClose: true,
            width: 800,
            dialogReturnValueCallback: myDialogCallback
        };

        SP.SOD.execute('sp.ui.dialog.js', 'SP.UI.ModalDialog.showModalDialog', options);
    }

    function isNullOrWhiteSpace(str) {
        if (typeof str !== 'undefined') {
            return (!str);
        }
        return true;
    }

    function myDialogCallback(dialogResult, data) {
        //alert("+" + dialogResult);
        //if (dialogResult == SP.UI.DialogResult.OK) {
        //    alert("User hit OK");
        //}
        //else if (dialogResult == SP.UI.DialogResult.cancel) {
        //    alert("user hit cancel");
        //}
        //else {
        //    alert("other");
        //}
        // this will refresh your page if dialogResult is successful
        SP.UI.ModalDialog.RefreshPage(dialogResult);
    }

    function UpdateDate(inputId) {
        //$hiddenInput = $("#" + hiddenInputId).first();
        var newDate = $("#" + inputId).val();

        var scope = angular.element($("#" + inputId)).scope();

        scope.$apply(function () {
           
            scope.InstitutionInformationForm.CONTRACT_DATE = newDate;
            
        });       
    }
</script>
<asp:Label ID="Label1" runat="server" Text="Label" Visible="false"></asp:Label>

<div id="nate//This is where my code starts" data-ng-app data-ng-controller="LrapController">
    <p data-ng-show="false" data-ng-repeat="h in InstitutionLrapHistorys">
        H: {{h | json}}
    </p>
    <div id="localDiv" style="display:none"></div>


    <div>

    <div class="modal fade" modaltarget="InstitutionLrapHistoryModal" id="Div6" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div style="width: 50%" class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="H9">{{InstitutionInformation.INSTITUTION_NAME}}: {{InstitutionLrapHistoryForm.DESCRIPTION}}</h4>
                </div>
                <div class="modal-body" style="width: 90%;">
                    <form class="form-horizontal">
                        <fieldset>
                            <div class="form-group" style="display: none">
                                <label class="col-md-2 control-label">ID</label>
                                <div class="col-md-10">
                                    <input type="text" title="InstitutionLrapHistoryModalFormId" data-ng-model="InstitutionLrapHistoryForm.ModalFormId" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Cohort</b></label>
                                <div class="col-md-4">
                                    <select style="width: 100%" data-ng-change="CohortChanged()" data-ng-model="InstitutionLrapHistoryForm.DESCRIPTION" data-ng-options="CohortOption.id as CohortOption.label for CohortOption in CohortOptions">
                                    </select>
                                </div>
                                <label class="col-md-2 control-label"><b>Freshmen Fee Type</b></label>
                                <div class="col-md-4">
                                    <select style="width: 100%" data-ng-model="InstitutionLrapHistoryForm.FRESHMEN_FEE_TYPE" data-ng-options="FreshmanFeeTypeOption.id as FreshmanFeeTypeOption.label for FreshmanFeeTypeOption in FreshmanFeeTypeOptions">
                                    </select>
                                </div>
                            </div>
                        </fieldset>
                        <fieldset>
                            <legend></legend>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2"></label>
                                <label style="text-align: center" class="col-md-2"><b>Annual Fee</b></label>
                                <label style="text-align: center" class="col-md-2"><b>Students</b></label>
                                <label style="text-align: center" class="col-md-3"><b>Annual Reserve</b></label>
                                <label style="text-align: center" class="col-md-3"><b>At Grad Reserve</b></label>
                            </div>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2 control-label"><b>Intro</b></label>
                                <div style="text-align: center" class="col-md-2">
                                    <input style="width: 100%" type="text"  data-ng-model="InstitutionLrapHistoryForm.INTRO_ANNUAL_FEE_AMOUNT" />
                                </div>
                                <div style="text-align: center" class="col-md-2">
                                    <input style="width: 100%" type="text"  data-ng-model="InstitutionLrapHistoryForm.INTRO_STUDENTS" />
                                </div>
                                <div class="col-md-3"></div>
                                <div class="col-md-3"></div>
                            </div>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2 control-label"><b>Freshmen</b></label>
                                <div style="text-align: right" class="col-md-2">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.FRESHMEN_ANNUAL_FEE_AMOUNT" />
                                </div>
                                <div class="col-md-2"></div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.FRESHMEN_RESERVE_ANNUAL" />
                                </div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.FRESHMEN_RESERVE_ATGRAD" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2 control-label"><b>Transfer</b></label>
                                <div style="text-align: right" class="col-md-2">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.TRANSFER_ANNUAL_FEE_AMOUNT" />
                                </div>
                                <div class="col-md-2"></div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.TRANSFER_RESERVE_ANNUAL" />
                                </div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.TRANSFER_RESERVE_ATGRAD" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2 control-label"><b>Retention</b></label>
                                <div style="text-align: right" class="col-md-2">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.RETENTION_ANNUAL_FEE_AMOUNT" />
                                </div>
                                <div class="col-md-2"></div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.RETENTION_RESERVE_ANNUAL" />
                                </div>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.RETENTION_RESERVE_ATGRAD" />
                                </div>
                            </div>
                        </fieldset>
     
                        <fieldset>
                            <legend></legend>
                            <div class="form-group">
                                <label style="text-align: center" class="col-md-2 control-label"><b>UIT</b></label>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.UPPER_INCOME_LIMIT" />
                                </div>
                                <label style="text-align: center" class="col-md-1 control-label"><b>LIT</b></label>
                                <div style="text-align: center" class="col-md-3">
                                    <input style="width: 100%" type="text" data-ng-model="InstitutionLrapHistoryForm.LOWER_INCOME_LIMIT" />
                                </div>
                                <div class="col-md-4">
                                </div>
                        </fieldset>
                    </form>
                    <%--  <table>
                        <tr style="display: none;">
                            <td style="width: 200px;">ID:
                            </td>
                            <td>
                                <input type="text" id="Text3" title="InstitutionLrapHistoryModalFormId" data-ng-model="InstitutionLrapHistoryForm.ModalFormId" />
                                <br />
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 200px">Freshmen Fee Type
                            </td>
                            <td>
                                <select data-ng-model="InstitutionLrapHistoryForm.FRESHMEN_FEE_TYPE" data-ng-options="FreshmanFeeTypeOption.id as FreshmanFeeTypeOption.label for FreshmanFeeTypeOption in FreshmanFeeTypeOptions">
                                    <option>--</option>
                                </select>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5">
                                <table>
                                    <tr>
                                        <th></th>
                                        <th>Annual Fee</th>
                                        <th>Institutions</th>
                                        <th>Annual Reserve</th>
                                        <th>Grad Reserve</th>
                                    </tr>
                                    <tr>
                                        <td><b>Intro</b></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.introAnnualFee" />
                                        </td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.introNumberOfInstitutions" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Freshmen</b></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.freshmenAnnualFee" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.freshmenAnnualReserve" />
                                        </td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.freshmenGradReserve" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Retention</b></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.retentionAnnualFee" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.retentionAnnualReserve" />
                                        </td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.retentionGradReserve" />
                                        </td>
                                    </tr>
                                    <tr>F
                                        <td><b>Transfer</b></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.transferAnnualFee" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.transferAnnualReserve" />
                                        </td>
                                        <td>
                                            <input type="text" data-ng-model="InstitutionLrapHistoryForm.transferGradReserve" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>UIT</b>
                            </td>
                            <td>
                                <input type="text" data-ng-model="InstitutionLrapHistoryForm.UPPER_INCOME_LIMIT" />
                            </td>
                            <td>
                                <b>LIT</b>
                            </td>
                            <td>
                                <input type="text" data-ng-model="InstitutionLrapHistoryForm.LOWER_INCOME_LIMIT" />
                            </td>


                        </tr>

                    </table>--%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=InstitutionLrapHistoryModal]');">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary" data-ng-click="AddInstitutionLrapHistory();HideModal('[modaltarget=InstitutionLrapHistoryModal]')">
                        Submit
                    </button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->

    <!--Institution Information Modal -->
    <div class="modal fade" modaltarget="InstitutionInformationModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div style="width: 98%" class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="H9">Edit {{InstitutionInformation.INSTITUTION_NAME}}</h4>
                </div>
                <div class="modal-body" style="width: 90%;">
                    <form class="form-horizontal">
                        <fieldset>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>LRAP School ID</b></label>
                                <div class="col-md-10">
                                    <input type="text" disabled="disabled" title="InstitutionInformationModalFormId" data-ng-model="InstitutionInformationForm.INSTITUTION_ID" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>School Name</b></label>
                                <div class="col-md-10">
                                    <input type="text" title="InstitutionInformationModalFormId" data-ng-model="InstitutionInformationForm.INSTITUTION_NAME" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>City</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionInformationForm.CITY">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>State/Province</b></label>
                                <div class="col-md-10">
                                    <input data-ng-model="InstitutionInformationForm.STATE_PROVINCE" class="form-control" type="text">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Short Name</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionInformationForm.SHORT_NAME">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Status</b></label>
                                <div class="col-md-5">
                                    <select data-ng-model="InstitutionInformationForm.STATUS" data-ng-options="InstitutionStatusOption.id as InstitutionStatusOption.label for InstitutionStatusOption in InstitutionStatusOptions">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Contract Date</b></label>
                                <div class="col-md-10">
                                     <div class="input-icon-right">
                                              <i class="fa fa-calendar"></i>
                                              <input id="InstitutionInformationFormCONTRACT_DATE" data-ng-model="InstitutionInformationForm.CONTRACT_DATE" onchange="UpdateDate('InstitutionInformationFormCONTRACT_DATE')" type="text" name="mydate" class="form-control datepicker" data-dateformat="mm/dd/yy" />                                                                                                                                          
                                     </div>
                                    <%--<input class="form-control" type="text" data-ng-model="InstitutionInformationForm.CONTRACT_DATE">--%>
                                </div>
                            </div>
                     
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>LRAF</b></label>
                                <div class="col-md-5">
                                    <label class="radio radio-inline">
                                        <input type="radio" name="InstitutionInformation_LRAF" value="Y" data-ng-model="InstitutionInformationForm.INSTITUTION_LRAF">
                                        Yes
                                    </label>
                                    <label class="radio radio-inline">
                                        <input type="radio" name="InstitutionInformation_LRAF" value="N" data-ng-model="InstitutionInformationForm.INSTITUTION_LRAF">
                                        No
                                    </label>

                                </div>
                            </div>
                             <div class="form-group">
                                <label class="col-md-2 control-label"><b>IPEDS ID</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionInformationForm.IPEDS_ID">                                 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Carnegie Classification</b></label>
                                <div class="col-md-10">
                                    <textarea disabled="disabled" data-ng-model="InstitutionInformationForm.CARNEGIE_CLASSIFICATION" class="form-control" rows="4"></textarea>
                                </div>
                            </div>


                        </fieldset>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=InstitutionInformationModal]');">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary" data-ng-click="UpdateInstitutionInformation();HideModal('[modaltarget=InstitutionInformationModal]');">
                        Submit
                    </button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!--End Institution Information Modal -->

    <!-- row -->
    <div class="row">


        <!-- end col -->
        <!-- right side of the page with the sparkline graphs -->
        <!-- col -->

        <!-- end col -->

    </div>
    <!-- end row -->
    <!--
        The ID "widget-grid" will start to initialize all widgets below
        You do not need to use widgets if you dont want to. Simply remove
        the <section></section> and you can use wells or panels instead
        -->
    <!-- widget grid -->
    <section id="widget-grid" class="">

        <!-- START ROW -->
        <div class="row">

            <!-- NEW COL START -->
            <article style="max-width:750px" class="col-sm-12 col-md-9 col-lg-8">

                <!-- Widget ID (each widget will need unique ID)-->
                <div class="jarviswidget" id="wid-id-0" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
                    <!-- widget options:
                        usage: <div class="jarviswidget" id="wid-id-0" data-widget-editbutton="false">

                        data-widget-colorbutton="false"
                        data-widget-editbutton="false"
                        data-widget-togglebutton="false"
                        data-widget-deletebutton="false"
                        data-widget-fullscreenbutton="false"
                        data-widget-custombutton="false"
                        data-widget-collapsed="true"
                        data-widget-sortable="false"

                        -->
                    <header>
                        <h2 style="padding-right: 5px">Institution Information</h2>
                        <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionInformation(InstitutionInformation.INSTITUTION_ID, '[modaltarget=InstitutionInformationModal]')" data-target="[modaltarget='InstitutionInformationModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a>
                        <%--<asp:Literal ID="Institution_Information_Edit_Button" runat="server"></asp:Literal>--%>
                    </header>


                    <!-- NEW ANGULAR CONTENT -->

                    <!-- widget div-->
                    <div>

                        <!-- widget edit box -->
                        <div class="jarviswidget-editbox">
                            <!-- This area used as dropdown edit box -->

                        </div>
                        <!-- end widget edit box -->
                        <!-- widget content  <p>Abilene Christian University</p>  -->
                        <div class="widget-body no-padding">

                            <div class="smart-form">


                                <fieldset id="InstitutioninformationFieldset">
                                    <div class="row">
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>School Name</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.INSTITUTION_NAME}}
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>Contract Date</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.CONTRACT_DATE}}
                                            </div>
                                        </section>
                                    </div>
                                    <div class="row">
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>City/State</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.CITY}}, {{InstitutionInformation.STATE_PROVINCE}}
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>LRAF</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.INSTITUTION_LRAF}}
                                            </div>
                                        </section>
                                    </div>
                                    <div class="row">
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>Short Name</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.SHORT_NAME}}
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>Freshmen Type</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.FRESHMEN_FEE_TYPE}}
                                            </div>
                                        </section>
                                    </div>
                                    <div class="row">
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>LRAP School ID</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.INSTITUTION_ID}}
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                             <div class="col col-5">
                                                <p><b>IPEDS ID</b></p>
                                            </div>
                                            <div class="col col-7">
                                                <p>{{InstitutionInformation.IPEDS_ID}}</p>
                                            </div>                                          
                                        </section>
                                    </div>
                                    <div class="row">
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>Status</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.STATUS}}
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <div class="col col-5">
                                                <p><b>Carnegie Clas.</b></p>
                                            </div>
                                            <div class="col col-7">
                                                {{InstitutionInformation.CARNEGIE_CLASSIFICATION}}
                                            </div>
                                        </section>
                                    </div>
                                </fieldset>
                                <!--
                                    <header>
                                        LRAP History
                                    </header>
                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p>School Name</p>
                                                </div>
                                                <div class="col col-7">
                                                    <p>Abilene Christian University</p>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p>Contract Date</p>
                                                </div>
                                                <div class="col col-7">
                                                    <p>5/1/2010</p>
                                                </div>
                                            </section>
                                        </div>
                                    </fieldset>
                                    -->

                            </div>

                        </div>
                        <!-- end widget content -->

                    </div>
                    <!-- end widget div -->

                    <!-- END NEW ANGULAR CONTENT -->
                    <!-- OLD CONTENT -->

                    <%--  <!-- widget div-->
                                <div>

                                    <!-- widget edit box -->
                                    <div class="jarviswidget-editbox">
                                        <!-- This area used as dropdown edit box -->

                                    </div>
                                    <!-- end widget edit box -->
                                    <!-- widget content  <p>Abilene Christian University</p>  -->
                                    <div class="widget-body no-padding">

                                        <div class="smart-form">
                                            

                                            <fieldset>
                                                <div class="row">
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>School Name</p>
                                                        </div>
                                                        <div class="col col-7">                                                    
                                                            <asp:Literal runat="server" ID="Institution_Info_School_Name" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>Contract Date</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_Contract_Date" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                </div>
                                                <div class="row">
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>City/State</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_City_State" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>LRAF</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_LRAF" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                </div>
                                                <div class="row">
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>Short Name</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_Short_Name" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>Freshmen Type</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_Freshmen_Type" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                </div>
                                                <div class="row">
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>LRAP School ID</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_LRAP_School_ID" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>Carnegie Clas.</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_Carnegie" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                </div>
                                                <div class="row">
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p>Status</p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <asp:Literal runat="server" ID="Institution_Info_Status" ></asp:Literal>
                                                        </div>
                                                    </section>
                                                    <section class="col col-6">
                                                        <div class="col col-5">
                                                            <p></p>
                                                        </div>
                                                        <div class="col col-7">
                                                            <p></p>
                                                        </div>
                                                    </section>
                                                </div>
                                            </fieldset>
                                            <!--
                                    <header>
                                        LRAP History
                                    </header>
                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p>School Name</p>
                                                </div>
                                                <div class="col col-7">
                                                    <p>Abilene Christian University</p>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p>Contract Date</p>
                                                </div>
                                                <div class="col col-7">
                                                    <p>5/1/2010</p>
                                                </div>
                                            </section>
                                        </div>
                                    </fieldset>
                                    -->
                                            
                                        </div>

                                    </div>
                                    <!-- end widget content -->

                                </div>
                                <!-- end widget div -->--%>
                    <!-- END OLD CONTENT -->

                </div>
                <!-- end widget -->

            </article>
            <!-- END COL -->

        </div>

        <!-- row -->
        <div class="row">

            <!-- NEW WIDGET START -->
            <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                <!-- Widget ID (each widget will need unique ID)-->
                <div class="jarviswidget" id="wid-id-1" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
                    <!-- widget options:
        usage: <div class="jarviswidget" id="wid-id-0" data-widget-editbutton="false">

        data-widget-colorbutton="false"
        data-widget-editbutton="false"
        data-widget-togglebutton="false"
        data-widget-deletebutton="false"
        data-widget-fullscreenbutton="false"
        data-widget-custombutton="false"
        data-widget-collapsed="true"
        data-widget-sortable="false"

        -->
                    <header>
                        <h2 style="padding-right: 5px">LRAP History</h2>
                        <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory('-1', '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>
                        <%--<asp:Literal ID="Institution_LRAP_History_New_Button" runat="server"></asp:Literal>--%>
                    </header>

                    <!-- widget div-->
                    <div>

                        <!-- widget edit box -->
                        <div class="jarviswidget-editbox">
                            <!-- This area used as dropdown edit box -->

                        </div>
                        <!-- end widget edit box -->
                        <!-- widget content -->
                        <div class="widget-body no-padding">

                            <table id="datatable_tabletools_nonsort" class="table table-striped table-hover" width="100%">
                                <thead>
                                    <tr>
                                        <th style="width:22%">Cohort</th>
                                        <th></th>
                                        <th>Fee Type</th>
                                        <th>Annual Fee</th>
                                        <th>UIT</th>
                                        <th>LIT</th>
                                        <th># of Students</th>
                                        <th># of Borrowers</th>

                                    </tr>
                                </thead>
                                <tbody data-ng-repeat="history in InstitutionLrapHistory" > <%--data-ng-init="historyCount = $index"--%>
                                    <%--<tr data-ng-repeat="fee in history.LRAP_FEES" data-ng-init="feeCount = $index">
                                        <td><span data-ng-show="feeCount == 0">{{history.DESCRIPTION}}</span></td>
                                        <td><span data-ng-show="feeCount == 0"><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory(historyCount, '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></span></td>
                                        <td>{{fee.FEE_TYPE}} </td>
                                        <td>{{fee.ANNUAL_FEE_AMOUNT}} <span data-ng-show="fee.FEE_TYPE == 'Intro'">({{history.INTRO_InstitutionS}})</span> </td>
                                        <td>{{history.UPPER_INCOME_LIMIT}} </td>
                                        <td>{{history.LOWER_INCOME_LIMIT}} </td>
                                        <td></td>
                                        <td></td>
                                    </tr>--%>
                                    <tr data-ng-show="null != history.INTRO_INSTITUTION_LRAP_FEE_ID">
                                        <td>{{history.DESCRIPTION}}: {{history.FRESHMEN_FEE_TYPE}}</td>
                                        <td><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory($index, '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></td>
                                        <td>Intro</td>
                                        <td>{{history.INTRO_ANNUAL_FEE_AMOUNT | currency:"$" }} ({{history.INTRO_STUDENTS}})</td>
                                        <td>{{history.UPPER_INCOME_LIMIT | number:0 }} </td>
                                        <td>{{history.LOWER_INCOME_LIMIT | number:0 }} </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr data-ng-show="null != history.FRESHMEN_INSTITUTION_LRAP_FEE_ID">
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID"> {{history.DESCRIPTION}}: {{history.FRESHMEN_FEE_TYPE}}</span></td>
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID"><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory($index, '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></span></td>
                                        <td>Freshmen</td>
                                        <td>{{history.FRESHMEN_ANNUAL_FEE_AMOUNT | currency:"$"}}</td>
                                        <td>{{history.UPPER_INCOME_LIMIT | number:0 }} </td>
                                        <td>{{history.LOWER_INCOME_LIMIT | number:0 }} </td>
                                        <td></td>
                                        <td></td>
                                    </tr>                              
                                    <tr data-ng-show="null != history.TRANSFER_INSTITUTION_LRAP_FEE_ID">
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID && null == history.FRESHMEN_INSTITUTION_LRAP_FEE_ID "> {{history.DESCRIPTION}}: {{history.FRESHMEN_FEE_TYPE}}</span></td>
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID && null == history.FRESHMEN_INSTITUTION_LRAP_FEE_ID"> <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory($index, '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></span></td>
                                        <td>Transfer</td>
                                        <td>{{history.TRANSFER_ANNUAL_FEE_AMOUNT | currency:"$"}}</td>
                                        <td>{{history.UPPER_INCOME_LIMIT | number:0 }} </td>
                                        <td>{{history.LOWER_INCOME_LIMIT | number:0 }} </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr data-ng-show="null != history.RETENTION_INSTITUTION_LRAP_FEE_ID">
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID && null == history.FRESHMEN_INSTITUTION_LRAP_FEE_ID && null == history.TRANSFER_INSTITUTION_LRAP_FEE_ID"> {{history.DESCRIPTION}}: {{history.FRESHMEN_FEE_TYPE}}</span></td>
                                        <td><span data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID && null == history.FRESHMEN_INSTITUTION_LRAP_FEE_ID && null == history.TRANSFER_INSTITUTION_LRAP_FEE_ID"> <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalInstitutionLrapHistory($index, '[modaltarget=InstitutionLrapHistoryModal]')" data-target="[modaltarget='InstitutionLrapHistoryModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></span></td>
                                        <td>Retention</td>
                                        <td>{{history.RETENTION_ANNUAL_FEE_AMOUNT | currency:"$" }}</td>
                                        <td>{{history.UPPER_INCOME_LIMIT | number:0 }} </td>
                                        <td>{{history.LOWER_INCOME_LIMIT | number:0 }} </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr data-ng-show="null == history.INTRO_INSTITUTION_LRAP_FEE_ID && null == history.FRESHMEN_INSTITUTION_LRAP_FEE_ID && null == history.TRANSFER_INSTITUTION_LRAP_FEE_ID && null == history.RETENTION_INSTITUTION_LRAP_FEE_ID">
                                        <td>{{history.DESCRIPTION}}: {{history.FRESHMEN_FEE_TYPE}}</td>
                                        <td></td>
                                        <td></td>
                                        <td><b>No Fees Recorded</b></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>


                                    <!--  <asp:Literal ID="Institution_LRAP_History" runat="server"></asp:Literal>
                                                    <!--
                                                    <tr>
                                                        <td>2010 - 2011: Selective Freshmen</td>
                                                        <td>Intro (#)</td>
                                                        <td>$1,100 (20)</td>
                                                        <td>11</td>
                                                        <td>11</td>
                                                        <td>$37,000</td>
                                                        <td>$20,000</td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Freshmen</td>
                                                        <td>$1,250</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Retention</td>
                                                        <td>$1,375</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Transfer</td>
                                                        <td>$1,579</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>2011 - 2012: All Freshmen</td>
                                                        <td>Freshmen</td>
                                                        <td>$1,250</td>
                                                        <td>117</td>
                                                        <td>88</td>
                                                        <td>$37,000</td>
                                                        <td>$20,000</td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Retention</td>
                                                        <td>$1,375</td>
                                                        <td>2</td>
                                                        <td>2</td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Transfer</td>
                                                        <td>$1,579</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td>2012 - 2013: Selective Freshmen</td>
                                                        <td>Freshmen</td>
                                                        <td>$1,250</td>
                                                        <td>125</td>
                                                        <td>95</td>
                                                        <td>$37,000</td>
                                                        <td>$20,000</td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Retention</td>
                                                        <td>$1,375</td>
                                                        <td>9</td>
                                                        <td>9</td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>Transfer</td>
                                                        <td>$1,579</td>
                                                        <td>2</td>
                                                        <td>2</td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr> -->
                                </tbody>
                            </table>

                        </div>
                    </div>
                    <!-- end widget content -->

                </div>
                <!-- end widget div -->
            </article>
        </div>

        <!-- row -->
        <div class="row">

            <!-- NEW WIDGET START -->
            <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                <!-- Widget ID (each widget will need unique ID)-->
                <div class="jarviswidget" id="wid-id-2" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
                    <!-- widget options:
        usage: <div class="jarviswidget" id="wid-id-0" data-widget-editbutton="false">

        data-widget-colorbutton="false"
        data-widget-editbutton="false"
        data-widget-togglebutton="false"
        data-widget-deletebutton="false"
        data-widget-fullscreenbutton="false"
        data-widget-custombutton="false"
        data-widget-collapsed="true"
        data-widget-sortable="false"

        -->
                    <header>
                        <h2 style="padding-right: 5px">School Documents</h2>
                        <a href="#" style="color: black; margin-top: 5px; padding-right: 5px" onclick='window.location=newDocTitleLink;' class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>

                    </header>

                    <!-- widget div-->
                    <div>

                        <!-- widget edit box -->
                        <div class="jarviswidget-editbox">
                            <!-- This area used as dropdown edit box -->

                        </div>
                        <!-- end widget edit box -->
                        <!-- widget content -->
                        <div class="widget-body">
                            <div id="demo">
                            </div>
                            <%--<span data-ng-repeat="doc in InstitutionDocuments" class="widget-icon"><i class="fa fa-file-word-o"></i>{{doc.FileName}}</span><br />                        --%>
                        </div>
                    </div>
                </div>
            </article>
    </section>
    <!-- end widget grid -->


</div>
