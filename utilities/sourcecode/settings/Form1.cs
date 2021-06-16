using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace settings
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
            string cfg = File.ReadAllText("D:\\gitlab\\wo\\Wrapper-Offline-Public\\utilities\\config.bat");
            string info = File.ReadAllText("D:\\gitlab\\wo\\Wrapper-Offline-Public\\wrapper\\static\\info.json");
            string page = File.ReadAllText("D:\\gitlab\\wo\\Wrapper-Offline-Public\\wrapper\\static\\page.js");
            if (cfg.Contains("VERBOSEWRAPPER=n"))
            {
                comboBox1.Text = "Off";
            }
            else
            {
                comboBox1.Text = "On";
            }
            if (cfg.Contains("INCLUDEDCHROMIUM=y"))
            {
                comboBox2.Text = "Included Chromium";
                if (cfg.Contains("APPCHROMIUM=y"))
                {
                    comboBox2.Text = "On";
                }
                else
                {
                    comboBox2.Text = "Off";
                }
            }
            else
            {
                if (cfg.Contains("INCLUDEDBASILISK=y"))
                {
                    comboBox2.Text = "Included Basilisk";
                }
                else
                {
                    if (cfg.Contains("CUSTOMBROWSER=y"))
                    {
                        comboBox2.Text = "Custom Browser";
                    }
                    else
                    {
                        comboBox2.Text = "Default Browser";
                    }
                }
            }
            if (cfg.Contains("SKIPCHECKDEPENDS=n"))
            {
                comboBox4.Text = "Off";
            }
            else
            {
                comboBox4.Text = "On";
            }
            if (info.Contains("00.9533660347057853,0.9961007157284003,0.7274075379698095,"))
            {
                comboBox5.Text = "Off";
            }
            else
            {
                comboBox5.Text = "On";
            }
            if (page.Contains("ut: 30"))
            {
                comboBox5.Text = "Off";
            }
            else
            {
                comboBox5.Text = "On";
            }
            if (File.Exists("D:\\gitlab\\wo\\Wrapper-Offline-Public\\wrapper\\main-norpc.js"))
            {
                comboBox6.Text = "On";
            }
            else
            {
                comboBox6.Text = "Off";
            }
            if (File.Exists("D:\\gitlab\\wo\\Wrapper-Offline-Public\\wrapper\\pages\\html\\_OLDLISTVIEW.txt"))
            {
                comboBox9.Text = "Old List";
            }
            else
            {
                if (File.Exists("D:\\gitlab\\wo\\Wrapper-Offline-Public\\wrapper\\pages\\html\\_GRIDVIEW.txt"))
                {
                    comboBox9.Text = "Grid";
                }
                else
                {
                    comboBox9.Text = "List";
                }
            }
            if (cfg.Contains("PORT="))
            {
                String port = cfg.Substring(2184, 6);
                comboBox18.Text = port;
            }
        }
    }
}
