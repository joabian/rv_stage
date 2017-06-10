<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="RecoverPassword.aspx.vb" Inherits="RecoverPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:PasswordRecovery ID="PasswordRecovery1" runat="server">
        <MailDefinition From="nonreply@radiadoresvencedores.com" Priority="High" 
            Subject="Recuperacion de Contraseña">
        </MailDefinition>
    </asp:PasswordRecovery>
</asp:Content>
