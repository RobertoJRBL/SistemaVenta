using Microsoft.Extensions.DependencyInjection;
using SVRepository.DB;
using SVServices.Implementation;
using SVServices.Interfaces;

namespace SVServices
{
    public static class DependecyInjection
    {
        public static void RegisterServicesDependencies(this IServiceCollection services)
        {
            services.AddSingleton<Conexion>();
            services.AddTransient<IMedidaService, MedidaService>();
            services.AddTransient<ICategoriaService, CategoriaService>();
        }
    }
}
