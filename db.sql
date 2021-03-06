DROP DATABASE motion;
CREATE DATABASE motion;
ALTER DATABASE motion DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
use motion;
CREATE TABLE events ( id int primary key auto_increment, camera integer, event integer, filename character varying(255), frame integer, file_type integer, event_timestamp timestamp, created_at timestamp NOT NULL, updated_at timestamp NOT NULL, deleted TINYINT(1) NOT NULL DEFAULT '0', key (camera)) engine=innodb;
CREATE TABLE users (id int primary key auto_increment, name character varying(255), password character varying(255), role character varying(255) NOT NULL DEFAULT 'user', enable TINYINT(1) NOT NULL DEFAULT '1', theme int NOT NULL DEFAULT '1', create_date timestamp, last_login timestamp NOT NULL) engine=innodb;
INSERT INTO users (name,password,role) values ('admin', '21232f297a57a5a743894a0e4a801fc3', 'admin');
CREATE TABLE cameras (id int primary key auto_increment, name character varying(255)) engine=innodb;
CREATE TABLE log (id int primary key auto_increment, type character varying(255), text character varying(255), event_timestamp timestamp) engine=innodb;
CREATE TABLE themes (id int primary key auto_increment, name character varying(255) NOT NULL, filename character varying(255) NOT NULL) engine=innodb;
INSERT INTO themes (name, filename) VALUES ('Orig', 'bootstrap_orig.css');
INSERT INTO themes (name, filename) VALUES ('Cosmo', 'bootstrap_cosmo.css');
INSERT INTO themes (name, filename) VALUES ('Cyborg', 'bootstrap_cyborg.css');
INSERT INTO themes (name, filename) VALUES ('Flatly', 'bootstrap_flatly.css');
INSERT INTO themes (name, filename) VALUES ('Journal', 'bootstrap_journal.css');
INSERT INTO themes (name, filename) VALUES ('Lumen', 'bootstrap_lumen.css');
INSERT INTO themes (name, filename) VALUES ('Readable', 'bootstrap_readable.css');
INSERT INTO themes (name, filename) VALUES ('Simplex', 'bootstrap_simplex.css');
INSERT INTO themes (name, filename) VALUES ('Slate', 'bootstrap_slate.css');
INSERT INTO themes (name, filename) VALUES ('Spacelab', 'bootstrap_spacelab.css');
INSERT INTO themes (name, filename) VALUES ('Superhero', 'bootstrap_superhero.css');
INSERT INTO themes (name, filename) VALUES ('Yeti', 'bootstrap_yeti.css');
GRANT ALL PRIVILEGES ON *.* TO motion@localhost IDENTIFIED BY 'base64' WITH GRANT OPTION;
