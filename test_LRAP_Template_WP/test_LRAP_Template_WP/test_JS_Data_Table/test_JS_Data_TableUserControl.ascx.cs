using Microsoft.SharePoint;
using Microsoft.SharePoint.WebPartPages;
using System;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace test_LRAP_Template_WP.test_JS_Data_Table
{
    public partial class test_JS_Data_TableUserControl : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string queryString = @"select dbo.STUDENT.STUDENT_ID, dbo.STUDENT.FIRST_NAME, dbo.STUDENT.LAST_NAME, dbo.STUDENT.MIDDLE_NAME, 
		                            dbo.INSTITUTION.INSTITUTION_NAME, dbo.COHORT.DESCRIPTION, dbo.STUDENT.FEE_TYPE, dbo.STUDENT.ADMITTED_CLASS
		                            from dbo.STUDENT 
		                            left join dbo.COHORT on dbo.STUDENT.COHORT_ID=dbo.COHORT.COHORT_ID
		                            left join dbo.INSTITUTION on dbo.STUDENT.INSTITUTION_ID=dbo.INSTITUTION.INSTITUTION_ID";
            try {
                //getWebPartProperty("InstitutionDisplayFormURL");
                using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                {
                    connection.Open();
                    Literal1.Text = string.Format( @"<script type=""text/javascript"">
                                    var dataSet = [
{0}
                                    ];

                                </script>",QueryDatabaseForStudentList(connection, queryString));

                }
            }
            catch (Exception ex)
            {
                Label1.Visible = true;
                Label1.Text = "ERROR:  " + ex.Message;
            }
        }
        private string QueryDatabaseForStudentList(SqlConnection connection, string queryString)
        {
            String dataRow = @"<tr><td><a href=""StudentDispForm.aspx?studentId={5}"">{0}</a></td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>";
            StringBuilder stringBuilder = new StringBuilder();

            // Create the Command which will be used to obtain query answer
            SqlCommand command = new SqlCommand(queryString, connection);
            //
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                stringBuilder.AppendFormat(@"['{0}', '{1}', '{2}', '{3}', '{4}', '{5}'],", "" + reader["LAST_NAME"] + ", " + reader["FIRST_NAME"] + " " + reader["MIDDLE_NAME"], "" + reader["INSTITUTION_NAME"], "" + reader["DESCRIPTION"], "" + reader["FEE_TYPE"], "" + reader["ADMITTED_CLASS"], "" + reader["STUDENT_ID"]);
            }
            

            return stringBuilder.ToString().TrimEnd(',');
        }
       
        
    }
}
       