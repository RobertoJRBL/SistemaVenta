﻿using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace SVRepository.DB
{
    public class Conexion
    {
        private readonly IConfiguration _configuracion;
        private readonly string _cadenaSql;

        public Conexion(IConfiguration configuracion)
        {
            _configuracion = configuracion;
            _cadenaSql = configuracion.GetConnectionString("CadenaSql")!;
        }

        public SqlConnection Obtener()
        {
            return new SqlConnection(_cadenaSql);
        }
    }
}