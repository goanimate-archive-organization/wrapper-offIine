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
using System.Diagnostics;

namespace AssetImporter
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            textBox3.Text = Globals.absolutePath;
        }

        private void reset()
        {
            progressBar1.Value -= 100;
            label10.Text = "0%";
            textBox1.Text = "";
            textBox4.Text = "";
            comboBox1.Items.Clear();
            comboBox2.Items.Clear();
            comboBox2.Visible = false;
            comboBox3.Items.Clear();
            comboBox3.Visible = false;
            label3.Visible = false;
            label7.Visible = false;
            richTextBox1.Text = "";
            richTextBox2.Text = "";
            label9.Text = "Progress:";
        }
        public static class Globals
        {
            public static String filePath = "";
            public static String fileName = "";
            public static String fileNameNoExt = "";
            public static String fileExt = "";
            public static String mp3Duration = "";
            public static String holdable = "";
            public static String wearable = "";
            public static String CFXML = "";
            public static String SOUNDTYPE = "";
            public static String ASSETLOC = "";
            public static String strExeFilePath = System.Reflection.Assembly.GetExecutingAssembly().Location;
            public static String strWorkPath = System.IO.Path.GetDirectoryName(strExeFilePath);
            public static String absolutePath = strWorkPath + "\\..";
        }
        public void button1_Click(object sender, EventArgs e)
        {


            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = "c:\\";
                openFileDialog.Filter = "All supported file types (*.jpg, *.jpeg, *.png, *.gif, *.swf, *.mp3)|*.jpg; *.jpeg; *.png; *.gif; *.swf; *.mp3|Joint Photographic Experts Group (JPEG) (*.jpg, *.jpeg)|*.jpg; *.jpeg|Portable Network Graphics (PNG) (*.png)|*.png|Graphics Interchange Format (GIF) (*.gif)|*.gif|Shockwave Flash (*.swf)|*.swf|MPEG-3 Audio (*.mp3)|*.mp3";
                openFileDialog.FilterIndex = 2;
                openFileDialog.RestoreDirectory = true;

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    //Get the path of specified file
                    Globals.filePath = openFileDialog.FileName;
                    Globals.fileName = openFileDialog.SafeFileName;
                    Globals.fileExt = Path.GetExtension(Globals.filePath);
                    Globals.fileNameNoExt = Path.GetFileNameWithoutExtension(Globals.filePath);
                    textBox1.Text = Globals.filePath;
                    textBox4.Text = Globals.fileNameNoExt;
                    Globals.absolutePath = textBox3.Text;
                    if (Globals.fileExt == ".jpg")
                    {
                        comboBox1.Items.Add("Prop");
                        comboBox1.Items.Add("Backdrop");
                        comboBox1.Text = "Prop";
                        if (comboBox1.Text == "Prop")
                        {
                            comboBox2.Items.Add("Yes");
                            comboBox2.Items.Add("No");
                            comboBox3.Items.Add("Yes");
                            comboBox3.Items.Add("No");
                            label3.Text = "Holdable:";
                            label3.Visible = true;
                            comboBox2.Visible = true;
                            label7.Visible = true;
                            comboBox3.Visible = true;
                            comboBox2.Text = "No";
                            comboBox3.Text = "No";
                            if (comboBox2.Text == "Yes")
                            {
                                Globals.holdable = "1";
                            }
                            else
                            {
                                Globals.holdable = "0";
                            }
                            if (comboBox3.Text == "Yes")
                            {
                                Globals.wearable = "1";
                            }
                            else
                            {
                                Globals.wearable = "0";
                            }
                            Globals.CFXML = "<prop id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" holdable=\"" + Globals.holdable + "\" wearable=\"" + Globals.wearable + "\" placeable=\"1\" facing=\"left\" thumb=\"\" aid=\"9004\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                        if (comboBox1.Text == "Backdrop")
                        {
                            Globals.CFXML = "<background id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" default=\"N\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                    }
                    if (Globals.fileExt == ".png")
                    {
                        comboBox1.Items.Add("Prop");
                        comboBox1.Items.Add("Backdrop");
                        comboBox1.Text = "Prop";
                        if (comboBox1.Text == "Prop")
                        {
                            comboBox2.Items.Add("Yes");
                            comboBox2.Items.Add("No");
                            comboBox3.Items.Add("Yes");
                            comboBox3.Items.Add("No");
                            label3.Text = "Holdable:";
                            label3.Visible = true;
                            comboBox2.Visible = true;
                            label7.Visible = true;
                            comboBox3.Visible = true;
                            comboBox2.Text = "No";
                            comboBox3.Text = "No";
                            if (comboBox2.Text == "Yes")
                            {
                                Globals.holdable = "1";
                            }
                            else
                            {
                                Globals.holdable = "0";
                            }
                            if (comboBox3.Text == "Yes")
                            {
                                Globals.wearable = "1";
                            }
                            else
                            {
                                Globals.wearable = "0";
                            }
                            Globals.CFXML = "<prop id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" holdable=\"" + Globals.holdable + "\" wearable=\"" + Globals.wearable + "\" placeable=\"1\" facing=\"left\" thumb=\"\" aid=\"9004\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                        if (comboBox1.Text == "Backdrop")
                        {
                            Globals.CFXML = "<background id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" default=\"N\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                    }
                    if (Globals.fileExt == ".gif")
                    {
                        MessageBox.Show("Do keep in mind that if you are importing an animated GIF, it will only import the first frame.", "Heads up", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        comboBox1.Items.Add("Prop");
                        comboBox1.Items.Add("Backdrop");
                        comboBox1.Text = "Prop";
                        if (comboBox1.Text == "Prop")
                        {
                            comboBox2.Items.Add("Yes");
                            comboBox2.Items.Add("No");
                            comboBox3.Items.Add("Yes");
                            comboBox3.Items.Add("No");
                            label3.Text = "Holdable:";
                            label3.Visible = true;
                            comboBox2.Visible = true;
                            label7.Visible = true;
                            comboBox3.Visible = true;
                            comboBox2.Text = "No";
                            comboBox3.Text = "No";
                            if (comboBox2.Text == "Yes")
                            {
                                Globals.holdable = "1";
                            }
                            else
                            {
                                Globals.holdable = "0";
                            }
                            if (comboBox3.Text == "Yes")
                            {
                                Globals.wearable = "1";
                            }
                            else
                            {
                                Globals.wearable = "0";
                            }
                            Globals.CFXML = "<prop id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" holdable=\"" + Globals.holdable + "\" wearable=\"" + Globals.wearable + "\" placeable=\"1\" facing=\"left\" thumb=\"\" aid=\"9004\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                        if (comboBox1.Text == "Backdrop")
                        {
                            Globals.CFXML = "<background id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" default=\"N\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                    }
                    if (Globals.fileExt == ".swf")
                    {
                        comboBox1.Items.Add("Prop");
                        comboBox1.Items.Add("Backdrop");
                        comboBox1.Text = "Prop";
                        if (comboBox1.Text == "Prop")
                        {
                            label3.Text = "Holdable:";
                            label3.Visible = true;
                            comboBox2.Visible = true;
                            label7.Visible = true;
                            comboBox3.Visible = true;
                            comboBox2.Text = "No";
                            comboBox3.Text = "No";
                            if (comboBox2.Text == "Yes")
                            {
                                Globals.holdable = "1";
                            }
                            else
                            {
                                Globals.holdable = "0";
                            }
                            if (comboBox3.Text == "Yes")
                            {
                                Globals.wearable = "1";
                            }
                            else
                            {
                                Globals.wearable = "0";
                            }
                            Globals.ASSETLOC = "prop";
                            Globals.CFXML = "<prop id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" holdable=\"" + Globals.holdable + "\" wearable=\"" + Globals.wearable + "\" placeable=\"1\" facing=\"left\" thumb=\"\" aid=\"9004\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                        if (comboBox1.Text == "Backdrop")
                        {
                            Globals.ASSETLOC = "bg";
                            Globals.CFXML = "<background id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" default=\"N\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                    }
                    // Uses the included MediaInfo.exe to calculate exact duration in milliseconds if the file is an *.mp3 file
                    if (Globals.fileExt == ".mp3")
                    {
                        Process p = new Process();

                        // Redirect the output stream of the child process.
                        p.StartInfo.CreateNoWindow = true;
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.StartInfo.FileName = Globals.absolutePath + "\\utilities\\mediainfo.exe";
                        p.StartInfo.Arguments = "\"--Output=General;%Duration%\" \"" + textBox1.Text + "\"";

                        p.Start();

                        string text = p.StandardOutput.ReadToEnd();
                        Globals.mp3Duration = text.Replace(System.Environment.NewLine, "");
                        textBox2.Text = Globals.mp3Duration;

                        p.WaitForExit();
                        label3.Text = "Duration (ms):";
                        label3.Visible = true;
                        textBox2.Visible = true;
                        comboBox2.Visible = false;
                        label7.Visible = false;
                        comboBox3.Visible = false;
                        comboBox1.Text = "Music";
                        comboBox1.Items.Add("Sound Effect");
                        comboBox1.Items.Add("Music");
                        if (comboBox1.Text == "Sound Effect")
                        {
                            Globals.ASSETLOC = "sound";
                            Globals.CFXML = "<sound id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" subtype=\"soundeffect\" duration=\"" + Globals.mp3Duration + "\" downloadtype=\"progressive\" aid=\"24304\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                        if (comboBox1.Text == "Music")
                        {
                            Globals.ASSETLOC = "sound";
                            Globals.CFXML = "<sound id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" subtype=\"bgmusic\" duration=\"" + Globals.mp3Duration + "\" downloadtype=\"progressive\" aid=\"24304\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                            richTextBox1.Text = Globals.CFXML;
                        }
                    }
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog())
            {
                if (folderBrowserDialog.ShowDialog() == DialogResult.OK) {
                    Globals.absolutePath = folderBrowserDialog.SelectedPath;
                    textBox3.Text = Globals.absolutePath;
                }
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (comboBox1.Text == "Sound Effect")
            {
                Globals.ASSETLOC = "sound";
                Globals.CFXML = "<sound id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" subtype=\"soundeffect\" duration=\"" + textBox2.Text + "\" downloadtype=\"progressive\" aid=\"24304\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                richTextBox1.Text = Globals.CFXML;
            }
            if (comboBox1.Text == "Music")
            {
                Globals.ASSETLOC = "sound";
                Globals.CFXML = "<sound id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" subtype=\"bgmusic\" duration=\"" + textBox2.Text + "\" downloadtype=\"progressive\" aid=\"24304\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                richTextBox1.Text = Globals.CFXML;
            }
            if (comboBox1.Text == "Prop")
            {
                if (comboBox2.Text == "Yes")
                {
                    Globals.holdable = "1";
                }
                else
                {
                    Globals.holdable = "0";
                }
                if (comboBox3.Text == "Yes")
                {
                    Globals.wearable = "1";
                }
                else
                {
                    Globals.wearable = "0";
                }
                Globals.ASSETLOC = "prop";
                Globals.CFXML = "<prop id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" holdable=\"" + Globals.holdable + "\" wearable=\"" + Globals.wearable + "\" placeable=\"1\" facing=\"left\" thumb=\"\" aid=\"9004\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                richTextBox1.Text = Globals.CFXML;
            }
            if (comboBox1.Text == "Backdrop")
            {
                Globals.ASSETLOC = "bg";
                Globals.CFXML = "<background id=\"" + Globals.fileName + "\" name=\"" + textBox4.Text + "\" default=\"N\" enable=\"Y\" is_premium=\"N\" money=\"0\" sharing=\"0\" />";
                richTextBox1.Text = Globals.CFXML;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string assetPath = Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\" + Globals.ASSETLOC;
            string destFile = System.IO.Path.Combine(assetPath, Globals.fileName);
            if (Directory.Exists(assetPath))
            {
                label9.Text = "Progress: ";
            }
            else
            {
                label9.Text = "Progress: Creating directory since it does not exist yet...";
                System.IO.Directory.CreateDirectory(assetPath);
            }
            if (File.Exists(destFile))
            {
                MessageBox.Show("It looks like the file already exists. Are you sure you want to import this file?\r\n\r\n(NOTE: It will overwrite the file.)", "Imported File Already Exists", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                if (MessageBox.Show("It looks like the file already exists. Are you sure you want to import this file?\r\n\r\n(NOTE: It will overwrite the file.)", "Imported File Already Exists", MessageBoxButtons.YesNo, MessageBoxIcon.Information) == DialogResult.Yes) 
                {
                    label9.Text = "Progress: Importing file to necessary directory...";
                    System.IO.File.Copy(textBox1.Text, destFile, true);
                    progressBar1.Value += 25;
                    label10.Text = progressBar1.Value + "%";
                }
            } else
            {
                label9.Text = "Progress: Importing file to necessary directory...";
                System.IO.File.Copy(textBox1.Text, destFile, true);
                progressBar1.Value += 25;
                label10.Text = progressBar1.Value + "%";
            }

            if (File.Exists(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\" + Globals.fileName))
            {
                label9.Text = "Progress: Moving file to the right directory since it appears it imported in the wrong place...";
                System.IO.File.Move(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\" + Globals.fileName, destFile);
            }
            

            label9.Text = "Progress: Adding generated string to XML...";
            if (checkBox2.Checked == false)
            {
                var fileContent = File.ReadLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml").ToList();
                if (checkBox1.Checked == false)
                {
                    fileContent[fileContent.Count - 1] = "    " + Globals.CFXML + "\r\n</theme>";
                }
                else
                {
                    fileContent[fileContent.Count - 2] = "    " + Globals.CFXML + "\r\n\r\n</theme>";
                }
                File.WriteAllLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml", fileContent);
                progressBar1.Value += 25;
                label10.Text = progressBar1.Value + "%";
            }
            else
            {
                var fileContent = File.ReadLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml").ToList();
                fileContent[fileContent.Count - 1] = "\r\n\r\n</theme>";
                File.WriteAllLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml", fileContent);
                var fileContent1 = File.ReadLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml").ToList();
                fileContent1[fileContent1.Count - 2] = "    " + Globals.CFXML + "\r\n\r\n</theme>";
                File.WriteAllLines(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml", fileContent);
                progressBar1.Value += 25;
                label10.Text = progressBar1.Value + "%";
            }

            label9.Text = "Progress: Copying new theme.xml to the _THEMES folder...";
            System.IO.File.Copy(Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml", Globals.absolutePath + "\\wrapper\\_THEMES\\import.xml", true);
            progressBar1.Value += 25;
            label10.Text = progressBar1.Value + "%";

            label9.Text = "Progress: Zipping it up because it demands that we do so...";

            Process p = new Process();

            // Redirect the output stream of the child process.
            p.StartInfo.CreateNoWindow = true;
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.RedirectStandardInput = true;
            p.StartInfo.RedirectStandardOutput = true;
            p.StartInfo.RedirectStandardError = true;
            p.StartInfo.FileName = Globals.absolutePath + "\\utilities\\7za.exe";
            p.StartInfo.Arguments = "a \"" + Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml\" \"" + Globals.absolutePath + "\\server\\store\\3a981f5cb2739137\\import\\theme.xml\" -y";

            p.Start();

            string text = p.StandardOutput.ReadToEnd();
            richTextBox2.Text = text;
            if (text.Contains("Open archive: "))
            {
                progressBar1.Value += 25;
                label10.Text = progressBar1.Value + "%";
            }

            p.WaitForExit();

            if (p.HasExited == true)
            {
                MessageBox.Show("Finished importing your file!\r\n\r\nIt should be in the \"Imported Assets\" theme.\r\n\r\nYou may need to reload the LVM in order for it to show up, however.", "Importing Finished", MessageBoxButtons.OK, MessageBoxIcon.Information);
                label9.Text = "Progress:";
                reset();
            }
        }
    }
}
