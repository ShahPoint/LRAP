using System;
using System.Security.Permissions;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Utilities;
using Microsoft.SharePoint.Workflow;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace ImportStudentsDocsER.ImportStudentDocs
{
    /// <summary>
    /// List Item Events
    /// </summary>
    public class ImportStudentDocs : SPItemEventReceiver
    {
        /// <summary>
        /// An item is being added.
        /// </summary>
        public override void ItemAdding(SPItemEventProperties properties)
        {
            base.ItemAdding(properties);
            
            //string str = "Adding1";

            //SPListItem item = properties.ListItem;
            //item["Title2"] = str;


            //item.SystemUpdate(false);


        }

        /// <summary>
        /// An item is being updated.
        /// </summary>
        //public override void ItemUpdating(SPItemEventProperties properties)
        //{
        //    base.ItemUpdating(properties);




        //}

        /// <summary>
        /// An item is being checked in.
        /// </summary>
        //public override void ItemCheckingIn(SPItemEventProperties properties)
        //{
        //    base.ItemCheckingIn(properties);


            
        //}

        /// <summary>
        /// An item was added.
        /// </summary>
        public override void ItemAdded(SPItemEventProperties properties)
        {
            base.ItemAdded(properties);
               
            
            try
                {
                    using (SqlConnection connection = new SqlConnection("Server=lrapdev2013.cloudapp.net;Database=LRAP;UID=sa;Pwd=Lisa needs braces.@"))
                    {
                        connection.Open();
                        string query = "select STUDENT_ID from STUDENT where FIRST_NAME='{0}' AND LAST_NAME='{1}'";

                         SPListItem item = properties.ListItem;
                         List<string> studentIds = new List<string>();
                         string value = "";

                        string fileName = "" + item["FileLeafRef"];

                        var fileNameSplitArray = fileName.Split(new string[] { " " }, StringSplitOptions.None);

                        int indexOfFirst = fileNameSplitArray.Length - 3;
                        int indexOfLast = fileNameSplitArray.Length - 2;

                        string firstName = fileNameSplitArray[indexOfFirst];
                        string lastName = fileNameSplitArray[indexOfLast];




                        string newQuery = String.Format(query, firstName, lastName);

                        // Create the Command which will be used to obtain query answer
                        SqlCommand command = new SqlCommand(newQuery, connection);
                        SqlDataReader reader = command.ExecuteReader();

                        while (reader.Read())
                        {
                            studentIds.Add("" + reader["STUDENT_ID"]);
                        }

                        if (studentIds.Count == 1)
                        {
                            value = studentIds[0];
                        }
                        //string rows =  "|" +   reader.RecordsAffected.ToString() + "|";
                        
            //
                        item["studentId"] = value;
                        item["Title"] = "Item Added: ImportStudentDocs Running";
                        this.EventFiringEnabled = false;

                        item.Update();

                        this.EventFiringEnabled = true;


                    }
                   
           

            }
            catch (Exception ex)
            {
                SPListItem item = properties.ListItem;
                item["Title"] = "ERROR: " + ex.Message;
                this.EventFiringEnabled = false;

                item.Update();

                this.EventFiringEnabled = true;
                //item.SystemUpdate(false);

            }

            //item.SystemUpdate(false);
        }

        /// <summary>
        /// An item was updated.
        /// </summary>
        public override void ItemUpdated(SPItemEventProperties properties)
        {
            base.ItemUpdated(properties);





            }
           
        /// <summary>
        /// An item was checked in.
        /// </summary>
        public override void ItemCheckedIn(SPItemEventProperties properties)
        {
            base.ItemCheckedIn(properties);

            //string str = "Adding6";

            //SPListItem item = properties.ListItem;
            //item["Title2"] = str;


            //item.SystemUpdate(false);
        }


    }
}