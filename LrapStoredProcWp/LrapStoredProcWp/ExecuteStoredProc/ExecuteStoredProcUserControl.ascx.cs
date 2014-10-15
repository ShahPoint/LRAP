using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace LrapStoredProcWp.ExecuteStoredProc
{
    public partial class ExecuteStoredProcUserControl : UserControl
    {
        List<string> ErrorsList = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string procName = Request.QueryString["Proc"];
                Dictionary<string, string> parameters = new Dictionary<string, string>();
                //            if(procName)

                StringBuilder SB = new StringBuilder();
                SB.Append("pROC: " + procName + "\n");



                foreach (String key in Request.QueryString.AllKeys)
                {
                    if (key != "Proc")
                    {
                        parameters.Add("@" + key, Request.QueryString[key]);
                    }
                }
                if (procName == "NEW_STUDENT")
                {
                    //String[] RequiredFields = new String[] { "@INSTITUTION_ID", "@FIRST_NAME", };

                    RequiredField(parameters,"@INSTITUTION_ID", "Institution");
                    RequiredField(parameters, "@FIRST_NAME", "First Name");
                    RequiredField(parameters, "@LAST_NAME", "Last Name");
                    RequiredField(parameters, "@COHORT_ID", "Cohort");
                    RequiredField(parameters, "@FEE_TYPE", "Fee Type");

                    if (ErrorsList.Count == 0)
                    {
                        response1.Attributes.Add("data-sp", "success");
                        response1.InnerText = StoredProcedure(procName, parameters);
                    }
                    else
                    {
                        FormatErrors();
                    }


                }
                else if (procName == "uspCreateNewInstitution")
                {
                    List<string> shortNames = new List<string>();
                    string shortName = Request.QueryString["SHORT_NAME"];
                    using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                    {
                        connection.Open();
                        // Create the Command which will be used to obtain query answer
                        SqlCommand command = new SqlCommand("Select SHORT_NAME from INSTITUTION", connection);
                        //
                        SqlDataReader reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            shortNames.Add("" + reader["SHORT_NAME"]);
                        }
                         
                        RequiredField(parameters, "@SHORT_NAME", "Short Name");

                        if (ErrorsList.Count != 0)
                        {
                            FormatErrors();
                        }
                        else if(ErrorsList.Count == 0 && shortNames.Contains(shortName))
                        {
                             ErrorsList.Add(@"Short Name """+ shortName + @""" has already been taken");
                             FormatErrors();
                        }
                        else
                        {
                            response1.Attributes.Add("data-sp", "success");
                            response1.InnerText = StoredProcedure(procName, parameters);
                           
                        }
                        connection.Close();
                    }
                }
                else if (procName == "NEW_INSTITUTION_LRAP_HISTORY")
                {

                    String[] InstitutionLrapHistoryParameters = new String[] { "@COHORT_ID", "@FRESHMEN_FEE_TYPE", "@INSTITUTION_ID", "@INTRO_STUDENTS", "@UPPER_INCOME_LIMIT", "@LOWER_INCOME_LIMIT" };
                    String[] FreshmenFeeParameters = new String[] { "@FRESHMEN_ANNUAL_FEE_AMOUNT", "@FRESHMEN_RESERVE_ANNUAL", "@FRESHMEN_RESERVE_ATGRAD" };
                    String[] TransferFeeParameters = new String[] { "@TRANSFER_ANNUAL_FEE_AMOUNT", "@TRANSFER_RESERVE_ANNUAL", "@TRANSFER_RESERVE_ATGRAD" };
                    String[] RetentionFeeParameters = new String[] { "@RETENTION_ANNUAL_FEE_AMOUNT", "@RETENTION_RESERVE_ANNUAL", "@RETENTION_RESERVE_ATGRAD" };
                    String[] IntroFeeParameters = new String[] { "@INTRO_ANNUAL_FEE_AMOUNT" };

                    Dictionary<string, string> newParameters = new Dictionary<string, string>();

                    //Do the LRAP History
                    foreach (string s in InstitutionLrapHistoryParameters)
                    {
                        if (parameters.ContainsKey(s))
                        {
                            newParameters.Add(s, parameters[s]);
                        }
                    }

                    string INSTITUTION_LRAP_HISTORY_ID = StoredProcedure("NEW_INSTITUTION_LRAP_HISTORY", newParameters);
                    if (string.IsNullOrEmpty(INSTITUTION_LRAP_HISTORY_ID))
                    {
                        response1.Attributes.Add("data-sp", "failure");
                        response1.InnerText = "Error: No LRAP History was Created in the Database";
                    }
                    else
                    {
                        string INTRO_INSTITUTION_LRAP_FEE_ID = "";
                        string FRESHMEN_INSTITUTION_LRAP_FEE_ID = "";
                        string TRANSFER_INSTITUTION_LRAP_FEE_ID = "";
                        string RETENTION_INSTITUTION_LRAP_FEE_ID = "";

                        newParameters.Clear();

                        //Do the Intro Fee Type
                        if (parameters.ContainsKey("@INTRO_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@INSTITUTION_LRAP_HISTORY_ID", INSTITUTION_LRAP_HISTORY_ID);
                            newParameters.Add("@FEE_TYPE", "Intro");

                            foreach (string s in IntroFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@INTRO_", "@"), parameters[s]);
                                }
                            }

                            INTRO_INSTITUTION_LRAP_FEE_ID = StoredProcedure("NEW_INSTITUTION_LRAP_FEE", newParameters);
                        }


                        newParameters.Clear();
                        //Do the FRESHMEN Fee Type
                        if (parameters.ContainsKey("@FRESHMEN_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@INSTITUTION_LRAP_HISTORY_ID", INSTITUTION_LRAP_HISTORY_ID);
                            newParameters.Add("@FEE_TYPE", "Freshmen");

                            foreach (string s in FreshmenFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@FRESHMEN_", "@"), parameters[s]);
                                }
                            }

                            FRESHMEN_INSTITUTION_LRAP_FEE_ID = StoredProcedure("NEW_INSTITUTION_LRAP_FEE", newParameters);
                        }
                        newParameters.Clear();

                        //Do the RETENTION Fee Type
                        if (parameters.ContainsKey("@RETENTION_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@INSTITUTION_LRAP_HISTORY_ID", INSTITUTION_LRAP_HISTORY_ID);
                            newParameters.Add("@FEE_TYPE", "Retention");

                            foreach (string s in RetentionFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@RETENTION_", "@"), parameters[s]);
                                }
                            }

                            RETENTION_INSTITUTION_LRAP_FEE_ID = StoredProcedure("NEW_INSTITUTION_LRAP_FEE", newParameters);
                        }
                        newParameters.Clear();


                        //Do the TRANSFER Fee Type
                        if (parameters.ContainsKey("@TRANSFER_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@INSTITUTION_LRAP_HISTORY_ID", INSTITUTION_LRAP_HISTORY_ID);
                            newParameters.Add("@FEE_TYPE", "Transfer");

                            foreach (string s in TransferFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@TRANSFER_", "@"), parameters[s]);
                                }
                            }

                            TRANSFER_INSTITUTION_LRAP_FEE_ID = StoredProcedure("NEW_INSTITUTION_LRAP_FEE", newParameters);
                        }

                        response1.Attributes.Add("data-sp", "success");
                        response1.InnerText = INSTITUTION_LRAP_HISTORY_ID + "|" + INTRO_INSTITUTION_LRAP_FEE_ID + "|" + FRESHMEN_INSTITUTION_LRAP_FEE_ID + "|" + RETENTION_INSTITUTION_LRAP_FEE_ID + "|" + TRANSFER_INSTITUTION_LRAP_FEE_ID + "|";
                    }
                }

                else if (procName == "UPDATE_INSTITUTION_LRAP_HISTORY")
                {




                    String[] InstitutionLrapHistoryParameters = new String[] { "@COHORT_ID", "@FRESHMEN_FEE_TYPE", "@INSTITUTION_LRAP_HISTORY_ID", "@INTRO_STUDENTS", "@UPPER_INCOME_LIMIT", "@LOWER_INCOME_LIMIT" };
                    String[] FreshmenFeeParameters = new String[] { "@FRESHMEN_ANNUAL_FEE_AMOUNT", "@FRESHMEN_RESERVE_ANNUAL", "@FRESHMEN_RESERVE_ATGRAD", "@FRESHMEN_INSTITUTION_LRAP_FEE_ID" };
                    String[] TransferFeeParameters = new String[] { "@TRANSFER_ANNUAL_FEE_AMOUNT", "@TRANSFER_RESERVE_ANNUAL", "@TRANSFER_RESERVE_ATGRAD", "@TRANSFER_INSTITUTION_LRAP_FEE_ID" };
                    String[] RetentionFeeParameters = new String[] { "@RETENTION_ANNUAL_FEE_AMOUNT", "@RETENTION_RESERVE_ANNUAL", "@RETENTION_RESERVE_ATGRAD", "@RETENTION_INSTITUTION_LRAP_FEE_ID" };
                    String[] IntroFeeParameters = new String[] { "@INTRO_ANNUAL_FEE_AMOUNT", "@INTRO_INSTITUTION_LRAP_FEE_ID" };

                    Dictionary<string, string> newParameters = new Dictionary<string, string>();



                    //Do the LRAP History
                    foreach (string s in InstitutionLrapHistoryParameters)
                    {
                        if (parameters.ContainsKey(s))
                        {
                            newParameters.Add(s, parameters[s]);
                        }
                    }

                    string INSTITUTION_LRAP_HISTORY_ID = StoredProcedure("UPDATE_INSTITUTION_LRAP_HISTORY", newParameters);
                    if (string.IsNullOrEmpty(INSTITUTION_LRAP_HISTORY_ID))
                    {
                        response1.Attributes.Add("data-sp", "failure");
                        response1.InnerText = "Error: No LRAP History was Edited in the Database";
                    }
                    else
                    {

                        newParameters.Clear();

                        //Do the Intro Fee Type
                        if (parameters.ContainsKey("@INTRO_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@FEE_TYPE", "Intro");

                            foreach (string s in IntroFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@INTRO_", "@"), parameters[s]);
                                }
                            }

                            StoredProcedure("UPDATE_INSTITUTION_LRAP_FEE", newParameters);
                        }


                        newParameters.Clear();
                        //Do the FRESHMEN Fee Type
                        if (parameters.ContainsKey("@FRESHMEN_ANNUAL_FEE_AMOUNT"))
                        {

                            newParameters.Add("@FEE_TYPE", "Freshmen");

                            foreach (string s in FreshmenFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@FRESHMEN_", "@"), parameters[s]);
                                }
                            }

                            StoredProcedure("UPDATE_INSTITUTION_LRAP_FEE", newParameters);
                        }
                        newParameters.Clear();

                        //Do the RETENTION Fee Type
                        if (parameters.ContainsKey("@RETENTION_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@FEE_TYPE", "Retention");

                            foreach (string s in RetentionFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@RETENTION_", "@"), parameters[s]);
                                }
                            }

                            StoredProcedure("UPDATE_INSTITUTION_LRAP_FEE", newParameters);
                        }
                        newParameters.Clear();


                        //Do the TRANSFER Fee Type
                        if (parameters.ContainsKey("@TRANSFER_ANNUAL_FEE_AMOUNT"))
                        {
                            newParameters.Add("@FEE_TYPE", "Transfer");

                            foreach (string s in TransferFeeParameters)
                            {
                                if (parameters.ContainsKey(s))
                                {
                                    newParameters.Add(s.Replace("@TRANSFER_", "@"), parameters[s]);
                                }
                            }

                            StoredProcedure("UPDATE_INSTITUTION_LRAP_FEE", newParameters);
                        }

                        response1.Attributes.Add("data-sp", "success");
                        response1.InnerText = "Good Work Kyle";
                    }
                }
                else
                {
                    response1.Attributes.Add("data-sp", "success");
                    response1.InnerText = StoredProcedure(procName, parameters);
                }

            }
            catch (SqlException ex)
            {
                StringBuilder SB = new StringBuilder();
                SB.Append("Sql Error: ");
                for (int i = 0; i < ex.Errors.Count; i++)
                {
                    SB.Append("(" + i + ") " + ex.Errors[i].ToString() + "\n");
                }



                response1.Attributes.Add("data-sp", "failure");
                response1.InnerText = SB.ToString();
            }
            catch (Exception ex)
            {
                Label1.Visible = true;

                response1.Attributes.Add("data-sp", "failure");
                response1.InnerText = "Error: " + ex.Message;
            }

            //foreach (string key in parameters.Keys)
            //{
            //    SB.Append(key + ": " + parameters[key] + "\n");
            //}
            //response1.InnerText = SB.ToString();
        }

        private void FormatErrors()
        {
            StringBuilder SB = new StringBuilder();

            foreach(string err in ErrorsList)
            {
                SB.Append(err + "|");
            }

            response1.Attributes.Add("data-sp", "failure");
            response1.InnerText = SB.ToString();
        }

        private void RequiredField(Dictionary<string, string> parameters, string databaseName, string displayName)
        {
            if (!parameters.ContainsKey(databaseName) || String.IsNullOrWhiteSpace(parameters[databaseName]))
            {
                ErrorsList.Add(displayName + " is required to have a value");
            }
        }


      
        protected string StoredProcedure(string procName, Dictionary<string, string> parameters)
        {


            using (SqlConnection conn = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
            {
                conn.Open();



                // 1.  create a command object identifying the stored procedure
                SqlCommand cmd = new SqlCommand(procName, conn);

                // 2. set the command object so it knows to execute a stored procedure
                cmd.CommandType = CommandType.StoredProcedure;

                /*
                 * All the Following Parameters Are Nullable
                 * */

                foreach (string key in parameters.Keys)
                {
                    cmd.Parameters.Add(new SqlParameter(key, parameters[key]));
                }
                //cmd.Parameters.Add(new SqlParameter("@INSTITUTION_STUDENT_ID", "qdw999999"));

                //// 3. add parameter to command, which will be passed to the stored procedure
                //cmd.Parameters.Add(new SqlParameter("@STUDENT_ID", "1002554"));
                //cmd.Parameters.Add(new SqlParameter("@INSTITUTION_ID", "1000000"));
                //cmd.Parameters.Add(new SqlParameter("@MIDDLE_NAME", "testmid"));
                //cmd.Parameters.Add(new SqlParameter("@FIRST_NAME", "pls")); 

                //cmd.Parameters.Add(new SqlParameter("@LAST_NAME", "TESTLAST")); 
                //cmd.Parameters.Add(new SqlParameter("@COHORT_ID", "1000000")); 
                //cmd.Parameters.Add(new SqlParameter("@FEE_TYPE", "Freshmen"));
                SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;
                // execute the command
                int rowsAffected = cmd.ExecuteNonQuery();



                return ("" + (int)returnParameter.Value);


                //Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }





        }
    }
}
