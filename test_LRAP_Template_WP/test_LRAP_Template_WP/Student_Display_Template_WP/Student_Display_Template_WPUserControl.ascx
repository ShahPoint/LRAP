<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Student_Display_Template_WPUserControl.ascx.cs" Inherits="test_LRAP_Template_WP.Student_Display_Template_WP.Student_Display_Template_WPUserControl" %>

<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.21/angular.min.js"></script>
<link type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
<script type="text/javascript" src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script type="text/javascript">

    $(document).ready(function () {
        $('#demo').html('<table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-hover" id="example2"></table>');

        $('#example2').dataTable({
            "data": ASP_StudentDocuments,
            "columns": [
                { "title": "Document", "width": "20%" },

            ],
            "lengthMenu": [[100, 50, 25, 10], [100, 50, 25, 10]]
        });
    });

</script>
<asp:Literal ID="StudentDocumentsLiteral" runat="server"></asp:Literal>

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

    function LrapController($scope, $filter, $http) {

        /* On page load the Controller Needs to Look into the URL for
			       an id ( pcrid='' )

			If not present, the code will need to create a new item upon first save

			If present, all saves will have to edit that item.

			pcrid is the id of the sharepoint item in the list
			*/
        $scope.studentId = getParameterByName("studentId");
        //$scope.studentLrapDetailsId = StudentLrapDetailsStatusId; //From C#
        // $scope.StudentInfoForm = studentInfoObject;
        $scope.StudentStatusForm = {};
        $scope.StudentLrapDetailsForm = {};
        //$scope.StudentDemoForm = studentDemoObject;
        $scope.StudentLoansForm = {};
        //$scope.studentStatus = studentStatuses; //from C#
        // $scope.studentDemoId = studentDemographicsId; //from C#
        // $scope.studentAddress = studentAddresses; //from C#
        //$scope.studentLoan = studentLoans; //from c#
        //$scope.lrapStudentId = lrapStudentID;
        //$scope.StudentLrapDetailsForm = StudentLrapDetailsObject;
        $scope.isNullOrWhiteSpace = function (str) {
            if (typeof str !== 'undefined') {
                return (!str);
            }
            return true;
        };

        function FormatDate(date) {
            var returnString = "";
            if (!$scope.isNullOrWhiteSpace(date)) {
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
                if (!$scope.isNullOrWhiteSpace(date)) {
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

        $scope.StudentInformation = angular.copy(ASP_StudentInformation);
        $scope.StudentInformationForm = {};
        $scope.StudentInformation["GRADUATION_DATE_ACTUAL"] = FormatDate("" + $scope.StudentInformation["GRADUATION_DATE_ACTUAL"]);

        $scope.StudentStatuses = angular.copy(ASP_StudentStatuses);
        $scope.StudentStatusesForm = {};
        var i;
        for (i = 0; i < $scope.StudentStatuses.length ; ++i) {
            $scope.StudentStatuses[i]["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatuses[i]["STATUS_PERIOD"]);
        }
        for (i = 0; i < $scope.StudentStatuses.length ; ++i) {
            $scope.StudentStatuses[i]["RETRO_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentStatuses[i]["RETRO_PERIOD"]);
        }

        $scope.StudentLrapDetails = angular.copy(ASP_StudentLrapDetails);
        $scope.StudentLrapDetailsForm = {};

        $scope.StudentDemo = angular.copy(ASP_StudentDemo);
        $scope.StudentDemoForm = {};
        $scope.StudentDemo["BIRTHDATE"] = FormatDate($scope.StudentDemo["BIRTHDATE"]);

        $scope.StudentAddress = angular.copy(ASP_StudentAddress);
        $scope.StudentAddressForm = {};


        $scope.StudentLoans = angular.copy(ASP_StudentLoans);
        $scope.StudentLoansForm = {};
        for (i = 0; i < $scope.StudentLoans.length ; ++i) {
            $scope.StudentLoans[i]["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentLoans[i]["STATUS_PERIOD"]);
        }

        $scope.InstitutionOptions = angular.copy(ASP_InstitutionOptions);
        $scope.CohortOptions = angular.copy(ASP_CohortOptions);
        $scope.FeeTypeOptions = [{ id: "Intro", label: "Intro" }, { id: "Freshmen", label: "Freshmen" }, { id: "Retention", label: "Retention" }, { id: "Transfer", label: "Transfer" }];
        $scope.CurrentClassOptions = [{ id: "FR", label: "FR" }, { id: "SO", label: "SO" }, { id: "JR", label: "JR" }, { id: "SR", label: "SR" }, { id: "5YR", label: "5YR" }, { id: "Not Enrolled", label: "Not Enrolled" }];
        $scope.LrapYearsOptions = [{ id: "2007", label: "2007" },
															{ id: "2008", label: "2008" },
															{ id: "2009", label: "2009" },
															{ id: "2010", label: "2010" },
															    { id: "2011", label: "2011" },
															        { id: "2012", label: "2012" },
															            { id: "2013", label: "2013" },
															                { id: "2014", label: "2014" },
															                    { id: "2015", label: "2015" },
															                        { id: "2016", label: "2016" },
															                            { id: "2017", label: "2017" },
															                                { id: "2018", label: "2018" },
															                                    { id: "2019", label: "2019" },
															{ id: "2020", label: "2020" }];

        $scope.StatusOptions = [{ id:"Enrolled", label:"Enrolled"},
        { id:"Graduated", label:"Graduated"},
        { id:"Withdrawn", label: "Withdrawn"},
        { id:"Not Enrolled", label: "Not Enrolled" },
        { id: "Hold/Temp Leave", label: "Hold/Temp Leave" }];
        $scope.AdmittedClassOptions = [
            {
                "id": "FR",
                "label": "Freshmen"
            },
            {
                "id": "SO",
                "label": "Sophomore"
            },
            {
                "id": "JR",
                "label": "Junior"
            },
            {
                "id": "SR",
                "label": "Senior"
            }
        ];

        $scope.LoanTypeOptions = [{ id: "1000000", label: "Direct Subsidized" },
                                        { id: "1000001", label: "Direct Unsubsidized" },
                                        { id: "1000002", label: "Perkins" },
                                        { id: "1000003", label: "Private/Alternative" },
                                        { id: "1000004", label: "Parent PLUS" },
                                        { id: "1000005", label: "Quest (State)" },
                                        { id: "1000006", label: "Unknown" }];
        

        /* nEW ANGULAR JS FUNCTONS */
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


        /*StudentInformation Functions */
        $scope.EditModalStudentInformation = function (formStudentId, jqueryTargetModal) {

            if ($scope.StudentInformationForm.STUDENT_ID != formStudentId) {

                $scope.StudentInformationForm = angular.copy($scope.StudentInformation);

            }

        };

        $scope.UpdateStudentInformation = function () {

            try {
                showToaster('Student Information', 'Updating...');
                var StudentInformationObject = {
                    STUDENT_ID: "" + $scope.StudentInformationForm["STUDENT_ID"],
                    INSTITUTION_ID: "" + $scope.StudentInformationForm["INSTITUTION_ID"],
                    FIRST_NAME: "" + $scope.StudentInformationForm["FIRST_NAME"],
                    LAST_NAME: "" + $scope.StudentInformationForm["LAST_NAME"],
                    LRAP_STUDENT_ID: "" + $scope.StudentInformationForm["LRAP_STUDENT_ID"],
                    INSTITUTION_STUDENT_ID: "" + $scope.StudentInformationForm["INSTITUTION_STUDENT_ID"],
                    MIDDLE_NAME: "" + $scope.StudentInformationForm["MIDDLE_NAME"],
                    MAIDEN_LAST_NAME: "" + $scope.StudentInformationForm["MAIDEN_LAST_NAME"],
                    PHONE_1: "" + $scope.StudentInformationForm["PHONE_1"],
                    PHONE_2: "" + $scope.StudentInformationForm["PHONE_2"],
                    EMAIL_1: "" + $scope.StudentInformationForm["EMAIL_1"],
                    EMAIL_2: "" + $scope.StudentInformationForm["EMAIL_2"],
                    PARENT_EMAIL_1: "" + $scope.StudentInformationForm["PARENT_EMAIL_1"],
                    PARENT_EMAIL_2: "" + $scope.StudentInformationForm["PARENT_EMAIL_2"],
                    ADMITTED_CLASS: "" + $scope.StudentInformationForm["ADMITTED_CLASS"],
                    GRADUATION_DATE_ACTUAL: FormatSqlDate("" + $scope.StudentInformationForm["GRADUATION_DATE_ACTUAL"])
                };

                $scope.StudentInformationObject = angular.copy(StudentInformationObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_INFORMATION&" + GenerateQueryString($scope.StudentInformationObject);

                //$http({ method: 'GET', url: 'http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?test=1&blah=blob' }).
                //success(function (data, status, headers, config) {
                //    alert("success: " + data);
                //}).
                //error(function (data, status, headers, config) {
                //    alert("error: " + status);
                //    });
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {
                        $scope.StudentInformation.STUDENT_ID = "" + StudentInformationObject["STUDENT_ID"];
                        $scope.StudentInformation.INSTITUTION_ID = "" + StudentInformationObject["INSTITUTION_ID"];
                        $scope.StudentInformation.FIRST_NAME = "" + StudentInformationObject["FIRST_NAME"];
                        $scope.StudentInformation.LAST_NAME = "" + StudentInformationObject["LAST_NAME"];
                        $scope.StudentInformation.LRAP_STUDENT_ID = "" + StudentInformationObject["LRAP_STUDENT_ID"];
                        $scope.StudentInformation.INSTITUTION_STUDENT_ID = "" + StudentInformationObject["INSTITUTION_STUDENT_ID"];
                        $scope.StudentInformation.MIDDLE_NAME = "" + StudentInformationObject["MIDDLE_NAME"];
                        $scope.StudentInformation.MAIDEN_LAST_NAME = "" + StudentInformationObject["MAIDEN_LAST_NAME"];
                        $scope.StudentInformation.PHONE_1 = "" + StudentInformationObject["PHONE_1"];
                        $scope.StudentInformation.PHONE_2 = "" + StudentInformationObject["PHONE_2"];
                        $scope.StudentInformation.EMAIL_1 = "" + StudentInformationObject["EMAIL_1"];
                        $scope.StudentInformation.EMAIL_2 = "" + StudentInformationObject["EMAIL_2"];
                        $scope.StudentInformation.PARENT_EMAIL_1 = "" + StudentInformationObject["PARENT_EMAIL_1"];
                        $scope.StudentInformation.PARENT_EMAIL_2 = "" + StudentInformationObject["PARENT_EMAIL_2"];
                        $scope.StudentInformation.ADMITTED_CLASS = "" + StudentInformationObject["ADMITTED_CLASS"];
                        $scope.StudentInformation.GRADUATION_DATE_ACTUAL = FormatDate("" + StudentInformationObject["GRADUATION_DATE_ACTUAL"]);

                        ShowToasterSuccess("Student Information", "Update Complete");
                        $scope.StudentInformationForm = {};
                        $scope.$apply();
                    }
                    else if (storedProcedureResult == "warning") {
                        showToasterWarning("Student Information", "" + $("#response1").text());
                    }
                    else if (storedProcedureResult == "failure") {
                        showToasterError("Student Information", "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Student Information", "Consult Kyle");
                    }
                });





            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };
        /*END StudentInformation Functions */





        /* StudnetStatus Functions */
        $scope.AddStudentStatuses = function () {
            try {
                showToaster('Student Information', 'Updating...');
                var STATUS_PERIOD = $scope.StudentStatusesForm.STATUS_PERIOD_YEAR.concat($scope.StudentStatusesForm.STATUS_PERIOD_MONTH);
                
                if (STATUS_PERIOD.length != 8 ) {
                    throw new Error("Please select both radio and dropdown option for Status Period");
                }

                var RETRO_PERIOD = "";
                if ($scope.StudentStatusesForm.RETRO_PERIOD_YEAR && $scope.StudentStatusesForm.RETRO_PERIOD_MONTH)
                {
                    RETRO_PERIOD = $scope.StudentStatusesForm.RETRO_PERIOD_YEAR.concat($scope.StudentStatusesForm.RETRO_PERIOD_MONTH);
                }
               

                //var CALC_FEE = "0";
                //if (("" + $scope.StudentStatusesForm.BORROWING) == "Y")
                //{                  
                //    CALC_FEE = "" + $scope.StudentLrapDetails.ANNUAL_FEE_AMOUNT;
                //}
                //else if (("" + $scope.StudentStatusesForm.BORROWING) == "N") {
                //    CALC_FEE = "0";
                //}
                //else {
                //    throw new Error("Please select an option for Borrowing");
                //}

                //var CALC_FEE = "0";
                //if (("" + $scope.StudentStatusesForm.BORROWING) == "Y") {
                //    CALC_FEE = "" + $scope.StudentLrapDetails.ANNUAL_FEE_AMOUNT;
                //}
                //else if (("" + $scope.StudentStatusesForm.BORROWING) == "N") {
                //    CALC_FEE = "0";
                //}
                //else {
                //    throw new Error("Please select an option for Borrowing");
                //}



                var StudentStatusesObject =
                    {
                        STATUS_PERIOD: "" + STATUS_PERIOD,
                        RETRO_PERIOD: "" + RETRO_PERIOD,
                        STATUS: "" + $scope.StudentStatusesForm.STATUS,
                        CURRENT_CLASS: "" + $scope.StudentStatusesForm.CURRENT_CLASS,
                        BORROWING: "" + $scope.StudentStatusesForm.BORROWING
                        
                    };

                //CALC_FEE: "" + CALC_FEE
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
                            $scope.StudentStatusesObject["CALC_FEE"] = "" + $scope.StudentStatuses[formId].CALC_FEE;
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
                    StudentStatusesObject["CALC_FEE"] = null;
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

        /*StudentLrapDetails Functions */
        $scope.EditModalStudentLrapDetails = function (formStudentId, jqueryTargetModal) {


            if ($scope.StudentLrapDetailsForm.STUDENT_ID != formStudentId) {

                //alert("filling");
                var StudentLrapDetailsForm = {
                    STUDENT_ID: "" + $scope.StudentInformation["STUDENT_ID"],
                    AWARD_LETTER: "" + $scope.StudentInformation["AWARD_LETTER"],
                    COHORT_ID: "" + $scope.StudentInformation["COHORT_ID"],
                    FEE_TYPE: "" + $scope.StudentInformation["FEE_TYPE"]
                };

                $scope.StudentLrapDetailsForm = angular.copy(StudentLrapDetailsForm);
            }
        };

        $scope.UpdateStudentLrapDetails = function () {

            try {
                showToaster('Student LRAP Details', 'Updating...');
                var StudentLrapDetailsObject = {
                    STUDENT_ID: "" + $scope.StudentLrapDetailsForm["STUDENT_ID"],
                    AWARD_LETTER: "" + $scope.StudentLrapDetailsForm["AWARD_LETTER"],
                    COHORT_ID: "" + $scope.StudentLrapDetailsForm["COHORT_ID"],
                    FEE_TYPE: "" + $scope.StudentLrapDetailsForm["FEE_TYPE"]

                };

                $scope.StudentLrapDetailsObject = angular.copy(StudentLrapDetailsObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_LRAP_DETAILS&" + GenerateQueryString($scope.StudentLrapDetailsObject);

                //$http({ method: 'GET', url: 'http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?test=1&blah=blob' }).
                //success(function (data, status, headers, config) {
                //    alert("success: " + data);
                //}).
                //error(function (data, status, headers, config) {
                //    alert("error: " + status);
                //    });
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {
                      
                        $scope.StudentInformation.AWARD_LETTER = "" + $scope.StudentLrapDetailsObject["AWARD_LETTER"];
                        $scope.StudentInformation.COHORT_ID = "" + $scope.StudentLrapDetailsObject["COHORT_ID"];
                        $scope.StudentInformation.FEE_TYPE = "" + $scope.StudentLrapDetailsObject["FEE_TYPE"];

                        ShowToasterSuccess("Student LRAP Details", "Update Complete");
                        $scope.StudentLrapDetailsForm = {};
                        $scope.$apply();
                    }
                    else if (storedProcedureResult == "warning") {
                        showToasterWarning("Student LRAP Details", "" + $("#response1").text());
                    }
                    else if (storedProcedureResult == "failure") {
                        showToasterError("Student LRAP Details", "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Uh Oh", "Uncaught Error. If problem persists, please file a bug with Kyle and Jay.  Thanks");
                    }
                });
            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };
        /*END StudentLrapDetails Functions */

        /*StudentDemo Functions */
        $scope.EditModalStudentDemo = function (formStudentId, jqueryTargetModal) {


            if ($scope.StudentDemoForm.STUDENT_DEMOGRAPHICS_ID != formStudentId) {


                var StudentDemoForm = {
                    STUDENT_DEMOGRAPHICS_ID: "" + $scope.StudentDemo["STUDENT_DEMOGRAPHICS_ID"],
                    GPA_HS: "" + $scope.StudentDemo["GPA_HS"],
                    GPA_UNIV: "" + $scope.StudentDemo["GPA_UNIV"],
                    MAJOR_ADMITTED: "" + $scope.StudentDemo["MAJOR_ADMITTED"],
                    MAJOR_CURRENT: "" + $scope.StudentDemo["MAJOR_CURRENT"],
                    SAT: "" + $scope.StudentDemo["SAT"],
                    ACT: "" + $scope.StudentDemo["ACT"],
                    GENDER: "" + $scope.StudentDemo["GENDER"],
                    BIRTHDATE: "" + $scope.StudentDemo["BIRTHDATE"],
                    EFC: "" + $scope.StudentDemo["EFC"]
                };

                $scope.StudentDemoForm = angular.copy(StudentDemoForm);
            }
        };

        $scope.UpdateStudentDemo = function () {

            try {

                showToaster('Student Demographics', 'Updating...');
                var StudentDemoObject = {
                    STUDENT_DEMOGRAPHICS_ID: "" + $scope.StudentDemoForm["STUDENT_DEMOGRAPHICS_ID"],
                    BIRTHDATE: FormatSqlDate("" + $scope.StudentDemoForm["BIRTHDATE"]),
                    EFC: "" + $scope.StudentDemoForm["EFC"],
                    ACT: "" + $scope.StudentDemoForm["ACT"],
                    SAT: "" + $scope.StudentDemoForm["SAT"],
                    GPA_HS: "" + $scope.StudentDemoForm["GPA_HS"],
                    GPA_UNIV: "" + $scope.StudentDemoForm["GPA_UNIV"],
                    MAJOR_ADMITTED: "" + $scope.StudentDemoForm["MAJOR_ADMITTED"],
                    MAJOR_CURRENT: "" + $scope.StudentDemoForm["MAJOR_CURRENT"],
                    GENDER: "" + $scope.StudentDemoForm["GENDER"]
                };

                $scope.StudentDemoObject = angular.copy(StudentDemoObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_DEMOGRAPHICS&" + GenerateQueryString($scope.StudentDemoObject);

            
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {
                        $scope.StudentDemo.GENDER = "" + $scope.StudentDemoObject["GENDER"],
                        $scope.StudentDemo.STUDENT_DEMOGRAPHICS_ID = "" + $scope.StudentDemoObject["STUDENT_DEMOGRAPHICS_ID"],
                        $scope.StudentDemo.BIRTHDATE = FormatDate("" + $scope.StudentDemoObject["BIRTHDATE"]),
                        $scope.StudentDemo.EFC = "" + $scope.StudentDemoObject["EFC"],
                        $scope.StudentDemo.ACT = "" + $scope.StudentDemoObject["ACT"],
                        $scope.StudentDemo.SAT = "" + $scope.StudentDemoObject["SAT"],
                        $scope.StudentDemo.GPA_HS = "" + $scope.StudentDemoObject["GPA_HS"],
                        $scope.StudentDemo.GPA_UNIV = "" + $scope.StudentDemoObject["GPA_UNIV"],
                        $scope.StudentDemo.MAJOR_ADMITTED = "" + $scope.StudentDemoObject["MAJOR_ADMITTED"],
                        $scope.StudentDemo.MAJOR_CURRENT = "" + $scope.StudentDemoObject["MAJOR_CURRENT"]  
                     

                        ShowToasterSuccess("Student Demographics", "Update Complete");
                        $scope.StudentDemoForm = {};
                        $scope.$apply();
                    }
                    else if (storedProcedureResult == "warning") {
                        showToasterWarning("Student Demographics", "" + $("#response1").text());
                    }
                    else if (storedProcedureResult == "failure") {
                        showToasterError("Student Demographics", "" + $("#response1").text());
                    }
                    else {
                        showToasterError("Uh Oh", "An uncaught error has occured. If it persists, please file a bug report to Kyle or Jay.  Thanks");
                    }
                });
            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };
        /*END StudentDemo Functions */

        /* StudentAddress Functions */
        $scope.AddStudentAddress = function () {
            try {
                showToaster('Student Information', 'Updating...');
                
                var StudentAddressObject =
                    {
                        ADDRESS_TYPE: $scope.StudentAddressForm.ADDRESS_TYPE,
                        ADDRESS_1: $scope.StudentAddressForm.ADDRESS_1,
                        ADDRESS_2: $scope.StudentAddressForm.ADDRESS_2,
                        CITY: $scope.StudentAddressForm.CITY,
                        STATE_PROVINCE: $scope.StudentAddressForm.STATE_PROVINCE,
                        POSTAL_CODE: $scope.StudentAddressForm.POSTAL_CODE,
                        COUNTRY: $scope.StudentAddressForm.COUNTRY
                    };
              
                var formId = parseInt($scope.StudentAddressForm.ModalFormId);
                if (formId >= 0) {
                    StudentAddressObject["STUDENT_ADDRESS_ID"] = "" + $scope.StudentAddressForm.STUDENT_ADDRESS_ID;
                    $scope.StudentAddressObject = angular.copy(StudentAddressObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_ADDRESS&" + GenerateQueryString($scope.StudentAddressObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {
                           
                            $scope.StudentAddress.splice(formId, 1, $scope.StudentAddressObject);
                            ShowToasterSuccess("Student Address", "Update Status Complete");
                            $scope.StudentAddressForm = {};
                          $scope.$apply();
                        }                      
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Address", "" + $("#response1").text());
                        }
                        else {
                            showToasterError("Unknown Error", "An unforseen error has occured");
                        }
                    });


                }
                else {
                    StudentAddressObject["STUDENT_ID"] = "" + $scope.StudentInformation.STUDENT_ID;
                    $scope.StudentAddressObject = angular.copy(StudentAddressObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=NEW_STUDENT_ADDRESS&" + GenerateQueryString($scope.StudentAddressObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {

                            $scope.StudentAddressObject["STUDENT_ADDRESS_ID"] =  "" + $("#response1").text();
                            $scope.StudentAddress.push($scope.StudentAddressObject);

                            //alert("success");
                            ShowToasterSuccess("Student Address", "New Address Complete");
                            $scope.StudentAddressForm = {};
                            $scope.$apply();
                        }
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Address", "" + $("#response1").text());
                        }
                        else {
                            showToasterError("Unknown Error", "An unforseen error has occured");
                        }
                    });



                }
            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };

        $scope.EditModalStudentAddress = function (itemId, jqueryTargetModal) {

            if (itemId == '-1') {
                //alert("new modal");
                $scope.ClearModal(jqueryTargetModal);
                $scope.ClearStudentAddressForm();
            }
            else if ($scope.StudentAddressForm.ModalFormId != itemId) {


                var StudentAddressForm = {
                    ADDRESS_TYPE: "" + $scope.StudentAddress[itemId].ADDRESS_TYPE,
                    ADDRESS_1: "" + $scope.StudentAddress[itemId].ADDRESS_1,
                    ADDRESS_2: "" + $scope.StudentAddress[itemId].ADDRESS_2,
                    CITY: "" + $scope.StudentAddress[itemId].CITY,
                    STATE_PROVINCE: "" + $scope.StudentAddress[itemId].STATE_PROVINCE,
                    POSTAL_CODE: "" + $scope.StudentAddress[itemId].POSTAL_CODE,
                    COUNTRY: "" + $scope.StudentAddress[itemId].COUNTRY,
                    STUDENT_ADDRESS_ID: "" + $scope.StudentAddress[itemId].STUDENT_ADDRESS_ID

                };
                $scope.StudentAddressForm = angular.copy(StudentAddressForm);
                $scope.StudentAddressForm.ModalFormId = itemId;



            }

        };

        $scope.ClearStudentAddressForm = function () {
            $scope.StudentAddressForm = {};
        };
        /* END StudentAddress Functions */

        /* StudentLoans Functions */
        $scope.AddStudentLoans = function () {
            try {
                showToaster('Student Loans', 'Updating...');
                var STATUS_PERIOD = $scope.StudentLoansForm.STATUS_PERIOD_YEAR.concat($scope.StudentLoansForm.STATUS_PERIOD_MONTH);
                
                if (STATUS_PERIOD.length != 8) {
                    throw new Error("Please select both Month and Year for Status Period");
                }

                var StudentLoansObject =
                    {
                        STATUS_PERIOD: "" + STATUS_PERIOD,                        
                        LOAN_AMOUNT: "" + $scope.StudentLoansForm.LOAN_AMOUNT,
                        LOAN_AMOUNT_TYPE: "" + $scope.StudentLoansForm.LOAN_AMOUNT_TYPE,
                        LOAN_TYPE_ID: "" + $scope.StudentLoansForm.LOAN_TYPE_ID,
                        NOTES: "" + $scope.StudentLoansForm.NOTES
                     
                    };
               
                var formId = parseInt($scope.StudentLoansForm.ModalFormId);
                if (formId >= 0) {
                    StudentLoansObject["STUDENT_LOANS_ID"] = "" + $scope.StudentLoansForm.STUDENT_LOANS_ID;
                    $scope.StudentLoansObject = angular.copy(StudentLoansObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=UPDATE_STUDENT_LOANS&" + GenerateQueryString($scope.StudentLoansObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {
                    //        $scope.StudentLoansObject["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentLoansObject["STATUS_PERIOD"]);
                    $scope.StudentLoansObject["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentLoansObject["STATUS_PERIOD"]);
                    $scope.StudentLoans.splice(formId, 1, $scope.StudentLoansObject);
                            ShowToasterSuccess("Student Loans", "Update Loan Complete");
                            $scope.StudentLoansForm = {};
                            $scope.$apply();
                        }                  
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Status", "" + $("#response1").text());
                        }
                        else {
                            showToasterError("Unknown Error", "An unforseen error has occured");
                        }
                    });


                }
                else {
                    StudentLoansObject["STUDENT_ID"] = "" + $scope.StudentInformation.STUDENT_ID;
                    $scope.StudentLoansObject = angular.copy(StudentLoansObject);

                    var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=NEW_STUDENT_LOANS&" + GenerateQueryString($scope.StudentLoansObject);

                    //alert(encodeURI(targetUrl));
                    $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                        clearToasts();
                        var storedProcedureResult = "" + $("#response1").attr('data-sp');
                        if (storedProcedureResult == "success") {
                            $scope.StudentLoansObject["STATUS_PERIOD_FORMATTED"] = FormatTimePeriod($scope.StudentLoansObject["STATUS_PERIOD"]);
                            //$scope.StudentLoansObject["STUDENT_LOANS_ID"] = "" + $("#response1").text();
                            $scope.StudentLoans.push($scope.StudentLoansObject);

                            //alert("success");
                            ShowToasterSuccess("Student Loans", "New Loan Complete");
                            $scope.StudentLoansForm = {};
                            $scope.$apply();
                        }
                        else if (storedProcedureResult == "failure") {
                            showToasterError("Student Loans", "" + $("#response1").text());
                        }
                        else {
                            showToasterError("Unknown Error", "An unforseen error has occured");
                        }
                    });



                }
            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };

        $scope.EditModalStudentLoans = function (itemId, jqueryTargetModal) {

            if (itemId == '-1') {
                //alert("new modal");
                $scope.ClearModal(jqueryTargetModal);
                $scope.ClearStudentLoansForm();
            }
            else if ($scope.StudentLoansForm.ModalFormId != itemId) {

                //alert("student loan" + $scope.StudentLoans[itemId].STATUS_PERIOD);
                var STATUS_PERIOD_YEAR = ($scope.StudentLoans[itemId].STATUS_PERIOD.length == 8 ? $scope.StudentLoans[itemId].STATUS_PERIOD.substring(0, 4) : "");
                //alert("student loan" + $scope.StudentLoans[itemId].STATUS_PERIOD);
                var STATUS_PERIOD_MONTH = ($scope.StudentLoans[itemId].STATUS_PERIOD.length == 8 ? $scope.StudentLoans[itemId].STATUS_PERIOD.substring(4, 8) : "");
                //alert("status loan MONTH" + STATUS_PERIOD_MONTH);
                var StudentLoansForm =
                    {
                        STATUS_PERIOD_YEAR: "" + STATUS_PERIOD_YEAR,
                      
                        STATUS_PERIOD_MONTH: "" + STATUS_PERIOD_MONTH,
                      
                        LOAN_AMOUNT: "" + $scope.StudentLoans[itemId].LOAN_AMOUNT,
                        LOAN_AMOUNT_TYPE: "" + $scope.StudentLoans[itemId].LOAN_AMOUNT_TYPE,
                        LOAN_TYPE_ID: "" + $scope.StudentLoans[itemId].LOAN_TYPE_ID,
                        NOTES: "" + $scope.StudentLoans[itemId].NOTES,
                        STUDENT_LOANS_ID: "" + $scope.StudentLoans[itemId].STUDENT_LOANS_ID
                    };

                $scope.StudentLoansForm = angular.copy(StudentLoansForm);
                $scope.StudentLoansForm.ModalFormId = itemId;
            }

        };

        $scope.ClearStudentLoansForm = function () {
            $scope.StudentLoansForm = {};
        };
        /* END StudentLoans Functions */


        /* eND nEW ANGULAR JS FUNCTONS */
        function FormatTimePeriod(date) {
            var returnString = "";
            if (!$scope.isNullOrWhiteSpace(date)) {
                var year = date.substring(0, 4);
                var month = date.substring(4, 6);


                returnString = (month == "08" ? "August" : "January") + " " + year;
            }
            return returnString;
        }

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));

        }

       

        function GenerateQueryString(obj) {
            var returnStr = "";
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    if (!$scope.isNullOrWhiteSpace(obj[key])) {
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

        $scope.GetCurrentDate = function () {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();

            if (dd < 10) {
                dd = '0' + dd
            }

            if (mm < 10) {
                mm = '0' + mm
            }

            today = yyyy + '' + mm + '' + dd;
            //alert(today);
            return today;
        }


     

     
    

    }
</script>




<asp:Literal ID="CohortOptionsLiteral" runat="server"></asp:Literal>
<asp:Literal ID="InstitutionOptionsLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentInformationLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentStatusesLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentDemoLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentLrapDetailsLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentAddressLiteral" runat="server"></asp:Literal>
<asp:Literal ID="StudentLoansLiteral" runat="server"></asp:Literal>



<script type="text/javascript">

    //$(document).ready(function () {
    //    $('.datepicker').change(function () {
    //        angular.element('#StudentEditForm_GradDate').scope().AngularApply();
    //    });
    //});
    //ModalSubmit('myModal')
    function SubmitForm() {
        //alert("Submit");
        $("#myModal").modal('hide');
    }

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

    function UpdateDate(inputId)
    {
        //$hiddenInput = $("#" + hiddenInputId).first();
        var newDate = $("#" + inputId).val();
       
        var scope = angular.element($("#" + inputId)).scope();

        scope.$apply(function () {
            if (inputId == 'StudentInformationFormGRADUATION_DATE_ACTUAL') {
                scope.StudentInformationForm.GRADUATION_DATE_ACTUAL = newDate;
            }
            else if(inputId == "StudentDemoFormBIRTHDATE")
            {
                scope.StudentDemoForm.BIRTHDATE = newDate;
            }
        });
        //$hiddenInput.trigger('change');
        //angular.element($hiddenInput).scope().$apply();
    }
    //function OpenEditModal(modalId, index)
    //{
    //    /*
    //    First we must fill all the modals

    //    */
    //    if (modalId == "newStudentStatusModal")
    //    {
    //        var statusPeriod = $('#datatable_tabletools_nonsort255 > tbody tr:nth-child(' + index + ') td:nth-child(2)').html();
    //        if (statusPeriod.length != 0)
    //        {
    //            var month = statusPeriod.split(" ")[0];
    //            var year = statusPeriod.split(" ")[1];

    //            if (month == "August")
    //            {
    //                $('input:radio[name=SS_StatusPeriod]')[0].checked = true;
    //            }
    //            else
    //            {
    //                $('input:radio[name=SS_StatusPeriod]')[1].checked = true;
    //            }

    //            $('#newStudentStatus_StatusPeriod').val(year);
    //        }
    //        else
    //        {
    //            $('#newStudentStatus_StatusPeriod').prop('selectedIndex', -1);
    //            $('input:radio[name=SS_StatusPeriod]').attr('checked', false);
    //        }
    //        $('#newStudentStatus_Status').val($('#datatable_tabletools_nonsort255 > tbody tr:nth-child(' + index + ') td:nth-child(3)').html());
    //        $('#newStudentStatus_CurrentClass').val($('#datatable_tabletools_nonsort255 > tbody tr:nth-child(' + index + ') td:nth-child(4)').html());

    //        var retroPeriod = $('#datatable_tabletools_nonsort255 > tbody tr:nth-child(' + index + ') td:nth-child(6)').html();
    //        if (retroPeriod.length != 0) {
    //            var month = statusPeriod.split(" ")[0];
    //            var year = statusPeriod.split(" ")[1];

    //            if (month == "August") {
    //                $('input:radio[name=SS_RetroPeriod]')[0].checked = true;
    //            }
    //            else {
    //                $('input:radio[name=SS_RetroPeriod]')[1].checked = true;
    //            }
    //            $('#newStudentStatus_RetrodPeriod').val(year);
    //        }
    //        else
    //        {
    //            $('#newStudentStatus_RetrodPeriod').prop('selectedIndex', -1);
    //            $('input:radio[name=SS_RetroPeriod]').attr('checked', false);
    //        }
    //        var borrowing = $('#datatable_tabletools_nonsort255 > tbody tr:nth-child(' + index + ') td:nth-child(5)').html();
    //        if (borrowing.length != 0) {
    //            if (borrowing == "Y") {
    //                $('input:radio[name=SS_Borrowing]')[0].checked = true;
    //            }
    //            else {
    //                $('input:radio[name=SS_Borrowing]')[1].checked = true;
    //            }
    //        }
    //        else
    //        {
    //            $('input:radio[name=SS_Borrowing]').attr('checked', false);
    //        }



    //    }
    //    else if (modalId == "newStudentLoanModal")
    //    {
    //        var statusPeriod = $('#datatable_tabletools32 > tbody tr:nth-child(' + index + ') td:nth-child(2)').html();
    //        if (statusPeriod.length != 0) {
    //            var month = statusPeriod.split(" ")[0];
    //            var year = statusPeriod.split(" ")[1];

    //            if (month == "August") {
    //                $('input:radio[name=SL_StatusPeriod]')[0].checked = true;
    //            }
    //            else {
    //                $('input:radio[name=SL_StatusPeriod]')[1].checked = true;
    //            }

    //            $('#newStudenLoan_StatusPeriod').val(year);
    //        }
    //        else {
    //            $('#newStudentLoan_StatusPeriod').prop('selectedIndex', -1);
    //            $('input:radio[name=SL_StatusPeriod]').attr('checked', false);
    //        }

    //        $('#newStudentLoan_LoanAmount').val($('#datatable_tabletools32 > tbody tr:nth-child(' + index + ') td:nth-child(4)').html());
    //        $('#newStudentLoan_Type').val($('#datatable_tabletools32 > tbody tr:nth-child(' + index + ') td:nth-child(3)').html());
    //        $('#newStudentLoan_Notes').val($('#datatable_tabletools32 > tbody tr:nth-child(' + index + ') td:nth-child(5)').html());
    //    }
    //    $('#' + modalId).modal('show');
    //}
    function ShowDialog_Click(modalUrl, title) {


        var options = {
            url: modalUrl,
            title: title,
            allowMaximize: false,
            showClose: true,
            dialogReturnValueCallback: myDialogCallback
        };

        SP.SOD.execute('sp.ui.dialog.js', 'SP.UI.ModalDialog.showModalDialog', options);


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
</script>
<asp:Button ID="Button1" runat="server" Text="Button" Visible="false" OnClientClick="ShowDialog_Click();return false;" />
<asp:Label runat="server" ID="Label1" Visible="false"></asp:Label>
<asp:Label runat="server" ID="Label2" Visible="false"></asp:Label>

<div data-ng-app data-ng-controller="LrapController">
   
    <div id="localDiv" style="display:none"></div>


    <div>


        <!--
            The ID "widget-grid" will start to initialize all widgets below
            You do not need to use widgets if you dont want to. Simply remove
            the <section></section> and you can use wells or panels instead
            -->
        <!-- widget grid -->
        <section id="widget-grid" class="">



            <div class="row">

                <!-- Student Information Article -->
                <article style="max-width: 750px" class="col-sm-12 col-md-9 col-lg-8">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-045" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false" >
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
                            <!-- <span class="widget-icon"> <i class="fa fa-table"></i> </span> -->
                            <h2 style="padding-right: 5px">Student Information</h2>
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentInformation(StudentInformation.STUDENT_ID, '[modaltarget=StudentInformationModal]')" data-target="[modaltarget='StudentInformationModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a>
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

                                <div class="smart-form">

                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Student Name</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.FIRST_NAME}} {{StudentInformation.MIDDLE_NAME}} {{StudentInformation.LAST_NAME}}
                                                              
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Primary Phone</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.PHONE_1}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Home City/State</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.CITY}}, {{StudentInformation.STATE_PROVINCE}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Secondary Phone</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.PHONE_2}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>LRAP Student ID</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.LRAP_STUDENT_ID}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Primary Email</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.EMAIL_1}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>School Name</b></p>
                                                </div>
                                                <div class="col col-7" data-ng-repeat="inst in InstitutionOptions | filter:StudentInformation.INSTITUTION_ID">
                                                    <%--{{StudentInformation.INSTITUTION_NAME}}--%>
                                                                {{inst.INSTITUTION_NAME  }}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Secondary Email</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.EMAIL_2}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>School Student ID</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.INSTITUTION_STUDENT_ID}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Parent Email 1</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.PARENT_EMAIL_1}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Admitted Class</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.ADMITTED_CLASS}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Parent Email 2</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.PARENT_EMAIL_2}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Current Class</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.CURRENT_CLASS}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>Graduation Date</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{StudentInformation.GRADUATION_DATE_ACTUAL}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-5">
                                                    <p><b>SQL Student ID</b></p>
                                                </div>
                                                <div class="col col-7">
                                                    {{studentId}}
                                                </div>
                                            </section>
                                            
                                        </div>
                                    </fieldset>
                                </div>

                            </div>
                            <!-- end widget content -->

                        </div>
                        <!-- end widget div -->

                    </div>
                    <!-- end widget -->

                </article>
                <!-- END COL -->

                <!-- Modal Dialog For New Students -->
                <div class="modal fade" modaltarget="StudentInformationModal" tabindex="-1" role="dialog" aria-labelledby="myModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="myModalTitle">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body">
                                <form class="form-horizontal">
                                    <fieldset>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">LRAP Student ID</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.LRAP_STUDENT_ID" />
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-2 control-label">First Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.FIRST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Middle Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.MIDDLE_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Last Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.LAST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Maiden Last Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.MAIDEN_LAST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Phone 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.PHONE_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Phone 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.PHONE_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Email 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.EMAIL_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Email 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.EMAIL_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Parent Email 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.PARENT_EMAIL_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Parent Email 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.PARENT_EMAIL_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Institution</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentInformationForm.INSTITUTION_ID" data-ng-options="InstitutionOption.INSTITUTION_ID as InstitutionOption.INSTITUTION_NAME for InstitutionOption in InstitutionOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Institution Student ID</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentInformationForm.INSTITUTION_STUDENT_ID" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Admitted Class</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentInformationForm.ADMITTED_CLASS" data-ng-options="AdmittedClassOption.id as AdmittedClassOption.label for AdmittedClassOption in AdmittedClassOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Graduation Date</label>

                                            <div class="col-md-10">
                                                <div class="input-icon-right">
                                                    <i class="fa fa-calendar"></i>
                                                    <input id="StudentInformationFormGRADUATION_DATE_ACTUAL" data-ng-model="StudentInformationForm.GRADUATION_DATE_ACTUAL" onchange="UpdateDate('StudentInformationFormGRADUATION_DATE_ACTUAL')" type="text" name="mydate" class="form-control datepicker" data-dateformat="mm/dd/yy" />                                          
                                                    <%--<div style="display:none" >
                                                        <input id="HiddenStudentInformationFormGRADUATION_DATE_ACTUAL" type="text"  data-ng-model="StudentInformationForm.GRADUATION_DATE_ACTUAL" />
                                                    </div>--%>
                                                    
                                                </div>
                                            </div>
                                        </div>
                                        
                                     
                                    </fieldset>
                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentInformationModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentInformationModal]');UpdateStudentInformation();">
                                    Submit
                                </button>
                                <%-- <button type="button" ID="SubmitButton1" runat="server" ClientIDMode="Static" Cssclass="btn btn-primary" onServerClick="SubmitForm" >
                        Submit
                    </button>--%>

                                <%-- <asp:Button ID="SubmitButton1" runat="server" ClientIdMode="Static" CssClass="btn btn-primary" OnClick="SubmitForm" />
                                --%>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->



            </div>




            <div class="row">

                <!--Student Statuses-->
                <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-134" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <!-- <span class="widget-icon"> <i class="fa fa-table"></i> </span> -->
                            <h2 style="padding-right: 5px">Student Statuses</h2>
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentStatuses('-1', '[modaltarget=StudentStatusesModal]')" data-target="[modaltarget='StudentStatusesModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>
                            <%--<a href="#" style="color:black;margin-top:5px;padding-right:5px" data-ng-click="NewStudentStatus()" class="btn btn-default btn-xs"> <i class="fa fa-plus"></i> New</a>--%>
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

                                <table id="datatable_tabletools_nonsort255" class="table table-striped table-hover" width="100%">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Status Period</th>
                                            <th>Status</th>
                                            <th>Class</th>
                                            <th>Borrowing</th>
                                            <th>Retro Coverage</th>
                                            <th>Fee</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%--<tr data-ng-repeat="status in studentStatus">
                                                        <td><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" data-ng-click="OpenStudentStatus($index, status.STUDENT_STATUS_ID)" class="btn btn-default btn-xs" > <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>{{status.STATUS_PERIOD}}</td>
                                                        <td>{{status.STATUS}}</td>
                                                        <td>{{status.CURRENT_CLASS}}</td>
                                                        <td>{{status.BORROWING}}</td>
                                                        <td>{{status.RETRO_PERIOD}}</td>
                                                        <td>{{status.ANNUAL_FEE_AMOUNT}}</td>
                                                    </tr>--%>
                                        <tr data-ng-repeat="StudentStatus in StudentStatuses">
                                            <td><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentStatuses($index, '[modaltarget=StudentStatusesModal]')" data-target="[modaltarget='StudentStatusesModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></td>
                                            <td>{{StudentStatus.STATUS_PERIOD_FORMATTED}}</td>
                                            <td>{{StudentStatus.STATUS}}</td>
                                            <td>{{StudentStatus.CURRENT_CLASS}}</td>
                                            <td>{{StudentStatus.BORROWING}}</td>
                                            <td>{{StudentStatus.RETRO_PERIOD_FORMATTED}}</td>
                                            <td><span data-ng-show="StudentStatus.BORROWING == 'Y' && !isNullOrWhiteSpace(StudentStatus.CALC_FEE)">{{StudentStatus.CALC_FEE | currency:"$"}}</span></td>
                                        </tr>
                                        <tr data-ng-show="StudentStatuses.length == 0">
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td><b>No Statuses Recorded</b></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>                          
                                    </tr>
                                       

                                    </tbody>
                                </table>

                            </div>
                        </div>
                        <!-- end widget content -->

                    </div>
                    <!-- end widget div -->
                </article>
                <!-- End student Statuses -->

                <!--   Beign student statues modal -->
                <div class="modal fade" modaltarget="StudentStatusesModal" id="Div6" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div style="width: 50%" class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="H9">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body" style="width: 90%;">
                                <form class="form-horizontal">
                                    <fieldset>
                                        <div class="form-group" style="display: none">
                                            <label class="col-md-2 control-label">ID</label>
                                            <div class="col-md-10">
                                                <input type="text" title="StudentStatusesModalFormId" data-ng-model="StudentStatusesForm.ModalFormId" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Current Class</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentStatusesForm.CURRENT_CLASS" data-ng-options="CurrentClassOption.id as CurrentClassOption.label for CurrentClassOption in CurrentClassOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Status Period</label>
                                            <div class="col-md-5">
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentStatusesForm.STATUS_PERIOD_MONTH" value="0801" name="SS_StatusPeriod">
                                                    August
                                                </label>
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentStatusesForm.STATUS_PERIOD_MONTH" value="0101" name="SS_StatusPeriod">
                                                    January
                                                </label>

                                            </div>
                                            <div class="col-md-5 pull-left">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentStatusesForm.STATUS_PERIOD_YEAR" data-ng-options="LrapYearsOption.id as LrapYearsOption.label for LrapYearsOption in LrapYearsOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Status</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentStatusesForm.STATUS" data-ng-options="StatusOption.id as StatusOption.label for StatusOption in StatusOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Retro Period</label>
                                            <div class="col-md-5">
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentStatusesForm.RETRO_PERIOD_MONTH" value="0801" name="SS_RetroPeriod">
                                                    August
                                                </label>
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentStatusesForm.RETRO_PERIOD_MONTH" value="0101" name="SS_RetroPeriod">
                                                    January
                                                </label>

                                            </div>
                                            <div class="col-md-5 pull-left">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentStatusesForm.RETRO_PERIOD_YEAR" data-ng-options="LrapYearsOption.id as LrapYearsOption.label for LrapYearsOption in LrapYearsOptions"></select>

                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Borrowing</label>
                                            <div class="col-md-5">
                                                <label class="radio radio-inline">
                                                    <input type="radio" name="SS_Borrowing" value="Y" data-ng-model="StudentStatusesForm.BORROWING">
                                                    Yes
                                                </label>
                                                <label class="radio radio-inline">
                                                    <input type="radio" name="SS_Borrowing" value="N" data-ng-model="StudentStatusesForm.BORROWING">
                                                    No
                                                </label>

                                            </div>
                                        </div>





                                    </fieldset>

                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentStatusesModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentStatusesModal]');AddStudentStatuses();">
                                    Submit
                                </button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- End Student Status Modal








                     
                        </div>                                                                  
                        <div class="row">

                            <!--LRAP Detail-->
                <article class="col-sm-12 col-md-6 col-lg-6">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-033" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <!-- <span class="widget-icon"> <i class="fa fa-edit"></i> </span> -->
                            <h2 style="padding-right: 5px">LRAP Detail</h2>
                            <%--<asp:Literal ID="Student_Details_Edit_Button" runat="server"></asp:Literal>--%>
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentLrapDetails(StudentInformation.STUDENT_ID, '[modaltarget=StudentLrapDetailsModal]')" data-target="[modaltarget='StudentLrapDetailsModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a>
                            <%-- <a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" data-ng-click="OpenStudentLrapDetails()" class="btn btn-default btn-xs" > <i class="fa fa-edit"></i> Edit</a>--%>
                            <%-- <a href="#" style="color:black;margin-top:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a>--%>
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

                                <div class="smart-form">

                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Cohort</b></p>
                                                </div>
                                                <div class="col col-6" data-ng-repeat="CohortOption in CohortOptions | filter:StudentInformation.COHORT_ID">
                                                    <%--<asp:Literal ID="Student_Details_Cohort" runat="server"></asp:Literal>   --%>
                                                                {{CohortOption.DESCRIPTION}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Intro Student</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    <p data-ng-show="StudentLrapDetails.FEE_TYPE == 'Intro'">Y</p>
                                                    <p data-ng-show="StudentLrapDetails.FEE_TYPE != 'Intro'">N</p>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Freshman Fee Type</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentLrapDetails.FRESHMEN_FEE_TYPE}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Fee Type</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentLrapDetails.FEE_TYPE}}
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Upper Income</b></p>
                                                </div>
                                                <div class="col col-6">
                                          <%--          <p data-ng-show="(StudentStatuses.length != 0 )"><span data-ng-show="StudentLrapDetails.UPPER_INCOME_LIMIT">{{ StudentLrapDetails.UPPER_INCOME_LIMIT | number:0}}</span></p>--%>
                                                     <p><span data-ng-show="StudentLrapDetails.UPPER_INCOME_LIMIT">{{ StudentLrapDetails.UPPER_INCOME_LIMIT | number:0}}</span></p>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Annual Fee</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    <p><span data-ng-show="StudentLrapDetails.ANNUAL_FEE_AMOUNT">{{ StudentLrapDetails.ANNUAL_FEE_AMOUNT | currency:"$"}}</span></p>
                                                    <%--<p data-ng-show="(StudentStatuses.length != 0 )"><span data-ng-show="StudentLrapDetails.ANNUAL_FEE_AMOUNT">{{ StudentLrapDetails.ANNUAL_FEE_AMOUNT | currency:"$"}}</span></p>--%>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Lower Income</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    <p><span data-ng-show="StudentLrapDetails.LOWER_INCOME_LIMIT">{{ StudentLrapDetails.LOWER_INCOME_LIMIT | number:0}}</span></p>
                                                   <%-- <p data-ng-show="(StudentStatuses.length != 0 )"><span data-ng-show="StudentLrapDetails.LOWER_INCOME_LIMIT">{{ StudentLrapDetails.LOWER_INCOME_LIMIT | number:0}}</span></p>--%>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Award Letter</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentLrapDetails.AWARD_LETTER}}
                                                </div>
                                            </section>
                                        </div>
                                        <%--<div class="row" style="display: none">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Retro Date</b></p>
                                                </div>
                                                <div class="col col-6" data-ng-repeat="StudentStatus in StudentStatuses">
                                                    <p>{{ StudentStatuses[$index].RETRO_DATE}}</p>
                                                </div>
                                            </section>
                                        </div>--%>
                                    </fieldset>
                                </div>

                            </div>
                            <!-- end widget content -->

                        </div>
                        <!-- end widget div -->

                    </div>
                    <!-- end widget -->

                </article>
                <!-- End Lrap Details -->

                <!-- Modal Dialog For Edit Students LRAP Details-->
                <div class="modal fade" modaltarget="StudentLrapDetailsModal" tabindex="-1" role="dialog" aria-labelledby="myModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="myModalTitle">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body">
                                <form class="form-horizontal">
                                    <fieldset>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Cohort</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentLrapDetailsForm.COHORT_ID" data-ng-options="CohortOption.COHORT_ID as CohortOption.DESCRIPTION for CohortOption in CohortOptions"></select>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-2 control-label">LRAP Fee Type</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentLrapDetailsForm.FEE_TYPE" data-ng-options="FeeTypeOption.id as FeeTypeOption.label for FeeTypeOption in FeeTypeOptions"></select>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Award Letter</label>
                                            <div class="col-md-5">
                                                <label class="radio radio-inline">
                                                    <input type="radio" value="Y" name="Award_Letter" data-ng-model="StudentLrapDetailsForm.AWARD_LETTER">
                                                    Yes
                                                </label>
                                                <label class="radio radio-inline">
                                                    <input type="radio" value="N" name="Award_Letter" data-ng-model="StudentLrapDetailsForm.AWARD_LETTER">
                                                    No
                                                </label>

                                            </div>
                                        </div>
                                    </fieldset>
                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentLrapDetailsModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentLrapDetailsModal]');UpdateStudentLrapDetails();">
                                    Submit
                                </button>
                                <%-- <button type="button" ID="SubmitButton1" runat="server" ClientIDMode="Static" Cssclass="btn btn-primary" onServerClick="SubmitForm" >
                        Submit
                    </button>--%>

                                <%-- <asp:Button ID="SubmitButton1" runat="server" ClientIdMode="Static" CssClass="btn btn-primary" OnClick="SubmitForm" />
                                --%>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->


                <!--Student Demographics-->
                <article class="col-sm-12 col-md-6 col-lg-6">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-07" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <!-- <span class="widget-icon"> <i class="fa fa-edit"></i> </span> -->
                            <h2 style="padding-right: 5px">Student Demographics</h2>
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentDemo(StudentDemo.STUDENT_DEMOGRAPHICS_ID, '[modaltarget=StudentDemoModal]')" data-target="[modaltarget='StudentDemoModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a>
                            <%--<a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-ng-click="OpenStudentDemo()" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a>--%>
                            <%-- <asp:Literal ID="Student_Demographics_Edit_Button" runat="server"></asp:Literal> --%>
                            <%-- <a href="#" style="color:black;margin-top:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a>                                     --%>
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

                                <div class="smart-form">

                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Gender</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.GENDER}}
                                                                <%--<asp:Literal ID="Student_Demographic_Gender" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>SAT Score</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.SAT}}
                                                                <%--<asp:Literal ID="Student_Demographic_Sat" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Birthdate</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.BIRTHDATE}}
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>ACT Score</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.ACT}}
                                                                <%--<asp:Literal ID="Student_Demographic_Act" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>EFC</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    <span data-ng-show="StudentDemo.EFC">
                                                        {{StudentDemo.EFC | number:0}}
                                                    </span>
                                                                <%--<asp:Literal ID="Student_Demographic_Efc" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Major Admitted</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.MAJOR_ADMITTED}}
                                                                <%--<asp:Literal ID="Student_Demographic_Major_Admitted" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>GPA HS</b></p>
                                                </div>

                                                <div class="col col-6">
                                                    {{StudentDemo.GPA_HS}}
                                                                <%--<asp:Literal ID="Student_Demographic_Gpa_Hs" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>Major Current</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.MAJOR_CURRENT}}
                                                                <%--<asp:Literal ID="Student_Demographic_Major_Current" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                        </div>
                                        <div class="row">
                                            <section class="col col-6">
                                                <div class="col col-6">
                                                    <p><b>GPA College</b></p>
                                                </div>
                                                <div class="col col-6">
                                                    {{StudentDemo.GPA_UNIV}}
                                                                <%--<asp:Literal ID="Student_Demographic_Gpa_College" runat="server"></asp:Literal>--%>
                                                </div>
                                            </section>
                                        </div>
                                    </fieldset>
                                </div>

                            </div>
                            <!-- end widget content -->

                        </div>
                        <!-- end widget div -->

                    </div>
                    <!-- end widget -->

                </article>
                <!-- END Student Demographics -->

                <!-- Modal Dialog For Edit Students Demo-->
                <div class="modal fade" modaltarget="StudentDemoModal" tabindex="-1" role="dialog" aria-labelledby="myModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="myModalTitle">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body">
                                <form class="form-horizontal">
                                    <fieldset>
                                        <div class="form-group">
                                <label class="col-md-2 control-label">Gender</label>
                                <div class="col-md-8">
                                    <label class="radio radio-inline">
                                        <input type="radio" value="M" name="Gender" data-ng-model="StudentDemoForm.GENDER">
                                        Male
                                    </label>
                                    <label class="radio radio-inline">
                                        <input type="radio" value="F" name="Gender" data-ng-model="StudentDemoForm.GENDER">
                                        Female
                                    </label>

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Birthdate</label>
                                <div class="col-md-10">
                                  <%--  <input class="form-control" type="text" data-ng-model="StudentDemoForm.BIRTHDATE_FORMATTED">--%>
                                    <div class="input-icon-right">
                                                    <i class="fa fa-calendar"></i>
                                                    <input id="StudentDemoFormBIRTHDATE" data-ng-model="StudentDemoForm.BIRTHDATE" onchange="UpdateDate('StudentDemoFormBIRTHDATE')" type="text" name="mydate" class="form-control datepicker" data-dateformat="mm/dd/yy" />                                          
                                                    <%--<div style="display:none" >
                                                        <input id="HiddenStudentInformationFormGRADUATION_DATE_ACTUAL" type="text"  data-ng-model="StudentInformationForm.GRADUATION_DATE_ACTUAL" />
                                                    </div>--%>
                                                    
                                                </div>
                                </div>
                            </div>
                                        {{StudentDemoForm.BIRTHDATE}}
                            <div class="form-group">
                                <label class="col-md-2 control-label">EFC</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentDemoForm.EFC">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">High School GPA</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentDemoForm.GPA_HS">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">University GPA</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentDemoForm.GPA_UNIV">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Admitted Major</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentDemoForm.MAJOR_ADMITTED">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Current Major</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentDemoForm.MAJOR_CURRENT">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">SAT</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentDemoForm.SAT">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">ACT</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentDemoForm.ACT">
                                </div>
                            </div>
                                    </fieldset>
                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentDemoModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentDemoModal]');UpdateStudentDemo();">
                                    Submit
                                </button>
                                <%-- <button type="button" ID="SubmitButton1" runat="server" ClientIDMode="Static" Cssclass="btn btn-primary" onServerClick="SubmitForm" >
                        Submit
                    </button>--%>

                                <%-- <asp:Button ID="SubmitButton1" runat="server" ClientIdMode="Static" CssClass="btn btn-primary" OnClick="SubmitForm" />
                                --%>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->
            </div>

            <div class="row">
                <!--Student Addresses-->
                <article class="col-sm-12 col-md-6 col-lg-6">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-02" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <h2 style="padding-right: 5px">Student Addresses</h2>
                          
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentAddress('-1', '[modaltarget=StudentAddressModal]')" data-target="[modaltarget='StudentAddressModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>
                           <%-- <a href="#" style="color: black; margin-top: 5px; padding-right: 5px" data-ng-click="NewStudentAddress()" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>--%>
                            <%--<asp:Literal ID="Student_Addresses_New_Button" runat="server"></asp:Literal>--%>
                            <%--<a href="#" style="color:black;margin-top:5px;padding-right:5px" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-plus"></i> New</a>    --%>
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

                                <div class="smart-form">

                                    <fieldset>
                                        <div class="row" data-ng-repeat="address in StudentAddress">
                                            <section class="col col-2">
                                                <div class="col col-12">
                                                    <p><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentAddress($index, '[modaltarget=StudentAddressModal]')" data-target="[modaltarget='StudentAddressModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></p>
                                                </div>
                                            </section>
                                            <section class="col col-3">
                                                <div class="col col-12">
                                                    <p>Address {{$index + 1}}:</p>
                                                </div>
                                            </section>
                                            <section class="col col-7">
                                                <div class="col col-12">
                                                    <p>{{address.ADDRESS_1}} {{address.ADDRESS_2}} {{address.CITY}} {{address.STATE_PROVINCE}} {{address.POSTAL_CODE}} {{address.COUNTRY}}</p>
                                                </div>
                                            </section>
                                        </div>


                                        <%--<asp:Literal ID="Student_Addresses" runat="server"></asp:Literal>--%>
                                    </fieldset>
                                </div>

                            </div>
                            <!-- end widget content -->

                        </div>
                        <!-- end widget div -->

                    </div>
                    <!-- end widget -->

                </article>
                <!-- end student address -->

                <!--   Beign student statues modal -->
                <div class="modal fade" modaltarget="StudentAddressModal" id="Div6" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div style="width: 50%" class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="H9">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body" style="width: 90%;">
                                <form class="form-horizontal">
                                    <fieldset>
                                      
                                        <div class="form-group">
                                <label class="col-md-2 control-label">Address Type</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentAddressForm.ADDRESS_TYPE">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Address 1</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentAddressForm.ADDRESS_1">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Address 2</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentAddressForm.ADDRESS_2">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">City</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentAddressForm.CITY">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">State/Province</label>
                                <div class="col-md-10">
                                    <input data-ng-model="StudentAddressForm.STATE_PROVINCE" class="form-control" type="text">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Zip</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentAddressForm.POSTAL_CODE">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Country</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentAddressForm.COUNTRY">
                                </div>
                            </div>




                                    </fieldset>

                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentAddressModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentAddressModal]');AddStudentAddress();">
                                    Submit
                                </button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- End Student Status Modal


                <!--Student Documents-->
                <article class="col-sm-12 col-md-6 col-lg-6">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-020987" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-custombutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <!-- <span class="widget-icon"> <i class="fa fa-edit"></i> </span> -->
                            <h2 style="padding-right: 5px">Student Documents</h2>
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
                            <div class="widget-body no-padding">

                                <div id="demo">

</div>
                               

                            </div>
                            <!-- end widget content -->

                        </div>
                        <!-- end widget div -->

                    </div>
                    <!-- end widget -->

                </article>
                <!-- END Student Documents -->
            </div>

            <div class="row">

                <!--Student Loans-->
                <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                    <!-- Widget ID (each widget will need unique ID)-->
                    <div class="jarviswidget" id="wid-id-1959" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-togglebutton="false">
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
                            <!-- <span class="widget-icon"> <i class="fa fa-table"></i> </span> -->
                            <h2 style="padding-right: 5px">Student Loans</h2>
                            <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentLoans('-1', '[modaltarget=StudentLoansModal]')" data-target="[modaltarget='StudentLoansModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>
                            <%--<a href="#" style="color: black; margin-top: 5px; padding-right: 5px" data-ng-click="NewStudentLoan()" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>New</a>--%>
                            <%--<asp:Literal ID="Student_Loans_New_Button" runat="server"></asp:Literal>--%>
                            <%--<a href="#" style="color:black;margin-top:5px;padding-right:5px" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-plus"></i> New</a>--%>
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

                                <table id="datatable_tabletools32111" class="table table-striped table-hover" width="100%">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Status Period</th>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th>Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr data-ng-repeat="StudentLoan in StudentLoans">
                                            <td><a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-ng-click="EditModalStudentLoans($index, '[modaltarget=StudentLoansModal]')" data-target="[modaltarget='StudentLoansModal']" class="btn btn-default btn-xs"><i class="fa fa-edit"></i>Edit</a></td>
                                            <td>{{StudentLoan.STATUS_PERIOD_FORMATTED}}</td>
                                            <td data-ng-repeat="t in LoanTypeOptions | filter:StudentLoan.LOAN_TYPE_ID">{{t.label}}</td>
                                            <td >{{StudentLoan.LOAN_AMOUNT | currency:"$"}}</td>
                                            <td>{{StudentLoan.NOTES}}</td>
                                        </tr>
                                        <%-- <asp:Literal ID="Student_Loans_Literal" runat="server"></asp:Literal>--%>
                                        <%--<tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2011</td>
                                                        <td>Direct Subsidized</td>
                                                        <td>$2,750</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2011</td>
                                                        <td>Direct Unsubsidized</td>
                                                        <td>$2,750</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2011</td>
                                                        <td>Perkins</td>
                                                        <td>$3,500</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2011</td>
                                                        <td>Private/Alternative</td>
                                                        <td>$1,550</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2011</td>
                                                        <td>Parent Plus</td>
                                                        <td>$5,000</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2010</td>
                                                        <td>Direct Subsidized</td>
                                                        <td>$5,000</td>
                                                        <td>Notes go here</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:1px" align="center"><a href="#" style="color:black;margin-top:4px;padding-right:5px;padding-left:5px;" onclick='window.location=http://www.google.com' class="btn btn-default btn-xs"> <i class="fa fa-edit"></i> Edit</a></td>
                                                        <td>Aug 2010</td>
                                                        <td>Perkins</td>
                                                        <td>$3,500</td>
                                                        <td>Notes go here</td>
                                                    </tr>--%>




                                        <%--<tr>
                                                        <td></td>
                                                        <td><b>Subtotal Federal</b></td>
                                                        <td></td>
                                                        <%--<asp:Literal ID="Student_Loans_Subtotal_Federal" runat="server"></asp:Literal>
                                                        <td><b>$10,500 (44%)</b></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td><b>Subtotal Other</b></td>
                                                        <td></td>
                                                        <%--<asp:Literal ID="Student_Loans_Subtotal_Other" runat="server"></asp:Literal>
                                                        <td><b>$13,550 (56%)</b></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td><b>Total Loans</b></td>
                                                        <td></td>
                                                        <%--<asp:Literal ID="Student_Loans_Total_Loans" runat="server"></asp:Literal>
                                                        <td><b>$24,050</b></td>
                                                        <td></td>
                                                    </tr>--%>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                        <!-- end widget content -->

                    </div>
                    <!-- end widget div -->
                </article>
                <!--END Student Loans -->

                <!--   Beign student Loans modal -->
                <div class="modal fade" modaltarget="StudentLoansModal" id="Div6" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div style="width: 50%" class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="H9">{{StudentInformation.FIRST_NAME}} {{StudentInformation.LAST_NAME}}</h4>
                            </div>
                            <div class="modal-body" style="width: 90%;">
                                <form class="form-horizontal">
                                    <fieldset>
                                       <div class="form-group">
                                            <label class="col-md-2 control-label">Status Period</label>
                                            <div class="col-md-5">
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentLoansForm.STATUS_PERIOD_MONTH" value="0801" name="SS_StatusPeriod">
                                                    August
                                                </label>
                                                <label class="radio radio-inline">
                                                    <input type="radio" data-ng-model="StudentLoansForm.STATUS_PERIOD_MONTH" value="0101" name="SS_StatusPeriod">
                                                    January
                                                </label>

                                            </div>
                                            <div class="col-md-5 pull-left">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentLoansForm.STATUS_PERIOD_YEAR" data-ng-options="LrapYearsOption.id as LrapYearsOption.label for LrapYearsOption in LrapYearsOptions"></select>
                                            </div>
                                        </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Loan Amount</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentLoansForm.LOAN_AMOUNT">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Loan Amount Type</label>
                                <div class="col-md-5">
                                    <label class="radio radio-inline">
                                        <input type="radio" value="Term" name="LoanAmountType" data-ng-model="StudentLoansForm.LOAN_AMOUNT_TYPE">
                                        Term
                                    </label>
                                    <label class="radio radio-inline">
                                        <input type="radio" value="Total" name="LoanAmountType" data-ng-model="StudentLoansForm.LOAN_AMOUNT_TYPE">
                                        Total
                                    </label>

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Student Loan Type</label>
                                <div class="col-md-10">
                                    <select class="form-control" data-ng-model="StudentLoansForm.LOAN_TYPE_ID" data-ng-options="LoanTypeOption.id as LoanTypeOption.label for LoanTypeOption in LoanTypeOptions">                                        
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Notes</label>
                                <div class="col-md-10">
                                    <textarea class="form-control" rows="5" data-ng-model="StudentLoansForm.NOTES"></textarea>
                                </div>
                            </div>
                                       
                                            



                                    </fieldset>

                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=StudentLoansModal]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=StudentLoansModal]');AddStudentLoans();">
                                    Submit
                                </button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- End Student lOANS Modal -->


            </div>




        </section>
        <!-- end widget grid -->






    </div>
    <!--End of nates content-->
</div>

<script type="text/javascript">
    $(document).ready(function () {

        //$('#StudentEditForm_LrapFeeType').prop('selectedIndex', -1);
        //$('#StudentEditForm_AdmittedClass').prop('selectedIndex', -1);
        //$('#StudentEditForm_Cohort').prop('selectedIndex', -1);
        $('.modal-title').each(function () {
            $(this).text($('#Student_Info_Student_Name_div > p').html());
        });
    });
</script>



















<%--         <!--Student Documents-->
                            <article class="col-sm-12 col-md-6 col-lg-6">

                                <!-- Widget ID (each widget will need unique ID)-->
                                <div class="jarviswidget" id="wid-id-2" data-widget-colorbutton="false" data-widget-editbutton="false">
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
                                        <span class="widget-icon"> <i class="fa fa-file-o"></i> </span>
                                        <h2>Student Documents</h2>

                                    </header>

                                    <!-- widget div-->
                                    <div>

                                        <!-- widget edit box -->
                                        <div class="jarviswidget-editbox">
                                            <!-- This area used as dropdown edit box -->

                                        </div>
                                        <!-- end widget edit box -->
                                        <!-- widget content -->
                                        <div class="widget-body  no-padding">
                                            <span class="widget-icon"> <i class="fa fa-file-pdf-o"></i> Award Letter PDF</span><br />
                                            <span>More to be added later</span><br />
                                        </div>
                                    </div>
                                </div>
                            </article>--%>