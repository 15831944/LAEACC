using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Windows.Forms;
using FastReport.Utils;
using System.Drawing;
using System.Drawing.Printing;

namespace FastReport.Export
{
  /// <summary>
  /// The base class for all export filters.
  /// </summary>
  public class ExportBase : Base
  {
    private PageRange FPageRange;
    private string FPageNumbers;
    private int FCurPage;
    private Stream FStream;
    private string FFileName;
    private List<int> FPages;
    private bool FOpenAfter;
    private bool FAllowOpenAfter;
    private float FZoom;
    private List<string> FGeneratedFiles;
    private bool FAllowSaveSettings;
    private bool FShowProgress;
    private int FExportTickCount;

    #region Properties

      /// <summary>
      /// Zoom factor for output file
      /// </summary>
      public float Zoom
      {
          get { return FZoom; }
          set { FZoom = value; }
      }

    /// <summary>
    /// File filter that can be used in the "Save file" dialog.
    /// </summary>
    public string FileFilter
    {
      get { return GetFileFilter(); }
    }
    
    /// <summary>
    /// Range of pages to export.
    /// </summary>
    public PageRange PageRange
    {
      get { return FPageRange; }
      set { FPageRange = value; }
    }

    /// <summary>
    /// Page numbers to export.
    /// </summary>
    /// <remarks>
    /// Use page numbers separated by comma and/or page ranges, for example: "1,3-5,12". Empty string means 
    /// that all pages need to be exported.
    /// </remarks>
    public string PageNumbers
    {
      get { return FPageNumbers; }
      set { FPageNumbers = value; }
    }
    
    /// <summary>
    /// Current page number.
    /// </summary>
    /// <remarks>
    /// Page number need to be exported if user selects "Current page" radiobutton in the export options dialog.
    /// This property is typically set to current page number in the preview window.
    /// </remarks>
    public int CurPage
    {
      get { return FCurPage; }
      set { FCurPage = value; }
    }

    /// <summary>
    /// Open the document after export.
    /// </summary>
    public bool OpenAfterExport
    {
      get { return FOpenAfter; }
      set { FOpenAfter = value; }
    }

    /// <summary>
    /// Allows or disables the OpenAfterExport feature.
    /// </summary>
    public bool AllowOpenAfter
    {
      get { return FAllowOpenAfter; }
      set { FAllowOpenAfter = value; }
    }

    /// <summary>
    /// Gets or sets a value that determines whether to show progress window during export or not.
    /// </summary>
    public bool ShowProgress
    {
      get { return FShowProgress; }
      set { FShowProgress = value; }
    }

    /// <summary>
    /// Gets a list of files generated by this export.
    /// </summary>
    public List<string> GeneratedFiles
    {
      get { return FGeneratedFiles; }
    }

    /// <summary>
    /// Stream to export to.
    /// </summary>
    protected Stream Stream
    {
      get { return FStream; }
    }
    
    /// <summary>
    /// File name to export to.
    /// </summary>
    protected string FileName
    {
      get { return FFileName; }
    }
    
    /// <summary>
    /// Array of page numbers to export.
    /// </summary>
    protected int[] Pages
    {
      get { return FPages.ToArray(); }
    }
    
    internal bool AllowSaveSettings
    {
      get { return FAllowSaveSettings; }
      set { FAllowSaveSettings = value; }
    }
    #endregion

    #region Private Methods
    private bool Parse(string pageNumbers, int total)
    {
      FPages.Clear();
      string s = pageNumbers.Replace(" ", "");
      if (s == "") return false;

      if (s[s.Length - 1] == '-')
        s += total.ToString();
      s += ',';

      int i = 0;
      int j = 0;
      int n1 = 0;
      int n2 = 0;
      bool isRange = false;

      while (i < s.Length)
      {
        if (s[i] == ',')
        {
          n2 = int.Parse(s.Substring(j, i - j));
          j = i + 1;
          if (isRange)
          {
            while (n1 <= n2)
            {
              FPages.Add(n1 - 1);
              n1++;
            }
          }
          else
            FPages.Add(n2 - 1);
          isRange = false;
        }
        else if (s[i] == '-')
        {
          isRange = true;
          n1 = int.Parse(s.Substring(j, i - j));
          j = i + 1;
        }
        i++;
      }

      return true;
    }

    private void PreparePageNumbers()
    {
      FPages.Clear();
      int total = Report.PreparedPages.Count;
      if (PageRange == PageRange.Current)
        FPages.Add(CurPage - 1);
      else if (!Parse(PageNumbers, total))
      {
        for (int i = 0; i < total; i++)
          FPages.Add(i);
      }
      
      // remove invalid page numbers
      for (int i = 0; i < FPages.Count; i++)
      {
        if (FPages[i] < 0 || FPages[i] >= total)
        {
          FPages.RemoveAt(i);
          i--;
        }
      }
    }

    private void OpenFile()
    {
      try
      {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.EnableRaisingEvents = false;
        proc.StartInfo.FileName = FFileName;
        proc.Start();
      }
      catch
      {
      }
    }

    private void SaveSettings()
    {
      XmlItem root = Config.Root.FindItem("Preview").FindItem("Exports").FindItem(ClassName);
      using (FRWriter writer = new FRWriter(root))
      {
        root.Clear();
        writer.Write(this);
      }
    }

    private void RestoreSettings()
    {
      XmlItem root = Config.Root.FindItem("Preview").FindItem("Exports").FindItem(ClassName);
      using (FRReader reader = new FRReader(null, root))
      {
        reader.Read(this);
      }
    }
    #endregion
    
    #region Protected Methods
    /// <summary>
    /// Returns a file filter for a save dialog.
    /// </summary>
    /// <returns>String that contains a file filter, for example: "Bitmap image (*.bmp)|*.bmp"</returns>
    protected virtual string GetFileFilter()
    {
      return "";
    }

    /// <summary>
    /// This method is called when the export starts.
    /// </summary>
    protected virtual void Start()
    {
    }

    /// <summary>
    /// This method is called for each exported page.
    /// </summary>
    /// <param name="pageNo">Page number to export.</param>
    /// <remarks>
    /// To get a page, use the following code:
    /// <code>
    /// ReportPage page = Report.PreparedPages.GetPage(pageNo);
    /// </code>
    /// </remarks>
    protected virtual void ExportPage(int pageNo)
    {
    }

    /// <summary>
    /// This method is called when the export is finished.
    /// </summary>
    protected virtual void Finish()
    {
    }

    /// <summary>
    /// Gets a report page with specified index.
    /// </summary>
    /// <param name="index">Zero-based index of page.</param>
    /// <returns>The prepared report page.</returns>
    protected ReportPage GetPage(int index)
    {
      ReportPage page = Report.PreparedPages.GetPage(index);

      return page;
    }
    #endregion
    
    #region Public Methods
    /// <inheritdoc/>
    public override void Assign(Base source)
    {
      BaseAssign(source);
    }

    /// <inheritdoc/>
    public override void Serialize(FRWriter writer)
    {
      writer.WriteValue("PageRange", PageRange);
      writer.WriteStr("PageNumbers", PageNumbers);
      writer.WriteBool("OpenAfterExport", OpenAfterExport);
    }

    /// <summary>
    /// Displays a dialog with export options.
    /// </summary>
    /// <returns><b>true</b> if dialog was closed with OK button.</returns>
    public virtual bool ShowDialog()
    {
      return true;
    }

    /// <summary>
    /// Exports the report to a stream.
    /// </summary>
    /// <param name="report">Report to export.</param>
    /// <param name="stream">Stream to export to.</param>
    /// <remarks>
    /// This method does not show an export options dialog. If you want to show it, call <see cref="ShowDialog"/>
    /// method prior to calling this method, or use the "Export(Report report)" method instead.
    /// </remarks>
    public void Export(Report report, Stream stream)
    {
      SetReport(report);
      FStream = stream;
      PreparePageNumbers();
      GeneratedFiles.Clear();
      FExportTickCount = Environment.TickCount;

      if (FPages.Count > 0)
      {
        if (!String.IsNullOrEmpty(FileName))
          GeneratedFiles.Add(FileName);
        Start();
        report.SetOperation(ReportOperation.Exporting);
        if (ShowProgress)
          Config.ReportSettings.OnStartProgress(Report);

        try
        {
          for (int i = 0; i < FPages.Count; i++)
          {
            if (ShowProgress)
              Config.ReportSettings.OnProgress(Report,
                String.Format(Res.Get("Messages,ExportingPage"), i + 1, FPages.Count), i + 1, FPages.Count);
            if (!Report.Aborted && i < FPages.Count)
              ExportPage(FPages[i]);
          }
        }
        finally
        {
          Finish();
          if (ShowProgress)
            Config.ReportSettings.OnProgress(Report, String.Empty);
          if (ShowProgress)
            Config.ReportSettings.OnFinishProgress(Report);
          report.SetOperation(ReportOperation.None);

          FExportTickCount = Environment.TickCount - FExportTickCount;
          if (Report.Preview != null && Config.ReportSettings.ShowPerformance)
            Report.Preview.ShowPerformance(String.Format(Res.Get("Export,Misc,Performance"), FExportTickCount));
          
          if (FOpenAfter && AllowOpenAfter)
          {
            stream.Close();
            OpenFile();
          }  
        }
      }  
    }

    /// <summary>
    /// Exports the report to a file.
    /// </summary>
    /// <param name="report">Report to export.</param>
    /// <param name="fileName">File name to export to.</param>
    /// <remarks>
    /// This method does not show an export options dialog. If you want to show it, call <see cref="ShowDialog"/>
    /// method prior to calling this method, or use the "Export(Report report)" method instead.
    /// </remarks>
    public void Export(Report report, string fileName)
    {
      FFileName = fileName;
      using (FileStream stream = new FileStream(fileName, FileMode.Create))
      {
        Export(report, stream);
      }
    }
    
    /// <summary>
    /// Exports the report to a file.
    /// </summary>
    /// <param name="report">Report to export.</param>
    /// <returns><b>true</b> if report was succesfully exported.</returns>
    /// <remarks>
    /// This method displays an export options dialog, then prompts a file name using standard "Open file"
    /// dialog. If both dialogs were closed by OK button, exports the report and returns <b>true</b>.
    /// </remarks>
    public bool Export(Report report)
    {
      SetReport(report);
      
      if (AllowSaveSettings)
        RestoreSettings();
      
      if (ShowDialog())
      {
        if (AllowSaveSettings)
          SaveSettings();
        
        using (SaveFileDialog dialog = new SaveFileDialog())
        {
          dialog.FileName = Path.GetFileNameWithoutExtension(Path.GetFileName(report.FileName));
          dialog.Filter = FileFilter;
          string defaultExt = dialog.Filter.Split(new char[] { '|' })[1];
          dialog.DefaultExt = Path.GetExtension(defaultExt);
          if (dialog.ShowDialog() == DialogResult.OK)
          {
            Application.DoEvents();
            Export(report, dialog.FileName);
            return true;
          }
        }
      }
      return false;
    }
    #endregion
    
    /// <summary>
    /// Initializes a new instance of the <see cref="ExportBase"/> class.
    /// </summary>
    public ExportBase()
    {
      FPageNumbers = "";
      FPages = new List<int>();
      FCurPage = 1;
      FFileName = "";
      FAllowOpenAfter = true;
      FZoom = 1;
      FGeneratedFiles = new List<string>();
    }
  }
}
