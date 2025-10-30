# Configuración del Dashboard Power BI
# Dashboard Seguimiento Presencial Agencias - La Ascensión S.A.

# Información General del Dashboard
DASHBOARD_INFO = {
    "nombre": "Seguimiento Presencial Agencias",
    "version": "1.0.0",
    "empresa": "La Ascensión S.A.",
    "departamento": "Centro de Gestión del Cliente",
    "descripcion": "Dashboard de Business Intelligence para seguimiento de interacciones presenciales",
    "fecha_creacion": "2023-10-30",
    "ultima_actualizacion": "2023-10-30"
}

# Configuración de Conexiones a Datos
DATA_SOURCES = {
    "base_datos_principal": {
        "tipo": "SQL Server",
        "servidor": "sql-server-produccion.laascension.local",
        "base_datos": "DW_Seguimiento_Presencial",
        "puerto": 1433,
        "autenticacion": "Windows",
        "metodo_actualizacion": "DirectQuery/Import",
        "descripcion": "Base de datos dimensional principal del dashboard"
    },
    "base_datos_backup": {
        "tipo": "SQL Server",
        "servidor": "sql-server-dr.laascension.local",
        "base_datos": "DW_Seguimiento_Presencial_DR",
        "puerto": 1433,
        "autenticacion": "Windows",
        "descripcion": "Base de datos de respaldo para disaster recovery"
    }
}

# Configuración de Actualización de Datos
REFRESH_SETTINGS = {
    "modo_principal": "Import",  # Import o DirectQuery
    "frecuencia_actualizacion": "30 minutos",
    "horarios_actualizacion": [
        "00:00", "00:30", "01:00", "01:30", "02:00", "02:30",
        "03:00", "03:30", "04:00", "04:30", "05:00", "05:30",
        "06:00", "06:30", "07:00", "07:30", "08:00", "08:30",
        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
        "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
        "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
        "21:00", "21:30", "22:00", "22:30", "23:00", "23:30"
    ],
    "actualizacion_incremental": True,
    "ventana_incremental_dias": 30,
    "retencion_historica_meses": 24,
    "timeout_actualizacion_minutos": 60
}

# Configuración de Páginas del Dashboard
DASHBOARD_PAGES = {
    "pagina_1": {
        "nombre": "Vista General",
        "descripcion": "Resumen ejecutivo con KPIs principales",
        "orden": 1,
        "visibilidad": "Todos los usuarios",
        "visualizaciones": [
            "KPI Total Interacciones",
            "KPI Tasa Completación",
            "KPI Satisfacción Promedio",
            "KPI Tasa Cancelación",
            "Gráfico Tendencia Diaria",
            "Top 5 Agencias",
            "Distribución por Tipo Servicio"
        ]
    },
    "pagina_2": {
        "nombre": "Análisis de Atención",
        "descripcion": "Análisis detallado del proceso de atención",
        "orden": 2,
        "visibilidad": "Todos los usuarios",
        "visualizaciones": [
            "Tiempo Promedio por Servicio",
            "Tiempo en Cola por Hora",
            "Distribución Horaria",
            "Capacidad Utilizada",
            "Análisis Duración por Agencia"
        ]
    },
    "pagina_3": {
        "nombre": "Análisis de Cancelaciones",
        "descripcion": "Análisis de patrones de cancelaciones",
        "orden": 3,
        "visibilidad": "Gerentes y superiores",
        "visualizaciones": [
            "Tasa Cancelación por Agencia",
            "Motivos de Cancelación",
            "Tiempo Antes de Cancelar",
            "Tendencia Temporal",
            "Distribución Semanal"
        ]
    },
    "pagina_4": {
        "nombre": "Rendimiento de Agencias",
        "descripcion": "Comparativo de desempeño entre agencias",
        "orden": 4,
        "visibilidad": "Gerentes regionales y superiores",
        "visualizaciones": [
            "Ranking por Satisfacción",
            "Productividad por Agencia",
            "Mapa Geográfico",
            "Matriz Volumen-Satisfacción",
            "Tendencias por Agencia"
        ]
    },
    "pagina_5": {
        "nombre": "Análisis de Asesores",
        "descripcion": "Rendimiento individual de asesores",
        "orden": 5,
        "visibilidad": "Gerentes de agencia y RRHH",
        "visualizaciones": [
            "Productividad Individual",
            "Calificación Promedio",
            "Carga de Trabajo",
            "Top Performers",
            "Comparativo Tiempos"
        ]
    },
    "pagina_6": {
        "nombre": "Análisis Temporal",
        "descripcion": "Identificación de patrones temporales",
        "orden": 6,
        "visibilidad": "Todos los usuarios",
        "visualizaciones": [
            "Análisis Estacionalidad",
            "Comparativo Año sobre Año",
            "Tendencias Trimestrales",
            "Días Atípicos",
            "Proyección Demanda"
        ]
    }
}

# Configuración de Seguridad y Row-Level Security
SECURITY_CONFIG = {
    "rls_habilitado": True,
    "roles": {
        "Administrador": {
            "filtro_rls": "1=1",  # Sin restricciones
            "descripcion": "Acceso completo a todos los datos",
            "permisos": ["Ver", "Editar", "Compartir", "Exportar"]
        },
        "Gerente_Regional": {
            "filtro_rls": "DimAgencia[Region] = USERPRINCIPALNAME()",
            "descripcion": "Acceso limitado a su región",
            "permisos": ["Ver", "Exportar"]
        },
        "Gerente_Agencia": {
            "filtro_rls": "DimAgencia[CodigoAgencia] = USERPRINCIPALNAME()",
            "descripcion": "Acceso limitado a su agencia",
            "permisos": ["Ver"]
        },
        "Analista": {
            "filtro_rls": "1=1",
            "descripcion": "Acceso completo solo lectura",
            "permisos": ["Ver"]
        }
    },
    "autenticacion": "Azure AD",
    "mfa_requerido": True
}

# Configuración de Métricas y KPIs
KPIS_CONFIG = {
    "total_interacciones": {
        "nombre": "Total Interacciones",
        "medida_dax": "TotalInteracciones",
        "formato": "#,##0",
        "icono": "👥",
        "meta": None,
        "descripcion": "Total de interacciones presenciales en el período"
    },
    "tasa_completacion": {
        "nombre": "Tasa de Completación",
        "medida_dax": "TasaCompletacion",
        "formato": "0.0%",
        "icono": "✓",
        "meta": 0.95,
        "umbral_verde": 0.95,
        "umbral_amarillo": 0.85,
        "descripcion": "Porcentaje de interacciones completadas exitosamente"
    },
    "satisfaccion_promedio": {
        "nombre": "Satisfacción Promedio",
        "medida_dax": "SatisfaccionPromedio",
        "formato": "0.00",
        "icono": "⭐",
        "meta": 4.0,
        "umbral_verde": 4.0,
        "umbral_amarillo": 3.5,
        "descripcion": "Calificación promedio otorgada por clientes"
    },
    "tasa_cancelacion": {
        "nombre": "Tasa de Cancelación",
        "medida_dax": "TasaCancelacion",
        "formato": "0.0%",
        "icono": "✗",
        "meta": 0.10,
        "umbral_verde": 0.05,
        "umbral_amarillo": 0.15,
        "descripcion": "Porcentaje de clientes que abandonan sin atención"
    },
    "tiempo_promedio_atencion": {
        "nombre": "Tiempo Promedio de Atención",
        "medida_dax": "PromedioTiempoAtencion",
        "formato": "0.0",
        "unidad": "min",
        "icono": "⏱",
        "meta": 20.0,
        "descripcion": "Tiempo promedio de atención en minutos"
    },
    "tiempo_promedio_cola": {
        "nombre": "Tiempo Promedio en Cola",
        "medida_dax": "PromedioTiempoCola",
        "formato": "0.0",
        "unidad": "min",
        "icono": "⏳",
        "meta": 15.0,
        "umbral_verde": 10.0,
        "umbral_amarillo": 20.0,
        "descripcion": "Tiempo promedio de espera en cola"
    }
}

# Paleta de Colores del Dashboard
COLOR_PALETTE = {
    "colores_principales": {
        "azul_corporativo": "#003366",
        "azul_claro": "#0066CC",
        "verde": "#28A745",
        "amarillo": "#FFC107",
        "rojo": "#DC3545",
        "gris": "#6C757D"
    },
    "colores_secundarios": {
        "azul_pastel": "#E3F2FD",
        "verde_pastel": "#E8F5E9",
        "amarillo_pastel": "#FFF9E6",
        "rojo_pastel": "#FFEBEE",
        "gris_claro": "#F8F9FA"
    },
    "gradientes": {
        "performance": ["#DC3545", "#FFC107", "#28A745"],  # Rojo -> Amarillo -> Verde
        "heat_map": ["#FFFFFF", "#0066CC", "#003366"]  # Blanco -> Azul claro -> Azul oscuro
    }
}

# Configuración de Exportación y Compartición
EXPORT_SETTINGS = {
    "formatos_permitidos": ["PDF", "PowerPoint", "Excel", "Imagen"],
    "limite_exportacion_filas": 150000,
    "permitir_datos_subyacentes": True,
    "marca_agua": "Confidencial - La Ascensión S.A.",
    "incluir_filtros_aplicados": True
}

# Configuración de Alertas y Notificaciones
ALERTS_CONFIG = {
    "alertas_habilitadas": True,
    "alertas_disponibles": {
        "tasa_cancelacion_alta": {
            "condicion": "TasaCancelacion > 0.15",
            "destinatarios": ["gerencia.regional@laascension.com"],
            "frecuencia": "Inmediata",
            "mensaje": "La tasa de cancelación ha superado el 15%"
        },
        "satisfaccion_baja": {
            "condicion": "SatisfaccionPromedio < 3.5",
            "destinatarios": ["calidad.servicio@laascension.com"],
            "frecuencia": "Diaria",
            "mensaje": "La satisfacción promedio está por debajo de 3.5"
        },
        "tiempo_espera_alto": {
            "condicion": "PromedioTiempoCola > 25",
            "destinatarios": ["operaciones@laascension.com"],
            "frecuencia": "Inmediata",
            "mensaje": "El tiempo promedio en cola supera los 25 minutos"
        }
    }
}

# Configuración de Optimización del Modelo
OPTIMIZATION_CONFIG = {
    "compresion_habilitada": True,
    "agregaciones_automaticas": True,
    "cache_habilitado": True,
    "particionamiento": {
        "habilitado": True,
        "tabla": "FactInteraccionesPresenciales",
        "columna_particion": "ID_Fecha",
        "granularidad": "Mensual"
    },
    "eliminacion_columnas_no_usadas": True,
    "reduccion_precision_decimales": True
}

# Configuración de Monitoreo y Logs
MONITORING_CONFIG = {
    "logs_habilitados": True,
    "nivel_log": "INFO",
    "metricas_rendimiento": {
        "tiempo_actualizacion_max": 60,  # minutos
        "tiempo_respuesta_visual_max": 5,  # segundos
        "tamanio_modelo_max_mb": 2048,
        "uso_memoria_max_mb": 4096
    },
    "alertas_rendimiento": True,
    "dashboard_url_monitoreo": "https://monitoring.laascension.com/powerbi"
}

# Configuración de Documentación
DOCUMENTATION_CONFIG = {
    "ubicacion_docs": "/docs",
    "archivos": {
        "documentacion_tecnica": "TECHNICAL_DOCUMENTATION.md",
        "guia_usuario": "USER_GUIDE.md",
        "diccionario_datos": "DATA_DICTIONARY.md"
    },
    "version_documentacion": "1.0.0",
    "ultima_revision": "2023-10-30"
}

# Configuración de Soporte
SUPPORT_CONFIG = {
    "email_soporte": "soporte.bi@laascension.com",
    "telefono_soporte": "+XXX-XXX-XXXX ext. 1234",
    "horario_soporte": "Lunes a Viernes, 8:00 AM - 6:00 PM",
    "portal_tickets": "https://soporte.laascension.com",
    "sla_respuesta_horas": 4,
    "sla_resolucion_horas": 24
}
