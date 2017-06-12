<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="add_ips.aspx.vb" Inherits="usuarios_add_ips" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Agregar IPs</h1>
    <br /><hr />
<fieldset><legend>Agregar IP</legend>
    <asp:TextBox ID="TB_ip" runat="server"></asp:TextBox>
    <asp:Button ID="Button1" runat="server" Text="Agregar" />
    <br />
</fieldset>
    <asp:Label ID="Lblerror" runat="server" Text="" ForeColor="Red"></asp:Label>
</asp:Content>

