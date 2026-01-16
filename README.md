# Artemist

A minimal bug tracking application with GitHub integration, built with Ruby on Rails.

## Features

- Bug/issue tracking with GitHub integration
- Built with Rails 7.1 and PostgreSQL
- Styled with Tailwind CSS
- Real-time updates with Hotwire (Turbo + Stimulus)

## Requirements

- Ruby 3.2.0+
- Rails 7.1+
- PostgreSQL 14+
- Node.js (for Tailwind CSS compilation)

## Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd artemist
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure environment variables

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```
DATABASE_URL=postgres://localhost:5432/artemist_development
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_TOKEN=your_github_personal_access_token
```

### 4. Set up the database

```bash
bin/rails db:create
bin/rails db:migrate
```

### 5. Run the application

Start the development server with Tailwind CSS compilation:

```bash
bin/dev
```

Or run just the Rails server (without Tailwind watch mode):

```bash
bin/rails server
```

The application will be available at `http://localhost:3000`.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | PostgreSQL connection string. Optional for local development. |
| `GITHUB_CLIENT_ID` | OAuth App Client ID from GitHub (Settings > Developer settings > OAuth Apps) |
| `GITHUB_CLIENT_SECRET` | OAuth App Client Secret from GitHub |
| `GITHUB_TOKEN` | Personal Access Token for GitHub API access (Settings > Developer settings > Personal access tokens) |

## Using Supabase

To use Supabase as your PostgreSQL database:

1. Create a new project at [supabase.com](https://supabase.com)
2. Get your connection string from Project Settings > Database
3. Set the `DATABASE_URL` in your `.env` file:

```
DATABASE_URL=postgres://postgres.[project-ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres
```

## Development

### Running tests

```bash
bin/rails test
```

### Linting

```bash
bin/rails tailwindcss:build
```

### Adding schema annotations to models

After running migrations, annotate your models:

```bash
bin/rails annotate_models
```

## License

MIT
