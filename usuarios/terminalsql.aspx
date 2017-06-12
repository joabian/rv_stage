<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="terminalsql.aspx.vb" Inherits="usuarios_terminalsql" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Terminal SQL</h1>
    <br /><hr />
    <div style="text-align:center;">
        <asp:TextBox ID="txt_query" runat="server" Height="120px" Width="100%" TextMode="MultiLine"></asp:TextBox><br /><br />
        <asp:Button ID="Button1" runat="server" Text="Get Query" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btn_download" runat="server" Text="Download" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button2" runat="server" Text="Exec Query" /><br /><br />
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button3" runat="server" Text="Get ASP Query" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button4" runat="server" Text="Exec ASP Query" /><br /><br />
        <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>
        <asp:GridView ID="gv_query" runat="server" Width="100%">
        </asp:GridView>
    </div>
    <asp:Label ID="lbl_compuname" runat="server" Text=""></asp:Label>
</asp:Content>

