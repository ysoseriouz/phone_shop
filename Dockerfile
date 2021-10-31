# syntax=docker/dockerfile:1
FROM ruby:3.0.1
RUN apt-get update -qq && apt-get install -y imagemagick freetds-dev

# Set an environment variable to store where the app is installed inside
# of the Docker image.
WORKDIR /src
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]