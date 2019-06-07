DROP DATABASE IF EXISTS the_recruiter;
CREATE DATABASE the_recruiter;

\c the_recruiter

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  password_digest VARCHAR(60),
  player_user BOOLEAN,
  college_user BOOLEAN
);

CREATE TABLE colleges(
  id SERIAL PRIMARY KEY,
  name VARCHAR(32),
  school_name VARCHAR(255),
  location VARCHAR(255), 
  user_id INTEGER REFERENCES users(id)
);
CREATE TABLE players(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  school_name VARCHAR(255),
  location VARCHAR(32),
  height NUMERIC NOT NULL DEFAULT 'NaN',
  weight NUMERIC NOT NULL DEFAULT 'NaN',
  stats VARCHAR(255),
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE positions(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);
CREATE TABLE college_needs(
  id SERIAL PRIMARY KEY,
  college_id INTEGER REFERENCES colleges(id), 
  position_id INTEGER REFERENCES positions(id) 
                                                

);
CREATE TABLE player_positions(
  id SERIAL PRIMARY KEY,
  player_id INTEGER REFERENCES players(id),
  position_id INTEGER REFERENCES positions(id)
);




