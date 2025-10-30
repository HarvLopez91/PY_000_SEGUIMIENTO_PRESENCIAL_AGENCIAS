"""
Tests para el sistema de versionado.
Valida el correcto funcionamiento de todas las funcionalidades de versionado.
"""

import unittest
import tempfile
import shutil
from pathlib import Path
import sys

# Añadir src al path para imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from versioning import SemanticVersion, VersionManager, get_version


class TestSemanticVersion(unittest.TestCase):
    """Tests para la clase SemanticVersion."""
    
    def test_version_parsing(self):
        """Test de parseo de versiones válidas."""
        version = SemanticVersion("1.2.3")
        self.assertEqual(version.major, 1)
        self.assertEqual(version.minor, 2)
        self.assertEqual(version.patch, 3)
        self.assertEqual(str(version), "1.2.3")
    
    def test_invalid_version_format(self):
        """Test de rechazo de formatos inválidos."""
        with self.assertRaises(ValueError):
            SemanticVersion("1.2")  # Falta patch
        
        with self.assertRaises(ValueError):
            SemanticVersion("1.2.3.4")  # Muy largo
        
        with self.assertRaises(ValueError):
            SemanticVersion("v1.2.3")  # Prefijo inválido
    
    def test_version_increments(self):
        """Test de incrementos de versión."""
        version = SemanticVersion("1.2.3")
        
        # Test patch increment
        patch_bump = version.bump_patch()
        self.assertEqual(str(patch_bump), "1.2.4")
        
        # Test minor increment
        minor_bump = version.bump_minor()
        self.assertEqual(str(minor_bump), "1.3.0")
        
        # Test major increment
        major_bump = version.bump_major()
        self.assertEqual(str(major_bump), "2.0.0")


class TestVersionManager(unittest.TestCase):
    """Tests para la clase VersionManager."""
    
    def setUp(self):
        """Configurar entorno de prueba temporal."""
        self.test_dir = tempfile.mkdtemp()
        self.version_file = Path(self.test_dir) / "VERSION"
        self.version_file.write_text("0.1.0")
        self.manager = VersionManager(Path(self.test_dir))
    
    def tearDown(self):
        """Limpiar entorno de prueba."""
        shutil.rmtree(self.test_dir)
    
    def test_get_current_version(self):
        """Test de lectura de versión actual."""
        version = self.manager.get_current_version()
        self.assertEqual(str(version), "0.1.0")
    
    def test_set_version(self):
        """Test de escritura de versión."""
        new_version = SemanticVersion("2.0.0")
        self.manager.set_version(new_version)
        
        # Verificar que se escribió correctamente
        content = self.version_file.read_text().strip()
        self.assertEqual(content, "2.0.0")
    
    def test_bump_version(self):
        """Test de incremento automático de versión."""
        # Test patch bump
        new_version = self.manager.bump_version("patch", "Fix test")
        self.assertEqual(str(new_version), "0.1.1")
        
        # Verificar que se escribió en el archivo
        content = self.version_file.read_text().strip()
        self.assertEqual(content, "0.1.1")
    
    def test_powerbi_version_string(self):
        """Test de generación de nombres Power BI."""
        powerbi_name = self.manager.get_powerbi_version_string()
        self.assertEqual(powerbi_name, "SEGUIMIENTO_PRESENCIAL_AGENCIAS_V0.1.0.pbix")
    
    def test_missing_version_file(self):
        """Test de manejo de archivo VERSION faltante."""
        # Crear manager con directorio sin archivo VERSION
        empty_dir = tempfile.mkdtemp()
        try:
            manager = VersionManager(Path(empty_dir))
            with self.assertRaises(FileNotFoundError):
                manager.get_current_version()
        finally:
            shutil.rmtree(empty_dir)


class TestVersioningFunctions(unittest.TestCase):
    """Tests para funciones de conveniencia."""
    
    def test_get_version_function(self):
        """Test de función get_version."""
        # Esta función lee del archivo VERSION real del proyecto
        version = get_version()
        self.assertIsInstance(version, str)
        self.assertRegex(version, r'^\d+\.\d+\.\d+$')


if __name__ == '__main__':
    unittest.main()