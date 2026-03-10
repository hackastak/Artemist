# Phase 1: Core Authentication & Security - Task List

## Key Decisions

> **Read this section first.** These decisions have been made to reduce ambiguity and keep development moving. If you have concerns or questions about any decision, raise them before starting the related task.

### Authentication

| Decision | Choice | Notes |
|----------|--------|-------|
| **Devise modules** | Minimal set only | Use `database_authenticatable`, `registerable`, `recoverable`, `rememberable`, `validatable`. Do NOT enable `confirmable` or `lockable` for MVP. |
| **User model** | Already exists | User model has `name`, `email`, `avatar_url`, `github_uid`, `github_username`. Devise will add auth fields to existing model. |
| **Session duration** | 2 weeks with "remember me" | Default to browser session; "remember me" checkbox extends to 2 weeks. |

### Authorization

| Decision | Choice | Notes |
|----------|--------|-------|
| **Authorization failure behavior** | Redirect with flash message | On `Pundit::NotAuthorizedError`, redirect to root path with flash: "You are not authorized to perform this action." Do not render a 403 page. |

### OAuth

| Decision | Choice | Notes |
|----------|--------|-------|
| **OAuth data storage** | Use existing User fields | User model already has `github_uid`, `github_username`, `avatar_url`. No separate OauthIdentity model needed. |
| **OAuth email conflict** | Block and prompt manual linking | If GitHub email matches an existing account, do NOT auto-link. Show error: "An account with this email already exists. Please sign in with your password and link GitHub from your profile settings." |
| **GitHub token storage** | Add `github_token` to User | Add encrypted `github_token` field to User model for Phase 3 GitHub API access. Use `encrypts :github_token`. |
| **GitHub OAuth App ownership** | Credentials already configured | Credentials stored in `config/credentials.yml.enc`. Access via `Rails.application.credentials.github.client_id` and `.client_secret`. |

### Security

| Decision | Choice | Notes |
|----------|--------|-------|
| **Rate limiting** | Skip for Phase 1 | Do not implement `rack-attack` now. This will be revisited in Phase 6 (Production Readiness). |

### Email & Mailer

| Decision | Choice | Notes |
|----------|--------|-------|
| **Development mailer** | Use `letter_opener` gem | Emails open in browser automatically. No real emails sent in dev. |
| **Production mailer** | SMTP2Go | Credentials stored in `config/credentials.yml.enc`. Access via `Rails.application.credentials.smtp2go`. |

### UI/Styling

| Decision | Choice | Notes |
|----------|--------|-------|
| **Auth page design** | Use Tailwind UI patterns | Reference the free Tailwind sign-in/sign-up examples. Keep it clean and minimal. No custom design needed unless provided. |

---

## Prerequisites

- [ ] Review existing Rails app structure and ensure Ruby/Rails versions are compatible
- [ ] Ensure PostgreSQL (or chosen database) is running and configured
- [ ] **Obtain `config/master.key` from project lead** (required to access encrypted credentials - share securely, not via git)
- [ ] Verify credentials access: `rails runner "puts Rails.application.credentials.github.client_id"`
- [ ] **Read the "Key Decisions" section above**

---

## 1. Authentication with Devise

### 1.1 Setup & Installation
- [ ] Add `devise` gem to Gemfile
- [ ] Run `bundle install`
- [ ] Run `rails generate devise:install`
- [ ] Follow the post-install instructions from Devise (flash messages, root route, mailer config)

### 1.2 User Model (already exists)
- [ ] Run `rails generate devise User` (Devise will detect existing model and create migration for auth fields only)
- [ ] Review the generated migration - enable only these modules initially:
  - `database_authenticatable`
  - `registerable`
  - `recoverable`
  - `rememberable`
  - `validatable`
- [ ] Note: `name`, `email`, `avatar_url` fields already exist - no need to add them
- [ ] Run `rails db:migrate`

### 1.3 Views & Styling
- [ ] Run `rails generate devise:views`
- [ ] Style the Devise views using Tailwind UI sign-in/sign-up patterns (see Key Decisions):
  - [ ] Sign up form
  - [ ] Sign in form
  - [ ] Password reset forms
  - [ ] Edit profile form
- [ ] Add flash message partial to application layout

### 1.4 Controller & Route Configuration
- [ ] Configure `before_action :authenticate_user!` in `ApplicationController`
- [ ] Set up `root` route for authenticated vs. unauthenticated users
- [ ] Configure permitted parameters for sign up/account update in `ApplicationController`:
  ```ruby
  before_action :configure_permitted_parameters, if: :devise_controller?
  ```

### 1.5 Mailer Setup (for password reset)
- [ ] Add `letter_opener` gem to development group and configure Action Mailer for development
- [ ] Configure Action Mailer for production using SMTP2Go credentials from `Rails.application.credentials.smtp2go`:
  ```ruby
  # config/environments/production.rb
  config.action_mailer.smtp_settings = {
    address: Rails.application.credentials.smtp2go[:host],
    port: Rails.application.credentials.smtp2go[:port],
    user_name: Rails.application.credentials.smtp2go[:username],
    password: Rails.application.credentials.smtp2go[:password],
    authentication: :plain,
    enable_starttls_auto: true
  }
  ```
- [ ] Test password reset email flow

### 1.6 Testing Authentication
- [ ] Write request specs for:
  - [ ] User registration (valid and invalid)
  - [ ] User login (valid and invalid credentials)
  - [ ] User logout
  - [ ] Password reset request
- [ ] Write model specs for User validations

---

## 2. Authorization with Pundit

### 2.1 Setup & Installation
- [ ] Add `pundit` gem to Gemfile
- [ ] Run `bundle install`
- [ ] Run `rails generate pundit:install`
- [ ] Include Pundit in `ApplicationController`:
  ```ruby
  include Pundit::Authorization
  ```

### 2.2 Application Policy
- [ ] Review generated `ApplicationPolicy`
- [ ] Set secure defaults (deny by default):
  ```ruby
  def index?
    false
  end
  ```

### 2.3 Project Policy
- [ ] Create `ProjectPolicy` (`rails generate pundit:policy Project`)
- [ ] Implement policy methods:
  - [ ] `index?` - user can list their own projects
  - [ ] `show?` - user owns the project
  - [ ] `create?` - any authenticated user
  - [ ] `update?` - user owns the project
  - [ ] `destroy?` - user owns the project
- [ ] Implement `Scope` class to filter projects by owner

### 2.4 Bug Policy
- [ ] Create `BugPolicy` (`rails generate pundit:policy Bug`)
- [ ] Implement policy methods:
  - [ ] `index?` - user owns the parent project
  - [ ] `show?` - user owns the parent project
  - [ ] `create?` - user owns the parent project
  - [ ] `update?` - user owns the parent project
  - [ ] `destroy?` - user owns the parent project
- [ ] Implement `Scope` class to filter bugs by project ownership

### 2.5 Integrate Authorization into Controllers
- [ ] Add `authorize @project` calls to ProjectsController actions
- [ ] Add `authorize @bug` calls to BugsController actions
- [ ] Use `policy_scope(Project)` and `policy_scope(Bug)` for index actions
- [ ] Add `rescue_from Pundit::NotAuthorizedError` handler in ApplicationController (redirect to root with flash message - see Key Decisions)

### 2.6 Testing Authorization
- [ ] Write request specs verifying:
  - [ ] User can access their own projects
  - [ ] User CANNOT access another user's projects (redirects with flash)
  - [ ] User can access bugs in their projects
  - [ ] User CANNOT access bugs in another user's projects
- [ ] Write policy specs for ProjectPolicy
- [ ] Write policy specs for BugPolicy

---

## 3. GitHub OAuth Integration

### 3.1 Setup & Installation
- [ ] Add gems to Gemfile:
  - `omniauth`
  - `omniauth-github`
  - `omniauth-rails_csrf_protection`
- [ ] Run `bundle install`

### 3.2 GitHub OAuth App Configuration
- [x] ~~Credentials already configured in `config/credentials.yml.enc`~~
- [ ] Verify credentials work: `rails runner "puts Rails.application.credentials.github.client_id"`

### 3.3 OmniAuth Configuration
- [ ] Create `config/initializers/omniauth.rb`:
  ```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github,
      Rails.application.credentials.github[:client_id],
      Rails.application.credentials.github[:client_secret],
      scope: "user:email,read:user"
  end
  ```
- [ ] Set up OmniAuth failure route in `config/routes.rb`

### 3.4 Add GitHub Token Field to User
- [ ] Generate migration to add token field:
  ```
  rails generate migration AddGithubTokenToUsers github_token:string
  ```
- [ ] Run `rails db:migrate`
- [ ] Add encryption to User model:
  ```ruby
  encrypts :github_token
  ```
- [ ] Note: `github_uid` and `github_username` fields already exist on User model

### 3.5 OAuth Callbacks Controller
- [ ] Create `Users::OmniauthCallbacksController`
- [ ] Implement `github` action to handle callback
- [ ] Handle these scenarios:
  - [ ] New user signing up via GitHub (create user with `github_uid`, `github_username`, `github_token`, `avatar_url`)
  - [ ] Existing user linking GitHub account (update user's GitHub fields)
  - [ ] Returning user signing in via GitHub (find user by `github_uid`, sign in)
  - [ ] Email conflict: block sign-up and prompt manual linking (see Key Decisions)
- [ ] Add appropriate flash messages for each scenario

### 3.6 Devise OmniAuth Configuration
- [ ] Add to User model: `devise :omniauthable, omniauth_providers: [:github]`
- [ ] Configure routes: `devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }`

### 3.7 UI Integration
- [ ] Add "Sign in with GitHub" button to sign-in page
- [ ] Add "Sign up with GitHub" button to sign-up page
- [ ] Add "Link GitHub Account" option in user settings/profile
- [ ] Add "Unlink GitHub Account" option (if linked)
- [ ] Display linked GitHub username in profile

### 3.8 Token Security
- [ ] Ensure `github_token` is filtered from logs:
  ```ruby
  config.filter_parameters += [:github_token]
  ```
- [ ] Verify `encrypts :github_token` is configured in User model (done in section 3.4)

### 3.9 Testing OAuth
- [ ] Configure OmniAuth test mode in `rails_helper.rb`:
  ```ruby
  OmniAuth.config.test_mode = true
  ```
- [ ] Create mock OAuth hash fixtures (uid, email, nickname, token, avatar_url)
- [ ] Write request specs for:
  - [ ] New user GitHub sign-up flow (user created with GitHub fields populated)
  - [ ] Existing user GitHub sign-in flow (user found by `github_uid`)
  - [ ] Account linking flow (existing user's GitHub fields updated)
  - [ ] OAuth failure handling

---

## 4. Security Hardening

### 4.1 Session Security
- [ ] Review and configure session timeout settings in Devise
- [ ] Ensure `config.force_ssl = true` in production
- [ ] Configure secure cookie settings

### 4.2 Parameter Filtering
- [ ] Verify sensitive params are filtered in logs:
  - `password`
  - `password_confirmation`
  - `github_token`
  - `client_secret`

### 4.3 CSRF Protection
- [ ] Verify CSRF protection is enabled (Rails default)
- [ ] Ensure `omniauth-rails_csrf_protection` is working

### 4.4 Rate Limiting
> **Skipped for Phase 1** - Rate limiting will be implemented in Phase 6 (Production Readiness). See Key Decisions.

---

## 5. Final Verification

- [ ] Manual testing checklist:
  - [ ] Sign up with email/password
  - [ ] Sign in with email/password
  - [ ] Sign out
  - [ ] Reset password via email
  - [ ] Sign up with GitHub
  - [ ] Sign in with GitHub (returning user)
  - [ ] Link GitHub to existing account
  - [ ] Verify user cannot access other users' projects
  - [ ] Verify user cannot access other users' bugs

- [ ] Code review checklist:
  - [ ] No hardcoded secrets
  - [ ] All sensitive data filtered from logs
  - [ ] Authorization checks on every controller action
  - [ ] Tests passing with good coverage

- [ ] Documentation:
  - [ ] Update README with authentication setup instructions
  - [ ] Document OAuth app configuration for other developers
