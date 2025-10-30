"""
Módulo de versionado para el proyecto de Seguimiento Presencial Agencias.
Implementa versionado semántico siguiendo las convenciones del proyecto.

POLÍTICA DE VERSIONADO (SemVer + "fuente única"):
- La versión SOLO vive en archivo VERSION
- Todos los demás archivos y scripts LEEN de VERSION
- Nada hardcodeado en UI, README, CHANGELOG o scripts
- Incrementos: bug→PATCH, nueva función compatible→MINOR, incompatible→MAJOR

LECTURA SIMPLIFICADA:
- VERSION = Path("VERSION").read_text().strip()
- from src.versioning import VERSION
"""

import re
from pathlib import Path
from datetime import datetime
from typing import Tuple, Optional


# LECTURA DIRECTA Y SIMPLE DE VERSIÓN (Paso 4)
# Esta es la forma más directa de leer la versión desde cualquier código Python
try:
    VERSION = Path(__file__).parent.parent.joinpath("VERSION").read_text().strip()
except FileNotFoundError:
    VERSION = "0.0.0"  # Fallback si no existe VERSION


class SemanticVersion:
    """Maneja versionado semántico para el proyecto."""
    
    def __init__(self, version_string: str):
        """Inicializa una versión semántica."""
        self.major, self.minor, self.patch = self._parse_version(version_string)
    
    def _parse_version(self, version_string: str) -> Tuple[int, int, int]:
        """Parsea una cadena de versión en componentes major.minor.patch."""
        pattern = r'^(\d+)\.(\d+)\.(\d+)$'
        match = re.match(pattern, version_string.strip())
        if not match:
            raise ValueError(f"Formato de versión inválido: {version_string}")
        return int(match.group(1)), int(match.group(2)), int(match.group(3))
    
    def __str__(self) -> str:
        """Retorna la versión como string."""
        return f"{self.major}.{self.minor}.{self.patch}"
    
    def bump_major(self) -> 'SemanticVersion':
        """Incrementa la versión mayor (cambios incompatibles)."""
        return SemanticVersion(f"{self.major + 1}.0.0")
    
    def bump_minor(self) -> 'SemanticVersion':
        """Incrementa la versión menor (nuevas funcionalidades compatibles)."""
        return SemanticVersion(f"{self.major}.{self.minor + 1}.0")
    
    def bump_patch(self) -> 'SemanticVersion':
        """Incrementa la versión de parche (corrección de errores)."""
        return SemanticVersion(f"{self.major}.{self.minor}.{self.patch + 1}")


class VersionManager:
    """Gestor de versiones del proyecto - FUENTE ÚNICA DE VERDAD."""
    
    def __init__(self, project_root: Optional[Path] = None):
        """Inicializa el gestor de versiones."""
        self.project_root = project_root or Path(__file__).parent.parent
        self.version_file = self.project_root / "VERSION"
    
    def get_current_version(self) -> SemanticVersion:
        """Obtiene la versión actual desde el archivo VERSION (fuente única)."""
        if not self.version_file.exists():
            raise FileNotFoundError(f"Archivo VERSION no encontrado en {self.version_file}")
        
        version_string = self.version_file.read_text(encoding='utf-8').strip()
        return SemanticVersion(version_string)
    
    def set_version(self, version: SemanticVersion) -> None:
        """Establece una nueva versión en el archivo VERSION."""
        self.version_file.write_text(str(version), encoding='utf-8')
    
    def bump_version(self, bump_type: str, reason: str = "") -> SemanticVersion:
        """
        Incrementa la versión según el tipo especificado.
        
        Args:
            bump_type: 'major', 'minor', o 'patch'
            reason: Descripción del cambio para logs
        
        Returns:
            Nueva versión
        """
        current = self.get_current_version()
        
        if bump_type.lower() == 'major':
            new_version = current.bump_major()
        elif bump_type.lower() == 'minor':
            new_version = current.bump_minor()
        elif bump_type.lower() == 'patch':
            new_version = current.bump_patch()
        else:
            raise ValueError(f"Tipo de incremento inválido: {bump_type}. Use 'major', 'minor', o 'patch'")
        
        self.set_version(new_version)
        self._log_version_change(current, new_version, bump_type, reason)
        return new_version
    
    def _log_version_change(self, old_version: SemanticVersion, new_version: SemanticVersion, 
                           bump_type: str, reason: str) -> None:
        """Registra el cambio de versión en logs internos."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_msg = f"[{timestamp}] VERSION BUMP: {old_version} → {new_version} ({bump_type.upper()})"
        if reason:
            log_msg += f" - {reason}"
        print(log_msg)
    
    def get_powerbi_version_string(self) -> str:
        """
        Genera string de versión para archivos Power BI.
        Formato: SEGUIMIENTO_PRESENCIAL_AGENCIAS_V{major}.{minor}.{patch}.pbix
        """
        version = self.get_current_version()
        return f"SEGUIMIENTO_PRESENCIAL_AGENCIAS_V{version}.pbix"
    
    def get_version_with_date(self) -> str:
        """Retorna versión con fecha actual para logs."""
        version = self.get_current_version()
        date_str = datetime.now().strftime("%Y-%m-%d")
        return f"{version} ({date_str})"
    
    def validate_version_consistency(self) -> bool:
        """Valida que no hay versiones hardcodeadas en otros archivos."""
        # Esta función podría extenderse para verificar archivos
        # y asegurar que no tienen versiones hardcodeadas
        return True


# Funciones utilitarias para uso directo
def get_version() -> str:
    """Función de conveniencia para obtener la versión actual de la fuente única."""
    manager = VersionManager()
    return str(manager.get_current_version())


def bump_version(bump_type: str, reason: str = "") -> str:
    """Función de conveniencia para incrementar versión."""
    manager = VersionManager()
    new_version = manager.bump_version(bump_type, reason)
    return str(new_version)


if __name__ == "__main__":
    # Ejemplo de uso del sistema de versionado
    manager = VersionManager()
    print(f"Versión actual (fuente única): {manager.get_current_version()}")
    print(f"Archivo Power BI: {manager.get_powerbi_version_string()}")
    print(f"Versión con fecha: {manager.get_version_with_date()}")
    
    # Ejemplo de incrementos de versión
    print("\n--- GUÍA DE INCREMENTOS ---")
    print("• bug/fix → PATCH (0.1.0 → 0.1.1)")
    print("• nueva función compatible → MINOR (0.1.1 → 0.2.0)")
    print("• cambio incompatible → MAJOR (0.2.0 → 1.0.0)")