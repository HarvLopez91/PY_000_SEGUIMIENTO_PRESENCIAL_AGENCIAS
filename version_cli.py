#!/usr/bin/env python3
"""
Script CLI para gestión de versiones del proyecto.
Implementa la política de "fuente única de verdad" en archivo VERSION.

Uso:
    python version_cli.py current        # Muestra versión actual
    python version_cli.py bump patch     # Incrementa PATCH (bug fix)
    python version_cli.py bump minor     # Incrementa MINOR (nueva función compatible)
    python version_cli.py bump major     # Incrementa MAJOR (cambio incompatible)
    python version_cli.py powerbi        # Muestra nombre de archivo Power BI
"""

import sys
import argparse
from pathlib import Path

# Añadir src al path para importar módulos
sys.path.insert(0, str(Path(__file__).parent / "src"))

from versioning import VersionManager


def main():
    """Función principal del CLI de versionado."""
    parser = argparse.ArgumentParser(
        description="Gestión de versiones para Seguimiento Presencial Agencias",
        epilog="""
Ejemplos:
  python version_cli.py current                    # Muestra: 0.1.0
  python version_cli.py bump patch "Fix dashboard" # 0.1.0 → 0.1.1
  python version_cli.py bump minor "Nueva métrica" # 0.1.1 → 0.2.0
  python version_cli.py bump major "Breaking API"  # 0.2.0 → 1.0.0
  python version_cli.py powerbi                    # SEGUIMIENTO_PRESENCIAL_AGENCIAS_V0.1.0.pbix
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    subparsers = parser.add_subparsers(dest='command', help='Comandos disponibles')
    
    # Comando 'current' - mostrar versión actual
    subparsers.add_parser('current', help='Muestra la versión actual (fuente única)')
    
    # Comando 'bump' - incrementar versión
    bump_parser = subparsers.add_parser('bump', help='Incrementa la versión')
    bump_parser.add_argument(
        'type', 
        choices=['patch', 'minor', 'major'],
        help='Tipo de incremento: patch (bug), minor (función compatible), major (incompatible)'
    )
    bump_parser.add_argument(
        'reason', 
        nargs='?', 
        default='',
        help='Descripción del cambio (opcional)'
    )
    
    # Comando 'powerbi' - mostrar nombre de archivo Power BI
    subparsers.add_parser('powerbi', help='Muestra nombre de archivo Power BI con versión')
    
    # Comando 'validate' - validar consistencia
    subparsers.add_parser('validate', help='Valida que no hay versiones hardcodeadas')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    try:
        manager = VersionManager()
        
        if args.command == 'current':
            print(manager.get_current_version())
            
        elif args.command == 'bump':
            old_version = manager.get_current_version()
            new_version = manager.bump_version(args.type, args.reason)
            print(f"✓ Versión actualizada: {old_version} → {new_version}")
            if args.reason:
                print(f"  Razón: {args.reason}")
            print(f"  Tipo: {args.type.upper()}")
            
        elif args.command == 'powerbi':
            print(manager.get_powerbi_version_string())
            
        elif args.command == 'validate':
            is_valid = manager.validate_version_consistency()
            if is_valid:
                print("✓ Consistencia de versiones OK - No hay versiones hardcodeadas")
            else:
                print("✗ Se encontraron versiones hardcodeadas")
                sys.exit(1)
                
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()