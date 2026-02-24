# Artemist: Production-Ready Implementation Plan

This plan outlines the phases required to transform the current Rails skeleton into a fully functional, secure, and performant bug tracking application.

## Phase 1: Core Authentication & Security
*Establish the foundation for user access and data protection.*

- [ ] **Authentication**: Implement user sign-up/login using **Devise**.
  - Modules: `database_authenticatable`, `registerable`, `recoverable`, `rememberable`, `validatable`
  - User model already exists with required fields
- [ ] **Authorization**: Ensure users can only access their projects and bugs using **Pundit**.
- [ ] **GitHub OAuth**: Configure OmniAuth using existing User model fields (`github_uid`, `github_username`, `github_token`).
  - Credentials configured in Rails encrypted credentials
- [ ] **Transactional Email**: Configure **SMTP2Go** for password reset emails.
  - Credentials configured in Rails encrypted credentials
  - Use `letter_opener` gem for development

## Phase 2: Functional Web Interface
*Build the CRUD workflows using Hotwire for a modern, SPA-like feel.*

- [ ] **Prototypes & Layouts**:
  - Implement a sleek sidebar/navigation using Tailwind.
  - Create a global "New Bug" shortcut.
- [ ] **Projects Dashboard**:
  - List view with search and filtering.
  - Project summary cards (total bugs, status breakdown).
- [ ] **Bug Management**:
  - Interactive kanban board or detailed list for bug status transitions.
  - Full CRUD for bugs and comments.
  - **Real-time updates**: Use Turbo Streams to sync bug status changes across users.

## Phase 3: GitHub Integration Sync
*Automate the bi-directional sync between Artemist and GitHub Issues.*

- [ ] **Background Jobs**: Configure `Solid Queue` (Rails 7.1 default) or `Sidekiq`.
- [ ] **Bi-directional Sync**:
  - Webhooks to receive updates from GitHub.
  - Service objects to push updates to GitHub when a bug state changes in Artemist.
- [ ] **Repo Import**: Allow users to import existing issues from their GitHub repositories.

## Phase 4: API Implementation
*Expose the application logic via a versioned REST API.*

- [ ] **API V1**:
  - JSON endpoints for Projects, Bugs, and Comments.
  - Token-based authentication (e.g., API Keys or JWT).
- [ ] **Documentation**: Generate API documentation using `Rswag` or `OpenAPI`.

## Phase 5: Testing & Quality Assurance
*Ensure reliability and prevent regressions.*

- [ ] **Test Coverage**:
  - Model tests (enhance existing).
  - Controller/Request tests for both Web and API.
  - System tests (Playwright or Selenium) for core UI flows.
- [ ] **CI/CD**: Configure GitHub Actions to run tests and lints on every push.

## Phase 6: Production Readiness
*Prepare for deployment and scaling.*

- [ ] **Deployment**:
  - Use `Kamal` for easy deployment to VPS or a Docker-based PaaS (Render/Heroku/Fly.io).
- [ ] **Observability**:
  - Implement error tracking (Sentry/Honeybadger).
  - Logging and performance monitoring (New Relic/Grafana).
- [ ] **Performance**:
  - Configure Redis for caching and Action Cable.
  - Optimize database queries (avoid N+1s).
- [ ] **Security Hardening**:
  - Implement rate limiting with `rack-attack` (deferred from Phase 1).

---

## Decisions Made

| Topic | Decision |
|-------|----------|
| **Authentication** | Devise (minimal modules for MVP) |
| **Authorization** | Pundit |
| **GitHub OAuth** | OmniAuth with existing User model fields |
| **Transactional Email** | SMTP2Go (production), letter_opener (development) |
| **Rate Limiting** | Deferred to Phase 6 |

## Open Questions

> [!NOTE]
> **Deployment Target**: Hosting provider not yet decided (AWS, Render, Fly.io, etc.)
