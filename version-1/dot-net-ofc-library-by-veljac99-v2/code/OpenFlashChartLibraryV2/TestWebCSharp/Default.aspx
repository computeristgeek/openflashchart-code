<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" ValidateRequest ="false" %>
<%@ OutputCache NoStore="true" Duration="1" VaryByParam="*" %>
<%@ Register assembly="OpenFlashChartASPNETLibraryV2" namespace="OpenFlashChartASPNETLibraryV2.WebComponent" tagprefix="ofc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <h2>
      <asp:Literal runat="server" ID="lblTitle"></asp:Literal>
    </h2>
    <div>
    
    <table width="100%">
      <tr>
        <td valign="top">
          Graph: <br />
          <asp:ListBox  runat="server" ID="cboGraph" 
              Height="300"
              onselectedindexchanged="cboGraph_SelectedIndexChanged"></asp:ListBox>
          <br />
          <asp:Button runat="server" ID="cmdRefresh" Text="Refresh" 
            onclick="cmdRefresh_Click" />
          
        </td>
        <td>
          <ofc:OpenFlashChartControl ID="OpenFlashChartControl1" runat="server" 
            WidthPx="600" HeightPx="450"
            isDataSourceExternal="true" 
            isSwfObjectEnabled="true" 
            visible="true">
          </ofc:OpenFlashChartControl>
        </td>
      </tr>
    </table>
    
    <table style="width:100%;overflow:scroll ;">
      <colgroup>
      <col width="50%" />
      <col width="50%" />
      </colgroup>
      <tr>
        <td>
          <b>C# code:</b>
        </td>
        <td>
          <b>Generated chart data: </b>
        </td>
      </tr>
      <tr>
        <td>
          <asp:TextBox Width="500" runat="server" ID="txtSourceCode" EnableViewState="false" TextMode="MultiLine" Rows="20"  ></asp:TextBox>
        </td>
        <td>
          <asp:TextBox Width="500" runat="server" ID="txtDataSource" EnableViewState="false" TextMode="MultiLine" Rows="20" Wrap="true"></asp:TextBox>    
        </td>
      </tr>
    </table>
    
    </div>
  
    
    
    
    
    
    </form>
</body>
</html>
