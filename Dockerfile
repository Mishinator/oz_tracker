FROM ruby:3.2.2

# Set production environment
ENV RAILS_ENV=production

# Install necessary packages
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client

# Install Yarn
RUN npm install --global yarn

# Set the application directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the entire application
COPY . .

# Install Node dependencies
RUN yarn install

# Install esbuild
RUN yarn add esbuild

# Precompile assets
RUN rails assets:precompile

# Set the default command to run the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
