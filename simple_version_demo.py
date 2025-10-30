#!/usr/bin/env python3
"""
Ejemplo simple de lectura de versión desde código Python (Paso 4).
Este es el patrón más directo y recomendado para la mayoría de casos.
"""

from pathlib import Path

# PATRÓN SIMPLE Y DIRECTO (Paso 4)
VERSION = Path("VERSION").read_text().strip()

def main():
    """Ejemplo de uso de la versión en código Python."""
    
    print(f"Seguimiento Presencial Agencias v{VERSION}")
    print("="*50)
    
    # Ejemplo 1: Usar en logs
    print(f"[INFO] Sistema iniciado - Versión {VERSION}")
    
    # Ejemplo 2: Generar nombres de archivo
    powerbi_file = f"SEGUIMIENTO_PRESENCIAL_AGENCIAS_V{VERSION}.pbix"
    print(f"[INFO] Archivo Power BI: {powerbi_file}")
    
    # Ejemplo 3: Incluir en metadatos
    metadata = {
        "project": "Seguimiento Presencial Agencias",
        "version": VERSION,
        "description": "Dashboard BI para Centro de Gestión del Cliente"
    }
    print(f"[INFO] Metadatos: {metadata}")
    
    # Ejemplo 4: Headers para scripts
    header = f"""
    #!/usr/bin/env python3
    # Seguimiento Presencial Agencias - Versión {VERSION}
    # Centro de Gestión del Cliente - La Ascensión S.A.
    """
    print(f"[INFO] Header para scripts:{header}")

if __name__ == "__main__":
    main()