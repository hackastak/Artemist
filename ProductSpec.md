# Artemist Product Specification (Current State)

Artemist is a minimal bug tracking application designed for GitHub integration. In its current state, it serves as a robust codebase skeleton with a complete data model but without a functional web interface or API implementation.

## Tech Stack

- **Framework**: [Ruby on Rails 7.1.5.1](https://rubyonrails.org/)
- **Language**: [Ruby 3.2.0](https://www.ruby-lang.org/)
- **Database**: [PostgreSQL](https://www.postgresql.org/) (Configurable for [Supabase](https://supabase.com))
- **Frontend**:
  - [Tailwind CSS](https://tailwindcss.com/) (Integration via `tailwindcss-rails`)
  - [Hotwire](https://hotwired.dev/) (Turbo + Stimulus)
- **Asset Management**: Import maps (`importmap-rails`)
- **Containerization**: [Docker](https://www.docker.com/) (Dockerfile provided)
- **GitHub Integration**: [`octokit`](https://github.com/octokit/octokit.rb) (Gem included, implementation pending)
- **Authentication**: [Devise](https://github.com/heartcombo/devise) + [OmniAuth](https://github.com/omniauth/omniauth) (GitHub OAuth)
- **Authorization**: [Pundit](https://github.com/varvet/pundit)
- **Transactional Email**: SMTP2Go (production), letter_opener (development)

## Current Features (Data Model Level)

The application has a well-defined database schema and Active Record models, though no routes or controllers are currently implemented to expose this functionality.

### Core Entities

- **User**: Represents team members. Fields include:
  - `name`, `email` (validated uniquely)
  - Devise authentication fields (password, sessions, password reset)
  - GitHub OAuth fields (`github_uid`, `github_username`, `github_token`, `avatar_url`)
- **Project**: Owned by a User. Acts as a container for bugs.
- **Bug**: The central entity.
  - **Status**: `open`, `in_progress`, `resolved`, `closed`.
  - **Priority**: `low`, `medium`, `high`, `critical`.
  - **Associations**: Belongs to a Project, a Reporter (User), and an optional Assignee (User).
- **Comment**: Enables threaded discussion on specific bugs.

## Local Setup Instructions

Follow these steps to get the project running on your local machine:

### 1. Prerequisites
Ensure you have the following installed:
- Ruby 3.2.0
- PostgreSQL 14+
- Node.js (for Tailwind CSS compilation)
- Bundler

### 2. Installation
```bash
git clone <repository-url>
cd Artemist
bundle install
```

### 3. Environment Configuration
Copy the example environment file and configure your database and GitHub credentials:
```bash
cp .env.example .env
```
*Note: Even without active GitHub logic, the app expects these variables to be present if referenced in initializers or future services.*

### 4. Database Setup
```bash
bin/rails db:prepare
```
This command will create the database, load the schema (or run migrations), and seed the database if `db/seeds.rb` is populated.

### 5. Running the App
Start the development server with Tailwind CSS compilation:
```bash
bin/dev
```
The application will be available at `http://localhost:3000`.

## Developer Notes

- **Routes**: The `config/routes.rb` file is currently empty beyond health check routes. Implementation of RESTful resources for Bugs, Projects, and Users is the immediate next step.
- **Controllers**: There are currently no functional controllers in `app/controllers`.
- **Authentication**: Devise + Pundit + OmniAuth to be implemented in Phase 1. See `phase-1-tasks.md` for detailed task list.
- **Credentials**: GitHub OAuth and SMTP2Go credentials are stored in Rails encrypted credentials (`config/credentials.yml.enc`). Developers need the `master.key` to access them.
- **Octokit**: The `octokit` gem is bundled but not yet utilized in the codebase.
- **Design System**: Tailwind CSS is configured and ready for use. Global styles can be found in `app/assets/stylesheets/application.css`.
- **Testing**: A testing suite is initialized in `test/`, with models being the primary focus of current tests. Run tests with `bin/rails test`.

## License
MIT
