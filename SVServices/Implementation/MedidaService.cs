using SVRepository.Entities;
using SVRepository.Interfaces;
using SVServices.Interfaces;

namespace SVServices.Implementation
{
    public class MedidaService : IMedidaService
    {
        private readonly IMedidaRepository _medidaRepostory;
        public MedidaService(IMedidaRepository medidaRepository)
        {
            _medidaRepostory = medidaRepository;
        }
        public async Task<List<Medida>> Lista()
        {
            return await _medidaRepostory.Lista();
        }
    }
}
