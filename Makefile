# Makefile para Seguimiento Presencial Agencias
# Automatiza testing, limpieza y tareas de desarrollo

# Variables
PYTHON = python
TEST_DIR = tests
SRC_DIR = src
DOCS_DIR = docs
TMP_DIR = tmp

# Colores para output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[1;33m
NC = \033[0m # No Color

# Ayuda (comando por defecto)
.PHONY: help
help:
	@echo "$(GREEN)Seguimiento Presencial Agencias - Comandos Make$(NC)"
	@echo ""
	@echo "$(YELLOW)Testing:$(NC)"
	@echo "  test       - Ejecutar todos los tests"
	@echo "  test-v     - Ejecutar tests con output verbose"
	@echo "  coverage   - Ejecutar tests con cobertura"
	@echo ""
	@echo "$(YELLOW)Limpieza:$(NC)"
	@echo "  clean      - Limpiar artefactos de desarrollo"
	@echo "  clean-all  - Limpieza completa (incluye archivos temporales)"
	@echo "  clean-test - Limpiar solo artefactos de testing"
	@echo ""
	@echo "$(YELLOW)Desarrollo:$(NC)"
	@echo "  version    - Mostrar versión actual"
	@echo "  lint       - Verificar código con linting"
	@echo "  format     - Formatear código Python"
	@echo ""
	@echo "$(YELLOW)Documentación:$(NC)"
	@echo "  docs       - Generar documentación"
	@echo "  docs-clean - Limpiar documentación generada"

# Testing
.PHONY: test
test:
	@echo "$(GREEN)Ejecutando tests...$(NC)"
	$(PYTHON) -m pytest $(TEST_DIR) -v

.PHONY: test-v
test-v:
	@echo "$(GREEN)Ejecutando tests (verbose)...$(NC)"
	$(PYTHON) -m pytest $(TEST_DIR) -v -s

.PHONY: coverage
coverage:
	@echo "$(GREEN)Ejecutando tests con cobertura...$(NC)"
	$(PYTHON) -m pytest $(TEST_DIR) --cov=$(SRC_DIR) --cov-report=html --cov-report=term

# Limpieza
.PHONY: clean
clean: clean-test clean-python
	@echo "$(GREEN)Limpieza completada$(NC)"

.PHONY: clean-all
clean-all: clean clean-tmp clean-logs
	@echo "$(GREEN)Limpieza completa realizada$(NC)"

.PHONY: clean-test
clean-test:
	@echo "$(YELLOW)Limpiando artefactos de testing...$(NC)"
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".pytest_cache" -type d -exec rm -rf {} + 2>/dev/null || true
	@rm -rf htmlcov/ 2>/dev/null || true
	@rm -f .coverage 2>/dev/null || true
	@rm -f coverage.xml 2>/dev/null || true

.PHONY: clean-python
clean-python:
	@echo "$(YELLOW)Limpiando archivos Python...$(NC)"
	@find . -name "*.py[co]" -delete 2>/dev/null || true
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@rm -rf build/ 2>/dev/null || true
	@rm -rf dist/ 2>/dev/null || true
	@rm -rf *.egg-info/ 2>/dev/null || true

.PHONY: clean-tmp
clean-tmp:
	@echo "$(YELLOW)Limpiando archivos temporales...$(NC)"
	@rm -rf $(TMP_DIR)/* 2>/dev/null || true
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.bak" -delete 2>/dev/null || true
	@find . -name "*~" -delete 2>/dev/null || true

.PHONY: clean-logs
clean-logs:
	@echo "$(YELLOW)Limpiando logs...$(NC)"
	@find . -name "*.log" -delete 2>/dev/null || true
	@rm -rf logs/ 2>/dev/null || true

# Desarrollo
.PHONY: version
version:
	@echo "$(GREEN)Versión actual:$(NC)"
	@$(PYTHON) version_cli.py current

.PHONY: lint
lint:
	@echo "$(GREEN)Verificando código...$(NC)"
	@$(PYTHON) -m flake8 $(SRC_DIR) --max-line-length=100 --ignore=E501,W503 || true
	@$(PYTHON) -m pylint $(SRC_DIR) --disable=C0114,C0115,C0116 || true

.PHONY: format
format:
	@echo "$(GREEN)Formateando código Python...$(NC)"
	@$(PYTHON) -m black $(SRC_DIR) --line-length=100 || echo "$(YELLOW)Black no instalado - instalar con: pip install black$(NC)"

# Documentación
.PHONY: docs
docs:
	@echo "$(GREEN)Generando documentación...$(NC)"
	@mkdir -p $(DOCS_DIR)/generated
	@$(PYTHON) -c "
import sys
sys.path.insert(0, '$(SRC_DIR)')
from versioning import VersionManager
vm = VersionManager()
print(f'# Documentación Auto-generada\\n\\nVersión: {vm.get_current_version()}')
" > $(DOCS_DIR)/generated/version_info.md

.PHONY: docs-clean
docs-clean:
	@echo "$(YELLOW)Limpiando documentación generada...$(NC)"
	@rm -rf $(DOCS_DIR)/generated/ 2>/dev/null || true

# Instalación de dependencias de desarrollo
.PHONY: install-dev
install-dev:
	@echo "$(GREEN)Instalando dependencias de desarrollo...$(NC)"
	@$(PYTHON) -m pip install pytest pytest-cov flake8 pylint black

# Verificación completa del proyecto
.PHONY: check
check: test lint
	@echo "$(GREEN)Verificación completa del proyecto finalizada$(NC)"

# Preparar para producción
.PHONY: prepare-prod
prepare-prod: clean-all test
	@echo "$(GREEN)Proyecto preparado para producción$(NC)"
	@$(PYTHON) version_cli.py powerbi
	@$(PYTHON) update_versions.py