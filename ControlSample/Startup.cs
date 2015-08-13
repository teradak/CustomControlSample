using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ControlSample.Startup))]
namespace ControlSample
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
