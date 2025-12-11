# GoStore 🚀

Una plataforma de aprendizaje de Ruby on Rails inspirada en FreeCodeCamp, construida con un stack moderno y profesional.

## 🛠 Tech Stack

- **Ruby**: 3.2.2
- **Rails**: 8.0.2
- **Database**: PostgreSQL
- **Frontend**: TailwindCSS, Slim, Stimulus
- **Process Manager**: Overmind
- **Linting**: Rubocop, Overcommit

## 📋 Prerrequisitos

Asegúrate de tener instalado:
- Ruby 3.2.2
- PostgreSQL (corriendo localmente)
- Overmind (`brew install overmind`)

## 🚀 Inicio Rápido

1. **Instalar dependencias**:
   ```bash
   bundle install
   ```

2. **Configurar la base de datos**:
   ```bash
   bin/rails db:setup
   ```
   *Esto creará la base de datos, correrá las migraciones y cargará los seeds.*

3. **Iniciar el servidor**:
   ```bash
   overmind start -f Procfile.dev
   ```
   *La app correrá en el puerto 3000 por defecto.*

4. **Visitar la App**:
   Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## 🧪 Calidad de Código

Este proyecto usa **Rubocop** y **Overcommit** para asegurar la calidad del código.

- Correr linter manualmente:
  ```bash
  bundle exec rubocop
  ```

- Los git hooks se instalaron automáticamente. Si necesitas reinstalarlos:
  ```bash
  overcommit --install
  ```
