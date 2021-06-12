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
using RC4Cryptography;

namespace RC4ify
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        public static class Globals
        {
            public static String OGPATH = "";
            public static String OUTPUTPATH = "";
            public static String filePath = "";
            public static String fileName = "";
            public static String fileNameNoExt = "";
            public static String fileExt = "";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = "c:\\";
                openFileDialog.Filter = "All files (*.*)|*.*";
                openFileDialog.RestoreDirectory = true;

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    //Get the path of specified file
                    Globals.filePath = openFileDialog.FileName;
                    Globals.fileName = openFileDialog.SafeFileName;
                    Globals.fileExt = Path.GetExtension(Globals.filePath);
                    Globals.OGPATH = Path.GetDirectoryName(Globals.filePath);
                    Globals.fileNameNoExt = Path.GetFileNameWithoutExtension(Globals.filePath);
                    textBox1.Text = Globals.filePath;
                    textBox2.Text = Globals.OGPATH + "\\" + Globals.fileNameNoExt + "_enc" + Globals.fileExt;
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog())
            {
                if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                {
                    textBox3.Text = folderBrowserDialog.SelectedPath + "\\" + Globals.fileNameNoExt + "_enc" + Globals.fileExt;
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Encrypt();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Decrypt();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked == true)
            {
                textBox3.Visible = false;
                comboBox1.Visible = true;
            }
            else
            {
                textBox3.Visible = true;
                comboBox1.Visible = false;
            }
        }

        public void Encrypt()
        {
            Globals.filePath = textBox1.Text;
            Globals.OUTPUTPATH = textBox2.Text;
            string key_phrase = "";
            if (checkBox1.Checked == true)
            {
                key_phrase = comboBox1.Text;
            }
            else
            {
                key_phrase = textBox3.Text;
            }
            byte[] data = File.ReadAllBytes(Globals.filePath);
            byte[] key = Encoding.UTF8.GetBytes(key_phrase);
            byte[] encrypted_data = RC4.Apply(data, key);
            System.IO.File.WriteAllBytes(Globals.OUTPUTPATH, encrypted_data);
            MessageBox.Show("Encryption successfully completed!", "Encryption Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        public void Decrypt()
        {
            Globals.filePath = textBox1.Text;
            Globals.OUTPUTPATH = textBox2.Text;
            string key_phrase = "";
            if (checkBox1.Checked == true)
            {
                key_phrase = comboBox1.Text;
            }
            else
            {
                key_phrase = textBox3.Text;
            }
            byte[] data = File.ReadAllBytes(Globals.filePath);
            byte[] key = Encoding.UTF8.GetBytes(key_phrase);
            byte[] decrypted_data = RC4.Apply(data, key);
            System.IO.File.WriteAllBytes(Globals.OUTPUTPATH, decrypted_data);
            MessageBox.Show("Decryption successfully completed!", "Decryption Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
