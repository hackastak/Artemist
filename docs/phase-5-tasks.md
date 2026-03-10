# Phase 5: Testing & Quality Assurance - Task List

## Overview
Phase 5 focuses on ensuring the reliability and stability of Artemist through comprehensive automated testing and a continuous integration pipeline.

---

## 1. Unit & Model Testing

### 1.1 Model Validations & Associations
- [ ] Enhance existing `User`, `Project`, and `Bug` model tests.
- [ ] Test all Active Record validations (uniqueness, presence, format).
- [ ] Test model associations (has_many, belongs_to).

### 1.2 Custom Business Logic
- [ ] Write unit tests for any custom methods in the models (e.g., status transition logic, helper methods).
- [ ] Test the `Comment` model and its interaction with `Bug`.

---

## 2. Controller & Request Testing

### 2.1 Web Controller Tests
- [ ] Write request specs for `ProjectsController`, `BugsController`, and `CommentsController`.
- [ ] Test successful rendering of views and appropriate redirection.
- [ ] Verify that authorization (Pundit) works as expected at the controller level.

### 2.2 API Endpoint Tests (Integration)
- [ ] Test all `Api::V1` endpoints for correct JSON responses and status codes.
- [ ] Verify that API authentication and rate limiting are working.

---

## 3. System Testing (UI Flows)

### 3.1 Core User Journeys
- [ ] Create system tests for the main workflows:
  - [ ] A user signs up, creates a project, and adds a bug.
  - [ ] A user updates a bug's status and sees the change reflected instantly.
  - [] A user adds a comment and verifies it's visible.
- [ ] Test UI responsiveness and mobile views using system test helpers.
- [ ] Verify that Turbo Frames/Streams are behaving as expected from a user's perspective.

---

## 4. GitHub Integration Mocking & Tests

### 4.1 Mocking the GitHub API
- [ ] Configure `WebMock` to intercept all outgoing GitHub API calls.
- [ ] Use `VCR` to record and replay real API interactions for consistent testing.
- [ ] Test GitHub service objects with mocked responses (Success, Error, Rate Limit).

### 4.2 Webhook Simulation
- [ ] Write tests that simulate incoming GitHub webhooks and verify that the correct background jobs are enqueued.

---

## 5. Continuous Integration (CI)

### 5.1 GitHub Actions Setup
- [ ] Create a `.github/workflows/ci.yml` file.
- [ ] Configure the workflow to:
  - [ ] Setup Ruby and PostgreSQL.
  - [ ] Run `bundle install`.
  - [ ] Run `bin/rails db:prepare`.
  - [ ] Run all tests (`bin/rails test`).
- [ ] Integrate a linter like `RuboCop` into the CI pipeline.
- [ ] (Optional) Configure code coverage reporting (e.g., SimpleCov).

---

## 6. Verification & Quality Check

### 6.1 Final Test Run
- [ ] Ensure all tests pass locally (`bin/rails test`).
- [ ] Ensure the CI pipeline passes on a test branch.
- [ ] Verify no regressions in Phase 1-4 functionality.
