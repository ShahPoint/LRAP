using Microsoft.SharePoint;
using Microsoft.SharePoint.WebPartPages;
using System;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI.WebControls.WebParts;



namespace test_LRAP_Template_WP.Institution_List_Template_WP
{
    [ToolboxItemAttribute(false)]
    public partial class Institution_List_Template_WP : System.Web.UI.WebControls.WebParts.WebPart
    {
        string institutionQuery = @"select recent.FRESHMEN_FEE_TYPE, INSTITUTION.IPEDS_ID, IPEDS_CARNEGIE_CLASSIFICATION.[Carnegie Classification 2010: Basic], COHORT.DESCRIPTION, INSTITUTION.INSTITUTION_ID, INSTITUTION.INSTITUTION_NAME, INSTITUTION.SHORT_NAME, 
                          INSTITUTION.CONTRACT_DATE, INSTITUTION.CITY, INSTITUTION.STATE_PROVINCE, INSTITUTION.STATUS FROM dbo.INSTITUTION
						  left join dbo.IPEDS_CARNEGIE_CLASSIFICATION on INSTITUTION.IPEDS_ID=IPEDS_CARNEGIE_CLASSIFICATION.unitid
						  left join COHORT ON COHORT.COHORT_ID=INSTITUTION.INITIAL_COHORT
						  left join
						  (select query2.* from
							(select INSTITUTION_LRAP_HISTORY.INSTITUTION_ID, MAX(INSTITUTION_LRAP_HISTORY.COHORT_ID) as MaxCohort from INSTITUTION_LRAP_HISTORY group by INSTITUTION_ID) query1,
							(select INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, INSTITUTION_LRAP_HISTORY.INSTITUTION_ID, INSTITUTION_LRAP_HISTORY.COHORT_ID FROM INSTITUTION_LRAP_HISTORY) query2 
								where query1.INSTITUTION_ID = query2.INSTITUTION_ID and query1.MaxCohort = query2.COHORT_ID) 
								recent ON recent.INSTITUTION_ID = INSTITUTION.INSTITUTION_ID
								order by INSTITUTION.INSTITUTION_ID";
        // Uncomment the following SecurityPermission attribute only when doing Performance Profiling on a farm solution
        // using the Instrumentation method, and then remove the SecurityPermission attribute when the code is ready
        // for production. Because the SecurityPermission attribute bypasses the security check for callers of
        // your constructor, it's not recommended for production purposes.
        // [System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityAction.Assert, UnmanagedCode = true)]
        public Institution_List_Template_WP()
        {
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            InitializeControl();
        }

        protected void Page_Load(object sender, EventArgs e)
        {           
            try {
                //getWebPartProperty("InstitutionDisplayFormURL");
                using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                {
                    connection.Open();
                    Literal1.Text = string.Format(@"<script type=""text/javascript"">
                                    var dataSet = [
{0}
                                    ];

                                </script>", QueryDatabaseForInstitutionList(connection, institutionQuery));
                }
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "ERROR:  " + ex.Message;
            }
        }

        private void getWebPartProperty(string p)
        {
            Label1.Visible = true;
            string propertyValue = "";
            SPWeb mySite = SPContext.Current.Web;
            SPLimitedWebPartManager wpManager = mySite.GetLimitedWebPartManager("http://lrapdev2013.cloudapp.net/SitePages/InstitutionsView.aspx", PersonalizationScope.Shared);

            SPLimitedWebPartCollection webParts = wpManager.WebParts;
            foreach (System.Web.UI.WebControls.WebParts.WebPart webPart in webParts)
            {
                if (webPart.Title == "test_LRAP_Template_WP - Institution_List_Template_WP")
                {
                    //string propertyValue = webPart.get
                }
                
            }
            

            //return "blah";
        }

        private string QueryDatabaseForInstitutionList(SqlConnection connection, string institutionQuery)
        {
                       
            //String dataRow = @"<tr><td><a href=""InstitutionsDispForm.aspx?institutionId={4}"">{0}</a></td><td>{1}</td><td>{2}</td><td>{3}</td></tr>";
            StringBuilder stringBuilder = new StringBuilder();
            
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(institutionQuery, connection);
            //
            SqlDataReader reader = command.ExecuteReader();
                
            while (reader.Read()) {
                string dateString;
                if (!string.IsNullOrEmpty("" + reader["CONTRACT_DATE"]))
                {
                    string date = "" + reader["CONTRACT_DATE"];
                    DateTime dateTime = new DateTime(Int32.Parse(date.Substring(0, 4)), Int32.Parse(date.Substring(4, 2)), Int32.Parse(date.Substring(6, 2)));
                    dateString = "" + dateTime.ToString("MM/dd/yyyy");
                }
                else
                {
                    dateString = "";
                }

              
                stringBuilder.AppendFormat(@"['<a href=""InstitutionsDispForm.aspx?institutionId={4}"">{0}</a>', '{1}', '{2}', '{3}', '{5}', ""{6}"", '{7}', '{8}', '{9}'],", 
                                                                    "" + reader["INSTITUTION_NAME"], 
                                                                    "" + reader["SHORT_NAME"], 
                                                                    "" + reader["CITY"] + ", " + reader["STATE_PROVINCE"], 
                                                                    "" + reader["STATUS"], 
                                                                    "" + reader["INSTITUTION_ID"],
                                                                    dateString,
                                                                    "" + reader["Carnegie Classification 2010: Basic"],
                                                                    "" + reader["DESCRIPTION"],
                                                                    "" + reader["IPEDS_ID"],
                                                                    "" + reader["FRESHMEN_FEE_TYPE"]
                                                                    );
            }


            return stringBuilder.ToString().TrimEnd(',');
        }
        
    }
}
