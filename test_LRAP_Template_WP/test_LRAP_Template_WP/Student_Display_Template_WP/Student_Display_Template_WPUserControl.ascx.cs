using Microsoft.SharePoint;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace test_LRAP_Template_WP.Student_Display_Template_WP
{
    public partial class Student_Display_Template_WPUserControl : UserControl
    {
        //string bdcIdentity = Page.Request.QueryString.Get("ID");
        string studentId = "";
        string studentFeeType = "";
        string studentInitialStatusPeriod = "";
        decimal studentLoansFederalAmount = 0.0M;
        decimal studentLoansOtherAmount = 0.0M;

   
        string queryStringStudentInfo = @"select TOP 1 dbo.STUDENT.STUDENT_ID, dbo.STUDENT.INSTITUTION_ID, dbo.STUDENT.LAST_NAME, dbo.STUDENT.FIRST_NAME, dbo.STUDENT.MIDDLE_NAME, dbo.STUDENT.MAIDEN_LAST_NAME, dbo.STUDENT.FEE_TYPE,
	                                            dbo.STUDENT_Address.CITY, dbo.STUDENT_ADDRESS.STATE_PROVINCE, dbo.STUDENT.LRAP_STUDENT_ID, dbo.STUDENT.INSTITUTION_STUDENT_ID,
	                                            dbo.INSTITUTION.INSTITUTION_NAME, dbo.STUDENT.INSTITUTION_STUDENT_ID, dbo.STUDENT.ADMITTED_CLASS, dbo.STUDENT.COHORT_ID,
	                                            dbo.STUDENT_STATUS.CURRENT_CLASS, dbo.STUDENT.PHONE_1, dbo.STUDENT.PHONE_2, dbo.STUDENT.EMAIL_1, dbo.STUDENT.AWARD_LETTER,
	                                            dbo.STUDENT.EMAIL_2, dbo.STUDENT.PARENT_EMAIL_1, dbo.STUDENT.PARENT_EMAIL_2, dbo.STUDENT.GRADUATION_DATE_ACTUAL, STUDENT_STATUS.STATUS_PERIOD
	                                            from STUDENT
	                                            left join STUDENT_ADDRESS on student.STUDENT_ID=STUDENT_ADDRESS.STUDENT_ID
	                                            left join INSTITUTION ON STUDENT.INSTITUTION_ID=INSTITUTION.INSTITUTION_ID
	                                            left join STUDENT_STATUS ON STUDENT_STATUS.STUDENT_ID=STUDENT.STUDENT_ID
	                                            where STUDENT.STUDENT_ID='{0}' order by STATUS_PERIOD DESC";


        string queryStringInstitutionOptions = "select INSTITUTION.INSTITUTION_NAME, INSTITUTION_ID from INSTITUTION ORDER BY INSTITUTION_NAME ASC";



//        string queryStringStudentInstitutions = @"select dbo.STUDENT_STATUS.STUDENT_STATUS_ID, dbo.STUDENT_STATUS.STATUS_PERIOD, dbo.STUDENT_STATUS.STATUS, dbo.STUDENT_STATUS.CURRENT_CLASS,
//	                                                dbo.STUDENT_STATUS.BORROWING, dbo.STUDENT_STATUS.CALC_FEE, dbo.STUDENT_STATUS.RETRO_PERIOD, dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID, dbo.COHORT.START_DATE
//	                                                from STUDENT_STATUS
//	                                                left join dbo.STUDENT on dbo.STUDENT_STATUS.STUDENT_ID=dbo.STUDENT.STUDENT_ID
//	                                                left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID
//	                                                left join dbo.INSTITUTION_LRAP_HISTORY on dbo.INSTITUTION.INSTITUTION_ID = dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_ID
//                                                    left join dbo.COHORT on dbo.COHORT.COHORT_ID=dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID and (dbo.COHORT.START_DATE= dbo.STUDENT_STATUS.STATUS_PERIOD OR dbo.COHORT.START_DATE=(dbo.STUDENT_STATUS.STATUS_PERIOD - 9300))
//	                                                where STUDENT_STATUS.STUDENT_ID='{0}' AND dbo.COHORT.START_DATE IS NOT NULL
//	                                                order by dbo.STUDENT_STATUS.STATUS_PERIOD asc";

        string queryStringStudentInstitutions = @"select * from STUDENT_STATUS where STUDENT_STATUS.STUDENT_ID='{0}' order by dbo.STUDENT_STATUS.STATUS_PERIOD asc";

//        string queryStringStudentAnnualAmount = @"select ANNUAL_FEE_AMOUNT
//	                                                from STUDENT_STATUS
//	                                                left join dbo.STUDENT on dbo.STUDENT_STATUS.STUDENT_ID=dbo.STUDENT.STUDENT_ID
//	                                                left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID
//	                                                left join dbo.INSTITUTION_LRAP_HISTORY on dbo.INSTITUTION.INSTITUTION_ID = dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_ID
//	                                                left join dbo.COHORT on dbo.COHORT.COHORT_ID=dbo.INSTITUTION_LRAP_HISTORY.COHORT_ID
//	                                                left join dbo.INSTITUTION_LRAP_FEE on dbo.INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID=dbo.INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_HISTORY_ID
//													where STUDENT_STATUS.STUDENT_ID='{0}' AND dbo.COHORT.START_DATE='{1}' AND dbo.INSTITUTION_LRAP_FEE.FEE_TYPE='{2}'";
        
//        string queryStringStudentLrapDetails = @"select COHORT.DESCRIPTION, STUDENT.FEE_TYPE, STUDENT_STATUS.RETRO_PERIOD, STUDENT_STATUS.CURRENT_CLASS, STUDENT_STATUS.BORROWING
//                                                    from STUDENT
//                                                    left join COHORT on STUDENT.COHORT_ID=COHORT.COHORT_ID
//                                                    left join STUDENT_STATUS on STUDENT_STATUS.STUDENT_ID=STUDENT.STUDENT_ID
//                                                    WHERE STUDENT.STUDENT_ID='1000000'
//                                                    order by STUDENT_STATUS.STATUS_PERIOD asc ";
////        string queryStringStudentLrapDetails2 = @"SELECT tt.STATUS_PERIOD, tt.STUDENT_STATUS_ID, STUDENT.AWARD_LETTER, INSTITUTION_LRAP_FEE.ANNUAL_FEE_AMOUNT, inst.FRESHMEN_FEE_TYPE, inst.LOWER_INCOME_LIMIT, inst.UPPER_INCOME_LIMIT, COHORT.DESCRIPTION, COHORT.START_DATE, STUDENT.COHORT_ID, STUDENT.FEE_TYPE, tt.RETRO_PERIOD, tt.CURRENT_CLASS,tt.BORROWING from STUDENT_STATUS tt
//                                                    left join STUDENT on STUDENT.STUDENT_ID=tt.STUDENT_ID
//                                                    left join COHORT on COHORT.COHORT_ID=STUDENT.COHORT_ID
//                                                    right join
//                                                       (select MIN(STUDENT_STATUS.STATUS_PERIOD) as MinStatusPeriod from STUDENT_STATUS where STUDENT_ID='{0}') groupedtt ON tt.STATUS_PERIOD = groupedtt.MinStatusPeriod
//                                                    left join
//	                                                    (select INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID, INSTITUTION_LRAP_HISTORY.LOWER_INCOME_LIMIT, INSTITUTION_LRAP_HISTORY.UPPER_INCOME_LIMIT, INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, INSTITUTION_LRAP_HISTORY.COHORT_ID, INSTITUTION_LRAP_HISTORY.INSTITUTION_ID from INSTITUTION_LRAP_HISTORY) inst 
//		                                                    ON inst.COHORT_ID=cohort.COHORT_ID AND inst.INSTITUTION_ID=STUDENT.INSTITUTION_ID
//                                                    left join INSTITUTION_LRAP_FEE ON INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_HISTORY_ID=inst.INSTITUTION_LRAP_HISTORY_ID AND INSTITUTION_LRAP_FEE.FEE_TYPE=STUDENT.FEE_TYPE
//                                                       where tt.STUDENT_ID='{0}'";

                     string queryStringStudentLrapDetails2    = @"select student.COHORT_ID, student.FEE_TYPE, student.AWARD_LETTER, INSTITUTION_LRAP_HISTORY.LOWER_INCOME_LIMIT, INSTITUTION_LRAP_HISTORY.UPPER_INCOME_LIMIT, INSTITUTION_LRAP_HISTORY.FRESHMEN_FEE_TYPE, INSTITUTION_LRAP_FEE.ANNUAL_FEE_AMOUNT from student 
inner join INSTITUTION_LRAP_HISTORY ON INSTITUTION_LRAP_HISTORY.INSTITUTION_ID=STUDENT.INSTITUTION_ID and INSTITUTION_LRAP_HISTORY.COHORT_ID=STUDENT.COHORT_ID
inner join INSTITUTION_LRAP_FEE ON INSTITUTION_LRAP_FEE.FEE_TYPE=STUDENT.FEE_TYPE AND INSTITUTION_LRAP_FEE.INSTITUTION_LRAP_HISTORY_ID=INSTITUTION_LRAP_HISTORY.INSTITUTION_LRAP_HISTORY_ID
where STUDENT_ID='{0}'";
        string queryStringStudentAddresses = @"select * from STUDENT_ADDRESS where STUDENT_ID='{0}'";

        string queryStringStudentLoans = @"select STUDENT_LOANS_ID, STATUS_PERIOD, DESCRIPTION, LOAN_AMOUNT, NOTES, LOAN_AMOUNT_TYPE, LOAN_TYPE_ID from STUDENT_LOANS
	                                            left join STUDENT_LOANS_TYPE on STUDENT_LOANS.LOAN_TYPE_ID=STUDENT_LOANS_TYPE.STUDENT_LOANS_TYPE_ID
	                                            where STUDENT_ID='{0}'
	                                            order by STATUS_PERIOD desc
                                            ";

        string studentAddressTableRow = @"<div class=""row"">
                                                        <section class=""col col-2"">
                                                            <div class=""col col-12"">
                                                                <p>{0}</p>
                                                            </div>
                                                        </section>
                                                        <section class=""col col-3"">
                                                            <div class=""col col-12"">
                                                                <p>{1}</p>
                                                            </div>
                                                        </section>
                                                        <section class=""col col-7"">
                                                            <div class=""col col-12"">
                                                                <p>{2}</p>
                                                            </div>
                                                        </section>
                                                    </div>";
        string studentLoanTableRow = @"<tr>
                                            <td style=""width:1px"" align=""center"">{0}</td>
                                            <td>{1}</td>
                                            <td>{2}</td>
                                            <td>{3}</td>
                                            <td>{4}</td>
                                       </tr>";
        string studentLoanTotalTableRow = @"<tr>
                                                        <td></td>
                                                        <td><b>{0}</b></td>
                                                        <td></td>                                                 
                                                        <td><b>{1} {2}</b></td>
                                                        <td></td>
                                                    </tr>";


        string queryStringStudentDemographics = @"select STUDENT_DEMOGRAPHICS_ID, GENDER, BIRTHDATE, EFC, GPA_HS, GPA_UNIV, SAT, ACT, MAJOR_ADMITTED, MAJOR_CURRENT from STUDENT_DEMOGRAPHICS where STUDENT_ID='{0}'";
        string queryStringCohortOptions = @"select COHORT_ID, DESCRIPTION from COHORT ORDER BY COHORT_ID ASC ";
        string studentInfoEditUrl =  @"/Lists/Student/EditForm.aspx?modal=1&ID={0}";
        string studentLoanEditUrl = @"/Lists/Student%20Loans/EditForm.aspx?modal=1&ID={0}";
        string studentDetailEditUrl = @"/Lists/Student%20Status/EditForm.aspx?modal=1&ID={0}";
        string studentDemographicEditUrl = @"/Lists/Student%20Demographics/EditForm.aspx?modal=1&ID={0}";
        string studentLoanNewUrl = @"/Lists/Student%20Loans/NewForm.aspx?modal=1";
        string studentAddressesNewUrl = @"/Lists/Student%20Address/NewForm.aspx?modal=1";
        string optionHtml = @"<option value=""{0}"">{1}</option>";
        
        
        protected void Page_Load(object sender, EventArgs e)
        {
            studentId = Page.Request.QueryString["studentId"];
            try
            {
                using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                {
                    connection.Open();
                    CohortOptionsLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_CohortOptions = {0}; </script>", GenerateCohortOptionsJsObject(connection));

                    StudentInformationLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_StudentInformation = {0}; </script>", GenerateStudentInformationJsObject(connection));
                    
                    InstitutionOptionsLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_InstitutionOptions = {0}; </script>", GenerateInstitutionOptionsJsObject(connection));

                    StudentStatusesLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_StudentStatuses = {0}; </script>", GenerateStudentStatusesJsObject(connection));

                    StudentLrapDetailsLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_StudentLrapDetails = {0}; </script>", GenerateStudentLrapDetailsJsObject(connection));

                    StudentDemoLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_StudentDemo = {0}; </script>", GenerateStudentDemoJsObject(connection));

                    StudentAddressLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_StudentAddress = {0}; </script>", GenerateStudentAddressJsObject(connection));
                    
                    StudentLoansLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                   var ASP_StudentLoans = {0};
                               </script>", GenerateStudentLoansJsObject(connection));
                    
                    
//                    QuerySQLDatabaseForStudentInfo(connection, queryStringStudentInfo, bdcIdentity);
//                    QuerySQLDatabaseForStudentLrapDetails(connection, queryStringStudentLrapDetails2, bdcIdentity);
//                    StudentStatusesLiteral.Text = string.Format(@"<script type=""text/javascript"">
//                                    var studentStatuses = [{0}];
//
//                                </script>", QuerySQLDatabaseForStudentInstitutions(connection, queryStringStudentInstitutions, bdcIdentity));

//                    //List<List<string>> studentInstitutions = QuerySQLDatabaseForStudentInstitutions(connection, queryStringStudentInstitutions, bdcIdentity);
//                    // DisplayStudentInstitutionsWithFee(studentInstitutions, connection, bdcIdentity);

//                    QuerySQLDatabaseForStudentDemographics(connection, queryStringStudentDemographics, bdcIdentity);
//                    StudentAddressLiteral.Text = string.Format(@"<script type=""text/javascript"">
//                                    var studentAddresses = [{0}];
//
//                                </script>", QuerySQLDatabseForStudentAddresses(connection, queryStringStudentAddresses, bdcIdentity));
//                    //List<List<string>> studentAddresses = QuerySQLDatabseForStudentAddresses(connection, queryStringStudentAddresses, bdcIdentity);
//                    //DisplayStudentAddress(studentAddresses, connection, bdcIdentity);
//                    StudentLoansLiteral.Text = string.Format(@"<script type=""text/javascript"">
//                                    var studentLoans = [{0}];
//
//                                </script>", QuerySQLDatabaseForStudentLoans(connection, queryStringStudentLoans, bdcIdentity));

//                    //List<List<string>> studentLoans = QuerySQLDatabaseForStudentLoans(connection, queryStringStudentLoans, bdcIdentity);
//                    //DisplayStudentLoans(studentLoans, connection, bdcIdentity);
//                    //List<List<string>> partialStudentDetails = QuerySQLDatabaseForStudentLrapDetails(connection, queryStringStudentLrapDetails, bdcIdentity);
//                    //DisplayStudentDetailsWithFee(partialStudentDetails, connection, bdcIdentity);
//                    AttachNewAndEditButtons();
                    
                    
                }
                using (SPWeb web = SPContext.Current.Web)
                {
                    SPList list = web.Lists["Student Documents"];
                    SPQuery qry = new SPQuery();
                    qry.Query = @"   <Where>
                                        <Eq>
                                            <FieldRef Name='studentId' />
                                            <Value Type='Text'>" + studentId + @"</Value>
                                        </Eq>
                                    </Where>";
                    //qry.ViewFields = @"<FieldRef Name='FileLeafRef' /><FieldRef Name='Title' /><FieldRef Name='InstitutionId' />";
                    SPListItemCollection listItems = list.GetItems(qry);
                    StringBuilder SB1 = new StringBuilder();


                    SB1.Append(@"<script type=""text/javascript"">
                                    var ASP_StudentDocuments = [ ");
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
                        ("" + list.DefaultNewFormUrl + "?studentId=" + studentId + "&Source=" + this.Page.Request.RawUrl).Replace("'", "\'")
                        );



                    SB1.Append("</script>");
                    StudentDocumentsLiteral.Text += SB1.ToString();
                }
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "ERROR: " + ex.Message + "|" + ex.Source + "|" + ex.StackTrace + "|" + ex.ToString();
            }
        }

        private string GenerateCohortOptionsJsObject(SqlConnection connection)
        {
            //string newQuery = string.Format(queryStringCohortOptions, studentId);
            SqlCommand command = new SqlCommand(queryStringCohortOptions, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");


            return DTblToJsArray(dt);
        }

        private string GenerateStudentLoansJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentLoans, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");


            return DTblToJsArray(dt);
        }

        private string GenerateStudentAddressJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentAddresses, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");


            return DTblToJsArray(dt);
        }

        private string GenerateStudentDemoJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentDemographics, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");

            return DTblToJsObject(dt);
        }

        private string GenerateStudentLrapDetailsJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentLrapDetails2, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");

        

            return DTblToJsObject(dt);
        }

        private string GenerateStudentStatusesJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentInstitutions, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();
           
           
            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");


            return DTblToJsArray(dt);
        }

        private string GenerateStudentInformationJsObject(SqlConnection connection)
        {
            string newQuery = string.Format(queryStringStudentInfo, studentId);
            SqlCommand command = new SqlCommand(newQuery, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");

          

            return DTblToJsObject(dt);
        }

        private string GenerateInstitutionOptionsJsObject(SqlConnection connection)
        {
            //string newQuery = string.Format(queryStringInstitutionOptions, studentId);
            SqlCommand command = new SqlCommand(queryStringInstitutionOptions, connection);
            //
            SqlDataAdapter da = new SqlDataAdapter(command);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();

            //FormatDateInDateTable(dt, "GRADUATION_DATE_ACTUAL");

         

            return DTblToJsArray(dt);
        }

        //private void FormatDateInDateTable(DataTable dt, string columnName)
        //{
        //    dt.Columns[columnName].DataType = 
            
        //    foreach (DataRow dr in dt.Rows)
        //    {
        //        foreach (DataColumn dc in dt.Columns)
        //        {
        //            if(dc.ToString() == columnName)
        //            {
        //                dr[dc] = FormatSQLDateToStringDate("" + dr[dc]);
        //            }                   
        //        }
        //    }
        //}

        //Input a DataTable and it will be returned as an array of javascript objects for each row in the table
        public String DTblToJsArray(DataTable tbl)
        {
            StringBuilder SB = new StringBuilder();

            SB.Append("[ ");
            
            foreach (DataRow dr in tbl.Rows)
            {
                SB.Append("{ ");
                foreach (DataColumn dc in tbl.Columns)
                {
                    SB.Append("" + dc.ToString() + ": \"" + dr[dc].ToString() + "\",");
                }
                SB.Remove(SB.Length - 1, 1);
                SB.Append("},");              
            }
            SB.Remove(SB.Length - 1, 1);
            SB.Append("]"); 

            return SB.ToString();
        }
        //Input a DataTable and it will be returned as an array of javascript objects for each row in the table
        public String DTblToJsObject(DataTable tbl)
        {
            StringBuilder SB = new StringBuilder();
          
            SB.Append("{ ");
            foreach (DataRow dr in tbl.Rows)
            {
               
                foreach (DataColumn dc in tbl.Columns)
                {
                    SB.Append("" + dc.ToString() + ": \"" + dr[dc].ToString() + "\",");                   
                }
                
            }

            SB.Remove(SB.Length - 1, 1);
            SB.Append("}");
            return SB.ToString();
        }

        private void FillFormsWithCohortOptions(SqlConnection connection, string cohortQuery)
        {
            //SqlCommand command = new SqlCommand(cohortQuery, connection);
            ////
            //SqlDataReader reader = command.ExecuteReader();
            //StringBuilder cohortSb = new StringBuilder();
            ////Dictionary<string,string> cohortsList = new Dictionary<string,string>();
            //while (reader.Read())
            //{
            //    //cohortsList.Add(("" + reader["COHORT_ID"]),("" + reader["DESCRIPTION"]));
            //    cohortSb.AppendFormat(optionHtml, "" + reader["COHORT_ID"], "" + reader["DESCRIPTION"]);
               
            //}
            ////StudentEditForm_Cohort.DataSource = cohortsList;
            ////StudentEditForm_Cohort.DataTextField = "Value";
            ////StudentEditForm_Cohort.DataValueField = "Key";
            ////StudentEditForm_Cohort.DataBind();

            ////editLrapDetails_Cohort.DataSource = cohortsList;
            ////editLrapDetails_Cohort.DataTextField = "Value";
            ////editLrapDetails_Cohort.DataValueField = "Key";
            ////editLrapDetails_Cohort.DataBind();

            //reader.Close();
            ////StudentEditForm_CohortOptions.Text = cohortSb.ToString();
            //StudentEditForm_CohortOptions2.Text = cohortSb.ToString();
        }
          
        private void AttachNewAndEditButtons()
        {
 
        }
      
        
        private void QuerySQLDatabaseForStudentLrapDetails(SqlConnection connection, string queryString, string id)
        {
            //string newQuery = string.Format(queryString, id);
            //SqlCommand command = new SqlCommand(newQuery, connection);
            ////
            //SqlDataReader reader = command.ExecuteReader();
            //while (reader.Read())
            //{
            //    InsertDataIntoStudentLrapDetailsTable(reader);
            //    break;
            //}
            //reader.Close();
            ///* Old version of code
            //List<List<string>> details = new List<List<string>>();
            //string newQuery = string.Format(queryString, id);
            //SqlCommand command = new SqlCommand(newQuery, connection);
            ////
            //SqlDataReader reader = command.ExecuteReader();
            //while (reader.Read())
            //{
            //    details.Add( new List<string>(){ "" + reader["DESCRIPTION"],
            //                                      "" + reader["FEE_TYPE"],
            //                                      "" + reader["CURRENT_CLASS"],
            //                                      "" + reader["RETRO_PERIOD"],
            //                                      "" + reader["BORROWING"],
            //                                      " ",
            //    });
            //    break;
            //}
            //reader.Close();

            //return details; */
        }

        //private void QuerySQLDatabaseForStudentDemographics(SqlConnection connection, string queryString, string id)
        //{
        //    string newQuery = string.Format(queryString, id);
        //    SqlCommand command = new SqlCommand(newQuery, connection);
        //    //
        //    SqlDataReader reader = command.ExecuteReader();
        //    while (reader.Read())
        //    {
        //        InsertDataIntoStudentDemographicsTable(reader);
        //        break;
        //    }
        //    reader.Close();
        //}        

        //private void DisplayStudentInstitutionsWithFee(List<List<string>> studentInstitutions, SqlConnection connection, string id)
        //{
        //    //0 = Edit Button For Student Status
        //    //1= Status
        //    //2 = Current Class
        //    //3 = Borrowing
        //    //4 = Retro Period
        //    //5 = Start Date
        //    //6 = Annual Amount
        //    bool isTransfer = false;
        //    StringBuilder studentInstitutionsTableBuilder = new StringBuilder();
        //    for(int i=0;i<studentInstitutions.Count;++i)    
        //    {
        //        List<string> cohort = studentInstitutions[i];
        //        studentInstitutionsTableBuilder.Append("<tr>");
        //        for(int j=0;j<cohort.Count;++j) 
        //        {
        //            if (j != 6) {
        //                if (j == 0)
        //                {
        //                    string column = cohort[j];
        //                    studentInstitutionsTableBuilder.Append(@"<td style=""width:1px"" align=""center"">" + column + "</td>");
        //                }
        //                else
        //                {
        //                    string column = cohort[j];
        //                    studentInstitutionsTableBuilder.Append("<td>" + column + "</td>");
        //                }
                        
        //            }
        //        }
        //        if(i == 0 && cohort[3] != "FR") {
        //            isTransfer=true;
        //        }

        //        string annualAmount = "";
        //        if (cohort[4] == "Y" && !string.IsNullOrEmpty(studentFeeType))
        //        {
        //            //if (cohort[3] == "FR")
        //            //{
        //            //    annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, cohort[6], "Freshmen");
        //            //}
        //            //else if (i == 0 && isTransfer) //transfer year
        //            //{
        //            //    annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, cohort[6], "Transfer");
        //            //}
        //            //else if (i != 0)
        //            //{
        //            //    annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, cohort[6], "Retention");
        //            //}
        //            //else
        //            //{
        //            //    annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, cohort[6], "Intro");
        //            //}
        //            annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, cohort[6], studentFeeType);
                    
        //        }
        //        studentInstitutionsTableBuilder.Append("<td>" + annualAmount + "</td>");
        //        studentInstitutionsTableBuilder.Append("</tr>");
        //    }
        //    //replace literal web control with table data
        //    Student_Institution_History.Text = studentInstitutionsTableBuilder.ToString();
        //}

        //private void DisplayStudentAddress(List<List<string>> studentAddresses, SqlConnection connection, string bdcIdentity)
        //{
        //    //Atach New Button
        //    //Student_Addresses_New_Button.Text = GetNewButton(studentAddressesNewUrl, "New Student Address");
        //    //Student_Addresses_New_Button.Text = GetNewButton2("editStudentAddressModal", "");

        //    StringBuilder studentAddressesTableBuilder = new StringBuilder();
        //    for (int i = 0; i < studentAddresses.Count; ++i)
        //    {
        //        List<string> address = studentAddresses[i];

        //        string studentAddress = string.Format(studentAddressTableRow, address[0], address[1], address[2]);
        //        studentAddressesTableBuilder.Append(studentAddress);
        //    }

        //    //Student_Addresses.Text = studentAddressesTableBuilder.ToString();
        //}

        //private void DisplayStudentLoans(List<List<string>> studentLoans, SqlConnection connection, string bdcIdentity)
        //{
        //    //Atach New Button
        //    //Student_Loans_New_Button.Text = GetNewButton(studentLoanNewUrl, "New Student Loan");
        //    //Student_Loans_New_Button.Text = GetNewButton2("newStudentLoanModal", "");

        //    StringBuilder studentLoansTableBuilder = new StringBuilder();
            
        //    //0 = edit button
        //    //1 = Date time
        //    //2 = Description
        //    //3 = Loan amount
        //    //4 = notes
        //    for (int i = 0; i < studentLoans.Count; ++i)
        //    {
        //        List<string> loan = studentLoans[i];

        //        string studentLoan = string.Format(studentLoanTableRow, loan[0], loan[1], loan[2], loan[3], loan[4]);
        //        studentLoansTableBuilder.Append(studentLoan);
        //    }

            

        //    /*
        //     * Calculate Sub Totals and display if necessary
        //     * */
        //    decimal studentLoansTotal = studentLoansFederalAmount + studentLoansOtherAmount;
        //    StringBuilder studentLoanSubtotal = new StringBuilder();
        //    if (studentLoansTotal != 0)
        //    {
        //        //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Federal", formatMoneyString(studentLoansFederalAmount.ToString()), "(" + formatPercentage(studentLoansFederalAmount/studentLoansTotal) + ")"));
        //        //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Other", formatMoneyString(studentLoansOtherAmount.ToString()), "(" + formatPercentage(studentLoansOtherAmount / studentLoansTotal) + ")"));
        //        //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Total Loans", formatMoneyString(studentLoansTotal.ToString()), ""));
             
        //        studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Federal", studentLoansFederalAmount.ToString("C0"), "(" + formatPercentage(studentLoansFederalAmount / studentLoansTotal) + ")"));
        //        studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Other", studentLoansOtherAmount.ToString("C0"), "(" + formatPercentage(studentLoansOtherAmount / studentLoansTotal) + ")"));
        //        studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Total Loans", studentLoansTotal.ToString("C0"), ""));
            
        //    }
        //    else
        //    {
        //        studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "No Loans Recorded", "", ""));
        //    }

        //    studentLoansTableBuilder.Append(studentLoanSubtotal.ToString());
        //    Student_Loans_Literal.Text = studentLoansTableBuilder.ToString();
        //}

        //private string formatPercentage(decimal p)
        //{
        //    string percentage;

        //    NumberFormatInfo nfi = new CultureInfo("en-US", false).NumberFormat;
        //    nfi.PercentDecimalDigits = 0;
        //    percentage = p.ToString("P", nfi);

        //    return percentage;
        //}

    
//        private string QuerySQLDatabaseForStudentInstitutionAmount(SqlConnection connection,string queryString, string id, string startDate, string feeType)
//        {
//            string annualAmount = "";
//            string newQuery = string.Format(queryString, id, startDate, feeType);
//            SqlCommand command = new SqlCommand(newQuery, connection);
//            SqlDataReader reader = command.ExecuteReader();
//            while (reader.Read())
//            {
//                annualAmount = formatMoneyString("" + reader["ANNUAL_FEE_AMOUNT"]);
//                break;
//            }

//            reader.Close();
//            return annualAmount;
//        }

//        private string GetEditButton(string serverRelativeUrl, string title)
//        {
//            return @"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" OnClick=""ShowDialog_Click('" + serverRelativeUrl + @"','" + title + @"');return false;"" class=""btn btn-default btn-xs""> <i class=""fa fa-edit""></i> Edit</a>";
//        }
//        private string GetEditButton2(string modalId, string attributes)
//        {
//            return string.Format(@"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" data-toggle=""modal"" data-target=""#{0}"" class=""btn btn-default btn-xs"" {1}> <i class=""fa fa-edit""></i> Edit</a>", modalId, attributes);
//        }
//        private string GetEditButtonWithIndex(int index, string modalId, string attributes)
//        {
//            return string.Format(@"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" onclick=""OpenEditModal(\'{0}\', \'" + index + @"\')"" class=""btn btn-default btn-xs"" {1}> <i class=""fa fa-edit""></i> Edit</a>", modalId, attributes);
//        }

//        private string GetNewButton(string serverRelativeUrl, string title)
//        {
//            return @"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" OnClick=""ShowDialog_Click('" + serverRelativeUrl + @"','" + title + @"');return false;"" class=""btn btn-default btn-xs""> <i class=""fa fa-plus""></i> New</a>";
//        }
       
//        private string GetNewButton2(string modalId, string attributes)
//        {
//            return string.Format(@"<a href=""#"" style=""color:black;margin-top:4px;padding-right:5px;padding-left:5px;"" data-toggle=""modal"" data-target=""#{0}"" class=""btn btn-default btn-xs""> <i class=""fa fa-plus""></i> New</a>", modalId, attributes);
//        }

//        private string QuerySQLDatabaseForStudentInstitutions(SqlConnection connection, string queryStringStudentInstitutions, string id)
//        {
//            int index = 1;
//            List<List<string>> studentInstitutionDataList = new List<List<string>>();
//            string annualAmount = "";
//            if (!string.IsNullOrEmpty(studentFeeType) && !string.IsNullOrEmpty(studentInitialStatusPeriod))
//            {
//                annualAmount = QuerySQLDatabaseForStudentInstitutionAmount(connection, queryStringStudentAnnualAmount, id, studentInitialStatusPeriod, studentFeeType);
//            }
//            string newQuery = string.Format(queryStringStudentInstitutions, id);
//            SqlCommand command = new SqlCommand(newQuery, connection);
//            //
//            SqlDataReader reader = command.ExecuteReader();
//            StringBuilder stringBuilder = new StringBuilder();
           
//            while (reader.Read())
//            {
               
//                string date = ("" + reader["STATUS_PERIOD"]);
//                DateTime dateTime = new DateTime(Int32.Parse(date.Substring(0, 4)), Int32.Parse(date.Substring(4, 2)), Int32.Parse(date.Substring(6, 2)));
//                string getEditButtonUrl = string.Format(@"/Lists/Student%20Status/EditForm.aspx?modal=1&ID={0}", GetBgcIdentityFromId("" + reader["STUDENT_STATUS_ID"]));
//                //studentInstitutionDataList.Add(new List<string>() { (GetEditButton(getEditButtonUrl,"Edit Student Status")),
//                //                                                    ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()),
//                //                                                     ("" + reader["STATUS"]),
//                //                                                      ("" + reader["CURRENT_CLASS"]),
//                //                                                      ("" + reader["BORROWING"]),
//                //                                                      ("" + reader["RETRO_PERIOD"]),
//                //                                                       ("" + reader["START_DATE"])
//                //                                                     }
//                //                                                     );

//                //studentInstitutionDataList.Add(new List<string>() { (GetEditButtonWithIndex(index++, "newStudentStatusModal","")),
//                //                                                    ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()),
//                //                                                     ("" + reader["STATUS"]),
//                //                                                      ("" + reader["CURRENT_CLASS"]),
//                //                                                      ("" + reader["BORROWING"]),
//                //                                                      ("" + reader["RETRO_PERIOD"]),
//                //                                                       ("" + reader["START_DATE"])
//                //                                                     }
//                //                                                     );

//                stringBuilder.AppendFormat(@"{8}button: '{0}', STATUS_PERIOD: '{1}', STATUS: '{2}', CURRENT_CLASS: '{3}', BORROWING: '{4}', RETRO_PERIOD: '{5}', ANNUAL_FEE_AMOUNT: '{6}', STUDENT_STATUS_ID: '{7}'{9},", GetEditButtonWithIndex(index++, "newStudentStatusModal", ""), 
//                                                                                                                                                                ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()), 
//                                                                                                                                                                 ("" + reader["STATUS"]),
//                                                                                                                                                                ("" + reader["CURRENT_CLASS"]),
//                                                                                                                                                                ("" + reader["BORROWING"]),
//                                                                                                                                                                FormatSQLDateToStringDate("" + reader["RETRO_PERIOD"]),
//                                                                                                                                                                (("" + reader["BORROWING"]) == "Y" ? FormatStringToRoundedDecimal("" + reader["CALC_FEE"]) : "") , 
//                                                                                                                                                                ("" + reader["STUDENT_STATUS_ID"]),"{", "}");

//            }

         
//            reader.Close();
//            return stringBuilder.ToString().TrimEnd(',');
//            //return studentInstitutionDataList;
//        }

//        private string FormatStringToRoundedDecimal(string number)
//        {
//            string returnString = "";
//            if (!string.IsNullOrEmpty(number))
//            {
//                returnString = Math.Round(decimal.Parse(number), 2).ToString();
//            }
//            return returnString;
//        }

//        private string QuerySQLDatabseForStudentAddresses(SqlConnection connection, string queryString, string id)
//        {
//            List<List<string>> studentAddressesDataList = new List<List<string>>();
//            string newQuery = string.Format(queryString, id);
//            SqlCommand command = new SqlCommand(newQuery, connection);
//            int count = 1;
//            //
//            SqlDataReader reader = command.ExecuteReader();
//            StringBuilder stringBuilder = new StringBuilder();
//            while (reader.Read())
//            {
//                string address = FormatAddress(reader);
//                int addressCount = count++;
//                string getEditButtonUrl = string.Format(@"/Lists/Student%20Address/EditForm.aspx?modal=1&ID={0}", GetBgcIdentityFromId("" + reader["STUDENT_ADDRESS_ID"]));
//                //studentAddressesDataList.Add(new List<string>() { (GetEditButton(getEditButtonUrl, "Edit Student Address")),
//                //                                                    ("Address " + addressCount.ToString() + ":"),
//                //                                                     ("" + address)
//                //});

//                //studentAddressesDataList.Add(new List<string>() { (GetEditButton2("editStudentAddressModal", "")),
//                //                                                    ("Address " + addressCount.ToString() + ":"),
//                //                                                     ("" + address)
//                //});
             
                
//                stringBuilder.AppendFormat(@"{0}STUDENT_ADDRESS_ID: '{1}', ADDRESS_TYPE: '{2}', ADDRESS_1: '{3}', ADDRESS_2: '{4}', CITY: '{5}', STATE_PROVINCE: '{6}', POSTAL_CODE: '{7}', COUNTRY: '{8}'{9},",
//                                                                                                                                                                "{",
//                                                                                                                                                               ("" + reader["STUDENT_ADDRESS_ID"]),
//                                                                                                                                                               ("" + reader["ADDRESS_TYPE"]), 
//                                                                                                                                                               ("" + reader["ADDRESS_1"]),
//                                                                                                                                                               ("" + reader["ADDRESS_2"]),
//                                                                                                                                                               ("" + reader["CITY"]),
//                                                                                                                                                               ("" + reader["STATE_PROVINCE"]),
//                                                                                                                                                               ("" + reader["POSTAL_CODE"]),
//                                                                                                                                                               ("" + reader["COUNTRY"]),  
//                                                                                                                                                               "}");

//            }
//            reader.Close();
//            //return studentAddressesDataList;
//            return stringBuilder.ToString().TrimEnd(',');
//        }

//        private string QuerySQLDatabaseForStudentLoans(SqlConnection connection, string queryString, string id)
//        {
//            int index = 1;
//            List<List<string>> studentLoansDataList = new List<List<string>>();
//            string newQuery = string.Format(queryString, id);
//            SqlCommand command = new SqlCommand(newQuery, connection);
//            //int count = 1;
//            //
//            SqlDataReader reader = command.ExecuteReader();
//            StringBuilder stringBuilder = new StringBuilder();
//            while (reader.Read())
//            {
               
//                 /*
//                 * Filter Loans by type and create subtotals
//                 * */
//                AddLoanToSubtotal("" + reader["DESCRIPTION"], decimal.Parse("" + reader["LOAN_AMOUNT"]));


//                string date = ("" + reader["STATUS_PERIOD"]);
//                DateTime dateTime = new DateTime(Int32.Parse(date.Substring(0, 4)), Int32.Parse(date.Substring(4, 2)), Int32.Parse(date.Substring(6, 2)));
//                //string address = FormatAddress(reader);
//                //int addressCount = count++;
//                string getEditButtonUrl = string.Format(studentLoanEditUrl, GetBgcIdentityFromId("" + reader["STUDENT_LOANS_ID"]));
//                //studentLoansDataList.Add(new List<string>() { (GetEditButton(getEditButtonUrl,"Edit Student Loan")),
//                //                                                    ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()),
//                //                                                     ("" + reader["DESCRIPTION"]),
//                //                                                     (formatMoneyString("" + reader["LOAN_AMOUNT"])),
//                //                                                     ("" + reader["NOTES"])

                                                                       

//                //});

//                //studentLoansDataList.Add(new List<string>() { (GetEditButtonWithIndex(index++, "newStudentLoanModal","")),
//                //                                                    ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()),
//                //                                                     ("" + reader["DESCRIPTION"]),
//                //                                                     (formatMoneyString("" + reader["LOAN_AMOUNT"])),
//                //                                                     ("" + reader["NOTES"])

                                                                       

//                //});

//                stringBuilder.AppendFormat(@"{0}STUDENT_LOANS_ID: '{1}', STATUS_PERIOD: '{2}', DESCRIPTION: '{3}', LOAN_AMOUNT: '{4}', NOTES: '{5}', LOAN_AMOUNT_TYPE: '{7}', LOAN_TYPE_ID: '{8}'{6},",
//                                                                                                                                                               "{",
//                                                                                                                                                              ("" + reader["STUDENT_LOANS_ID"]),
//                                                                                                                                                              ("" + dateTime.ToString("MMMM", CultureInfo.InvariantCulture) + " " + dateTime.Year.ToString()),
//                                                                                                                                                              ("" + reader["DESCRIPTION"]),
//                                                                                                                                                              ("" + reader["LOAN_AMOUNT"]),
//                                                                                                                                                              ("" + reader["NOTES"]),    
//                                                                                                                                                              "}",
//                                                                                                                                                              ("" + reader["LOAN_AMOUNT_TYPE"]),
//                                                                                                                                                              ("" + reader["LOAN_TYPE_ID"]));
//            }
//            /*
//            * Calculate Sub Totals and append to the literals 
//            * */
//            decimal studentLoansTotal = studentLoansFederalAmount + studentLoansOtherAmount;
//            StringBuilder studentLoanSubtotal = new StringBuilder();
//            if (studentLoansTotal != 0)
//            {
//                //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Federal", formatMoneyString(studentLoansFederalAmount.ToString()), "(" + formatPercentage(studentLoansFederalAmount/studentLoansTotal) + ")"));
//                //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Other", formatMoneyString(studentLoansOtherAmount.ToString()), "(" + formatPercentage(studentLoansOtherAmount / studentLoansTotal) + ")"));
//                //studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Total Loans", formatMoneyString(studentLoansTotal.ToString()), ""));

//                studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Federal", studentLoansFederalAmount.ToString("C0"), "(" + formatPercentage(studentLoansFederalAmount / studentLoansTotal) + ")"));
//                studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Subtotal Other", studentLoansOtherAmount.ToString("C0"), "(" + formatPercentage(studentLoansOtherAmount / studentLoansTotal) + ")"));
//                studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "Total Loans", studentLoansTotal.ToString("C0"), ""));

//            }
//            else
//            {
//                studentLoanSubtotal.Append(string.Format(studentLoanTotalTableRow, "No Loans Recorded", "", ""));
//            }

//            //studentLoansTableBuilder.Append(studentLoanSubtotal.ToString());
//            Student_Loans_Literal.Text = studentLoanSubtotal.ToString();
//            reader.Close();
//            //return studentLoansDataList;
//            return stringBuilder.ToString().TrimEnd(',');
//        }

//        private string FormatSQLDateToStringDate(string date)
//        {
//            string returnDate = "";
//            if (!String.IsNullOrEmpty(date))
//            {
//                DateTime dateTime = new DateTime(Int32.Parse(date.Substring(0, 4)), Int32.Parse(date.Substring(4, 2)), Int32.Parse(date.Substring(6, 2)));
//                returnDate = string.Format("{0:d}",dateTime);

//            }
//            return returnDate;
//        }
//        private void AddLoanToSubtotal(string loanType, decimal amount)
//        {
//            if (loanType == "Direct Unsubsidized" || loanType == "Direct Subsidized")
//            {
//                studentLoansFederalAmount += amount;
//            }
//            else
//            {
//                studentLoansOtherAmount += amount;
//            }
//        }
        
//        private void QuerySQLDatabaseForStudentInfo(SqlConnection connection, string queryString, string id)
//        {
//            string newQuery = string.Format(queryString, id);
//            SqlCommand command = new SqlCommand(newQuery, connection);
//            //
//            SqlDataAdapter da = new SqlDataAdapter(command);
//            DataTable dt = new DataTable();
//            da.Fill(dt);
//            da.Dispose();

//            GridView1.DataSource = dt;
//            GridView1.DataBind();
//            SqlDataReader reader = command.ExecuteReader();
//            while (reader.Read())
//            {
//                InsertDataIntoStudentInfoTable(reader);
//                InsertDataIntoStudentForm(reader);
                
//                break;
//            }
//            reader.Close();
//        }

//        private void InsertDataIntoStudentForm(SqlDataReader reader)
//        {
//            //StudentEditForm_LrapStudentID.Value = "" + reader["LRAP_STUDENT_ID"];
//            //StudentEditForm_InstitutionStudentID.Value = "" + reader["INSTITUTION_STUDENT_ID"];
//            //StudentEditForm_FirstName.Value = ("" + reader["FIRST_NAME"]);
//            //StudentEditForm_LastName.Value = ("" + reader["LAST_NAME"]);
//            //StudentEditForm_MiddleName.Value = ("" + reader["MIDDLE_NAME"]);
//            //StudentEditForm_MaidenLastName.Value = ("" + reader["MAIDEN_LAST_NAME"]);
//            //StudentEditForm_Phone1.Value = ("" + reader["PHONE_1"]);
//            //StudentEditForm_Phone2.Value = ("" + reader["PHONE_2"]);
//            //StudentEditForm_Email1.Value = ("" + reader["EMAIL_1"]);
//            //StudentEditForm_Email2.Value = ("" + reader["EMAIL_2"]);
//            //StudentEditForm_ParentEmail1.Value = ("" + reader["PARENT_EMAIL_1"]);
//            //StudentEditForm_ParentEmail2.Value = ("" + reader["PARENT_EMAIL_2"]);
//            //StudentEditForm_AdmittedClass.Value = ("" + reader["ADMITTED_CLASS"]);
//            //StudentEditForm_LrapFeeType.Value = ("" + reader["FEE_TYPE"]);


//            //StudentInfoLiteral.Text = string.Format(@"<script type=""text/javascript"">var lrapStudentID = '{1}';var studentInfoObject = {0} INSTITUTION_STUDENT_ID: '{2}',FIRST_NAME: '{3}',LAST_NAME: '{4}', MIDDLE_NAME: '{5}',MAIDEN_LAST_NAME : '{6}', PHONE_1: '{7}', PHONE_2: '{8}', EMAIL_1: '{9}', EMAIL_2: '{10}', PARENT_EMAIL_1: '{11}', PARENT_EMAIL_2: '{12}',ADMITTED_CLASS: '{13}',GRADUATION_DATE_ACTUAL: '{14}' {15}</script>", 
//            //    "{",
//            //    "" + reader["LRAP_STUDENT_ID"],
//            //     "" + reader["INSTITUTION_STUDENT_ID"],
//            //    ("" + reader["FIRST_NAME"]),
//            //    ("" + reader["LAST_NAME"]),
//            //    ("" + reader["MIDDLE_NAME"]),
//            //    ("" + reader["MAIDEN_LAST_NAME"]),
//            //    ("" + reader["PHONE_1"]),
//            //    ("" + reader["PHONE_2"]),
//            //    ("" + reader["EMAIL_1"]),
//            //    ("" + reader["EMAIL_2"]),
//            //    ("" + reader["PARENT_EMAIL_1"]),
//            //    ("" + reader["PARENT_EMAIL_2"]),
//            //    ("" + reader["ADMITTED_CLASS"]),
//            //    "" + reader["GRADUATION_DATE_ACTUAL"],
//            //    "};");

            
//            //Label2.Text = ("" + reader["FEE_TYPE"]);

//            //StudentEditForm_Cohort.ClearSelection();
//            //StudentEditForm_Cohort.Items.FindByValue(("" + reader["COHORT_ID"])).Selected = true;
//            //string city = string.IsNullOrEmpty("" + reader["CITY"]) ? "N/A" : ("" + reader["CITY"]);
//            //string state = string.IsNullOrEmpty("" + reader["STATE_PROVINCE"]) ? "N/A" : ("" + reader["STATE_PROVINCE"]);
//            //string institutionName = string.IsNullOrEmpty("" + reader["INSTITUTION_NAME"]) ? "N/A" : ("" + reader["INSTITUTION_NAME"]);
//            //string admittedClass = string.IsNullOrEmpty("" + reader["ADMITTED_CLASS"]) ? "N/A" : ("" + reader["ADMITTED_CLASS"]);
//            //string currentClass = string.IsNullOrEmpty("" + reader["CURRENT_CLASS"]) ? "N/A" : ("" + reader["CURRENT_CLASS"]);
//            //string phone1 = string.IsNullOrEmpty("" + reader["PHONE_1"]) ? "N/A" : ("" + reader["PHONE_1"]);
//            //string phone2 = string.IsNullOrEmpty("" + reader["PHONE_2"]) ? "N/A" : ("" + reader["PHONE_2"]);
//            //string email1 = string.IsNullOrEmpty("" + reader["EMAIL_1"]) ? "N/A" : ("" + reader["EMAIL_1"]);
//            //string email2 = string.IsNullOrEmpty("" + reader["EMAIL_2"]) ? "N/A" : ("" + reader["EMAIL_2"]);
//            //string pEmail1 = string.IsNullOrEmpty("" + reader["PARENT_EMAIL_1"]) ? "N/A" : ("" + reader["PARENT_EMAIL_1"]);
//            //string pEmail2 = string.IsNullOrEmpty("" + reader["PARENT_EMAIL_2"]) ? "N/A" : ("" + reader["PARENT_EMAIL_2"]);
//            //string graduationDate = string.IsNullOrEmpty("" + reader["GRADUATION_DATE_ACTUAL"]) ? "N/A" : ("" + reader["GRADUATION_DATE_ACTUAL"]);
//        }

//        //public void SubmitForm(object sender, EventArgs e)
//        //{
//        //    try
//        //    {
//        //        using (SqlConnection conn = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
//        //        {
//        //            conn.Open();

//        //            // 1.  create a command object identifying the stored procedure
//        //            SqlCommand cmd = new SqlCommand("UPDATE_STUDENT", conn);

//        //            // 2. set the command object so it knows to execute a stored procedure
//        //            cmd.CommandType = CommandType.StoredProcedure;

//        //            /*
//        //             * All the Following Parameters Are Nullable
//        //             * */
//        //            cmd.Parameters.Add(new SqlParameter("@INSTITUTION_STUDENT_ID", (String.IsNullOrEmpty(StudentEditForm_InstitutionStudentID.Value) ? null : StudentEditForm_InstitutionStudentID.Value)        ));
//        //            StudentEditForm_Cohort.Text
//        //            // 3. add parameter to command, which will be passed to the stored procedure
//        //            cmd.Parameters.Add(new SqlParameter("@STUDENT_ID", bdcIdentity));
//        //            cmd.Parameters.Add(new SqlParameter("@INSTITUTION_ID", "1000000"));
//        //            cmd.Parameters.Add(new SqlParameter("@MIDDLE_NAME", "9999111"));
//        //            cmd.Parameters.Add(new SqlParameter("@FIRST_NAME", "Test")); 
                    
//        //            cmd.Parameters.Add(new SqlParameter("@LAST_NAME", "TESTLAST")); 
//        //            cmd.Parameters.Add(new SqlParameter("@COHORT_ID", "1000000")); 
//        //            cmd.Parameters.Add(new SqlParameter("@FEE_TYPE", "Freshmen"));
//        //            // execute the command
//        //            int rowsAffected = cmd.ExecuteNonQuery();

//        //            if (rowsAffected == 1)
//        //            {
//        //                Label2.Text = "|" + StudentEditForm_Email2.Value + "|";
//        //            }
//        //            else
//        //            {
//        //                4 = "failure |" + rowsAffected + "|" ;
//        //            }
//        //            //Page.Response.Redirect(Page.Request.Url.ToString(), true);

//        //        }
//        //    }


    
//        //    catch (Exception ex)
//        //    {
//        //        Label1.Visible = true;
//        //        Label1.Text = "ERROR: " + ex.Message;
//        //    }
            

//        //}
////        private void InsertDataIntoStudentLrapDetailsTable(SqlDataReader reader)
////        {
////            string feeType = "N/A";
////            string intro = "N/A";
////            if (!string.IsNullOrEmpty("" + reader["FEE_TYPE"]))
////            {
////                studentFeeType = "" + reader["FEE_TYPE"];
////                if (("" + reader["FEE_TYPE"]) == "Intro")
////                {
////                    feeType = "Intro";
////                    intro = "Yes";
////                }
////                else
////                {
////                    feeType = ("" + reader["FEE_TYPE"]);
////                    intro = "No";
////                }                  
////            }
////            studentInitialStatusPeriod = "" + reader["START_DATE"];
////            Label2.Text = "|" + studentFeeType + "|" + studentInitialStatusPeriod;
////            Student_Details_Annual_Fee.Text = formatMoneyString("" + reader["ANNUAL_FEE_AMOUNT"]);
////            Student_Details_Award_Letter.Text = "" + reader["AWARD_LETTER"];
////            Student_Details_Cohort.Text = string.IsNullOrEmpty("" + reader["DESCRIPTION"]) ? "N/A" : ("" + reader["DESCRIPTION"]);
////            Student_Details_Fee_Type.Text = feeType;
////            Student_Details_Freshman.Text = string.IsNullOrEmpty("" + reader["FRESHMEN_FEE_TYPE"]) ? "N/A" : ("" + reader["FRESHMEN_FEE_TYPE"]);
////            Student_Details_Intro.Text = intro;
////            Student_Details_Lower_Income.Text = FormatStringDecimalToStringInt("" + reader["LOWER_INCOME_LIMIT"]);
////            Student_Details_Retro_Date.Text = FormatSQLDateToStringDate("" + reader["RETRO_PERIOD"]);
////            Student_Details_Upper_Income.Text = FormatStringDecimalToStringInt("" + reader["UPPER_INCOME_LIMIT"]);

////            //string editButtonUrl = string.Format(studentDetailEditUrl, GetBgcIdentityFromId("" + reader["STUDENT_STATUS_ID"]));
////            StudentLrapDetailsLiteral.Text = string.Format(@"<script type=""text/javascript"">
////                                    var StudentLrapDetailsStatusId = {0};
////                        
////                                    var StudentLrapDetailsObject = {1}COHORT_ID: '{2}',FEE_TYPE: '{3}', AWARD_LETTER: '{4}'{5};
////                                </script>", "" + reader["STUDENT_STATUS_ID"], "{", "" + reader["COHORT_ID"], "" + reader["FEE_TYPE"], "" + reader["AWARD_LETTER"], "}" );
////            //Label2.Text = "" + reader["STUDENT_STATUS_ID"];
////            //Student_Details_Edit_Button.Text = GetEditButton(editButtonUrl,"Edit LRAP Details");
////            //Student_Details_Edit_Button.Text = GetEditButton2("editLrapDetailsModal", "");
////        }
//        private void InsertDataIntoStudentInfoTable(SqlDataReader reader)
//        {
//            ////Atach Edit Button
//            //string editButtonUrl = string.Format(studentInfoEditUrl, GetBgcIdentityFromId("" + reader["STUDENT_ID"]));
//            ////Student_Information_Edit_Button.Text = GetEditButton(editButtonUrl,"Edit Student Information");
//            ////Student_Information_Edit_Button.Text = GetEditButton2("myModal","");
//            ////check if variables are empty and replace if necessary
//            //string lastName = ("" + reader["LAST_NAME"]);
//            //string firstName = ("" + reader["FIRST_NAME"]);
//            //string middleName = ("" + reader["MIDDLE_NAME"]);
//            //string lrapStudentId = string.IsNullOrEmpty("" + reader["LRAP_STUDENT_ID"]) ? "N/A" : ("" + reader["LRAP_STUDENT_ID"]);
//            //string institutionStudentId = string.IsNullOrEmpty("" + reader["INSTITUTION_STUDENT_ID"]) ? "N/A" : ("" + reader["INSTITUTION_STUDENT_ID"]);
//            //string city = string.IsNullOrEmpty("" + reader["CITY"]) ? "N/A" : ("" + reader["CITY"]);
//            //string state = string.IsNullOrEmpty("" + reader["STATE_PROVINCE"]) ? "N/A" : ("" + reader["STATE_PROVINCE"]);
//            //string institutionName = string.IsNullOrEmpty("" + reader["INSTITUTION_NAME"]) ? "N/A" : ("" + reader["INSTITUTION_NAME"]);
//            //string admittedClass = string.IsNullOrEmpty("" + reader["ADMITTED_CLASS"]) ? "N/A" : ("" + reader["ADMITTED_CLASS"]);
//            //string currentClass = string.IsNullOrEmpty("" + reader["CURRENT_CLASS"]) ? "N/A" : ("" + reader["CURRENT_CLASS"]);
//            //string phone1 = string.IsNullOrEmpty("" + reader["PHONE_1"]) ? "N/A" : ("" + reader["PHONE_1"]);
//            //string phone2 = string.IsNullOrEmpty("" + reader["PHONE_2"]) ? "N/A" : ("" + reader["PHONE_2"]);
//            //string email1 = string.IsNullOrEmpty("" + reader["EMAIL_1"]) ? "N/A" : ("" + reader["EMAIL_1"]);
//            //string email2 = string.IsNullOrEmpty("" + reader["EMAIL_2"]) ? "N/A" : ("" + reader["EMAIL_2"]);
//            //string pEmail1 = string.IsNullOrEmpty("" + reader["PARENT_EMAIL_1"]) ? "N/A" : ("" + reader["PARENT_EMAIL_1"]);
//            //string pEmail2 = string.IsNullOrEmpty("" + reader["PARENT_EMAIL_2"]) ? "N/A" : ("" + reader["PARENT_EMAIL_2"]);
//            //string graduationDate = string.IsNullOrEmpty("" + reader["GRADUATION_DATE_ACTUAL"]) ? "N/A" : ("" + reader["GRADUATION_DATE_ACTUAL"]);


//            //Student_Info_Student_Name.Text = string.Format("<p>{0}, {1} {2}</p>", lastName, firstName, middleName);

//            ////handle display of city and state 
//            //if (city == "N/A" && state != "N/A")
//            //{
//            //    Student_Info_City_State.Text = string.Format("<p>{0}</p>", state);
//            //}
//            //else if (city != "N/A" && state == "N/A")
//            //{
//            //    Student_Info_City_State.Text = string.Format("<p>{0}</p>", city);
//            //}
//            //else if (city == "N/A" && state == "N/A")
//            //{
//            //    Student_Info_City_State.Text = string.Format("<p>N/A</p>");
//            //}
//            //else
//            //{
//            //    Student_Info_City_State.Text = string.Format("<p>{0}, {1}</p>", city, state);
//            //}
//            //Student_Info_Admitted_Class.Text = string.Format("<p>{0}</p>", admittedClass);
//            //Student_Info_Current_Class.Text = string.Format("<p>{0}</p>", currentClass);
//            //Student_Info_Email_1.Text = string.Format("<p>{0}</p>", email1);
//            //Student_Info_Email_2.Text = string.Format("<p>{0}</p>", email2);
//            //Student_Info_Graduation_Date.Text = string.Format("<p>{0}</p>", graduationDate);
//            //Student_Info_LRAP_Student_ID.Text = string.Format("<p>{0}</p>", lrapStudentId);
//            //Student_Info_Parent_Email_1.Text = string.Format("<p>{0}</p>", pEmail1);
//            //Student_Info_Parent_Email_2.Text = string.Format("<p>{0}</p>", pEmail2);
//            //Student_Info_Phone_1.Text = string.Format("<p>{0}</p>", phone1);
//            //Student_Info_Phone_2.Text = string.Format("<p>{0}</p>", phone2);
//            //Student_Info_School_Name.Text = string.Format("<p>{0}</p>", institutionName);
//            //Student_Info_School_Student_ID.Text = string.Format("<p>{0}</p>", institutionStudentId);
        
            
        
//        }
//        private void InsertDataIntoStudentDemographicsTable(SqlDataReader reader)
//        {
//            //Atach Edit Button
//            //string editButtonUrl = string.Format(studentDemographicEditUrl, GetBgcIdentityFromId("" + reader["STUDENT_DEMOGRAPHICS_ID"]));
//            //SStudent_Demographics_Edit_Button.Text = GetEditButton(editButtonUrl,"Edit Student Demographics")tudent_Demographics_Edit_Button.Text = GetEditButton(editButtonUrl,"Edit Student Demographics");
//            //Student_Demographics_Edit_Button.Text = GetEditButton2("editStudentDemographicsModal", "");
//            //
//            //Label2.Text = "|" + reader["EFC"] + "|";
//            Student_Demographic_Act.Text = string.IsNullOrEmpty("" + reader["ACT"]) ? "N/A" : ("" + reader["ACT"]);
//            Student_Demographic_Birthdate.Text = string.IsNullOrEmpty("" + reader["BIRTHDATE"]) ? "N/A" : ("" + reader["BIRTHDATE"]);
//            if (!string.IsNullOrEmpty("" + reader["EFC"]))
//            {
//                Student_Demographic_Efc.Text = string.Format("{0:0,0}", decimal.Parse("" + reader["EFC"]));
//            }
//            else
//            {
//                Student_Demographic_Efc.Text = "" + reader["EFC"];
//            }
            
//            Student_Demographic_Gender.Text = string.IsNullOrEmpty("" + reader["GENDER"]) ? "N/A" : ("" + reader["GENDER"]);
//            Student_Demographic_Gpa_College.Text = string.IsNullOrEmpty("" + reader["GPA_UNIV"]) ? "N/A" : ("" + reader["GPA_UNIV"]);
//            Student_Demographic_Gpa_Hs.Text = string.IsNullOrEmpty("" + reader["GPA_HS"]) ? "N/A" : ("" + reader["GPA_HS"]);
//            Student_Demographic_Major_Admitted.Text = string.IsNullOrEmpty("" + reader["MAJOR_ADMITTED"]) ? "N/A" : ("" + reader["MAJOR_ADMITTED"]);
//            Student_Demographic_Major_Current.Text = string.IsNullOrEmpty("" + reader["MAJOR_CURRENT"]) ? "N/A" : ("" + reader["MAJOR_CURRENT"]);
//            Student_Demographic_Sat.Text = string.IsNullOrEmpty("" + reader["SAT"]) ? "N/A" : ("" + reader["SAT"]);

//            StudentDemoLiteral.Text = string.Format(@"<script type=""text/javascript"">
//                                    var studentDemographicsId = {0};
//                                    var studentDemoObject = {1}GENDER: '{2}', BIRTHDATE: '{3}',EFC: '{4}', GPA_HS: '{5}', GPA_UNIV: '{6}',MAJOR_ADMITTED: '{7}', MAJOR_CURRENT: '{8}',ACT: '{9}', SAT: '{10}' {11};
//
//                                </script>", "" + reader["STUDENT_DEMOGRAPHICS_ID"], "{", "" + reader["GENDER"], "" + reader["BIRTHDATE"], "" + reader["EFC"], "" + reader["GPA_HS"], "" + reader["GPA_UNIV"], "" + reader["MAJOR_ADMITTED"], "" + reader["MAJOR_CURRENT"], "" + reader["ACT"], "" + reader["SAT"], "}");
            
//        }
//        private string formatMoneyString(string money)
//        {
//            int length = money.Length;
//            string formattedMoney = "";
//            if (length >= 4)
//            {
//                StringBuilder moneyBuilder = new StringBuilder();
//                string cents = money.Substring((length - 1) - 3, 2);
//                string dollars = money.Substring(0, (length - 1) - 4);
//                string dollarsWithCommas = string.Format("{0:#,###0}", int.Parse(dollars));
//                //string dollarsWithCommas = int.Parse(dollars).ToString("N",new CultureInfo("en-US"));
//                moneyBuilder.AppendFormat("${0}.{1}", dollarsWithCommas, cents);
//                formattedMoney = moneyBuilder.ToString();
//            }
//            return formattedMoney;
//        }

//        private string FormatAddress(SqlDataReader reader)
//        {
//            string address = "";
//            List<string> addressFormatHelper = new List<string>() { ("" + reader["ADDRESS_1"]),
//                                                                        ("" + reader["ADDRESS_2"]),
//                                                                        ("" + reader["CITY"]),
//                                                                        ("" + reader["STATE_PROVINCE"]),
//                                                                        ("" + reader["POSTAL_CODE"]),
//                                                                        ("" + reader["COUNTRY"])
//            };

//            foreach (string str in addressFormatHelper)
//            {
//                if (str != "")
//                {
//                    if (address != "")
//                    {
//                        address += ", " + str;
//                    }
//                    else
//                    {
//                        address = str;
//                    }
//                }
//            }

//            return address;
//        }

//        private string GetBgcIdentityFromId(string id)
//        {
//            char[] chars = id.ToCharArray();
//            string bgcId = string.Format("__bgc100{0}300{1}300{2}300{3}300{4}300{5}300{6}300", chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6]);

//            return bgcId;
//        }

//        private string FormatStringDecimalToStringInt(string deci)
//        {
//            string returnInt = deci.Split(new char[] { '.' })[0];


//            return returnInt;
//        }
    
    }
}
