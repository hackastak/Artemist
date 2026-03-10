# Phase 3: GitHub Integration Sync - Task List

## Overview
Phase 3 focuses on automating the link between Artemist and GitHub Issues. This will involve background job processing, handling incoming webhooks from GitHub, and pushing local changes back to GitHub repositories.

---

## 1. Background Job Infrastructure

### 1.1 Solid Queue Setup
- [ ] Install and configure `solid_queue` (Rails 7.1 default).
- [ ] Set up the database tables for jobs: `bin/rails solid_queue:install`.
- [ ] Configure `config/environments/production.rb` to use `:solid_queue` as the adapter.
- [ ] Verify job processing with a simple test job.

---

## 2. GitHub API Client (Octokit)

### 2.1 Service Objects for API Interaction
- [ ] Create a `Github::BaseService` to handle authentication and Octokit client initialization.
- [ ] Create `Github::PushIssueService` to create or update issues on GitHub.
- [ ] Create `Github::SyncCommentService` to push/pull comments.
- [ ] Implement error handling for API rate limits and connection issues.

---

## 3. Webhooks & Incoming Synchronization

### 3.1 Webhook Endpoint
- [ ] Create `Webhooks::GithubController` to receive POST requests from GitHub.
- [ ] Implement webhook signature verification to ensure requests come only from GitHub.
- [ ] Add the webhook route to `config/routes.rb`.

### 3.2 Webhook Handlers
- [ ] Create handler logic for specific GitHub events:
  - [ ] `issues` (opened, edited, closed, reopened, assigned).
  - [ ] `issue_comment` (created, edited, deleted).
- [ ] Ensure webhooks trigger background jobs (`Github::SyncIssueJob`) rather than processing in-line.

---

## 4. Bi-directional Synchronization Logic

### 4.1 Syncing Local to GitHub
- [ ] Hook into `after_commit` callbacks in the `Bug` model to trigger a push to GitHub when modified.
- [ ] Hook into the `Comment` model to push new comments to GitHub.
- [ ] Handle "ghost" updates (prevent infinite loops where Artemist updates GitHub, which then sends a webhook back to Artemist).

### 4.2 Initial Repository Import
- [ ] Create a UI flow in the Projects section to "Import from GitHub".
- [ ] Implement `Github::ImportRepoService` to fetch all existing issues from a selected repository.
- [ ] Background the import process and provide progress feedback in the UI (Turbo Streams).

---

## 5. Security & Robustness

### 5.1 Token Management
- [ ] Verify that `github_token` is being securely accessed from the User model (encrypted).
- [ ] Implement logic to handle expired or revoked tokens (redirect user to re-authenticate).

### 5.2 Idempotency
- [ ] Use `github_id` (the external ID from GitHub) to uniquely identify and link bugs/comments to prevent duplicates.

---

## 6. Verification & Testing

### 6.1 Job & Service Testing
- [ ] Write unit tests for all GitHub service objects.
- [ ] Write background job tests (assert jobs are enqueued and perform as expected).

### 6.2 Integration Testing
- [ ] Use VCR or WebMock to mock GitHub API responses in tests.
- [ ] Write integration tests for the webhook receiver endpoint.

### 6.3 Manual Verification
- [ ] Create a test repo on GitHub and verify that creating a bug in Artemist creates an issue on GitHub.
- [ ] Verify that closing an issue on GitHub closes the corresponding bug in Artemist.
- [ ] Verify comment syncing in both directions.
