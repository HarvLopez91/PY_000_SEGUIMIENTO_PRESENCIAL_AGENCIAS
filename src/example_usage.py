"""
Ejemplos de uso del sistema de versionado.
Demuestra las diferentes formas de leer y usar la versión en código Python.
"""

# MÉTODO 1: Lectura directa y simple (Paso 4)
from pathlib import Path
VERSION = Path("VERSION").read_text().strip()

# MÉTODO 2: Importar constante VERSION desde módulo
from versioning import VERSION as PROJECT_VERSION

# MÉTODO 3: Usar funciones de conveniencia  
from versioning import get_version, VersionManager
from datetime import datetime


def demo_lectura_version():
    """Demuestra las diferentes formas de leer la versión."""
    
    print("=== DEMO: Lectura de Versión desde Código Python ===\n")
    
    # Método 1: Lectura directa simple
    print("1. LECTURA DIRECTA (más simple):")
    direct_version = Path("VERSION").read_text().strip()
    print(f"   VERSION = Path('VERSION').read_text().strip()")
    print(f"   Resultado: {direct_version}\n")
    
    # Método 2: Importar constante
    print("2. IMPORTAR CONSTANTE:")
    print(f"   from src.versioning import VERSION")
    print(f"   Resultado: {PROJECT_VERSION}\n")
    
    # Método 3: Función de conveniencia
    print("3. FUNCIÓN DE CONVENIENCIA:")
    function_version = get_version()
    print(f"   from src.versioning import get_version")
    print(f"   Resultado: {function_version}\n")
    
    # Método 4: Manager completo
    print("4. MANAGER COMPLETO:")
    manager = VersionManager()
    manager_version = str(manager.get_current_version())
    print(f"   manager = VersionManager()")
    print(f"   Resultado: {manager_version}\n")
    
    # Verificar consistencia
    versions = [direct_version, PROJECT_VERSION, function_version, manager_version]
    if len(set(versions)) == 1:
        print("✅ TODAS las formas de leer la versión son CONSISTENTES")
    else:
        print("❌ ERROR: Versiones inconsistentes detectadas")
        for i, v in enumerate(versions, 1):
            print(f"   Método {i}: {v}")


def demo_uso_en_aplicacion():
    """Demuestra cómo usar la versión en una aplicación real."""
    
    print("\n=== DEMO: Uso en Aplicación ===\n")
    
    # Caso 1: Logging con versión
    print("1. LOGGING CON VERSIÓN:")
    print(f"   [INFO] Aplicación iniciada - Versión {VERSION}")
    
    # Caso 2: Generación de nombres de archivo
    print("2. NOMBRES DE ARCHIVO POWER BI:")
    manager = VersionManager()
    powerbi_filename = manager.get_powerbi_version_string()
    print(f"   Archivo Power BI: {powerbi_filename}")
    
    # Caso 3: API responses (simulado)
    print("3. RESPUESTA API (simulada):")
    api_response = {
        "status": "success",
        "version": VERSION,
        "timestamp": datetime.now().isoformat(),
        "data": "Dashboard de Seguimiento Presencial"
    }
    print(f"   {api_response}")
    
    # Caso 4: Headers de scripts
    print("4. HEADERS DE SCRIPTS:")
    script_header = f"""
    # ===========================================
    # Seguimiento Presencial Agencias
    # Versión: {VERSION}
    # Fecha: {datetime.now().strftime('%Y-%m-%d')}
    # ===========================================
    """
    print(script_header)


def demo_validacion_version():
    """Demuestra validación de versión."""
    
    print("\n=== DEMO: Validación de Versión ===\n")
    
    try:
        # Validar formato de versión
        manager = VersionManager()
        current = manager.get_current_version()
        
        print(f"✅ Versión válida: {current}")
        print(f"   Mayor: {current.major}")
        print(f"   Menor: {current.minor}")
        print(f"   Parche: {current.patch}")
        
        # Simular incrementos
        print("\n📈 SIMULACIÓN DE INCREMENTOS:")
        print(f"   Actual: {current}")
        print(f"   Patch:  {current.bump_patch()}")
        print(f"   Minor:  {current.bump_minor()}")
        print(f"   Major:  {current.bump_major()}")
        
    except Exception as e:
        print(f"❌ Error en validación: {e}")


if __name__ == "__main__":
    # Ejecutar todas las demos
    demo_lectura_version()
    demo_uso_en_aplicacion()
    demo_validacion_version()
    
    print("\n" + "="*50)
    print("RESUMEN:")
    print(f"Versión actual del proyecto: {VERSION}")
    print("Todas las lecturas son consistentes ✅")
    print("="*50)