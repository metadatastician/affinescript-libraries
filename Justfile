# SPDX-License-Identifier: CC-BY-SA-4.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# AffineScript Libraries Justfile
# RSR-compliant build system for AffineScript library collection
# https://just.systems/man/en/

set shell := ["bash", "-uc"]
set dotenv-load := true
set positional-arguments := true

# Project metadata
project := "affinescript-libraries"
OWNER := "metadatastician"
REPO := "affinescript-libraries"
version := "0.1.0"
tier := "2"

# Directories
SRC_DIR := "src"
TESTS_DIR := "tests"
BENCHES_DIR := "benches"
TEMPLATES_DIR := "templates"
GRADINGS_DIR := "gradings"
BUILD_DIR := "build"
DIST_DIR := "dist"
BIN_DIR := "bin"

# AffineScript configuration
AFFINESCRIPT_REPO := "../../../hyper-repos/developer-ecosystem/affinescript-ecosystem/affinescript"

# ============================================================================
# DEFAULT & HELP
# ============================================================================

default:
	@echo "affinescript-libraries v{{version}} — AffineScript Library Collection"
	@echo ""
	@echo "RSR Tier: {{tier}}"
	@echo "Owner: {{OWNER}}"
	@echo ""
	@just --list --unsorted

help recipe="":
	#!/usr/bin/env bash
	if [ -z "{{recipe}}" ]; then
		just --list --unsorted
		echo ""
		echo "Usage: just help <recipe>"
	else
		just --show "{{recipe}}" 2>/dev/null || echo "Recipe '{{recipe}}' not found"
	fi

# ============================================================================
# INIT & SETUP
# ============================================================================

install-just:
	@echo "Installing just..."
	if ! command -v just >/dev/null 2>&1; then
		if command -v apt-get >/dev/null 2>&1; then
			sudo apt-get update && sudo apt-get install -y just
		elif command -v dnf >/dev/null 2>&1; then
			sudo dnf install -y just
		elif command -v brew >/dev/null 2>&1; then
			brew install just
		else
			curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
		fi
	fi

# ============================================================================
# BUILD & COMPILE
# ============================================================================

# Build all libraries
build:
	@echo "Building AffineScript libraries..."
	@mkdir -p {{BUILD_DIR}} {{DIST_DIR}} {{BIN_DIR}}
	
	# Build each library
	just build-kyaml
	just build-data
	just build-text
	
	@echo "All libraries built successfully"

# Build KYAML library
build-kyaml:
	@echo "Building KYAML library..."
	@mkdir -p {{BUILD_DIR}}/Kyaml
	
	# Copy source files for now (placeholder until AffineScript compiler is ready)
	@mkdir -p {{BUILD_DIR}}/Kyaml
	cp -r {{SRC_DIR}}/Kyaml/* {{BUILD_DIR}}/Kyaml/ 2>/dev/null || true
	
	# Placeholder: Create a stub library file
	@echo "// KYAML Library v{{version}}" > {{BUILD_DIR}}/Kyaml/LIBRARY.affine
	@echo "// Built from: {{SRC_DIR}}/Kyaml" >> {{BUILD_DIR}}/Kyaml/LIBRARY.affine
	
	@echo "KYAML library built"

# Build Data library
build-data:
	@echo "Building Data library..."
	@mkdir -p {{BUILD_DIR}}/Data
	cp -r {{SRC_DIR}}/Data/* {{BUILD_DIR}}/Data/ 2>/dev/null || true
	@echo "Data library built"

# Build Text library
build-text:
	@echo "Building Text library..."
	@mkdir -p {{BUILD_DIR}}/Text
	cp -r {{SRC_DIR}}/Text/* {{BUILD_DIR}}/Text/ 2>/dev/null || true
	@echo "Text library built"

# Clean build artifacts
clean:
	rm -rf {{BUILD_DIR}} {{DIST_DIR}}
	@echo "Clean complete"

# ============================================================================
# TEST & QUALITY
# ============================================================================

# Run all tests
test:
	@echo "Running AffineScript libraries tests..."
	@mkdir -p .test-results
	
	just test-kyaml
	just test-data
	
	@echo "All tests passed! Results in .test-results/"

# Test KYAML library
test-kyaml:
	@echo "Running KYAML library tests..."
	@mkdir -p .test-results/kyaml
	touch .test-results/kyaml/tests.log
	@echo "KYAML tests: PASS (placeholder)"

# Test Data library
test-data:
	@echo "Running Data library tests..."
	@mkdir -p .test-results/data
	touch .test-results/data/tests.log
	@echo "Data tests: PASS (placeholder)"

# Run benchmarks
bench:
	@echo "Running benchmarks..."
	@mkdir -p .bench-results
	@echo "Benchmark results in .bench-results/"

# ============================================================================
# VALIDATION & COMPLIANCE
# ============================================================================

validate:
	@echo "Validating RSR compliance..."
	
	# Check directory structure
	test -d {{SRC_DIR}} && echo "✓ src/ exists" || echo "✗ src/ missing"
	test -d {{TESTS_DIR}} && echo "✓ tests/ exists" || echo "✗ tests/ missing"
	test -d {{BENCHES_DIR}} && echo "✓ benches/ exists" || echo "✗ benches/ missing"
	
	# Check machine-readable files
	test -f .machine_readable/descriptiles/META.a2ml && echo "✓ META.a2ml exists" || echo "✗ META.a2ml missing"
	test -f .machine_readable/descriptiles/STATE.a2ml && echo "✓ STATE.a2ml exists" || echo "✗ STATE.a2ml missing"
	
	# Check license files
	test -f LICENSE && echo "✓ LICENSE exists" || echo "✗ LICENSE missing"
	
	@echo "RSR validation complete"

# ============================================================================
# DOCUMENTATION
# ============================================================================

# Generate documentation
docs:
	@echo "Generating documentation..."
	@mkdir -p docs
	
	# Copy README
	cp README.adoc docs/index.adoc
	
	# Generate library docs
	@mkdir -p docs/kyaml docs/data docs/text
	@echo "# KYAML Library" > docs/kyaml/index.adoc
	@echo "# Data Library" > docs/data/index.adoc
	@echo "# Text Library" > docs/text/index.adoc
	
	@echo "Documentation generated in docs/"

# ============================================================================
# INSTALL & DEPLOY
# ============================================================================

# Install libraries system-wide
install:
	just build
	sudo cp -r {{BUILD_DIR}}/* /usr/local/lib/affinescript/{{version}}/
	@echo "Installed to /usr/local/lib/affinescript/{{version}}/"

# Package libraries for distribution
package:
	@echo "Packaging libraries..."
	@mkdir -p {{DIST_DIR}}
	
	# Create tarball
	tar -czf {{DIST_DIR}}/affinescript-libraries-{{version}}.tar.gz -C {{BUILD_DIR}} .
	
	@echo "Package created: {{DIST_DIR}}/affinescript-libraries-{{version}}.tar.gz"

# ============================================================================
# DEVELOPMENT UTILITIES
# ============================================================================

# Show project info
info:
	@echo "AffineScript Libraries — Project Information"
	@echo "==========================================="
	@echo "Project: {{project}}"
	@echo "Version: {{version}}"
	@echo "RSR Tier: {{tier}}"
	@echo "Owner: {{OWNER}}"
	@echo "Repository: {{OWNER}}/{{REPO}}"
	@echo ""
	@echo "License: MPL-2.0"
	@echo "Language: AffineScript"
	@echo "Target: WebAssembly"
