using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using ControlSample.Models;

namespace ControlSample.Account
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Forgot(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // ユーザーのパスワードを検証します
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                ApplicationUser user = manager.FindByName(Email.Text);
                if (user == null || !manager.IsEmailConfirmed(user.Id))
                {
                    FailureText.Text = "ユーザーが存在しないか、未確認です。";
                    ErrorMessage.Visible = true;
                    return;
                }
                // アカウントの確認とパスワードの再設定を有効にする方法については、http://go.microsoft.com/fwlink/?LinkID=320771 を参照してください
                // コードとパスワードの再設定ページへのリダイレクトを記載した電子メールを送信します
                //string code = manager.GeneratePasswordResetToken(user.Id);
                //string callbackUrl = IdentityHelper.GetResetPasswordRedirectUrl(code);
                //manager.SendEmail(user.Id, "パスワード", "のリセット <a href=\"" + callbackUrl + "\">こちら</a>をクリックして、パスワードをリセットしてください.");
            }
        }
    }
}