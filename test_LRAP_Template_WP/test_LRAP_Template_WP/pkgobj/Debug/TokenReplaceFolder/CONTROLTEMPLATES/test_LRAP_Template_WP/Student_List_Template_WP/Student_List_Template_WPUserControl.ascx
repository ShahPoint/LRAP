<%@ Assembly Name="test_LRAP_Template_WP, Version=1.0.0.0, Culture=neutral, PublicKeyToken=3ea45007b5501931" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Student_List_Template_WPUserControl.ascx.cs" Inherits="test_LRAP_Template_WP.Student_List_Template_WP.Student_List_Template_WPUserControl" %>
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
<script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.21/angular.min.js"></script>
<link type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<asp:Label ID="Label1" runat="server" Text="Label" Visible="false"></asp:Label>
<asp:Literal ID="Literal1" runat="server"></asp:Literal>
<asp:Literal ID="InstitutionOptionsLiteral" runat="server"></asp:Literal>
<asp:Literal ID="CohortOptionsLiteral" runat="server"></asp:Literal>
<script type="text/javascript">
    function LrapController($scope, $filter, $http) {

        $scope.StudentForm = {};
        $scope.StudentForm.VALIDATION_TEXT = [];
        $scope.InstitutionOptions = angular.copy(ASP_InstitutionOptions);
        $scope.CohortOptions = angular.copy(ASP_CohortOptions);

        function FormatDate(date) {
            var returnString = "";
            if (!$scope.isNullOrWhiteSpace(date) ) {
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
                //alert("|" + date + "|");
                if (!$scope.isNullOrWhiteSpace(date)) {
                   // alert("pas");
                    var dates = date.split('/');
                    var year = (dates[2].length == 2 ? twenty.concat(dates[2]) : dates[2]);
                    var month = (dates[0].length != 2 ? zero.concat(dates[0]) : dates[0]);
                    var day = (dates[1].length != 2 ? zero.concat(dates[1]) : dates[1]);

                    returnDate = year + month + day;
                }
            }
            catch (err) {
                throw new Error("Error Parsing SqlDate From Display Date: Date must be in the format of MM/dd/YYYY ");
            }

            return returnDate;
        }

      

       
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

        $scope.StatusOptions = [{ id: "Enrolled", label: "Enrolled" },
        { id: "Graduated", label: "Graduated" },
        { id: "Withdrawn", label: "Withdrawn" },
        { id: "Not Enrolled", label: "Not Enrolled" },
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
       

        $scope.HideModal = function (jqueryTargetModal) {
           // alert("HELLO");
            $(jqueryTargetModal).modal('hide');
            //SuccessToast();
        }


        /*Student Functions */

        $scope.UpdateStudent = function () {

            try {
                showToaster('Student ', 'Updating...');
                var StudentObject = {
                    COHORT_ID: $scope.StudentForm.COHORT_ID,
                    INSTITUTION_ID: $scope.StudentForm.INSTITUTION_ID,
                    FIRST_NAME: $scope.StudentForm.FIRST_NAME,
                    LAST_NAME: $scope.StudentForm.LAST_NAME,                   
                    INSTITUTION_STUDENT_ID: $scope.StudentForm.INSTITUTION_STUDENT_ID,
                    MIDDLE_NAME: $scope.StudentForm.MIDDLE_NAME,
                    MAIDEN_LAST_NAME: $scope.StudentForm.MAIDEN_LAST_NAME,
                    PHONE_1: $scope.StudentForm.PHONE_1,
                    PHONE_2: $scope.StudentForm.PHONE_2,
                    EMAIL_1: $scope.StudentForm.EMAIL_1,
                    EMAIL_2: $scope.StudentForm.EMAIL_2,
                    PARENT_EMAIL_1: $scope.StudentForm.PARENT_EMAIL_1,
                    PARENT_EMAIL_2: $scope.StudentForm.PARENT_EMAIL_2,
                    ADMITTED_CLASS: $scope.StudentForm.ADMITTED_CLASS,
                    GRADUATION_DATE_ACTUAL: FormatSqlDate($scope.StudentForm.GRADUATION_DATE_ACTUAL),
                    GENDER: $scope.StudentForm.GENDER,
                    ACT: $scope.StudentForm.ACT,
                    SAT: $scope.StudentForm.SAT,
                    GPA_UNIV: $scope.StudentForm.GPA_UNIV,
                    GPA_HS:  $scope.StudentForm.GPA_HS,
                    MAJOR_CURRENT: $scope.StudentForm.MAJOR_CURRENT,
                    MAJOR_ADMITTED: $scope.StudentForm.MAJOR_ADMITTED,
                    EFC: $scope.StudentForm.EFC,
                    BIRTHDATE: FormatSqlDate($scope.StudentForm.BIRTHDATE),
                    ADDRESS_TYPE: $scope.StudentForm.ADDRESS_TYPE,
                    ADDRESS_1: $scope.StudentForm.ADDRESS_1,
                    ADDRESS_2: $scope.StudentForm.ADDRESS_2,
                    CITY: $scope.StudentForm.CITY,
                    STATE_PROVINCE: $scope.StudentForm.STATE_PROVINCE,
                    POSTAL_CODE: $scope.StudentForm.POSTAL_CODE,
                    COUNTRY: $scope.StudentForm.COUNTRY,
                    FEE_TYPE: $scope.StudentForm.FEE_TYPE

                };

                $scope.StudentObject = angular.copy(StudentObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=NEW_STUDENT&" + GenerateQueryString($scope.StudentObject);

                //$http({ method: 'GET', url: 'http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?test=1&blah=blob' }).
                //success(function (data, status, headers, config) {
                //    alert("success: " + data);
                //}).
                //error(function (data, status, headers, config) {
                //    alert("error: " + status);
                //    });
                //alert(encodeURI(targetUrl));
                $("#localDiv").load(encodeURI(targetUrl) + " #testResponse", function (response, status, xhr) {
                    //alert("In handler");
                    clearToasts();
                    var storedProcedureResult = "" + $("#response1").attr('data-sp');
                    if (storedProcedureResult == "success") {
                        var STUDENT_ID_RESULT = "" + $("#response1").text();
                        
                        ShowToasterSuccess("New Student Created: " + $scope.StudentObject.FIRST_NAME + " " + $scope.StudentObject.LAST_NAME, "Redirecting you to their page!");
                        $scope.StudentForm = {};
                        $(location).attr('href', "http://lrapdev2013.cloudapp.net/SitePages/StudentDispForm.aspx?studentId=" + STUDENT_ID_RESULT );
                    }                   
                    else if (storedProcedureResult == "failure") {
                        var i;
                        var errors = $("#response1").text().split('|');
                        for (i = 0;i < errors.length;++i)
                        {
                            $scope.StudentForm.VALIDATION_TEXT.push(errors[i]);
                        }
                        
                        //showToasterError("New Student", "" + $("#response1").text());
                        setTimeout(function () {
                            $('[modaltarget="StudentModal"]').modal('show');
                            $scope.$apply();
                        }, 2000);
                        
                        //$scope.$apply();

                    }
                    else {
                        //alert("CONSULT KYLE");
                        showToasterError("Student", "" + "Uncaught expection...Contact Kyle or Jay if problem persists");
                    }
                });





            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };
        /*END Student Functions */



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

        $scope.isNullOrWhiteSpace = function(str) {
            if (typeof str !== 'undefined') {
                return (!str);
            }
            return true;
        }

        function isEmpty(str)
        {
            return (!str || /^\s*$/.test(str));
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
    function showToasterWarning(title, message) {
        toastr.warning(message, title);
    }
    function UpdateDate(inputId) {
        //$hiddenInput = $("#" + hiddenInputId).first();
        var newDate = $("#" + inputId).val();

        var scope = angular.element($("#" + inputId)).scope();

        scope.$apply(function () {
            if (inputId == 'StudentFormBIRTHDATE') {
                scope.StudentForm.BIRTHDATE = newDate;
            }
            else if (inputId == 'StudentFormGRADUATION_DATE_ACTUAL')
            {
                scope.StudentForm.GRADUATION_DATE_ACTUAL = newDate;
            }
           
        });
    }
</script>

<script type="text/javascript">

    $(document).ready(function () {
        $('#demo').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="example"></table>');

        $('#example').dataTable({
            "data": dataSet,
            "columns": [
                { "title": "Student Name" },
                { "title": "Institution", "width": "18%" },
                { "title": "LRAP Cohort" },
                { "title": "Fee Type" },
                { "title": "Current Status" },
                { "title": "Admitted" },
                { "title": "Current", "width": "8%" },
                { "title": "Bor" },
                { "title": "LRAP Student ID" },
                { "title": "School Student ID"}
            ],         
            "lengthMenu": [[100, 50, 25, 10], [100, 50, 25, 10]]
        });
    });
    
</script>
<div data-ng-app data-ng-controllfer="LrapController">

    <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-target="[modaltarget='StudentModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>&nbsp;New</a>
    <div id="localDiv" style="display:none" ></div>


    
    <div id="demo">

    </div>




    <!-- Modal Dialog For New Students -->
                <div class="modal fade" modaltarget="StudentModal" tabindex="-1" role="dialog" aria-labelledby="myModalTitle" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="myModalTitle">New Student</h4>
                            </div>
                            <div class="modal-body no-padding">
                                <form class="smart-form">
                                    <header>
								        General
							        </header>
                                    <fieldset>
                                        <div class="row" data-ng-hide="StudentForm.VALIDATION_TEXT.length == 0">
                                            <section class="col col-2">
                                                <label class="control-label">Error<span data-ng-show="StudentForm.VALIDATION_TEXT.length > 1">s</span>: </label>
                                            </section>
                                            <section class="col col-10">
                                                <span style="color:red" data-ng-repeat="error in StudentForm.VALIDATION_TEXT"><b>{{error}}</b><br /></span>                                                  
                                            </section>
                                        </div>                                     
                                        <div class="row">
									        <section class="col col-5">
										        <label class="input"> <i class="icon-append fa fa-user"></i>
											        <input type="text"  placeholder="Last" data-ng-model="StudentForm.LAST_NAME">
										        </label>
									        </section>
									        <section class="col col-5">
										        <label class="input"> <i class="icon-append fa fa-user"></i>
											        <input type="text"  placeholder="First" data-ng-model="StudentForm.FIRST_NAME">
										        </label>
									        </section>
                                            <section class="col col-2">
										        <label class="input"> <i class="icon-append fa fa-user"></i>
											        <input type="text"  placeholder="M.I." data-ng-model="StudentForm.MIDDLE_NAME">
										        </label>
									        </section>
								        </div>                                    
                                        <div class="row">
									        <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-user"></i>
											        <input type="text"  placeholder="Maiden Last" data-ng-model="StudentForm.MAIDEN_LAST_NAME">
										        </label>
									        </section>
									        <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-phone"></i>
											        <input type="text"  placeholder="Phone 1" data-ng-model="StudentForm.PHONE_1">
										        </label>
									        </section>
                                            <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-phone"></i>
											        <input type="text"  placeholder="Phone 2" data-ng-model="StudentForm.PHONE_2">
										        </label>
									        </section>
								        </div>
                                        <div class="row">
									        <section class="col col-6">
										        <label class="input"> <i class="icon-append fa fa-envelope"></i>
											        <input type="text"  placeholder="Email 1" data-ng-model="StudentForm.EMAIL_1">
										        </label>
									        </section>
									        <section class="col col-6">
										        <label class="input"> <i class="icon-append fa fa-envelope"></i>
											        <input type="text"  placeholder="Email 2" data-ng-model="StudentForm.EMAIL_2">
										        </label>
									        </section>                                           
								        </div>
                                        <div class="row">
									       <section class="col col-6">
										        <label class="input"> <i class="icon-append fa fa-envelope"></i>
											        <input type="text"  placeholder="Parent Email 1" data-ng-model="StudentForm.PARENT_EMAIL_1">
										        </label>
									        </section>
									        <section class="col col-6">
										        <label class="input"> <i class="icon-append fa fa-envelope"></i>
											        <input type="text"  placeholder="Parent Email 2" data-ng-model="StudentForm.PARENT_EMAIL_2">
                                                </label>
                                            </section>
								        </div>
                                        
                                        <div class="row">
									       <section class="col col-5">
										        <label class="input"> 
											        <select style="width: 100%" class="form-control" data-ng-model="StudentForm.INSTITUTION_ID" data-ng-options="InstitutionOption.INSTITUTION_ID as InstitutionOption.INSTITUTION_NAME for InstitutionOption in InstitutionOptions">
                                                        <option value="">Institution</option>
											        </select>
										        </label>
									        </section>
									        <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-tags"></i>
											         <input class="form-control" type="text" placeholder="Inst. Student ID" data-ng-model="StudentForm.INSTITUTION_STUDENT_ID" />
                                                </label>
                                            </section>
                                            <section class="col col-3">
										        <label class="input"> 
											       <select style="width: 100%" class="form-control" data-ng-model="StudentForm.ADMITTED_CLASS" data-ng-options="AdmittedClassOption.id as AdmittedClassOption.label for AdmittedClassOption in AdmittedClassOptions">
                                                       <option value="">Admit. Class</option>
											       </select>
										        </label>
									        </section>
								        </div>                                       
                                        <div class="row">
									       <section class="col col-4">
										        <label class="input"> 
											        <select style="width: 100%" class="form-control" data-ng-model="StudentForm.COHORT_ID" data-ng-options="CohortOption.COHORT_ID as CohortOption.DESCRIPTION for CohortOption in CohortOptions">
                                                        <option value="">Cohort</option>
											        </select>
										        </label>
									        </section>
									        <section class="col col-4">
										        <label class="input"> 
											        <select style="width: 100%" class="form-control" data-ng-model="StudentForm.FEE_TYPE" data-ng-options="FeeTypeOption.id as FeeTypeOption.label for FeeTypeOption in FeeTypeOptions">
                                                        <option value="">Fee Type</option>
											        </select>
                                                </label>

                                            </section>
                                            <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-calendar"></i>								
                                                    <input class="form-control datepicker" placeholder="Birthdate" data-ng-model="StudentForm.GRADUATION_DATE_ACTUAL" id="StudentFormGRADUATION_DATE_ACTUAL" onchange="UpdateDate('StudentFormGRADUATION_DATE_ACTUAL')" data-dateformat="mm/dd/yy" />
                                                </label>
                                            </section>
								        </div>
                                    </fieldset>
                                    <header>
								        Demographics
							        </header>
                                    <fieldset>
                                        <div class="row">
                                             <section class="col col-6">
									            <div class="inline-group">
										            <label class="radio">
											            <input type="radio" value="M" name="Gender" data-ng-model="StudentForm.GENDER">
											                <i></i>Male
										            </label>
										            <label class="radio">
											            <input type="radio" value="F" name="Gender" data-ng-model="StudentForm.GENDER">
											                <i></i>Female
										            </label>
										        </div>
								            </section>
                                            <section class="col col-6">
										        <label class="input"> <i class="icon-append fa fa-calendar"></i>
											        <input class="form-control datepicker" placeholder="Birthdate" data-ng-model="StudentForm.BIRTHDATE" id="StudentFormBIRTHDATE" onchange="UpdateDate('StudentFormBIRTHDATE')" data-dateformat="mm/dd/yy" />
                                                    
                                                </label>
                                            </section>
                                        </div>
                                        <div class="row">
									        <section class="col col-3">
										        <label class="input"> <i class="icon-append fa fa-bar-chart"></i>
											        <input type="text"  placeholder="H.S. GPA" data-ng-model="StudentForm.GPA_HS">
										        </label>
									        </section>
									        <section class="col col-3">
										        <label class="input"> <i class="icon-append fa fa-bar-chart"></i>
											        <input type="text"  placeholder="Univ GPA" data-ng-model="StudentForm.GPA_UNIV">
										        </label>
									        </section>
                                            <section class="col col-3">
										        <label class="input"> <i class="icon-append fa fa-calculator"></i>
											        <input type="text"  placeholder="ACT" data-ng-model="StudentForm.ACT">
										        </label>
									        </section>
                                            <section class="col col-3">
										        <label class="input"> <i class="icon-append fa fa-calculator"></i>
											        <input type="text"  placeholder="SAT" data-ng-model="StudentForm.SAT">
										        </label>
									        </section>
								        </div>
                                        <div class="row">
									        <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-calculator"></i>
											        <input type="text"  placeholder="EFC" data-ng-model="StudentForm.EFC">
										        </label>
									        </section>
									        <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-university"></i>
											        <input type="text"  placeholder="Admitted Major" data-ng-model="StudentForm.MAJOR_ADMITTED">
										        </label>
									        </section>
                                            <section class="col col-4">
										        <label class="input"> <i class="icon-append fa fa-university"></i>
											        <input type="text"  placeholder="Current Major" data-ng-model="StudentForm.MAJOR_CURRENT">
										        </label>
									        </section>                                           
								        </div>
                                    </fieldset>
                                    <header>
                                        Address
                                    </header>
                                    <fieldset>
                                        <div class="row">
                                            <section class="col col-3">
										        <label class="input">
											        <input type="text"  placeholder="Type" data-ng-model="StudentForm.ADDRESS_TYPE">
										        </label>
									        </section>
									        <section class="col col-5">
										        <label class="input"> 
											        <input type="text"  placeholder="Address 1" data-ng-model="StudentForm.ADDRESS_1">
										        </label>
									        </section>
                                            <section class="col col-4">
										        <label class="input"> 
											        <input type="text"  placeholder="Address 2" data-ng-model="StudentForm.ADDRESS_2">
										        </label>
									        </section>    
                                        </div>
                                        <div class="row">
                                            <section class="col col-5">
										        <label class="input"> 
											        <input type="text"  placeholder="City" data-ng-model="StudentForm.CITY">
										        </label>
									        </section>
									        <section class="col col-2">
										        <label class="input">
											        <input type="text"  placeholder="State" data-ng-model="StudentForm.STATE_PROVINCE">
										        </label>
									        </section>
                                            <section class="col col-2">
										        <label class="input"> 
											        <input type="text"  placeholder="Country" data-ng-model="StudentForm.COUNTRY">
										        </label>
									        </section> 
                                            <section class="col col-3">
										        <label class="input"> 
											        <input type="text"  placeholder="Zip" data-ng-model="StudentForm.POSTAL_CODE">
										        </label>
									        </section>    
                                        </div>
                                    </fieldset>





<%--                                    <div style="display:nonejquery 

                                    
                                    <fieldset>    
                                        <div class="form-group" data-ng-hide="StudentForm.VALIDATION_TEXT.length == 0">
                                            <label class="col-md-2 control-label">Error<span data-ng-show="StudentForm.VALIDATION_TEXT.length > 1">s</span>: </label>
                                            <div class="col-md-10">
                                                <span style="color:red" data-ng-repeat="error in StudentForm.VALIDATION_TEXT"><b>{{error}}</b><br /></span>  
                                            </div>
                                        </div>                                 
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">First Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.FIRST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Middle Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.MIDDLE_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Last Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.LAST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Maiden Last Name</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.MAIDEN_LAST_NAME" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Phone 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.PHONE_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Phone 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.PHONE_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Email 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.EMAIL_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Email 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.EMAIL_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Parent Email 1</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.PARENT_EMAIL_1" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Parent Email 2</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.PARENT_EMAIL_2" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Cohort</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentForm.COHORT_ID" data-ng-options="CohortOption.COHORT_ID as CohortOption.DESCRIPTION for CohortOption in CohortOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">LRAP Fee Type</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentForm.FEE_TYPE" data-ng-options="FeeTypeOption.id as FeeTypeOption.label for FeeTypeOption in FeeTypeOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Institution</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentForm.INSTITUTION_ID" data-ng-options="InstitutionOption.INSTITUTION_ID as InstitutionOption.INSTITUTION_NAME for InstitutionOption in InstitutionOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Institution Student ID</label>
                                            <div class="col-md-10">
                                                <input class="form-control" type="text" data-ng-model="StudentForm.INSTITUTION_STUDENT_ID" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Admitted Class</label>
                                            <div class="col-md-10">
                                                <select style="width: 100%" class="form-control" data-ng-model="StudentForm.ADMITTED_CLASS" data-ng-options="AdmittedClassOption.id as AdmittedClassOption.label for AdmittedClassOption in AdmittedClassOptions"></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-md-2 control-label">Graduation Date</label>

                                            <div class="col-md-10">
                                                <div class="input-icon-right">
                                                    <%--<i class="fa fa-calendar"></i>--%>
                                                    <%--<input data-ng-mouseleave="AngularApply(this)" type="text" name="mydate" placeholder="Select a date" class="form-control datepicker" data-dateformat="mm/dd/yy" data-ng-model="StudentInfoForm.graduationDate" id="TestId">
                                                    <input class="form-control datepicker" type="text" data-ng-model="StudentForm.GRADUATION_DATE_ACTUAL" />
                                                </div>
                                            </div>
                                        </div>
                                    <div class="form-group">
                                <label class="col-md-2 control-label">Gender</label>
                                <div class="col-md-8">
                                    <label class="radio radio-inline">
                                        <input type="radio" value="M" name="Gender" data-ng-model="StudentForm.GENDER">
                                        Male
                                    </label>
                                    <label class="radio radio-inline">
                                        <input type="radio" value="F" name="Gender" data-ng-model="StudentForm.GENDER">
                                        Female
                                    </label>

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Birthdate</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.BIRTHDATE_FORMATTED">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">EFC</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.EFC">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">High School GPA</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.GPA_HS">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">University GPA</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.GPA_UNIV">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Admitted Major</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentForm.MAJOR_ADMITTED">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Current Major</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentForm.MAJOR_CURRENT">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">SAT</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentForm.SAT">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">ACT</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.ACT">
                                </div>
                            </div>
                                        <div class="form-group">
                                <label class="col-md-2 control-label">Address Type</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.ADDRESS_TYPE">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Address 1</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.ADDRESS_1">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Address 2</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.ADDRESS_2">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">City</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.CITY">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">State/Province</label>
                                <div class="col-md-10">
                                    <input data-ng-model="StudentForm.STATE_PROVINCE" class="form-control" type="text">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Zip</label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="StudentForm.POSTAL_CODE">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label">Country</label>
                                <div class="col-md-10">
                                    <input  class="form-control" type="text" data-ng-model="StudentForm.COUNTRY">
                                </div>
                            </div>
                                    </fieldset>
                                </div>
                             --%>   
                                
                                </form>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=&quot;StudentModal&quot;]');">
                                    Cancel
                                </button>
                                <button type="button" class="btn btn-primary" data-ng-click="HideModal('[modaltarget=&quot;StudentModal&quot;]');UpdateStudent();">
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
