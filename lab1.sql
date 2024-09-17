CREATE DATABASE "Lab 1"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;CREATE TABLE public.users
(
    id serial,
    firstname character varying(50),
    lastname character varying(50),
    isadmin boolean DEFAULT false,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

CREATE TABLE public.tasks
(
    id serial,
    name character varying(50),
    user_id integer
);

ALTER TABLE IF EXISTS public.tasks
    OWNER to postgres;DROP TABLE IF EXISTS tasks;
DROP DATABASE IF EXISTS Lab 1;
