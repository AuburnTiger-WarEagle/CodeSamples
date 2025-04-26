using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Lighthouse
{
    public partial class GenerateClassSchedule : Form
    {
        Form clientForm;

        public GenerateClassSchedule()
        {
            clientForm = this;
            InitializeComponent();
        }


        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void tsSearch_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void tsClasses_Click(object sender, EventArgs e)
        {

        }

        private void tsClassesViewSchedule_Click(object sender, EventArgs e)
        {

        }

        private void tsClassesGenerateSchedule_Click(object sender, EventArgs e)
        {
            GenerateSchedule generateForm = new GenerateSchedule(clientForm, "Client");
            generateForm.Show();
        }

        private void tsClassesAttendance_Click(object sender, EventArgs e)
        {

        }

        private void tsClassesAttendanceClass_Click(object sender, EventArgs e)
        {

        }

        private void tsClassesAttendanceClient_Click(object sender, EventArgs e)
        {

        }

        private void tsClassesAttendanceAbsentees_Click(object sender, EventArgs e)
        {

        }

        private void tsClients_Click(object sender, EventArgs e)
        {

        }

        private void tsClientsAdd_Click(object sender, EventArgs e)
        {
            AddClient addForm = new AddClient(clientForm, "Client");
            addForm.Show();
        }

        private void tsClientsModify_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void tsClientsDelete_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void tsClientsSearch_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void quitApplicationToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
            return;
        }

        private void processASignInSheetToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ProcessSheet processSheetForm = new ProcessSheet(clientForm, "Client");
            processSheetForm.Show();
        }

        private void clientsToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void addToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AddClient addForm = new AddClient(clientForm, "Client");
            addForm.Show();
        }

        private void modifyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void generateScheduleAndSigninSheetToolStripMenuItem_Click(object sender, EventArgs e)
        {
            GenerateSchedule generateForm = new GenerateSchedule(clientForm, "Client");
            generateForm.Show();
        }

        private void processASigninSheetToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            ProcessSheet processSheetForm = new ProcessSheet(clientForm, "Client");
            processSheetForm.Show();
        }

        private void searchForAClientToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Search searchForm = new Search(clientForm, "Client");
            searchForm.Show();
        }

        private void quitApplicationToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.Close();
            return;
        }

        private void viewScheduleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ViewSchedule scheduleForm = new ViewSchedule(clientForm, "Client");
            scheduleForm.Show();
        }

        private void forAClassToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Reports reportsForm = new Reports(clientForm, "Class");
            reportsForm.Show();
        }

        private void forAClientToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Reports reportsForm = new Reports(clientForm, "Client");
            reportsForm.Show();
        }

        private void absenteeListToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Reports reportsForm = new Reports(clientForm, "Absentee");
            reportsForm.Show();
        }





    }


}
