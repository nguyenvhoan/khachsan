using System.Drawing;
using System.Windows.Forms;

namespace Calculator
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();   
            groupBox1 = new GroupBox();
            label4 = new Label();
            label3 = new Label();
            label2 = new Label();
            textBox1 = new TextBox();
            textBox2 = new TextBox();
            textBox3 = new TextBox();
            button1 = new Button();
            button2 = new Button();
            button3 = new Button();
            button4 = new Button();
            groupBox1.SuspendLayout();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 20.25F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.ForeColor = Color.Red;
            label1.Location = new Point(206, 36);
            label1.Name = "label1";
            label1.RightToLeft = RightToLeft.No;
            label1.Size = new Size(431, 37);
            label1.TabIndex = 0;
            label1.Text = "Chương trình tính toán đơn giản";
            // 
            // groupBox1
            // 
            groupBox1.Controls.Add(textBox3);
            groupBox1.Controls.Add(textBox2);
            groupBox1.Controls.Add(textBox1);
            groupBox1.Controls.Add(label4);
            groupBox1.Controls.Add(label3);
            groupBox1.Controls.Add(label2);
            groupBox1.Location = new Point(248, 124);
            groupBox1.Name = "groupBox1";
            groupBox1.Size = new Size(327, 153);
            groupBox1.TabIndex = 1;
            groupBox1.TabStop = false;
            groupBox1.Text = "Tính toán đơn giản";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(23, 110);
            label4.Name = "label4";
            label4.Size = new Size(68, 15);
            label4.TabIndex = 2;
            label4.Text = "Số thứ nhất";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(23, 69);
            label3.Name = "label3";
            label3.Size = new Size(60, 15);
            label3.TabIndex = 2;
            label3.Text = "Số thứ hai";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(23, 27);
            label2.Name = "label2";
            label2.Size = new Size(68, 15);
            label2.TabIndex = 0;
            label2.Text = "Số thứ nhất";
            // 
            // textBox1
            // 
            textBox1.Location = new Point(97, 27);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(183, 23);
            textBox1.TabIndex = 3;
            // 
            // textBox2
            // 
            textBox2.Location = new Point(97, 66);
            textBox2.Name = "textBox2";
            textBox2.Size = new Size(183, 23);
            textBox2.TabIndex = 4;
            // 
            // textBox3
            // 
            textBox3.Enabled = false;
            textBox3.Location = new Point(97, 110);
            textBox3.Name = "textBox3";
            textBox3.ReadOnly = true;
            textBox3.Size = new Size(183, 23);
            textBox3.TabIndex = 5;
            // 
            // button1
            // 
            button1.Location = new Point(316, 303);
            button1.Name = "button1";
            button1.Size = new Size(53, 23);
            button1.TabIndex = 2;
            button1.Text = "Cộng";
            button1.UseVisualStyleBackColor = true;
            // 
            // button2
            // 
            button2.Location = new Point(493, 303);
            button2.Name = "button2";
            button2.Size = new Size(53, 23);
            button2.TabIndex = 3;
            button2.Text = "Chia";
            button2.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            button3.Location = new Point(434, 303);
            button3.Name = "button3";
            button3.Size = new Size(53, 23);
            button3.TabIndex = 4;
            button3.Text = "Nhân";
            button3.UseVisualStyleBackColor = true;
            // 
            // button4
            // 
            button4.Location = new Point(375, 303);
            button4.Name = "button4";
            button4.Size = new Size(53, 23);
            button4.TabIndex = 5;
            button4.Text = "Trừ";
            button4.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(button4);
            Controls.Add(button3);
            Controls.Add(button2);
            Controls.Add(button1);
            Controls.Add(groupBox1);
            Controls.Add(label1);
            Enabled = false;
            Name = "Form1";
            Text = "Form1";
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }


        #endregion
        private Label label1;
        private GroupBox groupBox1;
        private Label label4;
        private Label label3;
        private Label label2;
        private TextBox textBox1;
        private TextBox textBox3;
        private TextBox textBox2;
        private Button button1;
        private Button button2;
        private Button button3;
        private Button button4;
    }
}

