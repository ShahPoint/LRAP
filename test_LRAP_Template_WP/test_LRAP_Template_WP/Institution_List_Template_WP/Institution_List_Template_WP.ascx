<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Institution_List_Template_WP.ascx.cs" Inherits="test_LRAP_Template_WP.Institution_List_Template_WP.Institution_List_Template_WP" %>

<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
<script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.21/angular.min.js"></script>
<link type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" rel="stylesheet" />
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>

<asp:Label ID="Label1" runat="server" Text="Label" Visible="false"></asp:Label>
<asp:Literal ID="Literal1" runat="server"></asp:Literal>

<script type="text/javascript">
    function LrapController($scope, $filter, $http) {
        

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

        $scope.InstitutionForm = {
            CONTRACT_DATE: FormatDate("" + $scope.GetCurrentDate()),
            VALIDATION_TEXT: []
        };
       
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
                //alert("|" + date + "|");
                if (!isNullOrWhiteSpace(date)) {
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




        

        /* nEW ANGULAR JS FUNCTONS */

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
        $scope.HideModal = function (jqueryTargetModal) {
            // alert("HELLO");
            $(jqueryTargetModal).modal('hide');
            //SuccessToast();
        }


        /*Institution Functions */

        $scope.UpdateInstitution = function () {

            try {
                showToaster('New Institution ', 'Updating...');
                var InstitutionObject = {
                    INSTITUTION_NAME: $scope.InstitutionForm.INSTITUTION_NAME,
                    CITY: $scope.InstitutionForm.CITY,
                    STATE_PROVINCE: $scope.InstitutionForm.STATE_PROVINCE,
                    SHORT_NAME: $scope.InstitutionForm.SHORT_NAME,
                    STATUS: $scope.InstitutionForm.STATUS,
                    CONTRACT_DATE: FormatSqlDate( $scope.InstitutionForm.CONTRACT_DATE),
                    IPEDS_ID: $scope.InstitutionForm.IPEDS_ID   
                };

                $scope.InstitutionObject = angular.copy(InstitutionObject);

                var targetUrl = "http://lrapdev2013.cloudapp.net/SitePages/StoredProc.aspx?Proc=uspCreateNewInstitution&" + GenerateQueryString($scope.InstitutionObject);

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
                        var INSTITUTION_ID_RESULT = "" + $("#response1").text();

                        ShowToasterSuccess("New Institution Created: " + $scope.InstitutionObject.INSTITUTION_NAME , "Redirecting you to their page!");
                        $scope.InstitutionForm = {};
                        $(location).attr('href', "http://lrapdev2013.cloudapp.net/SitePages/InstitutionsDispForm.aspx?institutionId=" + INSTITUTION_ID_RESULT);
                    }
                    else if (storedProcedureResult == "failure") {
                        var i;
                        var errors = $("#response1").text().split('|');
                        for (i = 0;i < errors.length;++i)
                        {
                            $scope.InstitutionForm.VALIDATION_TEXT.push(errors[i]);
                        }
                        
                        //showToasterError("New Institution", "" + $("#response1").text());
                        setTimeout(function () {
                            $('[modaltarget=InstitutionModal]').modal('show');
                            $scope.$apply();
                        }, 2000);
                        
                        //$scope.$apply();

                    }
                    else {
                        //alert("CONSULT KYLE");
                        showToasterError("New Institution", "" + "Uncaught expection...Contact Kyle or Jay if problem persists");
                    }
                   
                });





            }
            catch (err) {
                clearToasts();
                showToasterError("Update Failed", err);
            }

        };
        /*END Institution Functions */



        /* eND nEW ANGULAR JS FUNCTONS */
        function FormatTimePeriod(date) {
            var returnString = "";
            if (!isNullOrWhiteSpace(date)) {
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

        function isNullOrWhiteSpace(str) {
            if (typeof str !== 'undefined') {
                return (!str);
            }
            return true;
        }

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
           
            scope.InstitutionForm.CONTRACT_DATE = newDate;
           
        });
        //$hiddenInput.trigger('change');
        //angular.element($hiddenInput).scope().$apply();
    }
</script>

<script type="text/javascript">

    $(document).ready(function () {
        $('#demo').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="example"></table>');

        $('#example').dataTable({
            "data": dataSet,
            "columns": [            
                { "title": "School", "width": "20%" },
                { "title": "Short Name" },
                { "title": "City/State" },
                { "title": "Active" },
                { "title": "Contract Date" },
                { "title": "Carnegie" },
                { "title": "Initial Cohort" },
                { "title": "IPEDS ID" },
                { "title": "Freshmen Fee Type" }
                //{ "title": "# of Enrolled" }
            ],
            "lengthMenu": [[100, 50, 25, 10], [100, 50, 25, 10]]
        });
    });

</script>
<div data-ng-app data-ng-controller="LrapController">

  
    <a href="#" style="color: black; margin-top: 4px; padding-right: 5px; padding-left: 5px;" data-toggle="modal" data-target="[modaltarget='InstitutionModal']" class="btn btn-default btn-xs"><i class="fa fa-plus"></i>&nbsp;New</a>
    <div id="localDiv" style="display:none" ></div>

 <%--   style="display:none"--%>
    
       <div id="demo">

</div>

    <!--Institution Modal -->
    <div class="modal fade" modaltarget="InstitutionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div style="width: 98%" class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="H9">New Institution</h4>
                </div>
                <div class="modal-body" style="width: 90%;">
                    <form class="form-horizontal">
                        <fieldset>
                            <div class="form-group" data-ng-hide="InstitutionForm.VALIDATION_TEXT.length == 0">
                                            <label class="col-md-2 control-label">Error<span data-ng-show="InstitutionForm.VALIDATION_TEXT.length > 1">s</span>: </label>
                                            <div class="col-md-10">
                                                <span style="color:red" data-ng-repeat="error in Institution.VALIDATION_TEXT"><b>{{error}}</b><br /></span>  
                                            </div>
                                        </div> 
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>School Name</b></label>
                                <div class="col-md-10">
                                    <input type="text" title="InstitutionModalFormId" data-ng-model="InstitutionForm.INSTITUTION_NAME" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>City</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionForm.CITY">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>State/Province</b></label>
                                <div class="col-md-10">
                                    <input data-ng-model="InstitutionForm.STATE_PROVINCE" class="form-control" type="text">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Short Name</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionForm.SHORT_NAME">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Status</b></label>
                                <div class="col-md-5">
                                    <select data-ng-model="InstitutionForm.STATUS" data-ng-options="InstitutionStatusOption.id as InstitutionStatusOption.label for InstitutionStatusOption in InstitutionStatusOptions">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label"><b>Contract Date</b></label>
                                <div class="col-md-10">
                                                
                                        <div class="input-icon-right">
                                                        <i class="fa fa-calendar"></i>
                                                        <input id="InstitutionFormCONTRACT_DATE" data-ng-model="InstitutionForm.CONTRACT_DATE" onchange="UpdateDate('InstitutionFormCONTRACT_DATE')" type="text" name="mydate" class="form-control datepicker" data-dateformat="mm/dd/yy" />                                                                                                                                          
                                                    </div>
                                   
                                    <%--<input class="form-control" type="text" data-ng-model="InstitutionForm.CONTRACT_DATE">--%>
                                </div>
                            </div>
              
                             <div class="form-group">
                                <label class="col-md-2 control-label"><b>IPEDS ID</b></label>
                                <div class="col-md-10">
                                    <input class="form-control" type="text" data-ng-model="InstitutionForm.IPEDS_ID">                                 
                                </div>
                            </div>
                           

                        </fieldset>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-ng-click="HideModal('[modaltarget=InstitutionModal]');">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary" data-ng-click="UpdateInstitution();HideModal('[modaltarget=InstitutionModal]');">
                        Submit
                    </button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!--End Institution  Modal -->
    </div>
