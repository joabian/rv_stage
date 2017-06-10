
Partial Class usuarios_usuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim users As MembershipUserCollection = Membership.GetAllUsers()

        gv_usuarios.DataSource = users
        gv_usuarios.DataBind()

        Dim username As String
        username = "admin"
        ''Dim user_actual = ProfileManager.FindProfilesByUserName(ProfileAuthenticationOption.All, username)
        Dim profiles As ProfileInfoCollection = ProfileManager.GetAllProfiles(ProfileAuthenticationOption.All)

        gv_profiles.DataSource = profiles
        gv_profiles.DataBind()

        'Dim user_profile As ProfileInfo
        'Dim user_profile As String

        'user_profile = Profile.UserName.ToString()


        
    End Sub
End Class
