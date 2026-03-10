# Phase 4: API Implementation - Task List

## Overview
Phase 4 involves exposing the application's core logic via a versioned RESTful API. This allows for third-party integrations, mobile apps, or headless usage of Artemist.

---

## 1. API Architecture & Versioning

### 1. versioned Route Setup
- [ ] Create a dedicated `api` namespace and `v1` version in `config/routes.rb`:
  ```ruby
  namespace :api do
    namespace :v1 do
      resources :projects
      resources :bugs
      resources :comments
    end
  end
  ```
- [ ] Create an `Api::V1::BaseController` as a parent for all API controllers.

---

## 2. API Authentication & Security

### 2.1 Token-based Authentication
- [ ] Implement a simple API Key system or use JWT (JSON Web Tokens).
- [ ] Create a `ApiKey` model linked to a `User`.
- [ ] Write a controller/service to generate and manage API keys via the web UI.
- [ ] Implement a `before_action :authenticate_api_user!` in the base API controller.

### 2.2 Rate Limiting
- [ ] Enable `rack-attack` for the API namespace.
- [ ] Set appropriate limits (e.g., 60 requests per minute per token).

---

## 3. Resource Endpoints (CRUD)

### 3.1 JSON Serialization
- [ ] Choose and install a serialization library (`jbuilder`, `blueprinter`, or `jsonapi-serializer`).
- [ ] Implement serializers for:
  - [ ] User (public profile info).
  - [ ] Project.
  - [ ] Bug (including reporter and assignee details).
  - [ ] Comment.

### 3.2 Projects API
- [ ] List all projects accessible to the user (`GET /api/v1/projects`).
- [ ] Show project details (`GET /api/v1/projects/:id`).

### 3.3 Bugs API
- [ ] List bugs for a project (`GET /api/v1/projects/:project_id/bugs`).
- [ ] create a new bug (`POST /api/v1/projects/:project_id/bugs`).
- [ ] Update bug status or details (`PATCH /api/v1/bugs/:id`).
- [ ] Delete a bug (`DELETE /api/v1/bugs/:id`).

### 3.4 Comments API
- [ ] List comments for a bug.
- [ ] Post a new comment.

---

## 4. Error Handling & Standards

### 4.1 Standardized Error Responses
- [ ] Implement a consistent JSON error format (e.g., `{ "errors": [{ "message": "...", "code": "..." }] }`).
- [ ] Handle common cases: 401 Unauthorized, 403 Forbidden, 404 Not Found, 422 Unprocessable Entity.

---

## 5. Documentation

### 5.1 Rswag or OpenAPI Integration
- [ ] Install `rswag` and `rswag-ui`.
- [ ] Generate API documentation through integration tests.
- [ ] Expose the documentation at `/api-docs`.

---

## 6. Verification & Testing

### 6.1 Request Specs
- [ ] Write comprehensive request tests for all API endpoints.
- [ ] Test authentication failures and permission boundaries (Pundit integration).
- [ ] Test edge cases (missing params, invalid data).

### 6.2 Manual Verification
- [ ] Use Postman or `curl` to verify the API endpoints with a valid token.
- [ ] Check rate limiting behavior under load.
