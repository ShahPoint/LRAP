using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace test_LRAP_Template_WP.Student_List_Template_WP
{
    public partial class Student_List_Template_WPUserControl : UserControl
    {
        string queryStringInstitutionOptions = "select INSTITUTION.INSTITUTION_NAME, INSTITUTION_ID from INSTITUTION ORDER BY INSTITUTION_NAME ASC";
        string queryStringCohortOptions = @"select COHORT_ID, DESCRIPTION from COHORT ORDER BY COHORT_ID ASC ";
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            string queryString = @"select dbo.STUDENT.STUDENT_ID, dbo.STUDENT.FIRST_NAME, dbo.STUDENT.LAST_NAME, dbo.STUDENT.MIDDLE_NAME, 
		                                dbo.INSTITUTION.INSTITUTION_NAME, dbo.COHORT.DESCRIPTION, dbo.STUDENT.FEE_TYPE, dbo.STUDENT.ADMITTED_CLASS, q.CURRENT_COHORT
		                                from dbo.STUDENT 
		                                left join dbo.COHORT on dbo.STUDENT.COHORT_ID=dbo.COHORT.COHORT_ID
		                                left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID
		                                left join (select MAX(dbo.STUDENT_STATUS.STATUS_PERIOD) AS CURRENT_COHORT, dbo.STUDENT_STATUS.STUDENT_ID
					                                from dbo.STUDENT_STATUS
					                                group by dbo.STUDENT_STATUS.STUDENT_ID ) q
					                                on dbo.STUDENT.STUDENT_ID=q.STUDENT_ID";
             * */
            string queryString = @"select dbo.STUDENT.STUDENT_ID, dbo.STUDENT.FIRST_NAME, dbo.STUDENT.LAST_NAME, dbo.STUDENT.MIDDLE_NAME, 
		                            dbo.INSTITUTION.INSTITUTION_NAME, dbo.STUDENT.INSTITUTION_ID, dbo.COHORT.DESCRIPTION, dbo.STUDENT.FEE_TYPE, dbo.STUDENT.ADMITTED_CLASS, dbo.student.INSTITUTION_STUDENT_ID
		                            from dbo.STUDENT 
		                            left join dbo.COHORT on dbo.STUDENT.COHORT_ID=dbo.COHORT.COHORT_ID
		                            left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID";
            string queryString2 = @"SELECT  dbo.STUDENT.STUDENT_ID, dbo.STUDENT.FIRST_NAME, dbo.STUDENT.LAST_NAME, dbo.STUDENT.MIDDLE_NAME, dbo.STUDENT.FEE_TYPE, 
 dbo.STUDENT.INSTITUTION_STUDENT_ID, dbo.INSTITUTION.INSTITUTION_NAME, dbo.COHORT.DESCRIPTION, dbo.INSTITUTION.INSTITUTION_ID, dbo.STUDENT.LRAP_STUDENT_ID,
	dbo.STUDENT.ADMITTED_CLASS, stats.BORROWING, stats.STATUS_PERIOD, stats.CURRENT_CLASS, stats.STATUS from STUDENT
			left join dbo.COHORT on dbo.STUDENT.COHORT_ID=dbo.COHORT.COHORT_ID
		    left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID
			left join
			(select query2.* from
(select MAX(STUDENT_STATUS.STATUS_PERIOD) as MaxStatusPeriod, STUDENT_STATUS.STUDENT_ID from STUDENT_STATUS group by STUDENT_ID) query1,
(select STUDENT_STATUS.STATUS_PERIOD, STUDENT_STATUS.CURRENT_CLASS, STUDENT_STATUS.BORROWING, STUDENT_STATUS.STATUS, STUDENT_STATUS.STUDENT_ID FROM STUDENT_STATUS) query2 
where query1.STUDENT_ID = query2.STUDENT_ID and query1.MaxStatusPeriod = query2.STATUS_PERIOD) stats ON stats.STUDENT_ID = STUDENT.STUDENT_ID";

            
            try
            {
                //getWebPartProperty("InstitutionDisplayFormURL");
                using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                {
                    connection.Open();
                    InstitutionOptionsLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_InstitutionOptions = {0}; </script>", GenerateInstitutionOptionsJsObject(connection));
                    CohortOptionsLiteral.Text = string.Format(@"<script type=""text/javascript"">
                                    var ASP_CohortOptions = {0}; </script>", GenerateCohortOptionsJsObject(connection));


                    Literal1.Text = string.Format(@"<script type=""text/javascript"">
                                    var dataSet = [
{0}
                                    ];

                                </script>", QueryDatabaseForStudentList(connection, queryString2));
                }
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "ERROR: " + ex.Message;
            }
        }

        private string QueryDatabaseForStudentList(SqlConnection connection, string queryString)
        {
            //String dataRow = @"<tr><td><a href=""StudentDispForm.aspx?studentId={5}"">{0}</a></td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>";
            StringBuilder stringBuilder = new StringBuilder();

            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(queryString, connection);
            //
            SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                stringBuilder.AppendFormat(@"['<a href=""StudentDispForm.aspx?studentId={5}"">{0}</a>', '<a href=""InstitutionsDispForm.aspx?institutionId={10}"">{1}</a>', '{2}', '{3}', '{7}', '{4}', '{8}', '{9}', '{11}', '{6}'],", "" + reader["LAST_NAME"] + ", " + reader["FIRST_NAME"] + " " + reader["MIDDLE_NAME"], "" + reader["INSTITUTION_NAME"], "" + reader["DESCRIPTION"], "" + reader["FEE_TYPE"], "" + reader["ADMITTED_CLASS"], "" + reader["STUDENT_ID"], "" + reader["INSTITUTION_STUDENT_ID"], "" + reader["STATUS"], "" + reader["CURRENT_CLASS"], "" + reader["BORROWING"], "" + reader["INSTITUTION_ID"], "" + reader["LRAP_STUDENT_ID"]);
            }

            return stringBuilder.ToString().TrimEnd(',');
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
    
    }
}
