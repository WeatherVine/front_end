# Weather Vine Front End Application

## About this Project
Weather Vine is an educational app for consumers to connect more deeply with the wine they enjoy. Explore wines from a region and see how the climate has influenced the very wine one drinks!   

## Table of Contents

  - [Getting Started](#getting-started)
  - [Running the tests](#running-the-tests)
  - [OAuth with Google](#oauth-with-google)
  - [Service Oriented Architecture](#service-oriented-architecture)
  - [Application Code](#application-code)
  - [Built With](#built-with)
  - [Contributing](#contributing)
  - [Versioning](#versioning)
  - [Authors](#authors)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

## Getting Started

To get the web application running, please fork and clone down the repo.
`git clone <your@github.account:WeatherVine/front_end.git>`

### Prerequisites

To run this application you will need Ruby 2.5.3 and Rails 5.2.5

### Installing

- Install the gem packages  
`bundle install`

- Create the database by running the following command in your terminal
`rails db{:drop, :create, :migrate}`

## Running the tests
RSpec testing suite is utilized for testing this application.
- Run the RSpec suite to ensure everything is passing as expected  
`bundle exec rspec`

## OAuth with Google
To get started with OAuth, please make sure to install the following gems:
  - `gem omniauth`
  - `gem omniauth-google-oauth2`: This specifies a unique provider(Google in our case)
  - `gem omniauth-rails_csrf_protection`: Make sure no vulnerabilities exist in the code

Run `bundle install`

This project will also require the gem `figaro`. Please add this in the development/ test part of the Gemfile.
  `gem figaro`

  - Run `bundle exec figaro install `
  - This will generate an `application.yml` file within the `config` folder.

    **It is imperative that the `application.yml` file is added to `.gitignore` so that the `env[VARS]` are not pushed up to production.**

  - Add `application.yml` to `.gitignore` like so:
  `# Ignore application configuration
  /config/application.yml`

Next, we will want to get the necessary variables from Google. Navigate to the Google developer's console: https://console.developers.google.com

- Click `Create a New Project`
  - Fill in the section for name with name of application i.e. WeatherVine
  - Click `View Project`: Takes user to the dashboard view to set up variables
  - Scroll down to `Getting Started` tab and click on `Explore and enable APIs`
  - Choose `Config Consent Screen`: Allows user to choose which Google account they would like to log in with
  - Fill out the application name i.e. WeatherVine
    - If hosting on a website like Heroku, will need to add Heroku website to `Authorized Domains` section before saving

Now it's time to create the Google credentials. Click on `Credentials` in the left tab
 - Create Oauth CLIENT_ID
  - Choose `web applications` and add name of application here
  - Add in authorized redirect URI: This makes a true `http` request to Google and where the callback is added
  - The callback should look like this:
  `http://localhost:3000/auth/google_oauth2/callback`
  - Click `Create` at this point, the Google credentials for CLIENT_ID and CLIENT_SECRET have been created

Add the credentials inside the `application.yml` file located within `/config`
  - Make sure to add these in like so with no quotes and all caps for the keys:
      - GOOGLE_CLIENT_ID: < add client id here >
      - GOOGLE_CLIENT_SECRET: < add client secret here >

Set up middleware: Middle ware is a link that says sign in with Google so that we're not processing the request
 - Located in `/config/initializers`, add a file called `omniauth.rb`
  - Add the following inside this file:
    ```ruby
      Rails.application.config.middleware.use OmniAuth::Builder do
        provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], :skip_jwt=>true
      end
    ```
    **Whatever is listed as the key for the `ENV` has to match exactly as what exists within the `application.yml` file**

## Service Oriented Architecture
The following is a depiction of the overall service oriented architecture for this application which includes a Rails Front End application, a Rails Engine on the Back End, and two microservices that call out to a World Weather Online's api and Quini Wine's api:

 ![service_oriented_architecture](https://user-images.githubusercontent.com/23460878/115339977-77e4fb80-a16b-11eb-8653-cf989f600b57.png)

## Endpoints

## Built With
- Ruby
- Rails
- RSpec
- FactoryBot
- Faker


## Versioning
- Ruby 2.5.3
- Rails 5.2.5

## Authors
- **Adam Bowers**
| [GitHub](https://github.com/Pragmaticpraxis37) |
  [LinkedIn](https://www.linkedin.com/in/adam-bowers-06a871209/)
- **Alex Schwartz**
| [GitHub](https://github.com/aschwartz1) |
  [LinkedIn](https://www.linkedin.com/in/alex-s-77659758/)
- **Diana Buffone**
| [GitHub](https://github.com/Diana20920) |
  [LinkedIn](https://www.linkedin.com/in/dianabuffone/)
- **Katy La Tour**
| [GitHub](https://github.com/klatour324) |
  [LinkedIn](https://www.linkedin.com/in/klatour324/)
- **Tommy Nieuwenhuis**
|  [GitHub](https://github.com/tsnieuwen) |
    [LinkedIn](https://www.linkedin.com/in/thomasnieuwenhuis/)
- **Trevor Suter**
|    [GitHub](https://github.com/trevorsuter) |
    [LinkedIn](https://www.linkedin.com/in/trevor-suter-216207203/)
- **Wil McCauley**
|    [GitHub](https://github.com/wil-mcc) |
    [LinkedIn](https://www.linkedin.com/in/wil-mccauley/)
