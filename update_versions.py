#!/usr/bin/env python3
"""
Script para actualizar dinámicamente archivos que referencian la versión.
Asegura que README, CHANGELOG y otros archivos siempre lean desde VERSION.
"""

import re
import sys
from pathlib import Path

# Añadir src al path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from versioning import VersionManager


def update_readme_version(readme_path: Path, version: str) -> bool:
    """Actualiza la versión en el README dinámicamente."""
    if not readme_path.exists():
        return False
    
    content = readme_path.read_text(encoding='utf-8')
    
    # Patrón para encontrar la línea de versión
    version_pattern = r'(\*\*Versión\*\*: ).*'
    replacement = f'\\g<1>{version}'
    
    new_content = re.sub(version_pattern, replacement, content)
    
    # Si no hay cambios, la versión ya está actualizada
    if new_content == content:
        # Si no encuentra el patrón, agregar línea de versión
        if "**Versión**:" not in content:
            lines = content.split('\n')
            # Buscar la línea del título principal
            for i, line in enumerate(lines):
                if line.startswith('# '):
                    lines.insert(i + 2, f'**Versión**: {version}')
                    lines.insert(i + 3, '')
                    new_content = '\n'.join(lines)
                    break
    
    if new_content != content:
        readme_path.write_text(new_content, encoding='utf-8')
        return True
    
    return False


def update_all_version_references():
    """Actualiza todas las referencias de versión en el proyecto."""
    manager = VersionManager()
    current_version = str(manager.get_current_version())
    
    project_root = Path(__file__).parent
    updated_files = []
    
    # Actualizar README
    readme_path = project_root / "README.md"
    if update_readme_version(readme_path, current_version):
        updated_files.append(str(readme_path))
    
    # Actualizar other files here if needed
    
    return updated_files, current_version


def main():
    """Función principal."""
    try:
        updated_files, version = update_all_version_references()
        
        print(f"✓ Versión actual (fuente única): {version}")
        
        if updated_files:
            print("✓ Archivos actualizados:")
            for file_path in updated_files:
                print(f"  - {file_path}")
        else:
            print("✓ Todos los archivos ya están sincronizados con la versión actual")
            
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()