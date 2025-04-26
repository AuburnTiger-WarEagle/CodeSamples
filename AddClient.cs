using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.OleDb;

namespace Lighthouse
{
    public partial class AddClient : Form
    {
        Form clientForm;
        Form searchResultsForm;

        public AddClient()
        {
            InitializeComponent();
        }

        public AddClient(Form callingForm, string szCallingForm)
        {
            InitializeComponent();

            switch(szCallingForm)
            {
                case "Client" :
                    {
                        //tbClientID.Clear();
                        tbClientName.Clear();
                        tbIntakeFee.Clear();
                        tbNumberOfWeeks.Clear();
                        tbTotalFee.Clear();
                        tbWeeklyFee.Clear();
                        clientForm = callingForm;
                        break;
                    }
                case "SearchResults" :
                    {
                        searchResultsForm = callingForm;
                        break;
                    }
            }
        }

        private void tbNumberOfWeeks_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            string szErrorMessage = "";
            bool bError = false;
            int iNumberOfWeeks = 0;
            decimal dIntakeFee = 0;
            decimal dWeeklyFee = 0;
            decimal dTotalFee = 0;
            
            if (tbClientName.Text.Length < 1)
            {
                szErrorMessage = szErrorMessage + "Client Name is a required field.\n";
                bError = true;
            }
            if (cbGender.Text.Length < 1)
            {
                szErrorMessage = szErrorMessage + "Gender is a required field.\n";
                bError = true;
            }

            try
            {
                iNumberOfWeeks = System.Convert.ToInt32(tbNumberOfWeeks.Text);
            }
            catch (Exception err)
            {
                szErrorMessage = szErrorMessage + "Number of Weeks is a required numeric field.\n";
                bError = true;
            }
            try
            {
                dIntakeFee = System.Convert.ToDecimal(tbIntakeFee.Text);
            }
            catch (Exception err)
            {
                szErrorMessage = szErrorMessage + "Intake Fee is a required decimal field (no dollar signs).\n";
                bError = true;
            }
            try
            {
                dWeeklyFee = System.Convert.ToDecimal(tbWeeklyFee.Text);
            }
            catch (Exception err)
            {
                szErrorMessage = szErrorMessage + "Weekly Fee is a required decimal field (no dollar signs).\n";
                bError = true;
            }

            if (bError)
                MessageBox.Show(szErrorMessage);
            else
            {
                int iClientID = 0;
                int iClassID = 0;
                string szClassDay = "";
                dTotalFee = ((System.Convert.ToDecimal(tbWeeklyFee.Text)) * (System.Convert.ToInt32(tbNumberOfWeeks.Text)));
                dTotalFee = dTotalFee + (System.Convert.ToDecimal(tbIntakeFee.Text));
                tbTotalFee.Text = dTotalFee.ToString();
                
                DateTime dtStartDateValue = dtStartDate.Value;
                // connect to database
                OleDbConnection odbcAccess = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=c:\\Lighthouse\\Lighthouse.accdb");
                odbcAccess.Open();
                OleDbCommand odbcQuery;
                OleDbDataReader odbcReader;

                // get next Client_ID
                string szQuery = "select Client_ID from [Client_ID]";
                odbcQuery = new OleDbCommand(szQuery);
                odbcQuery.Connection = odbcAccess;

                odbcReader = odbcQuery.ExecuteReader();

                if (odbcReader.HasRows == true)
                {
                    while (odbcReader.Read() != false)
                    {
                        iClientID = odbcReader.GetInt32(0);
                        tbClientID.Text = iClientID.ToString();
                    }
                }
                else
                {
                    MessageBox.Show("Unable to determine Client ID - contact support");
                    odbcAccess.Close();
                    return;
                }

                string szInsertQuery = "INSERT INTO Client_Table (Client_ID, Client_Name, Gender, Number_Of_Weeks, Start_Date, Intake_Fee, Weekly_Fee, Total_Fee, Balance_Owed, Classes_Attended, Intake_Fee_Paid) VALUES (" + iClientID.ToString() + ", \"" + tbClientName.Text + "\",\"" + cbGender.Text + "\"," + iNumberOfWeeks.ToString() + ",\"" + dtStartDateValue.ToShortDateString() + "\"," + dIntakeFee.ToString() + "," + dWeeklyFee.ToString() + "," + dTotalFee.ToString() + "," + dTotalFee.ToString() + ", 0, \"N\")";
                //MessageBox.Show(szInsertQuery);
                try
                {
                    odbcQuery = new OleDbCommand(szInsertQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }
                tbStatusMessage.Text = "Client record was added.";

                szInsertQuery = "UPDATE CLIENT_ID SET CLIENT_ID= (CLIENT_ID + 1)"; // +iNextClientID.ToString();
                //MessageBox.Show(szInsertQuery);
                try
                {
                    odbcQuery = new OleDbCommand(szInsertQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }

                // add reader here to fine client ID
                // move this code to create class roster and replace with lookup from Client_Class_Table

                // determine classes for each client
                int iWeekDayValue = (int)dtStartDateValue.DayOfWeek;
                odbcQuery = new OleDbCommand("select Class_ID, Day_Of_Week from Classes_Table where Day_Of_Week_Index = " + iWeekDayValue.ToString() + " and Gender = \"" + cbGender.Text + "\"");
                odbcQuery.Connection = odbcAccess;
                odbcReader = odbcQuery.ExecuteReader();


                if (odbcReader.HasRows == true)
                {
                    odbcReader.Read();
                    iClassID = odbcReader.GetInt32(0);
                    szClassDay = odbcReader.GetString(1);
                    tbStatusMessage.Text = "Client record was added. " + szClassDay + " class has been selected.";
                }

                szInsertQuery = "INSERT INTO Client_Class_Table (Client_ID, Class_ID) VALUES (" + iClientID.ToString() + "," + iClassID.ToString() + ")";
                //MessageBox.Show(szInsertQuery);
                try
                {
                    odbcQuery = new OleDbCommand(szInsertQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }
                tbStatusMessage.Text = "Client record was added. " + szClassDay + " class has been selected.  Class record created.";

                odbcAccess.Close();


            }

        }

        private void returnToMainScreenToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
            return;
        }
    }
}
