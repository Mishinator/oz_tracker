FROM ruby:3.2.2

# Set production environment
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Install necessary packages
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client libvips-dev imagemagick && rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN npm install --global yarn

# Set the application directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install --without development test

# Copy the entire application
COPY . .

# Install Node dependencies
RUN yarn install --production

# Install esbuild
RUN yarn add esbuild

# Precompile assets
RUN rails assets:precompile

# Set the default command to run the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
