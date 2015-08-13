using System;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.DataProtection;
using Microsoft.Owin.Security.Google;
using Owin;
using ControlSample.Models;

namespace ControlSample
{
    public partial class Startup {

        // 認証の構成の詳細については、http://go.microsoft.com/fwlink/?LinkId=301883 を参照してください。
        public void ConfigureAuth(IAppBuilder app)
        {
            // リクエストあたり 1 インスタンスのみを使用するように DB コンテキストとユーザー マネージャーを設定します
            app.CreatePerOwinContext(ApplicationDbContext.Create);
            app.CreatePerOwinContext<ApplicationUserManager>(ApplicationUserManager.Create);

            // サインインしたユーザーの情報を保存するために、アプリケーションが Cookie を使用できるようにします
            // また、サード パーティ ログイン プロバイダーを使用してログインしたユーザーに関する情報を一時的に保存するために、Cookie を使用できるようにします。
            // サインイン Cookie を構成します
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                LoginPath = new PathString("/Account/Login"),
                Provider = new CookieAuthenticationProvider
                {
                    OnValidateIdentity = SecurityStampValidator.OnValidateIdentity<ApplicationUserManager, ApplicationUser>(
                        validateInterval: TimeSpan.FromMinutes(20),
                        regenerateIdentity: (manager, user) => user.GenerateUserIdentityAsync(manager))
                }
            });
            // サード パーティ ログイン プロバイダーを使用してログインしたユーザーに関する情報を一時的に保存するために、Cookie を使用します。
            app.UseExternalSignInCookie(DefaultAuthenticationTypes.ExternalCookie);

            // 次の行のコメントを解除して、サード パーティ ログイン プロバイダーを使用したログインを有効にします
            //app.UseMicrosoftAccountAuthentication(
            //    clientId: "",
            //    clientSecret: "");

            //app.UseTwitterAuthentication(
            //   consumerKey: "",
            //   consumerSecret: "");

            //app.UseFacebookAuthentication(
            //   appId: "",
            //   appSecret: "");

            //app.UseGoogleAuthentication(new GoogleOAuth2AuthenticationOptions()
            //{
            //    ClientId = "",
            //    ClientSecret = ""
            //});
        }
    }
}
