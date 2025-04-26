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
    public partial class DisplayClient : Form
    {
        Form clientForm;
        Form searchResultsForm;

        public DisplayClient()
        {
            InitializeComponent();
        }

        public DisplayClient(Form callingForm, string szCallingForm, int iClientID, string szClientName, string szGender, DateTime dtStartDate, string szIntakeFee, string szWeeklyFee, string szTotalFee, string szBalanceOwed, int iNumberOfWeeks, int iClassID, string szClassDay, int iAttended)
        {
            InitializeComponent();
            searchResultsForm = callingForm;
            tbClientID.Text = iClientID.ToString();
            tbClientName.Text = szClientName;
            tbGender.Text = szGender;
            tbStartDate.Text = dtStartDate.ToShortDateString();
            tbIntakeFee.Text = szIntakeFee;
            tbWeeklyFee.Text = szWeeklyFee;
            tbTotalFee.Text = szTotalFee;
            tbBalanceOwed.Text = szBalanceOwed;
            tbNumberOfWeeks.Text = iNumberOfWeeks.ToString();
            tbClassID.Text = iClassID.ToString();
            tbClassDay.Text = szClassDay;
            tbAttended.Text = iAttended.ToString();

                    
            
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void tsSearch_Click(object sender, EventArgs e)
        {
            searchResultsForm.Show();
            this.Close();
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            tbClientName.ReadOnly = false;
            tbGender.ReadOnly = false;
            tbStartDate.ReadOnly = false;
            tbIntakeFee.ReadOnly = false;
            tbWeeklyFee.ReadOnly = false;
            tbNumberOfWeeks.ReadOnly = false;
            btnSave.Enabled = true;
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            string szErrorMessage = "";
            bool bError = false;
            int iNumberOfWeeks = 0;
            decimal dIntakeFee = 0;
            decimal dWeeklyFee = 0;
            decimal dTotalFee = 0;
            string szDollarSigns = "$ ";

            if (tbClientName.Text.Length < 1)
            {
                szErrorMessage = szErrorMessage + "Client Name is a required field.\n";
                bError = true;
            }
            if (tbGender.Text.Length < 1)
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
                dIntakeFee = System.Convert.ToDecimal(tbIntakeFee.Text.Trim(szDollarSigns.ToCharArray()));
            }
            catch (Exception err)
            {
                szErrorMessage = szErrorMessage + "Intake Fee is a required decimal field (no dollar signs).\n";
                bError = true;
            }
            try
            {
                dWeeklyFee = System.Convert.ToDecimal(tbWeeklyFee.Text.Trim(szDollarSigns.ToCharArray()));
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
                int iClientID = System.Convert.ToInt32(tbClientID.Text);
                int iClassID = System.Convert.ToInt32(tbClassID.Text);
                string szClassDay = "";
                dTotalFee = ((System.Convert.ToDecimal(tbWeeklyFee.Text.Trim(szDollarSigns.ToCharArray())) * (System.Convert.ToInt32(tbNumberOfWeeks.Text.Trim(szDollarSigns.ToCharArray())))));
                tbTotalFee.Text = String.Format("{0:C}", dTotalFee);
                DateTime dtStartDateValue = System.Convert.ToDateTime(tbStartDate.Text);

                // connect to database
                OleDbConnection odbcAccess = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=c:\\Lighthouse\\Lighthouse.accdb");
                odbcAccess.Open();
                OleDbCommand odbcQuery;
                OleDbDataReader odbcReader;

                // determine classes for each client
                int iWeekDayValue = (int)dtStartDateValue.DayOfWeek;
                odbcQuery = new OleDbCommand("select Class_ID, Day_Of_Week from Classes_Table where Day_Of_Week_Index = " + iWeekDayValue.ToString() + " and Gender = \"" + tbGender.Text + "\"");
                odbcQuery.Connection = odbcAccess;
                odbcReader = odbcQuery.ExecuteReader();


                if (odbcReader.HasRows == true)
                {
                    odbcReader.Read();
                    iClassID = odbcReader.GetInt32(0);
                    szClassDay = odbcReader.GetString(1);
                    tbStatusMessage.Text = "Client record was added. " + szClassDay + " class has been selected.";
                }
                string szUpdateQuery = "UPDATE Client_Table SET Client_Name=\"" + tbClientName.Text +
                    "\", Gender=\"" + tbGender.Text + "\", Number_Of_Weeks=" + iNumberOfWeeks.ToString() +
                    ", Start_Date=\"" + dtStartDateValue.ToShortDateString() + "\", Intake_Fee=" +
                    dIntakeFee.ToString() + ", Weekly_Fee=" + dWeeklyFee.ToString() + ", Total_Fee=" +
                    dTotalFee.ToString() + " WHERE Client_ID=" + iClientID.ToString();
                //MessageBox.Show(szInsertQuery);
                try
                {
                    odbcQuery = new OleDbCommand(szUpdateQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }
                szUpdateQuery = "UPDATE Client_Class_Table SET Client_ID=" + iClientID.ToString() +
                    ", Class_ID=" + iClassID.ToString() + " WHERE Client_ID=" + iClientID.ToString();
                //MessageBox.Show(szInsertQuery);
                try
                {
                    odbcQuery = new OleDbCommand(szUpdateQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }

                tbClassID.Text = iClassID.ToString();
                tbClassDay.Text = szClassDay;

                tbStatusMessage.Text = "Client record was updated.";
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            int iClientID = System.Convert.ToInt32(tbClientID.Text);
            int iClassID = System.Convert.ToInt32(tbClassID.Text);

            // connect to database
            OleDbConnection odbcAccess = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=c:\\Lighthouse\\Lighthouse.accdb");
            odbcAccess.Open();
            OleDbCommand odbcQuery;
            OleDbDataReader odbcReader;
            string szUpdateQuery;
            DialogResult mbAnswer;
            string szMBText = "Please confirm that you wish to delete Client ID: " + iClientID.ToString() + " Client Name: " + tbClientName.Text.ToString() + ".  Press 'Yes' to delete or 'No' to cancel this operation.";
            mbAnswer = MessageBox.Show(szMBText, "Confirm Client Deletion", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (mbAnswer == DialogResult.Yes)
            {
                try
                {
                    szUpdateQuery = "DELETE FROM Client_Table WHERE Client_ID=" + iClientID.ToString();
                    odbcQuery = new OleDbCommand(szUpdateQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                    szUpdateQuery = "DELETE FROM Client_Class_Table WHERE Client_ID=" + iClientID.ToString();
                    odbcQuery = new OleDbCommand(szUpdateQuery);
                    odbcQuery.Connection = odbcAccess;
                    odbcQuery.ExecuteNonQuery();
                }
                catch (Exception err)
                {
                    throw (err);
                }
                tbStatusMessage.Text = "Client record was deleted.";
            }
            else
            {
                tbStatusMessage.Text = "Operation canceled.";
            }
        }


    }
}
