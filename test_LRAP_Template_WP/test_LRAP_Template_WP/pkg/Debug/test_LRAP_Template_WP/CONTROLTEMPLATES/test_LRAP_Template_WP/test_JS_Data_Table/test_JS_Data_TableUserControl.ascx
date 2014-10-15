<%@ Assembly Name="test_LRAP_Template_WP, Version=1.0.0.0, Culture=neutral, PublicKeyToken=3ea45007b5501931" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="test_JS_Data_TableUserControl.ascx.cs" Inherits="test_LRAP_Template_WP.test_JS_Data_Table.test_JS_Data_TableUserControl" %>

<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
<script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<asp:Literal ID="Literal1" runat="server"></asp:Literal>
<script type="text/javascript">
    ///*
	//		* DIALOG HEADER I*/

    //// Modal Link
    //$('#modal_link').click(function () {
    //    $('#dialog-message').dialog('open');
    //    return false;
    //});

    //$("#dialog-message").dialog({
    //    autoOpen: false,
    //    modal: true,
    //    title: "<div class='widget-header'><h4><i class='icon-ok'></i> jQuery UI Dialog</h4></div>",
    //    buttons: [{
    //        html: "Cancel",
    //        "class": "btn btn-default",
    //        click: function () {
    //            $(this).dialog("close");
    //        }
    //    }, {
    //        html: "<i class='fa fa-check'></i>&nbsp; OK",
    //        "class": "btn btn-primary",
    //        click: function () {
    //            $(this).dialog("close");
    //        }
    //    }]

    //});

    ///*
    // * Remove focus from buttons
    // */
    //$('.ui-dialog :button').blur();
    function ShowDialog_Click() 
    {


        var options = {
            url: '/Lists/Test%20Modal/NewForm.aspx?modal=1',
            title: 'My Dialog', 
            allowMaximize: false, 
            showClose: true, 
            width: 600, 
            height: 600,
            dialogReturnValueCallback: myDialogCallback
        };

        SP.SOD.execute('sp.ui.dialog.js', 'SP.UI.ModalDialog.showModalDialog', options);

    
    }

    function myDialogCallback(dialogResult, data) {
        alert("+" + dialogResult);
        if (dialogResult == SP.UI.DialogResult.OK) {
            alert("User hit OK");
        }
        else if (dialogResult == SP.UI.DialogResult.cancel) {
            alert("user hit cancel");
        }
        else {
            alert("other");
        }
        // this will refresh your page if dialogResult is successful
        SP.UI.ModalDialog.RefreshPage(dialogResult);
    }



</script>

<script type="text/javascript">

    $(document).ready(function () {
        $('#demo').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="example"></table>');

        $('#example').dataTable({
            "data": dataSet,
            "columns": [
                { "title": "Student Name" },
                { "title": "Institution Name" },
                { "title": "LRAP Fee Type" },
                { "title": "Freshman Fee Type" },
                { "title": "Admitted Class" },
                { "title": "Student ID" }
            ]
        });
    });

</script>
<asp:Button ID="Button1" runat="server" Text="Button" OnClientClick="ShowDialog_Click();return false;" />

<asp:Label ID="Label1" runat="server" Text="Label" Visible="false"></asp:Label>
<div id="demo">

</div>
