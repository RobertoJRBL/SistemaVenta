using Microsoft.Extensions.DependencyInjection;
using SVRepository.Implementation;
using SVRepository.Interfaces;

namespace SVRepository
{
    public static class DependencyInjetion
    {
        public static void RegisterRepositoryDependencies(this IServiceCollection services)
        {
            services.AddTransient<IMedidaRepository, MedidaRepository>();
            services.AddTransient<ICategoriaRepository, CategoriaRepository>();
        }
    }
}
