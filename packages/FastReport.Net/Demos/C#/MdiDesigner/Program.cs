using System;
using System.Collections.Generic;
using System.Windows.Forms;
using FastReport.Utils;
using FastReport.Design.StandardDesigner;

namespace MdiDesigner
{
  static class Program
  {
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    [STAThread]
    static void Main()
    {
      Application.EnableVisualStyles();
      Application.SetCompatibleTextRenderingDefault(false);

      using (Office2007DesignerForm designerForm = new Office2007DesignerForm())
      {
        designerForm.ShowInTaskbar = true;
        designerForm.Designer.MdiMode = true;
        designerForm.ShowDialog();
      }
    }
  }
}