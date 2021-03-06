﻿<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="AC080.aspx.vb" Inherits="LAEACC.AC080" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
</asp:content>


<asp:Content ID="Content" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
       <Triggers>
          <asp:PostBackTrigger ControlID="BtnPrint" />
       </Triggers>

        <ContentTemplate>        
            <!--關鍵值隱藏區-->
            <asp:Label ID="txtKey1" Text="" Visible="false" runat="server" />
   
            <!--主項目區-->
            <div style="margin: 10px 0px 0px 10px;">
                <section id="widget-grid" style="width:98%;">
                    <div class="row">
                        <article class="col-sm-12 col-md-12 col-lg-12">
                            <table id="table-data" rules="all">
                                <tr><td colspan="2" style="color:#f84444;font-size:16px;font-weight:bold;text-align:center;">列印日計表</td></tr>                                 
                                
                                <tr>   
                                    <th>起印日期</th>                                             
                                    <td>
                                        <asp:TextBox ID="dtpDateS" Width="80px" onClick="WdatePicker({dateFmt:'yyy-MM-dd',skin:'whyGreen'})" runat="server" />
                                    </td>
                                </tr>
                                <tr>   
                                    <th>訖印日期</th>                                             
                                    <td>
                                         <asp:TextBox ID="dtpDateE" Width="80px" onClick="WdatePicker({dateFmt:'yyy-MM-dd',skin:'whyGreen'})" runat="server" />
                                    </td>
                                </tr>                                
                                <tr>   
                                    <th>起頁</th>                                             
                                    <td>
                                       <asp:TextBox ID="txtNoD" CssClass="form-control" runat="server" />
                                    </td>
                                </tr>
                                <tr>                                                
                                    <td colspan="2" align="center"><asp:Button ID="BtnPrint" Text="列印" CssClass="btn btn-primary" runat="server" /> </td>
                                </tr>                                              
                           
                            </table>
                            <div style="padding-bottom:1px;">&nbsp;</div>                            
                        </article>
                    </div>
                </section>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
