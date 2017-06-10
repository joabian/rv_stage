Imports Microsoft.VisualBasic
Imports System.Net.Mail

Public Class email_mng

    Public Sub sendEmail(ByVal emailTo As String, ByVal emailSbject As String, ByVal emailBody As String)

        Dim Smtp_Server As New SmtpClient
        Dim e_mail As MailMessage = New MailMessage
        'Smtp_Server.UseDefaultCredentials = False
        Smtp_Server.Credentials = New Net.NetworkCredential("system@radiadoresvencedores.com", "5y5t3m123")
        Smtp_Server.Port = 2525
        Smtp_Server.EnableSsl = False
        Smtp_Server.Host = "mail.radiadoresvencedores.com"

        e_mail = New MailMessage()
        e_mail.From = New MailAddress("system@radiadoresvencedores.com")
        e_mail.To.Add(emailTo)
        e_mail.Subject = emailSbject
        e_mail.IsBodyHtml = True
        e_mail.Body = emailBody

        Try
            Smtp_Server.Send(e_mail)
        Catch error_t As Exception

        End Try

    End Sub

End Class
