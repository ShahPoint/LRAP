using Microsoft.SharePoint.WebControls;
using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Text;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Microsoft.SharePoint;

namespace test_LRAP_Template_WP.Institution_Template_WP
{   
    [ToolboxItemAttribute(false)]
    public partial class Institution_Template_WP : WebPart
    {
        string lrapSchoolId = "";
        //string bdcIdentity = Page.Request.QueryString.Get("ID");
        string bdcIdentity = "__bgc1001300030003000300030003000300";
        string queryStringInstitutionInfo = @"select TOP 1 INSTITUTION.IPEDS_ID, IPEDS_CARNEGIE_CLASSIFICATION.[Carnegie Classification 2010: Basic], dbo.INSTITUTION.INSTITUTION_NAME, dbo.INSTITUTION.CITY, dbo.INSTITUTION.STATE_PROVINCE, dbo.INSTITUTION.SHORT_NAME,
                                    dbo.INSTITUTION.INSTITUTION_ID, dbo.INSTITUTION.STATUS, dbo.INSTITUTION.CONTRACT_DATE, dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAF,
                                    dbo.INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE from INSTITUTION 
	LEFT JOIN IPEDS_CARNEGIE_CLASSIFICATION ON INSTITUTION.IPEDS_ID=IPEDS_CARNEGIE_CLASSIFICATION.unitid
	LEFT join INSTITUTION_LRAP_HISTORY on INSTITUTION_LRAP_HISTORY.INSTITUTION_ID=INSTITUTION.INSTITUTION_ID
	where INSTITUTION.INSTITUTION_ID='{0}' ORDER BY INSTITUTION_LRAP_HISTORY.COHORT_ID DESC";     
        string queryStringHistoryIds = @"select dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID from dbo.INSTITUTION_LRAP_HISTORY 
                                            where dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_ID='{0}' ORDER BY dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID ASC";

        string queryStringLrapHistories = @"select dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID, dbo.INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, dbo.INSTITUTION_LRAP_HISTORY.LOWER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.UPPER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.INTRO_STUDENTS,  dbo.COHORT.DESCRIPTION from dbo.INSTITUTION_LRAP_HISTORY                     
                                                        left join dbo.COHORT on dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID=dbo.COHORT.COHORT_ID
                                            where dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_ID='{0}' ORDER BY dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID ASC";

        string queryStringLrapHistories2 = @"select  dbo.INSTITUTION_LRAP_FEE.RESERVE_ANNUAL, dbo.INSTITUTION_LRAP_FEE.RESERVE_ATGRAD, dbo.INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_FEE_ID, dbo.INSTITUTION_LRAP_FEE.FEE_TYPE, dbo.INSTITUTION_LRAP_FEE.ANNUAL_FEE_AMOUNT, dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID, dbo.INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, dbo.INSTITUTION_LRAP_HISTORY.LOWER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.UPPER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.INTRO_STUDENTS,  dbo.COHORT.DESCRIPTION, dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID from dbo.INSTITUTION_LRAP_HISTORY                     
                                                        left join dbo.COHORT on dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID=dbo.COHORT.COHORT_ID
														left join dbo.INSTITUTION_LRAP_FEE on dbo.INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_HISTORY_ID = dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID
                                            where dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_ID='{0}' AND  dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID = '{1}' ORDER BY dbo.INSTITUTION_LRAP_FEE.FEE_TYPE ASC";


        string queryStringInstitutionHistoryByFeeType = @"select dbo.INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_FEE_ID, dbo.INSTITUTION_LRAP_FEE.FEE_TYPE, dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID, dbo.INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, dbo.INSTITUTION_LRAP_HISTORY.LOWER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.UPPER_INCOME_LIMIT, dbo.INSTITUTION_LRAP_HISTORY.INTRO_STUDENTS, dbo.INSTITUTION_LRAP_FEE.ANNUAL_FEE_AMOUNT, dbo.COHORT.DESCRIPTION from dbo.INSTITUTION_LRAP_HISTORY 
                                                        left join dbo.INSTITUTION_LRAP_FEE on dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID=dbo.INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_HISTORY_ID
                                                        left join dbo.COHORT on dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID=dbo.COHORT.COHORT_ID
                                                        where dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID='{0}' AND dbo.INSTITUTION_LRAP_FEE.FEE_TYPE='{1}'";

       
        string queryStringCohorts = @"select COHORT_ID, DESCRIPTION from COHORT";
        string institutionInfoEditUrl = @"/Lists/Institution/EditForm.aspx?modal=1&ID={0}";
        string institutionHistoryNewUrl = @"/Lists/Institution%20LRAP%20History/NewForm.aspx?modal=1";
        string institutionFeeEditUrl = @"/Lists/Institution%20LRAP%20Fee/EditForm.aspx?modal=1&ID={0}";

        // Uncomment the following SecurityPermission attribute only when doing Performance Profiling on a farm solution
        // using the Instrumentation method, and then remove the SecurityPermission attribute when the code is ready
        // for production. Because the SecurityPermission attribute bypasses the security check for callers of
        // your constructor, it's not recommended for production purposes.
        // [System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityAction.Assert, UnmanagedCode = true)]
        public Institution_Template_WP()
        {
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            InitializeControl();

           
        }


        protected void Page_Load(object sender, EventArgs e)
        {



            try
            {
                using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                {
                    bdcIdentity = Page.Request.QueryString["institutionId"];
                    connection.Open();


                    QuerySQLDatabaseForInstitutionInfo(connection, queryStringInstitutionInfo, bdcIdentity);


                    //Get every Lrap History Year and associated meta data
                    StringBuilder SB = new StringBuilder();

                    List<string> JavaScriptObjectsList = new List<string>();

                    //First get every institution history id
                    List<string> historyIds = QuerySQLDatabaseForInstitutionHistoryIds(connection, queryStringHistoryIds, bdcIdentity);
                    foreach (string historyId in historyIds)
                    {
                        JavaScriptObjectsList.Add(QuerySQLDatabaseForInstitutionLrapHistoryObject(connection, queryStringLrapHistories2, bdcIdentity, historyId));
                    }

                    SB.Append(@"<script type=""text/javascript"">
                                    var ASP_InstitutionLrapHistory = [ ");


                    foreach (string JavaScriptObject in JavaScriptObjectsList)
                    {
                        SB.AppendFormat("{0},", JavaScriptObject);
                    }

                    SB.Remove(SB.Length - 1, 1);
                    SB.Append(@"];
                        </script>");

                    InstitutionLrapHistory.Text = SB.ToString();


                    //pass the Ids to a helper function which will Query the Database for every ID and return the cohort information 
                    //to a list
                    List<List<string>> institutionCohortHistory = AddInstitutionHistoryToList(connection, historyIds);

                    //pass the cohort history to helper function which displays the data to the table
                    DisplayInstitutionCohortHistory(institutionCohortHistory);


                    CohortOptions.Text = QuerySQLDatabaseForCohortOptionsObject(connection, queryStringCohorts);
                    /*
                        int count = 0;
                        //get every institution history id
                        List<string> historyIds = QuerySQLDatabaseForInstitutionHistoryIds(connection, queryStringHistoryIds, bdcIdentity);                               
                        //for each Cohort of Inst
                        StringBuilder institutionHistoryText = new StringBuilder();
                        SqlDataReader reader;
                        string[] properlyFormattedType = new String[4] { "Intro", "Freshmen", "Retention", "Transfer" };
                        foreach(string historyId in historyIds) {
                            bool firstRowEmpty = true;
                            foreach (string type in properlyFormattedType)
                            {
                                count++;
                                reader = QuerySQLDatabaseForInstitutionCohortHistory(connection, queryStringInstitutionHistoryByFeeType, type);
                                if (null != reader)
                                {
                                    count++;
                                    institutionHistoryText.Append(CreateTableHTMLForInstitutionCohortHistory(reader,firstRowEmpty));
                                    if (firstRowEmpty) {                               
                                        firstRowEmpty = false;
                                    }
                                    reader.Close();
                                }                      
                            }
                            break;
                       
                        }
                        Literal1.Text = institutionHistoryText.ToString();
                        Label1.Visible = true;
                        Label1.Text = count.ToString();
                     * 
                     * */
                    connection.Close();


                    //            using (SPSite site = new SPSite(SPContext.Current.Site.Url))
                    //            {
                    //                using (SPWeb web = site.OpenWeb())
                    //                {
                    //                    SPList list = web.Lists["Documents"];
                    //                    SPQuery qry = new SPQuery();
                    //                    qry.Query = @"   <Where>
                    //                                        <Eq>
                    //                                            <FieldRef Name='InstitutionId' />
                    //                                            <Value Type='Text'>" + lrapSchoolId + @"</Value>
                    //                                        </Eq>
                    //                                    </Where>";
                    //                    qry.ViewFields = @"<FieldRef Name='FileLeafRef' /><FieldRef Name='Title' /><FieldRef Name='InstitutionId' />";
                    //                    SPListItemCollection listItems = list.GetItems(qry);
                    //                    StringBuilder SB1 = new StringBuilder();


                    //                    SB1.Append(@"<script type=""text/javascript"">
                    //                                    var ASP_InstitutionDocuments = [ ");
                    //                    foreach (SPListItem item in listItems)
                    //                    {
                    //                        //string fileType = ("" + item["FileLeafRef"]).Split(new Char [] {'\''})[1];
                    //                        SB1.AppendFormat(@"{{
                    //                                            FileName: '{0}',                                            
                    //                                          }},",
                    //                                          "" + item["FileLeafRef"]);
                    //                    }

                    //                    SB1.Remove(SB1.Length - 1, 1);
                    //                    SB1.Append(@"];</script>");
                    //                    InstitutionDocuments.Text = SB1.ToString();
                    //                }
                    //            }
                    
                    // string institutionId = GetInstitutionIdFromBdcIdentity(bdcIdentity);

                    //Institution_Information_School_Name.Text = institutionId;
                    //Button1_Click(institutionId);

                }
                using (SPWeb web = SPContext.Current.Web)
                {
                    SPList list = web.Lists["Institution Documents"];
                    SPQuery qry = new SPQuery();
                    qry.Query = @"   <Where>
                                        <Eq>
                                            <FieldRef Name='institutionId' />
                                            <Value Type='Text'>" + lrapSchoolId + @"</Value>
                                        </Eq>
                                    </Where>";
                    //qry.ViewFields = @"<FieldRef Name='FileLeafRef' /><FieldRef Name='Title' /><FieldRef Name='InstitutionId' />";
                    SPListItemCollection listItems = list.GetItems(qry);
                    StringBuilder SB1 = new StringBuilder();


                    SB1.Append(@"<script type=""text/javascript"">
                                    var ASP_InstitutionDocuments = [ ");
                    foreach (SPListItem item in listItems)
                    {
                        //string fileType = ("" + item["FileLeafRef"]).Split(new Char[] { '\'' })[1];
                        SB1.AppendFormat(@"[
                                              '<a href=""{1}"">{0}</a>'              
                                          ],",
                                          ("" + item["FileLeafRef"]).Replace("'", "\'"),
                                          ("" + item["FileRef"]).Replace("'", "\'")

                                          );


                    }

                    SB1.Remove(SB1.Length - 1, 1);
                    SB1.Append(@"];
                    ");
                    SB1.AppendFormat("var newDocTitleLink = '{0}';",
                        ("" + list.DefaultNewFormUrl + "?institutionId=" + lrapSchoolId + "&source=" + this.Page.Request.RawUrl).Replace("'", "\'")
                        );



                    SB1.Append("</script>");
                    InstitutionDocuments.Text += SB1.ToString();
                }
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "eRROR: " + ex.Message;
            }
        }
       
        private string QuerySQLDatabaseForCohortOptionsObject(SqlConnection connection, string queryStringCohorts)
        {
             StringBuilder SB = new StringBuilder();
             SB.Append(@"<script type=""text/javascript"">
                                    var ASP_CohortOptions = [");
        
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(queryStringCohorts, connection);
            //
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                SB.AppendFormat(@"{{
                                        id: '{0}',
                                        label: '{0}',
                                        cohortId: '{1}'
                                  }},",
                                  "" + reader["DESCRIPTION"],
                                  "" + reader["COHORT_ID"]);
            }
            
            SB.Remove(SB.Length - 1, 1);
            SB.Append(@"];
                        </script>");
            reader.Close();
            return SB.ToString();
        }

        private string QuerySQLDatabaseForInstitutionLrapHistoryObject(SqlConnection connection, string queryStringLrapHistory, string id, string lrapHistoryId)
        {
            bool firstRead = true;
            StringBuilder SB = new StringBuilder();
            Dictionary<string, string> numberOfStudentsList = new Dictionary<string,string>();
          
            string newQueryString = string.Format(queryStringLrapHistory, id, lrapHistoryId);
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(newQueryString, connection);
            //
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
              
                //If its the first read for a historyId
                if (firstRead)
                {
                    firstRead = false;
                    SB.AppendFormat(@"{0} 
                                    INSTITUTION_LRAP_HISTORY_ID: '{1}',
                                    DESCRIPTION: '{2}',
                                    FRESHMEN_FEE_TYPE: '{3}',
                                    LOWER_INCOME_LIMIT: '{4}',
                                    UPPER_INCOME_LIMIT: '{5}',
                                    INTRO_STUDENTS: '{6}',
                                    COHORT_ID: '{7}',
                                    ",
                                      "{",
                                      "" + reader["INSTITUTION_LRAP_HISTORY_ID"],
                                      "" + reader["DESCRIPTION"],
                                      "" + reader["FRESHMEN_FEE_TYPE"],
                                     FormatStringDecimalToStringInt( "" + reader["LOWER_INCOME_LIMIT"]),
                                     FormatStringDecimalToStringInt( "" + reader["UPPER_INCOME_LIMIT"]),
                                      "" + reader["INTRO_STUDENTS"],
                                      "" + reader["COHORT_ID"]
                               );
                }
                switch ("" + reader["FEE_TYPE"])
                {
                    case "Intro":
                        SB.AppendFormat(@"  INTRO_INSTITUTION_LRAP_FEE_ID: '{0}',
                                    INTRO_ANNUAL_FEE_AMOUNT: '{1}',",
                                  "" + reader["INSTITUTION_LRAP_FEE_ID"],
                                 FormatStringToRoundedDecimal( "" + reader["ANNUAL_FEE_AMOUNT"])
                                 );
                        numberOfStudentsList = QuerySqlDatabaseForBorrowers("Intro", "" + reader["COHORT_ID"], lrapSchoolId);
                        if (numberOfStudentsList.Count != 0 )
                        {
                            SB.AppendFormat(@"  INTRO_NUMBER_OF_STUDENTS: '{0}',
                                    INTRO_NUMBER_OF_BORROWERS: '{1}',",
                                 "" + numberOfStudentsList["Students"],
                                "" + numberOfStudentsList["Borrowers"]
                                );
                        }
                        break;
                    case "Freshmen":
                        SB.AppendFormat(@"  FRESHMEN_INSTITUTION_LRAP_FEE_ID: '{0}',
                                    FRESHMEN_ANNUAL_FEE_AMOUNT: '{1}',
                                    FRESHMEN_RESERVE_ANNUAL: '{2}',
                                    FRESHMEN_RESERVE_ATGRAD: '{3}',",
                                  "" + reader["INSTITUTION_LRAP_FEE_ID"],
                                 FormatStringToRoundedDecimal("" + reader["ANNUAL_FEE_AMOUNT"]),
                                  FormatStringToRoundedDecimal("" + reader["RESERVE_ANNUAL"]),
                                  FormatStringToRoundedDecimal("" + reader["RESERVE_ATGRAD"])
                                 );
                        numberOfStudentsList = QuerySqlDatabaseForBorrowers("Intro", "" + reader["COHORT_ID"], lrapSchoolId);
                        if (numberOfStudentsList.Count != 0 )
                        {
                            SB.AppendFormat(@"  INTRO_NUMBER_OF_STUDENTS: '{0}',
                                    INTRO_NUMBER_OF_BORROWERS: '{1}',",
                                 "" + numberOfStudentsList["Students"],
                                "" + numberOfStudentsList["Borrowers"]
                                );
                        }
                        break;
                    case "Transfer":
                        SB.AppendFormat(@"  TRANSFER_INSTITUTION_LRAP_FEE_ID: '{0}',
                                    TRANSFER_ANNUAL_FEE_AMOUNT: '{1}',
                                    TRANSFER_RESERVE_ANNUAL: '{2}',
                                    TRANSFER_RESERVE_ATGRAD: '{3}',",
                                  "" + reader["INSTITUTION_LRAP_FEE_ID"],
                                 FormatStringToRoundedDecimal( "" + reader["ANNUAL_FEE_AMOUNT"]),
                                 FormatStringToRoundedDecimal( "" + reader["RESERVE_ANNUAL"]),
                                 FormatStringToRoundedDecimal( "" + reader["RESERVE_ATGRAD"])
                                 );
                        break;
                    case "Retention":
                        SB.AppendFormat(@"  RETENTION_INSTITUTION_LRAP_FEE_ID: '{0}',
                                    RETENTION_ANNUAL_FEE_AMOUNT: '{1}',
                                    RETENTION_RESERVE_ANNUAL: '{2}',
                                    RETENTION_RESERVE_ATGRAD: '{3}',",
                                  "" + reader["INSTITUTION_LRAP_FEE_ID"],
                                  FormatStringToRoundedDecimal("" + reader["ANNUAL_FEE_AMOUNT"]),
                                   FormatStringToRoundedDecimal("" + reader["RESERVE_ANNUAL"]),
                                   FormatStringToRoundedDecimal("" + reader["RESERVE_ATGRAD"])
                                 );
                        break;
                }
//                //If its the first read for a historyId
//                if (firstRead)
//                {
//                    firstRead = false;
//                    SB.AppendFormat(@"{0} 
//                                    INSTITUTION_LRAP_HISTORY_ID: '{1}',
//                                    DESCRIPTION: '{2}',
//                                    FRESHMEN_FEE_TYPE: '{3}',
//                                    LOWER_INCOME_LIMIT: '{4}',
//                                    UPPER_INCOME_LIMIT: '{5}',
//                                    INTRO_STUDENTS: '{6}',
//                                    LRAP_FEES: [",
//                                      "{",
//                                      "" + reader["INSTITUTION_LRAP_HISTORY_ID"],
//                                      "" + reader["DESCRIPTION"],
//                                      "" + reader["FRESHMEN_FEE_TYPE"],
//                                      "" + reader["LOWER_INCOME_LIMIT"],
//                                      "" + reader["UPPER_INCOME_LIMIT"],
//                                      "" + reader["INTRO_STUDENTS"]
//                               );
//                }
//                SB.AppendFormat(@"{0}
//                                  INSTITUTION_LRAP_FEE_ID: '{1}',
//                                    FEE_TYPE: '{2}',
//                                    ANNUAL_FEE_AMOUNT: '{3}',
//                                    RESERVE_ANNUAL: '{4}',
//                                    RESERVE_ATGRAD: '{5}'
//                                    {6},
//                                ",
//                                 "{",
//                                 "" + reader["INSTITUTION_LRAP_FEE_ID"],
//                                 "" + reader["FEE_TYPE"],
//                                 "" + reader["ANNUAL_FEE_AMOUNT"],
//                                 "" + reader["RESERVE_ANNUAL"],
//                                 "" + reader["RESERVE_ATGRAD"],
//                                 "}");
            }
            SB.Remove(SB.Length - 1, 1);
            SB.Append(@"}");
            reader.Close();

            return SB.ToString();
        }

        private Dictionary<string,string> QuerySqlDatabaseForBorrowers(string feeType, string cohortId, string lrapSchoolId)
        {
            Dictionary<string, string> returnList = new Dictionary<string,string>();
            string query = String.Format(@"select
       i.INSTITUTION_ID,
	   c.description
	   ,count(distinct s.student_id) Students
       ,count(distinct ss.STUDENT_ID) Borrowers
	  

from
       institution i
       inner join student s on i.INSTITUTION_ID = s.INSTITUTION_ID
	   inner join COHORT c on s.COHORT_ID = c.COHORT_ID
	   left join STUDENT_STATUS ss on s.STUDENT_ID = ss.STUDENT_ID and ss.BORROWING = 'Y' 
	  
	   where i.INSTITUTION_ID='{0}' and c.COHORT_ID='{1}'and FEE_TYPE='{2}'
	   group by
       i.INSTITUTION_ID
       ,c.DESCRIPTION
	   ORDER BY INSTITUTION_ID ASC
	  ",lrapSchoolId, cohortId, feeType);

            using (SqlConnection connection2 = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
            {
                connection2.Open();
                 SqlCommand command = new SqlCommand(query, connection2);
                    //
                    SqlDataReader reader = command.ExecuteReader();

                    //DataTable table = new DataTable();



                    if (reader.HasRows)
                    {
                        reader.Read();
                        returnList.Add("Students", "" + reader["Students"]);
                        returnList.Add("Borrowers", "" + reader["Borrowers"]);
                        
                    }

                    reader.Close();
                    connection2.Close();
            }

            return returnList;

        }

        private void DisplayInstitutionCohortHistory(List<List<string>> institutionCohortHistory)
        {
            //Atach New Button
            //Institution_LRAP_History_New_Button.Text = GetNewButton(institutionHistoryNewUrl, "New Institution LRAP History");
            StringBuilder lrapHistoryTableBuilder = new StringBuilder();
            foreach (List<string> cohort in institutionCohortHistory)
            {
                lrapHistoryTableBuilder.Append("<tr>");
                foreach (string column in cohort)
                {
                    lrapHistoryTableBuilder.Append("<td>" + column + "</td>");
                }
                lrapHistoryTableBuilder.Append("</tr>");
            }
            //replace literal web control with table data
            Institution_LRAP_History.Text = lrapHistoryTableBuilder.ToString();
            
        }

        private List<List<string>>  AddInstitutionHistoryToList(SqlConnection connection, List<string> historyIds)
        {
         
           
            string[] feeTypes = new String[] { "Intro", "Freshmen", "Retention", "Transfer" };

            List<List<string>> dataTableListList = new List<List<string>>();

            foreach (string id in historyIds)
            {
                
                foreach (string feeType in feeTypes)
                {
                    string newQueryString = string.Format(queryStringInstitutionHistoryByFeeType, id, feeType);
                    // Create the Command which will be used to obtain query answer
                    SqlCommand command = new SqlCommand(newQueryString, connection);
                    //
                    SqlDataReader reader = command.ExecuteReader();

                    //DataTable table = new DataTable();



                    if (reader.HasRows)
                    {
                        reader.Read();
                        //Label1.Text += "<br> " + id + ":" + feeType + ":" + reader["INSTITUTION_LRAP_HISTORY_ID"] + ":" + reader["FRESHMEN_FEE_TYPE"] + ":" + reader["LOWER_INCOME_LIMIT"] + ":" + reader["UPPER_INCOME_LIMIT"] + ":" + reader["INTRO_STUDENTS"] + ":" + reader["ANNUAL_FEE_AMOUNT"] + ":" + reader["DESCRIPTION"] + ":";
                        string getEditButtonUrl = string.Format(institutionFeeEditUrl, GetBgcIdentityFromId("" + reader["INSTITUTION_LRAP_FEE_ID"]));
               
                        string cohortColumn = "" + reader["DESCRIPTION"] + ": " + reader["FRESHMEN_FEE_TYPE"];
                        string feeTypeColumn = (feeType == "Intro") ? "Intro (#)" : feeType;
                        dataTableListList.Add(new List<string>() { (dataTableListList.Where(x => x[0] == cohortColumn).Count() > 0 ? "" : cohortColumn), 
                                                                        (GetEditButton(getEditButtonUrl,"Edit Institution LRAP Fee")),
                                                                        feeTypeColumn, 
                                                                        ( (feeTypeColumn == "Intro (#)") ? (formatMoneyString("" + reader["ANNUAL_FEE_AMOUNT"]) + " (" + "" + reader["INTRO_STUDENTS"] + ")") : (formatMoneyString("" + reader["ANNUAL_FEE_AMOUNT"])) ),
                                                                        "",
                                                                        "",
                                                                        formatMoneyString("" + reader["UPPER_INCOME_LIMIT"]),
                                                                        formatMoneyString("" + reader["LOWER_INCOME_LIMIT"]) 
                                                                     }
                                             );

                    }

                    //Label1.Text += "<br> " + id + ":" + feeType + ":" + reader.HasRows.ToString() + ":";
                    reader.Close();
                }
            }

            /*
             * 
             * 
             * 
             * Bind To GridView
             * *
             * *
             * 
            var institutionHistoryList = from item in dataTableListList
                                         select new
                                         {
                                             Cohort = "" + item[0],
                                             FeeType = "" + item[1],
                                             AnnualFee = "" + item[2],
                                             NumberOfStudents = "",
                                             NumberOfBorrowers = "",
                                             UIT = "" + item[3],
                                             LIT = "" + item[4]
                                         };

            //institutionHistoryList = institutionHistoryList.OrderBy(c => c.ID);
            /*
            GridView gridView = new GridView();
            gridView.DataSource = institutionHistoryList;
            gridView.DataBind();

            Controls.Add(gridView);
             * */

          
            return dataTableListList;
        }

        private string FormatStringToRoundedDecimal(string number)
        {
            string returnString = "";
            if (!string.IsNullOrEmpty(number))
            {
                returnString = Math.Round(decimal.Parse(number), 2).ToString();
            }
            return returnString;
        }

        private string FormatStringDecimalToStringInt(string deci)
        {
            string returnInt = deci.Split(new char[]{'.'})[0];

    
            return returnInt;
        }
        private List<string> QuerySQLDatabaseForInstitutionHistoryIds(SqlConnection connection, string queryStringHistoryIds, string id)
        {
            List<string> historyIds = new List<string>();

            string newQuery = string.Format(queryStringHistoryIds, id);
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                historyIds.Add("" + reader["INSTITUTION_LRAP_HISTORY_ID"]);
            }
            reader.Close();


            return historyIds;
        }

        private string formatMoneyString(string money)
        {
            int length = money.Length;
            string formattedMoney = "";
            if (length >= 6)
            {
                StringBuilder moneyBuilder = new StringBuilder();
                string cents = money.Substring((length-1)-3,2);
                string dollars = money.Substring(0,(length-1)-4);
                string dollarsWithCommas = string.Format("{0:#,###0}", int.Parse(dollars));
                //string dollarsWithCommas = int.Parse(dollars).ToString("N",new CultureInfo("en-US"));
                moneyBuilder.AppendFormat("${0}.{1}", dollarsWithCommas, cents);
                formattedMoney = moneyBuilder.ToString();
            }
            return formattedMoney;
        }

        /*private SqlDataReader QuerySQLDatabaseForInstitutionCohortHistory(SqlConnection connection, string queryString, string cohortType)
        {
            SqlDataReader returnReader = null;
            String newQueryString = String.Format(queryString, cohortType);
           
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(queryString, connection);
                //
            returnReader = command.ExecuteReader();
                
            if(!returnReader.HasRows) {
                returnReader.Close();
                returnReader = null;
            }                            
            
            
            
            return returnReader;
        }*/

        /* Old Query
        private List<string> QuerySQLDatabaseForInstitutionHistoryIds(SqlConnection connection, string queryString, string bdcIdentity)
        {
            List<string> historyIds = new List<string>();
            try
            {         
                // Create the Command which will be used to obtain query answer
                SqlCommand command = new SqlCommand(queryString, connection);
                //
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    historyIds.Add("" + reader["INSTITUTION_LRAP_HISTORY_ID"]);
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "eRROR: " + ex.Message;

            }
            
            return historyIds;
        }
        */

        private void QuerySQLDatabaseForInstitutionInfo(SqlConnection connection, string queryString, string id)
        {
            
            int count = 0;
            string newQuery = string.Format(queryString, id);
            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(newQuery, connection);
                //
            
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                    count++;
                    InsertDataIntoInstitutionInfoTable(reader);
                    break;
            }

                //Institution_Info_Short_Name.Text = "<p>" + count.ToString() + "</p>";
                //foreach (KeyValuePair<string, string> entry in dictionary)
                //{
                //    //AddBoundField(grid, entry.Key, entry.Value);
                //}

                /*
                                while (reader.Read())
                                {
                    
                                //List<object> stuff = reader. .Select(r => new { CustomerID = r["CITY"], CustomerName = r["STATE/PROVINCE"] }).ToList();
                                //Label1.Text = (string)reader.GetValue(0) + " " + (string)reader.GetValue(1); // On first iteration will be hello
                                //var value2 = reader.GetValue(1); // On first iteration will be hello2
                                //var value3 = reader.GetValue(2); // On first iteration will be hello3
                                //}

                                //reader
                                //event handler added
                                //grid.RowDataBound += grid_RowDataBound;
                */
                /*
                              grid.DataSource = reader;
                              grid.DataBind();


                              foreach (SPGridViewRow row in grid.Rows)
                              {
                                  row.Cells[0].Text = @"<a href=""#"" onclick='CreateModal(""http://lrapdev2013.cloudapp.net/Lists/" + listName + @"/DispForm.aspx?ID=" + CreateBgcId(row.Cells[1].Text) + @""", ""Display Details"")'>Show Details</a>";
                              }

                              grid.Columns[1].Visible = false;*/
            reader.Close();            
        }

        private void InsertDataIntoInstitutionInfoTable(SqlDataReader reader)
        {
            CreateInstitutionInformationJsObject(reader);
            //Atach Edit Button
            string editButtonUrl = string.Format(institutionInfoEditUrl, GetBgcIdentityFromId("" + reader["INSTITUTION_ID"]));
            //Institution_Information_Edit_Button.Text = GetEditButton(editButtonUrl, "Edit Institution Information");
            //check if variables are empty and replace if necessary
            //string carnegie = string.IsNullOrEmpty("" + reader["PILOT_DESCRIPTION"]) ? "N/A" : ("" + reader["PILOT_DESCRIPTION"]);
            string city = string.IsNullOrEmpty("" + reader["CITY"]) ? "" : ("" + reader["CITY"]);
            string state = string.IsNullOrEmpty("" + reader["STATE_PROVINCE"]) ? "" : ("" + reader["STATE_PROVINCE"]);
            string contractDate = ("" + reader["CONTRACT_DATE"]);
            if (!string.IsNullOrEmpty(contractDate))
            {
                contractDate = string.Format("{0}/{1}/{2}",contractDate.Substring(4, 2),contractDate.Substring(6, 2),contractDate.Substring(0, 4));
            }
            else
            {
                contractDate = "N/A";
            }
            
            string freshmenType = string.IsNullOrEmpty("" + reader["FRESHMEN_FEE_TYPE"]) ? "N/A" : ("" + reader["FRESHMEN_FEE_TYPE"]);
            string lraf = string.IsNullOrEmpty("" + reader["INSTITUTION_LRAF"]) ? "N/A" : ("" + reader["INSTITUTION_LRAF"]);
            lrapSchoolId = string.IsNullOrEmpty("" + reader["INSTITUTION_ID"]) ? "N/A" : ("" + reader["INSTITUTION_ID"]);
            string schoolName = string.IsNullOrEmpty("" + reader["INSTITUTION_NAME"]) ? "N/A" : ("" + reader["INSTITUTION_NAME"]);
            string shortName = string.IsNullOrEmpty("" + reader["SHORT_NAME"]) ? "N/A" : ("" + reader["SHORT_NAME"]);
            string status = string.IsNullOrEmpty("" + reader["STATUS"]) ? "N/A" : ("" + reader["STATUS"]);

            //Institution_Info_Carnegie.Text = string.Format("<p>{0}</p>", carnegie);
            
            ////handle display of city and state 
            //if (city == "N/A" && state != "N/A")
            //{
            //    Institution_Info_City_State.Text = string.Format("<p>{0}</p>", state);
            //}
            //else if(city != "N/A" && state == "N/A") {
            //    Institution_Info_City_State.Text = string.Format("<p>{0}</p>", city);
            //}
            //else if (city == "N/A" && state == "N/A")
            //{
            //    Institution_Info_City_State.Text = string.Format("<p>{0}</p>", city);
            //}
            //else
            //{
            //    Institution_Info_City_State.Text = string.Format("<p>{0}, {1}</p>", city, state);
            //}
            //Institution_Info_Contract_Date.Text = string.Format("<p>{0}</p>", contractDate);
            //Institution_Info_Freshmen_Type.Text = string.Format("<p>{0}</p>", freshmenType);
            //Institution_Info_LRAF.Text = string.Format("<p>{0}</p>", lraf);
            //Institution_Info_LRAP_School_ID.Text = string.Format("<p>{0}</p>", lrapSchoolId);
            //Institution_Info_School_Name.Text = string.Format("<p>{0}</p>", schoolName);
            //Institution_Info_Short_Name.Text = string.Format("<p>{0}</p>", shortName);
            //Institution_Info_Status.Text = string.Format("<p>{0}</p>", status);
             
        }

        private void CreateInstitutionInformationJsObject(SqlDataReader reader)
        {
            StringBuilder SB = new StringBuilder();

            string contractDate = ("" + reader["CONTRACT_DATE"]);
            if (!string.IsNullOrEmpty(contractDate))
            {
                contractDate = string.Format("{0}/{1}/{2}",contractDate.Substring(4, 2),contractDate.Substring(6, 2),contractDate.Substring(0, 4));
            }

            SB.Append(@"<script type=""text/javascript"">
                                    var ASP_InstitutionInformation = {");

            SB.AppendFormat(@"INSTITUTION_NAME: '{0}',
                                CONTRACT_DATE: '{1}',
                                CITY: '{2}',
                                STATE_PROVINCE: '{3}',
                                INSTITUTION_LRAF: '{4}',
                                SHORT_NAME: '{5}',
                                FRESHMEN_FEE_TYPE: '{6}',
                                INSTITUTION_ID: '{7}',
                                STATUS: '{8}',
                                IPEDS_ID: '{9}',
                                CARNEGIE_CLASSIFICATION: ""{10}""                               
                              ",
                               "" + reader["INSTITUTION_NAME"],
                               contractDate,
                               "" + reader["CITY"],
                               "" + reader["STATE_PROVINCE"],
                               "" + reader["INSTITUTION_LRAF"],
                               "" + reader["SHORT_NAME"],
                               "" + reader["FRESHMEN_FEE_TYPE"],
                               "" + reader["INSTITUTION_ID"],
                               "" + reader["STATUS"],
                               "" + reader["IPEDS_ID"],
                               "" + reader["Carnegie Classification 2010: Basic"]
            );
                   
            SB.Append(@"};
                        </script>");
            InstitutionInformation.Text = SB.ToString();
        }



        private string GetBgcIdentityFromId(string id)
        {
            char[] chars = id.ToCharArray();
            string bgcId = string.Format("__bgc100{0}300{1}300{2}300{3}300{4}300{5}300{6}300", chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6]);

            return bgcId;
        }

        private string GetEditButton(string serverRelativeUrl, string title)
        {
            return @"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" OnClick=""ShowDialog_Click('" + serverRelativeUrl + @"','" + title + @"');return false;"" class=""btn btn-default btn-xs""> <i class=""fa fa-edit""></i> Edit</a>";
        }

        private string GetNewButton(string serverRelativeUrl, string title)
        {
            return @"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" OnClick=""ShowDialog_Click('" + serverRelativeUrl + @"','" + title + @"');return false;"" class=""btn btn-default btn-xs""> <i class=""fa fa-plus""></i> New</a>";
        }

         private string GetInstitutionIdFromBdcIdentity(string bdcIdentity)
        {
            char[] chars = bdcIdentity.ToCharArray();
            string institutionId = string.Format("{0}{1}{2}{3}{4}{5}{6}", chars[7], chars[11], chars[15], chars[19], chars[23], chars[27]);

            return institutionId;
        }
    /*
      //  private void AddQueryToGridManual(SqlConnection connection, string queryString, SPGridView grid, string listName)
        {
            try
            {
                // Create the Command which will be used to obtain query answer
                SqlCommand command = new SqlCommand(queryString, connection);

                //
                SqlDataReader reader = command.ExecuteReader();

                grid.AutoGenerateColumns = false;

                //foreach (KeyValuePair<string, string> entry in dictionary)
                //{
                //    //AddBoundField(grid, entry.Key, entry.Value);
                //}


                // while (reader.Read())
                //{
                // object[] values = new object[100];
                //reader.GetSqlValues(values);

                //List<object> stuff = reader. .Select(r => new { CustomerID = r["CITY"], CustomerName = r["STATE/PROVINCE"] }).ToList();
                //Label1.Text = (string)reader.GetValue(0) + " " + (string)reader.GetValue(1); // On first iteration will be hello
                //var value2 = reader.GetValue(1); // On first iteration will be hello2
                //var value3 = reader.GetValue(2); // On first iteration will be hello3
                //}

                //reader
                //event handler added
                //grid.RowDataBound += grid_RowDataBound;

                grid.DataSource = reader;
                grid.DataBind();


                foreach (SPGridViewRow row in grid.Rows)
                {
                    row.Cells[0].Text = @"<a href=""#"" onclick='CreateModal(""http://lrapdev2013.cloudapp.net/Lists/" + listName + @"/DispForm.aspx?ID=" + CreateBgcId(row.Cells[1].Text) + @""", ""Display Details"")'>Show Details</a>";
                }

                grid.Columns[1].Visible = false;
                reader.Close();

            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "eRROR: " + ex.Message;
            }
        }

      //  //void grid_RowDataBound(object sender, GridViewRowEventArgs e)
        //{

        //Label1.Text = "22|" + e.Row.Cells[0].Text + "|";
        //e.Row.Cells[0].Text = @"<a href=""#"" onclick='CreateModal(""http://lrapdev2013.cloudapp.net/Lists/Student/DispForm2.aspx?ID=""" + CreateBgcId(e.Row.Cells[0].Text) + @", ""Display Details"")'Show Details</a>";
        //e.Row.Cells[0].Text = 
        // }

      //  private string CreateBgcId(string id)
        {
            char[] chars = id.ToCharArray();
            string urlId = string.Format("__bgc100{0}300{1}300{2}300{3}300{4}300{5}300{6}300", chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6]);
            return urlId;
        }


      //  private void AddBoundField(GridView grid, string internalName, string displayName)
        {
            BoundField colDescriptione = new BoundField();
            colDescriptione.DataField = internalName;
            colDescriptione.HeaderText = displayName;
            colDescriptione.SortExpression = internalName;
            grid.Columns.Add(colDescriptione);
        }

       // protected void Button1_Click(string studentID)
        {
            using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
            {
                connection.Open();
                //Dictionary<string, string> gridColumnsAddress = new Dictionary<string, string>() {{"ITEM","ITEM"}, { "CITY", "CITY" }, { "STATE_PROVINCE", "STATE/PROVINCE" } };
                //Dictionary<string, string> gridColumnsDemographics = new Dictionary<string, string>() { { "EFC", "EFC" }, { "GPA_UNIV", "UNIVERSITY GPA" }, { "MAJOR_CURRENT", "CURRENT MAJOR" }, { "SAT", "SAT" } };
                //Dictionary<string, string> gridColumnsLoans = new Dictionary<string, string>() { { "STATUS_PERIOD", "STATUS_PERIOD" }, { "LOAN_AMOUNT", "LOAN_AMOUNT" }, { "LOAN_AMOUNT_TYPE", "LOAN_AMOUNT_TYPE" } };
                //Dictionary<string, string> gridColumnsStatus = new Dictionary<string, string>() { { "CURRENT_CLASS", "CURRENT_CLASS" }, { "STATUS_PERIOD", "STATUS_PERIOD" }, { "BORROWING", "BORROWING" } };

                //String studentID = TextBox1.Text;
                String addressQuery = String.Format("select STUDENT_ADDRESS_ID, CITY, STATE_PROVINCE from dbo.STUDENT_ADDRESS where STUDENT_ID='{0}'", studentID);
                String demographicsQuery = String.Format("select STUDENT_DEMOGRAPHICS_ID, EFC,GPA_UNIV, MAJOR_CURRENT, SAT from dbo.STUDENT_DEMOGRAPHICS where STUDENT_ID='{0}'", studentID);
                String loansQuery = String.Format("select STUDENT_LOANS_ID, STATUS_PERIOD, LOAN_AMOUNT, LOAN_AMOUNT_TYPE from dbo.STUDENT_LOANS where STUDENT_ID='{0}'", studentID);
                String statusQuery = String.Format("select STUDENT_STATUS_ID, CURRENT_CLASS,STATUS_PERIOD,BORROWING from dbo.STUDENT_STATUS where STUDENT_ID='{0}'", studentID);

                String addressList = "Student%20Address";
                String demographicsList = "Student%20Demographics";
                String loansList = "Student%20Loans";
                String statusList = "Student%20Status";

                //GridView GridView1 = new GridView();
                //GridView GridView2 = new GridView();
                //GridView GridView3 = new GridView();
                //GridView GridView4 = new GridView();

                //AddQueryToGrid(connection, "select CITY, STATE_PROVINCE from dbo.STUDENT_ADDRESS where STUDENT_ID='1000598'", GridView1, Label1);
                AddQueryToGridManual(connection, addressQuery, grdViewAddr, addressList);
                AddQueryToGridManual(connection, demographicsQuery, grdViewDemo, demographicsList);
                AddQueryToGridManual(connection, loansQuery, grdViewLoans, loansList);
                AddQueryToGridManual(connection, statusQuery, grdViewStatus, statusList);
            }
         
        }
         * */
    }
}
