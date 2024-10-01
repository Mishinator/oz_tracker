# Project Setup Instructions

## Technologies
- Rails 7.0.8.4
- Ruby 3.2.2
- Node 18.17.0

## Steps to Setup

1. Install Ruby and Gems
    ```bash
    bundle install
    ```

2. Install Node version 18.17.0
    ```bash
    nvm use 18
    ```

3. Install Yarn dependencies
    ```bash
    yarn install
    ```

4. Add Esbuild
    ```bash
    yarn add esbuild
    ```

5. Install Rails JavaScript using Esbuild
    ```bash
    rails javascript:install:esbuild
    ```

6. Precompile Assets
    ```bash
    rails assets:precompile
    ```

7. Set up the database:
    ```bash
    rails db:create
    rails db
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    rails db:migrate
    ```

8. Start Sidekiq:
    ```bash
    bundle exec sidekiq
    ```

9. Start Rails Server:
    ```bash
    bundle exec rails s
    ```

## Live Demo
[Deployed Site](https://oztracker-production.up.railway.app)
