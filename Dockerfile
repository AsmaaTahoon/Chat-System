FROM ruby:2.6.3
COPY . /home/app/
WORKDIR /home/app
RUN bundle install
EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
