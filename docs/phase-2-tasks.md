# Phase 2: Functional Web Interface - Task List

## Overview
Phase 2 focuses on building a modern, responsive, and interactive user interface for Artemist. We will use **Tailwind CSS** for styling and **Hotwire** (Turbo + Stimulus) to create a fast, single-page application feel.

---

## 1. Design System & Layouts

### 1.1 Sidebar & Global Navigation
- [ ] Create an application layout shell in `app/views/layouts/application.html.erb`.
- [ ] Implement a responsive sidebar using Tailwind CSS.
  - [ ] Logo and Brand name.
  - [ ] Navigation links: Dashboard, Projects, My Bugs, Settings.
  - [ ] User profile summary (avatar, name).
  - [ ] Mobile-friendly toggle for the sidebar.
- [ ] Implement a top navigation bar (if needed).
  - [ ] Global search bar (UI only for now).
  - [ ] "New Bug" shortcut button.

### 1.2 Global Theme & Typography
- [ ] Define the color palette in `tailwind.config.js` (Brand primary, Secondary, Success, Warning, Danger).
- [ ] Set up default typography (Inter or similar clean sans-serif).
- [ ] Create reusable CSS components in `app/assets/stylesheets/application.css` (Buttons, Badges, Cards, Modals).

---

## 2. Projects Dashboard

### 2.1 Project List View
- [ ] Generate `ProjectsController` with `index` and `show` actions.
- [ ] Create the `index` view.
  - [ ] Search input for filtering projects.
  - [ ] Grid or list layout of project cards.
  - [ ] Card details: Project name, Bug count summary (Open/Closed), Last updated timestamp.
- [ ] Implement basic filtering logic in the controller.

### 2.2 Project Summary & Statistics
- [ ] Add summary statistics to the dashboard.
  - [ ] Total active bugs.
  - [ ] Bugs assigned to the current user.
  - [ ] Critical priority bugs count.

---

## 3. Bug Management CRUD

### 3.1 Bug Resource Implementation
- [ ] Generate `BugsController` with full RESTful actions (`index`, `show`, `new`, `create`, `edit`, `update`, `destroy`).
- [ ] Update `config/routes.rb` to include nested routes:
  ```ruby
  resources :projects do
    resources :bugs
  end
  ```

### 3.2 Bug Creation & Editing
- [ ] Create the "New Bug" form.
  - [ ] Fields: Title, Description, Priority, Status, Assignee.
  - [ ] Use a modal or a dedicated page.
- [ ] Implement the "Edit Bug" form.
- [ ] Add form validations feedback in the UI using Tailwind styles.

### 3.3 Bug Show Page & Comments
- [ ] Create a detailed view for a single bug.
  - [ ] Header with Title, Status badge, Priority badge.
  - [ ] Metadata section: Reporter, Assignee, Created date.
  - [ ] Description (rendered as Markdown if possible).
- [ ] Implement Commenting system.
  - [ ] `CommentsController` for `create` and `destroy`.
  - [ ] List of comments with author and timestamp.
  - [ ] Form to add a new comment.

---

## 4. Hotwire & Real-time Updates

### 4.1 Turbo Frames for Inline Editing
- [ ] Use Turbo Frames to allow editing bug titles or statuses directly from the list view without a full page reload.
- [ ] Wrap comments in a Turbo Frame for seamless addition and deletion.

### 4.2 Turbo Streams for Real-time Content
- [ ] Broadcast bug status changes to all users viewing the same project.
  - [ ] Add `broadcasts_to :project` to the `Bug` model.
  - [ ] Update project views to listen for Turbo Stream updates.
- [ ] Broadcast new comments to the bug show page.

### 4.3 Stimulus Controllers for Interactivity
- [ ] Create a Stimulus controller for handling modals.
- [ ] Create a Stimulus controller for auto-saving form drafts or character counters.
- [ ] Create a Stimulus controller for handling dropdown menus and UI toggles.

---

## 5. Visual Polish & UX

### 5.1 Flash Messages & Alerts
- [ ] Design and implement pretty flash message notifications (Success, Error, Info).
- [ ] Use a Stimulus controller to auto-dismiss flash messages after a few seconds.

### 5.2 Loading States & Skeletons
- [ ] Add loading indicators for async operations.
- [ ] Use Skeleton screens for initial page loads (optional but recommended).

### 5.3 Mobile Responsiveness
- [ ] Ensure all key pages (Dashboard, Bug View, Forms) are fully responsive on mobile devices.

---

## 6. Verification & Testing

### 6.1 UI Verification
- [ ] Manually test all CRUD flows for Projects, Bugs, and Comments.
- [ ] Verify Turbo Stream broadcasts work correctly across different browser segments.
- [ ] Check sidebar and navigation responsiveness.

### 6.2 System Tests
- [ ] Write system tests for:
  - [ ] Creating a new bug and seeing it appear in the list.
  - [ ] Changing a bug's status and verifying the live update.
  - [ ] Adding and deleting comments.
  - [ ] Navigating between projects.
