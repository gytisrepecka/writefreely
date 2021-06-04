-- DROP SCHEMA dev_writefreely;

-- CREATE SCHEMA dev_writefreely AUTHORIZATION dev_writefreely;

-- DROP SEQUENCE collections_id_seq;

CREATE SEQUENCE collections_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE remoteusers_id_seq;

CREATE SEQUENCE remoteusers_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE users_id_seq;

CREATE SEQUENCE users_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- accesstokens definition

-- Drop table

-- DROP TABLE accesstokens;

CREATE TABLE accesstokens (
	"token" bytea NOT NULL,
	user_id int4 NOT NULL,
	sudo bool NOT NULL DEFAULT false,
	one_time bool NOT NULL DEFAULT false,
	created timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	expires timestamptz NULL,
	user_agent varchar(255) NULL DEFAULT NULL::character varying,
	CONSTRAINT idx_16475_primary PRIMARY KEY (token)
);


-- appcontent definition

-- Drop table

-- DROP TABLE appcontent;

CREATE TABLE appcontent (
	id varchar(36) NOT NULL,
	"content" text NOT NULL,
	updated timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	title varchar(255) NULL DEFAULT NULL::character varying,
	content_type varchar(36) NOT NULL DEFAULT 'page'::character varying,
	CONSTRAINT idx_16485_primary PRIMARY KEY (id)
);


-- appmigrations definition

-- Drop table

-- DROP TABLE appmigrations;

CREATE TABLE appmigrations (
	"version" int8 NOT NULL,
	migrated timestamptz NOT NULL,
	"result" text NOT NULL
);


-- collectionattributes definition

-- Drop table

-- DROP TABLE collectionattributes;

CREATE TABLE collectionattributes (
	collection_id int4 NOT NULL,
	"attribute" varchar(128) NOT NULL,
	value varchar(255) NOT NULL,
	CONSTRAINT idx_16500_primary PRIMARY KEY (collection_id, attribute)
);


-- collectionkeys definition

-- Drop table

-- DROP TABLE collectionkeys;

CREATE TABLE collectionkeys (
	collection_id int4 NOT NULL,
	public_key bytea NOT NULL,
	private_key bytea NOT NULL,
	CONSTRAINT idx_16503_primary PRIMARY KEY (collection_id)
);


-- collectionpasswords definition

-- Drop table

-- DROP TABLE collectionpasswords;

CREATE TABLE collectionpasswords (
	collection_id int4 NOT NULL,
	"password" bpchar(60) NOT NULL,
	CONSTRAINT idx_16509_primary PRIMARY KEY (collection_id)
);


-- collectionredirects definition

-- Drop table

-- DROP TABLE collectionredirects;

CREATE TABLE collectionredirects (
	prev_alias varchar(100) NOT NULL,
	new_alias varchar(100) NOT NULL,
	CONSTRAINT idx_16512_primary PRIMARY KEY (prev_alias)
);


-- collections definition

-- Drop table

-- DROP TABLE collections;

CREATE TABLE collections (
	id serial NOT NULL,
	alias varchar(100) NULL DEFAULT NULL::character varying,
	title varchar(255) NOT NULL,
	description varchar(160) NOT NULL,
	style_sheet text NULL,
	script text NULL,
	post_signature text NULL,
	format varchar(8) NULL DEFAULT NULL::character varying,
	privacy bool NOT NULL,
	owner_id int4 NOT NULL,
	view_count int4 NOT NULL,
	CONSTRAINT idx_16517_primary PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_16517_alias ON collections USING btree (alias);


-- oauth_client_states definition

-- Drop table

-- DROP TABLE oauth_client_states;

CREATE TABLE oauth_client_states (
	state varchar(255) NOT NULL,
	used bool NOT NULL,
	created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	provider varchar(24) NOT NULL DEFAULT ''::character varying,
	client_id varchar(128) NOT NULL DEFAULT ''::character varying,
	attach_user_id int8 NULL,
	invite_code bpchar(6) NULL DEFAULT NULL::bpchar
);
CREATE UNIQUE INDEX idx_16526_state ON oauth_client_states USING btree (state);


-- oauth_users definition

-- Drop table

-- DROP TABLE oauth_users;

CREATE TABLE oauth_users (
	user_id int8 NOT NULL,
	remote_user_id varchar(128) NOT NULL,
	provider varchar(24) NOT NULL DEFAULT ''::character varying,
	client_id varchar(128) NOT NULL DEFAULT ''::character varying,
	access_token varchar(512) NOT NULL DEFAULT ''::character varying
);
CREATE UNIQUE INDEX idx_16533_oauth_users_uk ON oauth_users USING btree (user_id, provider, client_id);


-- posts definition

-- Drop table

-- DROP TABLE posts;

CREATE TABLE posts (
	id bpchar(16) NOT NULL,
	slug varchar(100) NULL DEFAULT NULL::character varying,
	modify_token bpchar(32) NULL DEFAULT NULL::bpchar,
	text_appearance bpchar(4) NOT NULL DEFAULT 'norm'::bpchar,
	"language" bpchar(2) NULL DEFAULT NULL::bpchar,
	rtl bool NULL,
	privacy bool NOT NULL,
	owner_id int4 NULL,
	collection_id int4 NULL,
	pinned_position bool NULL,
	created timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	view_count int4 NOT NULL,
	title varchar(160) NOT NULL,
	"content" text NOT NULL,
	CONSTRAINT idx_16542_primary PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_16542_id_slug ON posts USING btree (collection_id, slug);
CREATE UNIQUE INDEX idx_16542_owner_id ON posts USING btree (owner_id, id);
CREATE INDEX idx_16542_owner_id_2 ON posts USING btree (owner_id, id);
CREATE INDEX idx_16542_privacy_id ON posts USING btree (privacy, id);


-- remotefollows definition

-- Drop table

-- DROP TABLE remotefollows;

CREATE TABLE remotefollows (
	collection_id int8 NOT NULL,
	remote_user_id int8 NOT NULL,
	created timestamptz NOT NULL,
	CONSTRAINT idx_16554_primary PRIMARY KEY (collection_id, remote_user_id)
);


-- remoteuserkeys definition

-- Drop table

-- DROP TABLE remoteuserkeys;

CREATE TABLE remoteuserkeys (
	id varchar(255) NOT NULL,
	remote_user_id int8 NOT NULL,
	public_key bytea NOT NULL,
	CONSTRAINT idx_16557_primary PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_16557_follower_id ON remoteuserkeys USING btree (remote_user_id);


-- remoteusers definition

-- Drop table

-- DROP TABLE remoteusers;

CREATE TABLE remoteusers (
	id bigserial NOT NULL,
	actor_id varchar(255) NOT NULL,
	inbox varchar(255) NOT NULL,
	shared_inbox varchar(255) NOT NULL,
	handle varchar(255) NULL DEFAULT NULL::character varying,
	CONSTRAINT idx_16565_primary PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_16565_collection_id ON remoteusers USING btree (actor_id);


-- userattributes definition

-- Drop table

-- DROP TABLE userattributes;

CREATE TABLE userattributes (
	user_id int4 NOT NULL,
	"attribute" varchar(64) NOT NULL,
	value varchar(255) NOT NULL,
	CONSTRAINT idx_16573_primary PRIMARY KEY (user_id, attribute)
);


-- userinvites definition

-- Drop table

-- DROP TABLE userinvites;

CREATE TABLE userinvites (
	id bpchar(6) NOT NULL,
	owner_id int8 NOT NULL,
	max_uses int2 NULL,
	created timestamptz NOT NULL,
	expires timestamptz NULL,
	inactive bool NOT NULL
);


-- users definition

-- Drop table

-- DROP TABLE users;

CREATE TABLE users (
	id serial NOT NULL,
	username varchar(100) NOT NULL,
	"password" bpchar(60) NOT NULL,
	email bytea NULL,
	created timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status int8 NOT NULL DEFAULT '0'::bigint,
	CONSTRAINT idx_16581_primary PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_16581_username ON users USING btree (username);


-- usersinvited definition

-- Drop table

-- DROP TABLE usersinvited;

CREATE TABLE usersinvited (
	invite_id bpchar(6) NOT NULL,
	user_id int8 NOT NULL
);
