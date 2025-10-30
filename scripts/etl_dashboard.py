"""
ETL Script para Dashboard Seguimiento Presencial Agencias
La Ascensión S.A.

Este script extrae datos de las bases transaccionales, 
los transforma y carga en el modelo dimensional.
"""

import pandas as pd
import pyodbc
from datetime import datetime, timedelta
import logging
import sys
from typing import Dict, List, Optional

# Configuración de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f'etl_log_{datetime.now().strftime("%Y%m%d")}.log'),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)


class ETLDashboardPresencial:
    """Clase principal para el proceso ETL del dashboard"""
    
    def __init__(self, config: Dict[str, str]):
        """
        Inicializa la conexión a las bases de datos
        
        Args:
            config: Diccionario con configuración de conexiones
        """
        self.config = config
        self.conn_source = None
        self.conn_target = None
        
    def conectar_bases_datos(self) -> bool:
        """Establece conexiones a bases de datos de origen y destino"""
        try:
            # Conexión a base transaccional (origen)
            self.conn_source = pyodbc.connect(
                f"DRIVER={{ODBC Driver 17 for SQL Server}};"
                f"SERVER={self.config['source_server']};"
                f"DATABASE={self.config['source_database']};"
                f"UID={self.config['source_user']};"
                f"PWD={self.config['source_password']}"
            )
            logger.info("Conexión exitosa a base de datos origen")
            
            # Conexión a base dimensional (destino)
            self.conn_target = pyodbc.connect(
                f"DRIVER={{ODBC Driver 17 for SQL Server}};"
                f"SERVER={self.config['target_server']};"
                f"DATABASE={self.config['target_database']};"
                f"UID={self.config['target_user']};"
                f"PWD={self.config['target_password']}"
            )
            logger.info("Conexión exitosa a base de datos destino")
            
            return True
            
        except Exception as e:
            logger.error(f"Error al conectar a bases de datos: {str(e)}")
            return False
    
    def extraer_interacciones_nuevas(self, fecha_desde: datetime) -> pd.DataFrame:
        """
        Extrae interacciones presenciales nuevas desde una fecha
        
        Args:
            fecha_desde: Fecha desde la cual extraer datos
            
        Returns:
            DataFrame con interacciones nuevas
        """
        try:
            query = """
                SELECT 
                    i.ID_Interaccion,
                    i.Fecha,
                    i.ID_Agencia,
                    i.ID_Cliente,
                    i.ID_TipoServicio,
                    i.ID_Asesor,
                    i.HoraInicio,
                    i.HoraFin,
                    DATEDIFF(MINUTE, i.HoraInicio, i.HoraFin) AS DuracionMinutos,
                    i.EstadoInteraccion,
                    i.CalificacionServicio,
                    i.TiempoEsperaMinutos AS TiempoCola,
                    i.NumeroTicket
                FROM InteraccionesPresenciales i
                WHERE i.Fecha >= ?
                    AND i.FechaCreacion >= ?
                ORDER BY i.FechaCreacion
            """
            
            df = pd.read_sql(
                query, 
                self.conn_source,
                params=[fecha_desde, fecha_desde]
            )
            
            logger.info(f"Extraídas {len(df)} interacciones nuevas")
            return df
            
        except Exception as e:
            logger.error(f"Error al extraer interacciones: {str(e)}")
            raise
    
    def extraer_cancelaciones_nuevas(self, fecha_desde: datetime) -> pd.DataFrame:
        """
        Extrae cancelaciones nuevas desde una fecha
        
        Args:
            fecha_desde: Fecha desde la cual extraer datos
            
        Returns:
            DataFrame con cancelaciones nuevas
        """
        try:
            query = """
                SELECT 
                    c.ID_Cancelacion,
                    c.Fecha,
                    c.ID_Agencia,
                    c.ID_Cliente,
                    c.MotivoCancelacion,
                    c.TiempoEsperaMinutos AS TiempoEsperaAntesCancelacion,
                    c.HoraCancelacion,
                    c.NumeroTicket
                FROM Cancelaciones c
                WHERE c.Fecha >= ?
                    AND c.FechaCreacion >= ?
                ORDER BY c.FechaCreacion
            """
            
            df = pd.read_sql(
                query,
                self.conn_source,
                params=[fecha_desde, fecha_desde]
            )
            
            logger.info(f"Extraídas {len(df)} cancelaciones nuevas")
            return df
            
        except Exception as e:
            logger.error(f"Error al extraer cancelaciones: {str(e)}")
            raise
    
    def transformar_interacciones(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Aplica transformaciones al DataFrame de interacciones
        
        Args:
            df: DataFrame con datos crudos
            
        Returns:
            DataFrame transformado
        """
        try:
            # Convertir fecha a ID_Fecha formato YYYYMMDD
            df['ID_Fecha'] = pd.to_datetime(df['Fecha']).dt.strftime('%Y%m%d').astype(int)
            
            # Validar duración
            df['DuracionMinutos'] = df['DuracionMinutos'].clip(lower=0, upper=240)
            
            # Validar tiempo en cola
            df['TiempoCola'] = df['TiempoCola'].clip(lower=0, upper=480)
            
            # Validar calificación
            df.loc[~df['CalificacionServicio'].between(1, 5), 'CalificacionServicio'] = None
            
            # Agregar campos de auditoría
            df['FechaCreacion'] = datetime.now()
            df['UsuarioCreacion'] = 'etl_proceso'
            
            logger.info(f"Transformadas {len(df)} interacciones")
            return df
            
        except Exception as e:
            logger.error(f"Error al transformar interacciones: {str(e)}")
            raise
    
    def cargar_interacciones(self, df: pd.DataFrame) -> int:
        """
        Carga interacciones transformadas a la tabla de hechos
        
        Args:
            df: DataFrame con datos transformados
            
        Returns:
            Número de registros cargados
        """
        try:
            cursor = self.conn_target.cursor()
            
            # Preparar query de inserción
            insert_query = """
                INSERT INTO FactInteraccionesPresenciales (
                    ID_Interaccion, ID_Fecha, ID_Agencia, ID_Cliente,
                    ID_TipoServicio, ID_Asesor, HoraInicio, HoraFin,
                    DuracionMinutos, EstadoInteraccion, CalificacionServicio,
                    TiempoCola, NumeroTicket, FechaCreacion, UsuarioCreacion
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """
            
            # Cargar en lotes
            batch_size = 1000
            total_cargados = 0
            
            for i in range(0, len(df), batch_size):
                batch = df.iloc[i:i+batch_size]
                
                # Convertir a lista de tuplas
                values = [tuple(x) for x in batch[[
                    'ID_Interaccion', 'ID_Fecha', 'ID_Agencia', 'ID_Cliente',
                    'ID_TipoServicio', 'ID_Asesor', 'HoraInicio', 'HoraFin',
                    'DuracionMinutos', 'EstadoInteraccion', 'CalificacionServicio',
                    'TiempoCola', 'NumeroTicket', 'FechaCreacion', 'UsuarioCreacion'
                ]].values]
                
                cursor.executemany(insert_query, values)
                total_cargados += len(batch)
                
                if i % 5000 == 0:
                    logger.info(f"Cargados {total_cargados} registros...")
            
            self.conn_target.commit()
            logger.info(f"Total de {total_cargados} interacciones cargadas exitosamente")
            
            return total_cargados
            
        except Exception as e:
            self.conn_target.rollback()
            logger.error(f"Error al cargar interacciones: {str(e)}")
            raise
    
    def cargar_cancelaciones(self, df: pd.DataFrame) -> int:
        """
        Carga cancelaciones transformadas a la tabla de hechos
        
        Args:
            df: DataFrame con datos transformados
            
        Returns:
            Número de registros cargados
        """
        try:
            # Convertir fecha a ID_Fecha
            df['ID_Fecha'] = pd.to_datetime(df['Fecha']).dt.strftime('%Y%m%d').astype(int)
            df['FechaCreacion'] = datetime.now()
            
            cursor = self.conn_target.cursor()
            
            insert_query = """
                INSERT INTO FactCancelaciones (
                    ID_Cancelacion, ID_Fecha, ID_Agencia, ID_Cliente,
                    MotivoCancelacion, TiempoEsperaAntesCancelacion,
                    HoraCancelacion, NumeroTicket, FechaCreacion
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """
            
            values = [tuple(x) for x in df[[
                'ID_Cancelacion', 'ID_Fecha', 'ID_Agencia', 'ID_Cliente',
                'MotivoCancelacion', 'TiempoEsperaAntesCancelacion',
                'HoraCancelacion', 'NumeroTicket', 'FechaCreacion'
            ]].values]
            
            cursor.executemany(insert_query, values)
            self.conn_target.commit()
            
            logger.info(f"Total de {len(df)} cancelaciones cargadas exitosamente")
            return len(df)
            
        except Exception as e:
            self.conn_target.rollback()
            logger.error(f"Error al cargar cancelaciones: {str(e)}")
            raise
    
    def actualizar_dimensiones(self):
        """Actualiza dimensiones con datos nuevos o modificados"""
        try:
            logger.info("Iniciando actualización de dimensiones...")
            
            # Actualizar DimAgencia (SCD Tipo 2)
            self._actualizar_dim_agencia()
            
            # Actualizar DimAsesor (SCD Tipo 2)
            self._actualizar_dim_asesor()
            
            # Actualizar DimCliente (SCD Tipo 1)
            self._actualizar_dim_cliente()
            
            # Actualizar DimTipoServicio (SCD Tipo 1)
            self._actualizar_dim_tipo_servicio()
            
            logger.info("Dimensiones actualizadas exitosamente")
            
        except Exception as e:
            logger.error(f"Error al actualizar dimensiones: {str(e)}")
            raise
    
    def _actualizar_dim_agencia(self):
        """Actualiza dimensión de agencias con SCD Tipo 2"""
        # Implementación de SCD Tipo 2
        logger.info("Actualizando DimAgencia...")
        # TODO: Implementar lógica SCD Tipo 2
        pass
    
    def _actualizar_dim_asesor(self):
        """Actualiza dimensión de asesores con SCD Tipo 2"""
        logger.info("Actualizando DimAsesor...")
        # TODO: Implementar lógica SCD Tipo 2
        pass
    
    def _actualizar_dim_cliente(self):
        """Actualiza dimensión de clientes con SCD Tipo 1"""
        logger.info("Actualizando DimCliente...")
        # TODO: Implementar lógica SCD Tipo 1
        pass
    
    def _actualizar_dim_tipo_servicio(self):
        """Actualiza dimensión de tipos de servicio"""
        logger.info("Actualizando DimTipoServicio...")
        # TODO: Implementar actualización
        pass
    
    def validar_calidad_datos(self, df: pd.DataFrame, tipo: str) -> bool:
        """
        Valida la calidad de los datos antes de cargar
        
        Args:
            df: DataFrame a validar
            tipo: Tipo de datos ('interacciones' o 'cancelaciones')
            
        Returns:
            True si pasa las validaciones, False en caso contrario
        """
        try:
            errores = []
            
            # Validar que no haya duplicados en PK
            if tipo == 'interacciones':
                duplicados = df['ID_Interaccion'].duplicated().sum()
                if duplicados > 0:
                    errores.append(f"Se encontraron {duplicados} IDs duplicados")
            
            # Validar completitud de campos obligatorios
            campos_obligatorios = ['ID_Fecha', 'ID_Agencia', 'ID_Cliente']
            for campo in campos_obligatorios:
                nulos = df[campo].isna().sum()
                if nulos > 0:
                    errores.append(f"Campo {campo} tiene {nulos} valores nulos")
            
            # Validar rangos
            if tipo == 'interacciones':
                fuera_rango = ((df['DuracionMinutos'] < 0) | (df['DuracionMinutos'] > 240)).sum()
                if fuera_rango > 0:
                    errores.append(f"{fuera_rango} registros con duración fuera de rango")
            
            if errores:
                for error in errores:
                    logger.error(f"Error de validación: {error}")
                return False
            
            logger.info(f"Validación de {tipo} exitosa")
            return True
            
        except Exception as e:
            logger.error(f"Error en validación: {str(e)}")
            return False
    
    def ejecutar_etl_incremental(self, dias_atras: int = 1):
        """
        Ejecuta el proceso ETL incremental
        
        Args:
            dias_atras: Número de días hacia atrás para extraer datos
        """
        try:
            logger.info("=" * 60)
            logger.info("INICIANDO PROCESO ETL INCREMENTAL")
            logger.info("=" * 60)
            
            # Conectar a bases de datos
            if not self.conectar_bases_datos():
                raise Exception("No se pudo conectar a las bases de datos")
            
            # Calcular fecha desde
            fecha_desde = datetime.now() - timedelta(days=dias_atras)
            logger.info(f"Extrayendo datos desde: {fecha_desde}")
            
            # Actualizar dimensiones primero
            self.actualizar_dimensiones()
            
            # Procesar interacciones
            logger.info("Procesando interacciones...")
            df_interacciones = self.extraer_interacciones_nuevas(fecha_desde)
            
            if not df_interacciones.empty:
                df_interacciones = self.transformar_interacciones(df_interacciones)
                
                if self.validar_calidad_datos(df_interacciones, 'interacciones'):
                    self.cargar_interacciones(df_interacciones)
                else:
                    logger.warning("Interacciones no pasaron validación, no se cargaron")
            else:
                logger.info("No hay interacciones nuevas para procesar")
            
            # Procesar cancelaciones
            logger.info("Procesando cancelaciones...")
            df_cancelaciones = self.extraer_cancelaciones_nuevas(fecha_desde)
            
            if not df_cancelaciones.empty:
                if self.validar_calidad_datos(df_cancelaciones, 'cancelaciones'):
                    self.cargar_cancelaciones(df_cancelaciones)
                else:
                    logger.warning("Cancelaciones no pasaron validación, no se cargaron")
            else:
                logger.info("No hay cancelaciones nuevas para procesar")
            
            logger.info("=" * 60)
            logger.info("PROCESO ETL COMPLETADO EXITOSAMENTE")
            logger.info("=" * 60)
            
        except Exception as e:
            logger.error(f"Error en proceso ETL: {str(e)}")
            raise
        
        finally:
            # Cerrar conexiones
            if self.conn_source:
                self.conn_source.close()
            if self.conn_target:
                self.conn_target.close()
            logger.info("Conexiones cerradas")


def main():
    """Función principal para ejecutar el ETL"""
    
    # Configuración de conexiones (debería venir de archivo de configuración)
    config = {
        'source_server': 'localhost',
        'source_database': 'DB_Transaccional',
        'source_user': 'etl_user',
        'source_password': 'password',
        'target_server': 'localhost',
        'target_database': 'DW_Seguimiento_Presencial',
        'target_user': 'etl_user',
        'target_password': 'password'
    }
    
    # Crear instancia de ETL
    etl = ETLDashboardPresencial(config)
    
    # Ejecutar proceso incremental (últimos 2 días)
    etl.ejecutar_etl_incremental(dias_atras=2)


if __name__ == "__main__":
    main()
