--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.virtual_tickets DROP CONSTRAINT IF EXISTS virtual_tickets_ticket_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.virtual_tickets DROP CONSTRAINT IF EXISTS virtual_tickets_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tickets DROP CONSTRAINT IF EXISTS tickets_sale_id_fkey;
ALTER TABLE IF EXISTS ONLY public.ticket_types DROP CONSTRAINT IF EXISTS ticket_types_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seats DROP CONSTRAINT IF EXISTS seats_section_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seat_sections DROP CONSTRAINT IF EXISTS seat_sections_seat_map_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seat_maps DROP CONSTRAINT IF EXISTS seat_maps_template_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seat_maps DROP CONSTRAINT IF EXISTS seat_maps_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.seat_map_templates DROP CONSTRAINT IF EXISTS seat_map_templates_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.sales DROP CONSTRAINT IF EXISTS sales_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales DROP CONSTRAINT IF EXISTS sales_ticket_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales DROP CONSTRAINT IF EXISTS sales_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.refunds DROP CONSTRAINT IF EXISTS refunds_payment_id_fkey;
ALTER TABLE IF EXISTS ONLY public.physical_tickets DROP CONSTRAINT IF EXISTS physical_tickets_ticket_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.physical_tickets DROP CONSTRAINT IF EXISTS physical_tickets_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_sale_id_fkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_folders DROP CONSTRAINT IF EXISTS media_folders_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_seat_map_id_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_organizer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_additional_data DROP CONSTRAINT IF EXISTS event_additional_data_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.check_in_records DROP CONSTRAINT IF EXISTS check_in_records_sale_id_fkey;
ALTER TABLE IF EXISTS ONLY public.check_in_records DROP CONSTRAINT IF EXISTS check_in_records_event_id_fkey;
DROP TRIGGER IF EXISTS update_virtual_tickets_updated_at ON public.virtual_tickets;
DROP TRIGGER IF EXISTS update_users_updated_at ON public.users;
DROP TRIGGER IF EXISTS update_ticket_types_updated_at ON public.ticket_types;
DROP TRIGGER IF EXISTS update_seat_maps_updated_at ON public.seat_maps;
DROP TRIGGER IF EXISTS update_seat_map_templates_updated_at ON public.seat_map_templates;
DROP TRIGGER IF EXISTS update_sales_updated_at ON public.sales;
DROP TRIGGER IF EXISTS update_sales_points_updated_at ON public.sales_points;
DROP TRIGGER IF EXISTS update_refunds_updated_at ON public.refunds;
DROP TRIGGER IF EXISTS update_physical_tickets_updated_at ON public.physical_tickets;
DROP TRIGGER IF EXISTS update_payments_updated_at ON public.payments;
DROP TRIGGER IF EXISTS update_payment_methods_updated_at ON public.payment_methods;
DROP TRIGGER IF EXISTS update_media_folders_updated_at ON public.media_folders;
DROP TRIGGER IF EXISTS update_media_files_updated_at ON public.media_files;
DROP TRIGGER IF EXISTS update_events_updated_at ON public.events;
DROP TRIGGER IF EXISTS update_event_additional_data_updated_at ON public.event_additional_data;
DROP TRIGGER IF EXISTS update_categories_updated_at ON public.categories;
DROP INDEX IF EXISTS public.unique_seat_per_section;
DROP INDEX IF EXISTS public.idx_virtual_tickets_status;
DROP INDEX IF EXISTS public.idx_virtual_tickets_number;
DROP INDEX IF EXISTS public.idx_virtual_tickets_event;
DROP INDEX IF EXISTS public.idx_virtual_tickets_customer_email;
DROP INDEX IF EXISTS public.idx_virtual_tickets_created;
DROP INDEX IF EXISTS public.idx_users_status;
DROP INDEX IF EXISTS public.idx_users_role;
DROP INDEX IF EXISTS public.idx_users_phone;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_tickets_status;
DROP INDEX IF EXISTS public.idx_tickets_sale;
DROP INDEX IF EXISTS public.idx_tickets_code;
DROP INDEX IF EXISTS public.idx_ticket_types_status;
DROP INDEX IF EXISTS public.idx_ticket_types_event;
DROP INDEX IF EXISTS public.idx_seats_status;
DROP INDEX IF EXISTS public.idx_seats_section;
DROP INDEX IF EXISTS public.idx_seat_sections_map;
DROP INDEX IF EXISTS public.idx_scheduled_reports_status;
DROP INDEX IF EXISTS public.idx_scheduled_reports_next_run;
DROP INDEX IF EXISTS public.idx_saved_reports_created_by;
DROP INDEX IF EXISTS public.idx_sales_user;
DROP INDEX IF EXISTS public.idx_sales_status;
DROP INDEX IF EXISTS public.idx_sales_points_status;
DROP INDEX IF EXISTS public.idx_sales_points_name;
DROP INDEX IF EXISTS public.idx_sales_event;
DROP INDEX IF EXISTS public.idx_sales_created;
DROP INDEX IF EXISTS public.idx_refunds_status;
DROP INDEX IF EXISTS public.idx_refunds_payment;
DROP INDEX IF EXISTS public.idx_physical_tickets_status;
DROP INDEX IF EXISTS public.idx_physical_tickets_event;
DROP INDEX IF EXISTS public.idx_physical_tickets_created;
DROP INDEX IF EXISTS public.idx_physical_tickets_batch_number;
DROP INDEX IF EXISTS public.idx_payments_status;
DROP INDEX IF EXISTS public.idx_payments_sale;
DROP INDEX IF EXISTS public.idx_payments_gateway_transaction;
DROP INDEX IF EXISTS public.idx_password_reset_tokens_user_id;
DROP INDEX IF EXISTS public.idx_password_reset_tokens_expires_at;
DROP INDEX IF EXISTS public.idx_notifications_type;
DROP INDEX IF EXISTS public.idx_notifications_target;
DROP INDEX IF EXISTS public.idx_notifications_sent_at;
DROP INDEX IF EXISTS public.idx_media_folders_parent;
DROP INDEX IF EXISTS public.idx_media_files_upload_date;
DROP INDEX IF EXISTS public.idx_media_files_type;
DROP INDEX IF EXISTS public.idx_media_files_folder;
DROP INDEX IF EXISTS public.idx_events_video_url;
DROP INDEX IF EXISTS public.idx_events_status;
DROP INDEX IF EXISTS public.idx_events_slug;
DROP INDEX IF EXISTS public.idx_events_organizer;
DROP INDEX IF EXISTS public.idx_events_main_image;
DROP INDEX IF EXISTS public.idx_events_featured;
DROP INDEX IF EXISTS public.idx_events_date;
DROP INDEX IF EXISTS public.idx_events_category;
DROP INDEX IF EXISTS public.idx_event_additional_data_event_key;
DROP INDEX IF EXISTS public.idx_check_in_records_ticket_number;
DROP INDEX IF EXISTS public.idx_check_in_records_event_id;
DROP INDEX IF EXISTS public.idx_check_in_records_check_in_time;
DROP INDEX IF EXISTS public.idx_categories_status;
DROP INDEX IF EXISTS public.idx_categories_slug;
DROP INDEX IF EXISTS public.idx_audit_logs_user_id;
DROP INDEX IF EXISTS public.idx_audit_logs_timestamp;
DROP INDEX IF EXISTS public.idx_audit_logs_severity;
DROP INDEX IF EXISTS public.idx_audit_logs_action;
ALTER TABLE IF EXISTS ONLY public.virtual_tickets DROP CONSTRAINT IF EXISTS virtual_tickets_ticket_number_key;
ALTER TABLE IF EXISTS ONLY public.virtual_tickets DROP CONSTRAINT IF EXISTS virtual_tickets_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.tickets DROP CONSTRAINT IF EXISTS tickets_ticket_code_key;
ALTER TABLE IF EXISTS ONLY public.tickets DROP CONSTRAINT IF EXISTS tickets_pkey;
ALTER TABLE IF EXISTS ONLY public.ticket_types DROP CONSTRAINT IF EXISTS ticket_types_pkey;
ALTER TABLE IF EXISTS ONLY public.seats DROP CONSTRAINT IF EXISTS seats_pkey;
ALTER TABLE IF EXISTS ONLY public.seat_sections DROP CONSTRAINT IF EXISTS seat_sections_pkey;
ALTER TABLE IF EXISTS ONLY public.seat_maps DROP CONSTRAINT IF EXISTS seat_maps_pkey;
ALTER TABLE IF EXISTS ONLY public.seat_map_templates DROP CONSTRAINT IF EXISTS seat_map_templates_pkey;
ALTER TABLE IF EXISTS ONLY public.scheduled_reports DROP CONSTRAINT IF EXISTS scheduled_reports_pkey;
ALTER TABLE IF EXISTS ONLY public.saved_reports DROP CONSTRAINT IF EXISTS saved_reports_pkey;
ALTER TABLE IF EXISTS ONLY public.sales_points DROP CONSTRAINT IF EXISTS sales_points_pkey;
ALTER TABLE IF EXISTS ONLY public.sales DROP CONSTRAINT IF EXISTS sales_pkey;
ALTER TABLE IF EXISTS ONLY public.refunds DROP CONSTRAINT IF EXISTS refunds_pkey;
ALTER TABLE IF EXISTS ONLY public.physical_tickets DROP CONSTRAINT IF EXISTS physical_tickets_pkey;
ALTER TABLE IF EXISTS ONLY public.physical_tickets DROP CONSTRAINT IF EXISTS physical_tickets_batch_number_key;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_methods DROP CONSTRAINT IF EXISTS payment_methods_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_user_id_key;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.media_folders DROP CONSTRAINT IF EXISTS media_folders_pkey;
ALTER TABLE IF EXISTS ONLY public.media_files DROP CONSTRAINT IF EXISTS media_files_pkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_slug_key;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_pkey;
ALTER TABLE IF EXISTS ONLY public.event_additional_data DROP CONSTRAINT IF EXISTS event_additional_data_pkey;
ALTER TABLE IF EXISTS ONLY public.check_in_records DROP CONSTRAINT IF EXISTS check_in_records_ticket_number_key;
ALTER TABLE IF EXISTS ONLY public.check_in_records DROP CONSTRAINT IF EXISTS check_in_records_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_slug_key;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS ONLY public.backups DROP CONSTRAINT IF EXISTS backups_pkey;
ALTER TABLE IF EXISTS ONLY public.backup_schedules DROP CONSTRAINT IF EXISTS backup_schedules_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS public.virtual_tickets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tickets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.ticket_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seats ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seat_sections ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seat_maps ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.seat_map_templates ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.scheduled_reports ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.saved_reports ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.sales_points ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.sales ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.refunds ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.physical_tickets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.payments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.payment_methods ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.password_reset_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.notifications ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.media_folders ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.media_files ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.event_additional_data ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.check_in_records ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.backups ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.backup_schedules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.audit_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.virtual_tickets_id_seq;
DROP TABLE IF EXISTS public.virtual_tickets;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.tickets_id_seq;
DROP TABLE IF EXISTS public.tickets;
DROP SEQUENCE IF EXISTS public.ticket_types_id_seq;
DROP TABLE IF EXISTS public.ticket_types;
DROP SEQUENCE IF EXISTS public.seats_id_seq;
DROP TABLE IF EXISTS public.seats;
DROP SEQUENCE IF EXISTS public.seat_sections_id_seq;
DROP TABLE IF EXISTS public.seat_sections;
DROP SEQUENCE IF EXISTS public.seat_maps_id_seq;
DROP TABLE IF EXISTS public.seat_maps;
DROP SEQUENCE IF EXISTS public.seat_map_templates_id_seq;
DROP TABLE IF EXISTS public.seat_map_templates;
DROP SEQUENCE IF EXISTS public.scheduled_reports_id_seq;
DROP TABLE IF EXISTS public.scheduled_reports;
DROP SEQUENCE IF EXISTS public.saved_reports_id_seq;
DROP TABLE IF EXISTS public.saved_reports;
DROP SEQUENCE IF EXISTS public.sales_points_id_seq;
DROP TABLE IF EXISTS public.sales_points;
DROP SEQUENCE IF EXISTS public.sales_id_seq;
DROP TABLE IF EXISTS public.sales;
DROP SEQUENCE IF EXISTS public.refunds_id_seq;
DROP TABLE IF EXISTS public.refunds;
DROP SEQUENCE IF EXISTS public.physical_tickets_id_seq;
DROP TABLE IF EXISTS public.physical_tickets;
DROP SEQUENCE IF EXISTS public.payments_id_seq;
DROP TABLE IF EXISTS public.payments;
DROP SEQUENCE IF EXISTS public.payment_methods_id_seq;
DROP TABLE IF EXISTS public.payment_methods;
DROP SEQUENCE IF EXISTS public.password_reset_tokens_id_seq;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP SEQUENCE IF EXISTS public.notifications_id_seq;
DROP VIEW IF EXISTS public.notification_summary;
DROP TABLE IF EXISTS public.notifications;
DROP SEQUENCE IF EXISTS public.media_folders_id_seq;
DROP TABLE IF EXISTS public.media_folders;
DROP SEQUENCE IF EXISTS public.media_files_id_seq;
DROP TABLE IF EXISTS public.media_files;
DROP SEQUENCE IF EXISTS public.events_id_seq;
DROP TABLE IF EXISTS public.events;
DROP SEQUENCE IF EXISTS public.event_additional_data_id_seq;
DROP TABLE IF EXISTS public.event_additional_data;
DROP SEQUENCE IF EXISTS public.check_in_records_id_seq;
DROP TABLE IF EXISTS public.check_in_records;
DROP SEQUENCE IF EXISTS public.categories_id_seq;
DROP TABLE IF EXISTS public.categories;
DROP SEQUENCE IF EXISTS public.backups_id_seq;
DROP TABLE IF EXISTS public.backups;
DROP SEQUENCE IF EXISTS public.backup_schedules_id_seq;
DROP TABLE IF EXISTS public.backup_schedules;
DROP VIEW IF EXISTS public.audit_summary;
DROP SEQUENCE IF EXISTS public.audit_logs_id_seq;
DROP TABLE IF EXISTS public.audit_logs;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    user_name character varying(255) NOT NULL,
    user_email character varying(255) NOT NULL,
    action character varying(100) NOT NULL,
    resource character varying(100) NOT NULL,
    resource_id character varying(255),
    details jsonb,
    ip_address inet NOT NULL,
    user_agent text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    severity character varying(20) DEFAULT 'low'::character varying,
    status character varying(20) DEFAULT 'success'::character varying,
    CONSTRAINT audit_logs_severity_check CHECK (((severity)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'critical'::character varying])::text[]))),
    CONSTRAINT audit_logs_status_check CHECK (((status)::text = ANY ((ARRAY['success'::character varying, 'failure'::character varying, 'warning'::character varying])::text[])))
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: audit_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.audit_summary AS
 SELECT date("timestamp") AS date,
    action,
    severity,
    status,
    count(*) AS count
   FROM public.audit_logs
  GROUP BY (date("timestamp")), action, severity, status;


--
-- Name: backup_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backup_schedules (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    frequency character varying(20) NOT NULL,
    "time" time without time zone NOT NULL,
    retention_days integer DEFAULT 30,
    status character varying(20) DEFAULT 'active'::character varying,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_backup timestamp without time zone,
    next_backup timestamp without time zone,
    CONSTRAINT backup_schedules_frequency_check CHECK (((frequency)::text = ANY ((ARRAY['daily'::character varying, 'weekly'::character varying, 'monthly'::character varying])::text[]))),
    CONSTRAINT backup_schedules_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


--
-- Name: backup_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.backup_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: backup_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.backup_schedules_id_seq OWNED BY public.backup_schedules.id;


--
-- Name: backups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backups (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    size bigint NOT NULL,
    type character varying(50) DEFAULT 'manual'::character varying,
    status character varying(20) DEFAULT 'completed'::character varying,
    created_by character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp without time zone,
    file_path text,
    CONSTRAINT backups_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'completed'::character varying, 'failed'::character varying])::text[])))
);


--
-- Name: backups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.backups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: backups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.backups_id_seq OWNED BY public.backups.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    icon character varying(50),
    color character varying(7) DEFAULT '#3B82F6'::character varying,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT categories_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: check_in_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.check_in_records (
    id integer NOT NULL,
    ticket_number character varying(255) NOT NULL,
    event_name character varying(255) NOT NULL,
    customer_name character varying(255) NOT NULL,
    ticket_type character varying(100) DEFAULT 'General'::character varying,
    check_in_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    gate character varying(100) NOT NULL,
    status character varying(20) DEFAULT 'checked-in'::character varying,
    operator character varying(255) NOT NULL,
    event_id integer,
    sale_id integer,
    CONSTRAINT check_in_records_status_check CHECK (((status)::text = ANY ((ARRAY['checked-in'::character varying, 'pending'::character varying, 'duplicate'::character varying, 'invalid'::character varying])::text[])))
);


--
-- Name: check_in_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.check_in_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: check_in_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.check_in_records_id_seq OWNED BY public.check_in_records.id;


--
-- Name: event_additional_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_additional_data (
    id integer NOT NULL,
    event_id integer NOT NULL,
    data_key character varying(100) NOT NULL,
    data_value text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: event_additional_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_additional_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_additional_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_additional_data_id_seq OWNED BY public.event_additional_data.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    description text,
    long_description text,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    venue character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    category_id integer,
    organizer_id integer NOT NULL,
    total_capacity integer DEFAULT 0,
    price numeric(10,2) DEFAULT 0.00,
    status character varying(20) DEFAULT 'draft'::character varying,
    sales_start_date timestamp without time zone,
    sales_end_date timestamp without time zone,
    youtube_url character varying(500),
    image_url character varying(500),
    featured boolean DEFAULT false,
    seat_map_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    main_image_url character varying(500),
    video_url character varying(500),
    gallery_images jsonb DEFAULT '[]'::jsonb,
    social_links jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT events_status_check CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'published'::character varying, 'cancelled'::character varying, 'completed'::character varying])::text[])))
);


--
-- Name: COLUMN events.main_image_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.events.main_image_url IS 'URL de la imagen principal del evento';


--
-- Name: COLUMN events.video_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.events.video_url IS 'URL del video promocional del evento';


--
-- Name: COLUMN events.gallery_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.events.gallery_images IS 'Array JSON con URLs de imágenes de la galería';


--
-- Name: COLUMN events.social_links; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.events.social_links IS 'JSON con enlaces a redes sociales del evento';


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: media_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_files (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    original_name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    size bigint NOT NULL,
    url text NOT NULL,
    alt_text text,
    description text,
    tags text[],
    folder_id integer,
    upload_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_used timestamp without time zone,
    usage_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT media_files_type_check CHECK (((type)::text = ANY ((ARRAY['image'::character varying, 'video'::character varying, 'audio'::character varying, 'document'::character varying])::text[])))
);


--
-- Name: media_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_files_id_seq OWNED BY public.media_files.id;


--
-- Name: media_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_folders (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent_id integer,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: media_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_folders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_folders_id_seq OWNED BY public.media_folders.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    type character varying(20) DEFAULT 'info'::character varying,
    target character varying(20) DEFAULT 'all'::character varying,
    recipients jsonb,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    read_by jsonb DEFAULT '[]'::jsonb,
    status character varying(20) DEFAULT 'sent'::character varying,
    created_by character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT notifications_status_check CHECK (((status)::text = ANY ((ARRAY['sent'::character varying, 'delivered'::character varying, 'failed'::character varying])::text[]))),
    CONSTRAINT notifications_target_check CHECK (((target)::text = ANY ((ARRAY['all'::character varying, 'admins'::character varying, 'organizers'::character varying, 'users'::character varying, 'specific'::character varying])::text[]))),
    CONSTRAINT notifications_type_check CHECK (((type)::text = ANY ((ARRAY['info'::character varying, 'success'::character varying, 'warning'::character varying, 'error'::character varying])::text[])))
);


--
-- Name: notification_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.notification_summary AS
 SELECT date(sent_at) AS date,
    type,
    target,
    status,
    count(*) AS count
   FROM public.notifications
  GROUP BY (date(sent_at)), type, target, status;


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.password_reset_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    gateway character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    configuration jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_gateway character varying(50) NOT NULL,
    gateway_transaction_id character varying(255),
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'COP'::character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    gateway_response jsonb,
    processed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'processing'::character varying, 'completed'::character varying, 'failed'::character varying, 'cancelled'::character varying, 'refunded'::character varying])::text[])))
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: physical_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.physical_tickets (
    id integer NOT NULL,
    batch_number character varying(50) NOT NULL,
    event_id integer NOT NULL,
    ticket_type_id integer NOT NULL,
    quantity integer NOT NULL,
    printed integer DEFAULT 0,
    sold integer DEFAULT 0,
    price numeric(10,2) NOT NULL,
    sales_point character varying(255) NOT NULL,
    notes text,
    status character varying(20) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    printed_at timestamp without time zone,
    distributed_at timestamp without time zone,
    CONSTRAINT physical_tickets_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'printed'::character varying, 'distributed'::character varying, 'completed'::character varying])::text[])))
);


--
-- Name: physical_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.physical_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: physical_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.physical_tickets_id_seq OWNED BY public.physical_tickets.id;


--
-- Name: refunds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refunds (
    id integer NOT NULL,
    payment_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    reason text,
    status character varying(20) DEFAULT 'pending'::character varying,
    gateway_refund_id character varying(255),
    processed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT refunds_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'processing'::character varying, 'completed'::character varying, 'failed'::character varying])::text[])))
);


--
-- Name: refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refunds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refunds_id_seq OWNED BY public.refunds.id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    user_id integer NOT NULL,
    event_id integer NOT NULL,
    ticket_type_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    payment_method character varying(50),
    payment_reference character varying(255),
    buyer_name character varying(255) NOT NULL,
    buyer_email character varying(255) NOT NULL,
    buyer_phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sales_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'refunded'::character varying])::text[])))
);


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: sales_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_points (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255),
    address text,
    contact_person character varying(255),
    contact_phone character varying(20),
    contact_email character varying(255),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sales_points_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


--
-- Name: sales_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_points_id_seq OWNED BY public.sales_points.id;


--
-- Name: saved_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_reports (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    type character varying(50) NOT NULL,
    filters jsonb,
    schedule jsonb,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: saved_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_reports_id_seq OWNED BY public.saved_reports.id;


--
-- Name: scheduled_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheduled_reports (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    type character varying(50) NOT NULL,
    schedule jsonb NOT NULL,
    recipients jsonb,
    status character varying(20) DEFAULT 'active'::character varying,
    created_by character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_run timestamp without time zone,
    next_run timestamp without time zone,
    CONSTRAINT scheduled_reports_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheduled_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheduled_reports_id_seq OWNED BY public.scheduled_reports.id;


--
-- Name: seat_map_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seat_map_templates (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    template_data jsonb NOT NULL,
    thumbnail_url character varying(500),
    is_public boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: seat_map_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seat_map_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seat_map_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seat_map_templates_id_seq OWNED BY public.seat_map_templates.id;


--
-- Name: seat_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seat_maps (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    venue_name character varying(200),
    total_capacity integer DEFAULT 0,
    map_data jsonb NOT NULL,
    template_id integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: seat_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seat_maps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seat_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seat_maps_id_seq OWNED BY public.seat_maps.id;


--
-- Name: seat_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seat_sections (
    id integer NOT NULL,
    seat_map_id integer NOT NULL,
    name character varying(100) NOT NULL,
    section_type character varying(20) DEFAULT 'seating'::character varying,
    capacity integer DEFAULT 0,
    price_modifier numeric(5,2) DEFAULT 1.00,
    color character varying(7) DEFAULT '#3B82F6'::character varying,
    position_data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seat_sections_section_type_check CHECK (((section_type)::text = ANY ((ARRAY['seating'::character varying, 'standing'::character varying, 'vip'::character varying, 'disabled'::character varying])::text[])))
);


--
-- Name: seat_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seat_sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seat_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seat_sections_id_seq OWNED BY public.seat_sections.id;


--
-- Name: seats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seats (
    id integer NOT NULL,
    section_id integer NOT NULL,
    seat_number character varying(10) NOT NULL,
    row_number character varying(10),
    status character varying(20) DEFAULT 'available'::character varying,
    position_x integer DEFAULT 0,
    position_y integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seats_status_check CHECK (((status)::text = ANY ((ARRAY['available'::character varying, 'reserved'::character varying, 'sold'::character varying, 'blocked'::character varying])::text[])))
);


--
-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


--
-- Name: ticket_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket_types (
    id integer NOT NULL,
    event_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    sold integer DEFAULT 0,
    max_per_order integer DEFAULT 10,
    sale_start timestamp without time zone,
    sale_end timestamp without time zone,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ticket_types_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'sold_out'::character varying])::text[])))
);


--
-- Name: ticket_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_types_id_seq OWNED BY public.ticket_types.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tickets (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    ticket_code character varying(50) NOT NULL,
    qr_code text,
    seat_info jsonb,
    status character varying(20) DEFAULT 'valid'::character varying,
    used_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tickets_status_check CHECK (((status)::text = ANY ((ARRAY['valid'::character varying, 'used'::character varying, 'cancelled'::character varying])::text[])))
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying,
    status character varying(20) DEFAULT 'active'::character varying,
    is_2fa_enabled boolean DEFAULT false,
    two_factor_secret character varying(255),
    email_verified_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login timestamp without time zone,
    phone character varying(20),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'organizer'::character varying, 'user'::character varying])::text[]))),
    CONSTRAINT users_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'suspended'::character varying])::text[])))
);


--
-- Name: COLUMN users.phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.phone IS 'Número de teléfono del usuario';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: virtual_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.virtual_tickets (
    id integer NOT NULL,
    ticket_number character varying(50) NOT NULL,
    event_id integer NOT NULL,
    ticket_type_id integer NOT NULL,
    customer_name character varying(255) NOT NULL,
    customer_email character varying(255) NOT NULL,
    customer_phone character varying(20),
    price numeric(10,2) NOT NULL,
    qr_code text NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    purchase_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    event_date date NOT NULL,
    used_at timestamp without time zone,
    sent_at timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT virtual_tickets_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'used'::character varying, 'cancelled'::character varying, 'expired'::character varying])::text[])))
);


--
-- Name: virtual_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.virtual_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.virtual_tickets_id_seq OWNED BY public.virtual_tickets.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: backup_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_schedules ALTER COLUMN id SET DEFAULT nextval('public.backup_schedules_id_seq'::regclass);


--
-- Name: backups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backups ALTER COLUMN id SET DEFAULT nextval('public.backups_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: check_in_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.check_in_records ALTER COLUMN id SET DEFAULT nextval('public.check_in_records_id_seq'::regclass);


--
-- Name: event_additional_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_additional_data ALTER COLUMN id SET DEFAULT nextval('public.event_additional_data_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: media_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_files ALTER COLUMN id SET DEFAULT nextval('public.media_files_id_seq'::regclass);


--
-- Name: media_folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_folders ALTER COLUMN id SET DEFAULT nextval('public.media_folders_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: physical_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.physical_tickets ALTER COLUMN id SET DEFAULT nextval('public.physical_tickets_id_seq'::regclass);


--
-- Name: refunds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refunds ALTER COLUMN id SET DEFAULT nextval('public.refunds_id_seq'::regclass);


--
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: sales_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_points ALTER COLUMN id SET DEFAULT nextval('public.sales_points_id_seq'::regclass);


--
-- Name: saved_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports ALTER COLUMN id SET DEFAULT nextval('public.saved_reports_id_seq'::regclass);


--
-- Name: scheduled_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_reports ALTER COLUMN id SET DEFAULT nextval('public.scheduled_reports_id_seq'::regclass);


--
-- Name: seat_map_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_map_templates ALTER COLUMN id SET DEFAULT nextval('public.seat_map_templates_id_seq'::regclass);


--
-- Name: seat_maps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_maps ALTER COLUMN id SET DEFAULT nextval('public.seat_maps_id_seq'::regclass);


--
-- Name: seat_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_sections ALTER COLUMN id SET DEFAULT nextval('public.seat_sections_id_seq'::regclass);


--
-- Name: seats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


--
-- Name: ticket_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_types ALTER COLUMN id SET DEFAULT nextval('public.ticket_types_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: virtual_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_tickets ALTER COLUMN id SET DEFAULT nextval('public.virtual_tickets_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_logs (id, user_id, user_name, user_email, action, resource, resource_id, details, ip_address, user_agent, "timestamp", severity, status) FROM stdin;
1	admin1	Admin Principal	admin@eventu.co	LOGIN	auth	\N	{"method": "email", "success": true}	192.168.1.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36	2025-08-25 12:48:29.72124	low	success
2	admin1	Admin Principal	admin@eventu.co	CREATE_EVENT	events	\N	{"eventId": "event123", "eventTitle": "Conferencia Tech 2024"}	192.168.1.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36	2025-08-25 12:48:29.72124	medium	success
\.


--
-- Data for Name: backup_schedules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.backup_schedules (id, name, frequency, "time", retention_days, status, created_by, created_at, last_backup, next_backup) FROM stdin;
\.


--
-- Data for Name: backups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.backups (id, filename, size, type, status, created_by, created_at, completed_at, file_path) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, slug, description, icon, color, status, created_at, updated_at) FROM stdin;
1	Conciertos	conciertos	Eventos musicales y conciertos en vivo	Music	#FF6B6B	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
2	Teatro	teatro	Obras de teatro y espectáculos dramáticos	Drama	#4ECDC4	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
3	Deportes	deportes	Eventos deportivos y competencias	Trophy	#45B7D1	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
4	Conferencias	conferencias	Conferencias, seminarios y eventos corporativos	Users	#96CEB4	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
5	Festivales	festivales	Festivales culturales y gastronómicos	Star	#FFEAA7	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
6	Familiar	familiar	Eventos para toda la familia	Heart	#DDA0DD	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
7	Educación	educacion	Talleres, cursos y eventos educativos	BookOpen	#98D8C8	active	2025-08-19 16:06:26.149857	2025-08-19 16:06:26.149857
\.


--
-- Data for Name: check_in_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.check_in_records (id, ticket_number, event_name, customer_name, ticket_type, check_in_time, gate, status, operator, event_id, sale_id) FROM stdin;
\.


--
-- Data for Name: event_additional_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_additional_data (id, event_id, data_key, data_value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, title, slug, description, long_description, date, "time", venue, location, category_id, organizer_id, total_capacity, price, status, sales_start_date, sales_end_date, youtube_url, image_url, featured, seat_map_id, created_at, updated_at, main_image_url, video_url, gallery_images, social_links) FROM stdin;
3	Obra: Romeo y Julieta	obra-romeo-julieta	Clásica obra de Shakespeare	La compañía de teatro más prestigiosa del país presenta esta obra maestra de William Shakespeare con una puesta en escena moderna y emotiva.	2024-02-20	19:30:00	Teatro Colón	BOGOTÁ	2	26	400	35000.00	published	2024-01-10 00:00:00	\N	\N	/images/romeo-julieta.jpg	f	\N	2025-08-19 16:06:26.156369	2025-08-29 16:01:10.785409	/images/romeo-julieta.jpg	\N	[]	{}
5	Partido Clásico: Millonarios vs Nacional	partido-millonarios-nacional	El clásico más esperado del fútbol colombiano	El encuentro más emocionante del fútbol profesional colombiano. Dos equipos históricos se enfrentan en un partido que promete emociones fuertes.	2024-03-25	16:00:00	Estadio El Campín	BOGOTÁ	3	3	1200	25000.00	published	2024-02-25 00:00:00	\N	\N	/images/clasico-futbol.jpg	t	2	2025-08-19 16:06:26.156369	2025-08-26 10:11:24.240431	/images/clasico-futbol.jpg	\N	[]	{}
7	Feria de Emprendimiento Digital	feria-emprendimiento-digital	Conecta con startups y emprendedores	El evento más importante para emprendedores digitales en Colombia. Networking, conferencias magistrales, pitch competitions y oportunidades de inversión.	2024-04-20	08:00:00	Centro de Convenciones Ágora	MEDELLÍN	4	3	800	75000.00	published	2024-02-15 00:00:00	\N	\N	/images/emprendimiento-digital.jpg	t	\N	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/emprendimiento-digital.jpg	\N	[]	{}
9	Obra: La Casa de Bernarda Alba	obra-casa-bernarda-alba	Clásico de Federico García Lorca	Una magistral puesta en escena de una de las obras más importantes del teatro español. Dirigida por María Elena Sarmiento con un elenco de lujo.	2024-03-30	20:00:00	Teatro Nacional La Castellana	BOGOTÁ	2	3	350	42000.00	published	2024-02-01 00:00:00	\N	\N	/images/bernarda-alba.jpg	f	\N	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/bernarda-alba.jpg	\N	[]	{}
11	Seminario de Inteligencia Artificial	seminario-inteligencia-artificial	El futuro de la IA en América Latina	Expertos internacionales comparten las últimas tendencias en IA, Machine Learning y Deep Learning. Incluye talleres prácticos y certificación.	2024-04-15	09:00:00	Universidad de los Andes	BOGOTÁ	7	3	200	150000.00	published	2024-02-20 00:00:00	\N	\N	/images/ai-seminar.jpg	f	\N	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/ai-seminar.jpg	\N	[]	{}
4	Conferencia Tech Summit 2024	tech-summit-2024	La conferencia de tecnología más importante del año	Líderes de la industria tecnológica se reúnen para compartir las últimas tendencias en IA, blockchain, desarrollo web y más. Networking y oportunidades de negocio.	2024-04-10	09:00:00	Centro Empresarial	BOGOTÁ	4	2	300	120000.00	published	2024-02-01 00:00:00	\N	https://youtube.com/watch?v=example3	/images/tech-summit.jpg	t	\N	2025-08-19 16:06:26.156369	2025-08-26 10:11:24.240431	/images/tech-summit.jpg	https://youtube.com/watch?v=example3	[]	{}
6	Concierto Rock Nacional	concierto-rock-nacional	Los mejores exponentes del rock colombiano	Una noche épica con las bandas más representativas del rock nacional. Desde los clásicos hasta las nuevas propuestas que están revolucionando la escena musical colombiana.	2024-05-15	21:00:00	Coliseo Live	BOGOTÁ	1	2	2000	45000.00	published	2024-03-01 00:00:00	\N	https://youtube.com/watch?v=rock-nacional	/images/rock-nacional.jpg	t	2	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/rock-nacional.jpg	https://youtube.com/watch?v=rock-nacional	[]	{}
8	Festival de Jazz Latinoamericano	festival-jazz-latinoamericano	Tres días de jazz de clase mundial	Los mejores exponentes del jazz latinoamericano se dan cita en este festival único. Artistas de Colombia, Argentina, Brasil, Cuba y México en un solo escenario.	2024-06-10	19:00:00	Teatro Mayor Julio Mario Santo Domingo	BOGOTÁ	1	2	1200	85000.00	published	2024-04-01 00:00:00	\N	https://youtube.com/watch?v=jazz-latino	/images/jazz-festival.jpg	t	1	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/jazz-festival.jpg	https://youtube.com/watch?v=jazz-latino	[]	{}
12	Concierto Futuro 2025	concierto-futuro-2025	Un concierto que será en el futuro	\N	2025-12-31	20:00:00	Teatro Nacional	BOGOTÁ	1	1	1000	100000.00	published	\N	\N	\N	\N	t	\N	2025-08-20 12:18:32.5924	2025-08-27 10:37:36.303449	\N	\N	[]	{}
10	Torneo de Esports Championship	torneo-esports-championship	La competencia gamer más grande del país	Los mejores equipos de Colombia compiten en League of Legends, Dota 2, Counter-Strike y FIFA. Premios por más de $200 millones de pesos.	2024-05-25	10:00:00	Movistar Arena	BOGOTÁ	3	2	8000	35000.00	published	2024-03-15 00:00:00	\N	https://youtube.com/watch?v=esports-championship	/images/esports-tournament.jpg	t	3	2025-08-19 16:07:58.109778	2025-08-26 10:11:24.240431	/images/esports-tournament.jpg	https://youtube.com/watch?v=esports-championship	[]	{}
1	Concierto Sinfónico de Año Nuevo	concierto-sinfonico-ano-nuevo	Gran concierto sinfónico para celebrar el año nuevo	La Orquesta Sinfónica Nacional presenta un espectacular concierto para recibir el año nuevo con las mejores melodías clásicas y contemporáneas. Una noche mágica llena de música y emociones.	2024-12-31	20:00:00	Teatro Nacional	BOGOTÁ	1	2	800	50000.00	published	2024-01-01 00:00:00	\N	https://youtube.com/watch?v=example1	/images/concierto-sinfonico.jpg	t	1	2025-08-19 16:06:26.156369	2025-08-26 10:11:24.240431	/images/concierto-sinfonico.jpg	https://youtube.com/watch?v=example1	[]	{}
2	Festival Gastronómico Internacional	festival-gastronomico-internacional	Festival con los mejores chefs internacionales	Disfruta de una experiencia culinaria única con chefs reconocidos mundialmente. Degustaciones, talleres y espectáculos gastronómicos en un solo lugar.	2024-03-15	18:00:00	Centro de Convenciones	MEDELLÍN	5	2	500	80000.00	published	2024-01-15 00:00:00	\N	https://youtube.com/watch?v=example2	/images/festival-gastronomico.jpg	t	2	2025-08-19 16:06:26.156369	2025-08-26 10:11:24.240431	/images/festival-gastronomico.jpg	https://youtube.com/watch?v=example2	[]	{}
\.


--
-- Data for Name: media_files; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_files (id, name, original_name, type, size, url, alt_text, description, tags, folder_id, upload_date, last_used, usage_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: media_folders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_folders (id, name, parent_id, created_date, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, title, message, type, target, recipients, sent_at, read_by, status, created_by, created_at) FROM stdin;
1	Nuevo evento publicado	El evento "Conferencia Tech 2024" ha sido publicado exitosamente	success	all	\N	2025-08-25 12:48:29.723542	[]	delivered	\N	2025-08-25 12:48:29.723542
2	Mantenimiento programado	El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 4:00 AM	warning	admins	\N	2025-08-25 12:48:29.723542	[]	sent	\N	2025-08-25 12:48:29.723542
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (id, user_id, token, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) FROM stdin;
1	Tarjeta de Crédito	stripe	t	{"fees": {"fixed": 300, "percentage": 2.9}, "currencies": ["COP", "USD"]}	2025-08-19 16:07:37.433834	2025-08-19 16:07:37.433834
2	PayPal	paypal	t	{"fees": {"fixed": 0, "percentage": 3.4}, "currencies": ["USD", "COP"]}	2025-08-19 16:07:37.433834	2025-08-19 16:07:37.433834
3	MercadoPago	mercadopago	t	{"fees": {"fixed": 0, "percentage": 3.5}, "currencies": ["COP", "USD"]}	2025-08-19 16:07:37.433834	2025-08-19 16:07:37.433834
4	Wompi	wompi	t	{"fees": {"fixed": 200, "percentage": 2.8}, "currencies": ["COP"]}	2025-08-19 16:07:37.433834	2025-08-19 16:07:37.433834
5	Transferencia Bancaria	bank_transfer	t	{"fees": {"fixed": 0, "percentage": 0}, "currencies": ["COP"]}	2025-08-19 16:07:37.433834	2025-08-19 16:07:37.433834
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) FROM stdin;
1	1	credit_card	stripe	txn_123456789	150000.00	COP	completed	\N	2025-08-18 10:58:07.925182	2025-08-18 10:53:07.925182	2025-08-20 10:53:07.925182
2	2	debit_card	stripe	txn_987654321	75000.00	COP	completed	\N	2025-08-19 10:56:07.925182	2025-08-19 10:53:07.925182	2025-08-20 10:53:07.925182
3	3	credit_card	stripe	txn_555666777	200000.00	COP	pending	\N	\N	2025-08-20 04:53:07.925182	2025-08-20 10:53:07.925182
4	4	bank_transfer	manual	ref_888999000	120000.00	COP	failed	\N	\N	2025-08-19 22:53:07.925182	2025-08-20 10:53:07.925182
5	5	credit_card	stripe	txn_111222333	150000.00	COP	completed	\N	2025-08-17 10:55:07.925182	2025-08-17 10:53:07.925182	2025-08-20 10:53:07.925182
6	6	debit_card	stripe	txn_444555666	180000.00	COP	completed	\N	2025-08-13 11:03:07.925182	2025-08-13 10:53:07.925182	2025-08-20 10:53:07.925182
7	7	credit_card	stripe	txn_777888999	75000.00	COP	cancelled	\N	\N	2025-08-16 10:53:07.925182	2025-08-20 10:53:07.925182
8	1	credit_card	stripe	ch_1234567890	500000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567890"}	\N	2024-12-15 14:32:00	2025-08-20 13:12:24.592619
9	2	credit_card	stripe	ch_1234567891	600000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567891"}	\N	2024-12-16 10:17:00	2025-08-20 13:12:24.592619
10	3	bank_transfer	payu	payu_123456	350000.00	COP	completed	{"gateway": "payu", "transaction_id": "payu_123456"}	\N	2024-12-17 16:47:00	2025-08-20 13:12:24.592619
11	4	credit_card	stripe	ch_1234567892	500000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567892"}	\N	2024-12-18 11:22:00	2025-08-20 13:12:24.592619
12	5	credit_card	stripe	ch_1234567893	360000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567893"}	\N	2024-12-19 09:32:00	2025-08-20 13:12:24.592619
13	6	credit_card	stripe	ch_1234567894	160000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567894"}	\N	2024-12-20 15:47:00	2025-08-20 13:12:24.592619
14	7	cash	cash	CASH-001	65000.00	COP	completed	{"gateway": "cash", "receipt": "CASH-001"}	\N	2024-12-21 13:17:00	2025-08-20 13:12:24.592619
15	8	credit_card	stripe	ch_1234567895	90000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567895"}	\N	2024-12-22 17:32:00	2025-08-20 13:12:24.592619
16	9	bank_transfer	payu	payu_123457	500000.00	COP	completed	{"gateway": "payu", "transaction_id": "payu_123457"}	\N	2024-12-23 08:47:00	2025-08-20 13:12:24.592619
17	10	credit_card	stripe	ch_1234567896	700000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567896"}	\N	2024-12-24 12:02:00	2025-08-20 13:12:24.592619
18	11	credit_card	stripe	ch_1234567897	360000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567897"}	\N	2024-12-25 14:22:00	2025-08-20 13:12:24.592619
19	12	credit_card	stripe	ch_1234567898	300000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567898"}	\N	2024-12-26 10:32:00	2025-08-20 13:12:24.592619
20	13	credit_card	stripe	ch_1234567899	360000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567899"}	\N	2024-12-27 16:17:00	2025-08-20 13:12:24.592619
21	14	cash	cash	CASH-002	120000.00	COP	completed	{"gateway": "cash", "receipt": "CASH-002"}	\N	2024-12-28 19:47:00	2025-08-20 13:12:24.592619
22	15	credit_card	stripe	ch_1234567900	50000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567900"}	\N	2024-12-29 07:32:00	2025-08-20 13:12:24.592619
23	16	credit_card	stripe	ch_1234567901	35000.00	COP	completed	{"gateway": "stripe", "charge_id": "ch_1234567901"}	\N	2024-12-30 11:22:00	2025-08-20 13:12:24.592619
24	20	cash	cash	CASH-003	45000.00	COP	completed	{"gateway": "cash", "receipt": "CASH-003"}	\N	2025-01-03 13:57:00	2025-08-20 13:12:24.592619
\.


--
-- Data for Name: physical_tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.physical_tickets (id, batch_number, event_id, ticket_type_id, quantity, printed, sold, price, sales_point, notes, status, created_at, updated_at, printed_at, distributed_at) FROM stdin;
\.


--
-- Data for Name: refunds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refunds (id, payment_id, amount, reason, status, gateway_refund_id, processed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) FROM stdin;
1	4	1	1	2	50000.00	100000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 16:06:26.163898	2025-08-19 16:06:26.163898
2	5	1	2	1	75000.00	75000.00	completed	debit_card	\N	Ana López	ana@example.com	3007654321	2025-08-19 16:06:26.163898	2025-08-19 16:06:26.163898
3	4	2	3	3	80000.00	240000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 16:06:26.163898	2025-08-19 16:06:26.163898
4	5	4	5	1	100000.00	100000.00	completed	bank_transfer	\N	Ana López	ana@example.com	3007654321	2025-08-19 16:06:26.163898	2025-08-19 16:06:26.163898
5	4	5	7	4	25000.00	100000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 16:06:26.163898	2025-08-19 16:06:26.163898
6	4	6	13	2	45000.00	90000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 16:07:58.118272	2025-08-19 16:07:58.118272
7	5	7	16	1	75000.00	75000.00	completed	bank_transfer	\N	Ana López	ana@example.com	3007654321	2025-08-19 16:07:58.118272	2025-08-19 16:07:58.118272
8	4	8	19	2	85000.00	170000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 16:07:58.118272	2025-08-19 16:07:58.118272
9	5	10	25	4	35000.00	140000.00	completed	debit_card	\N	Ana López	ana@example.com	3007654321	2025-08-19 16:07:58.118272	2025-08-19 16:07:58.118272
10	1	1	1	2	75000.00	150000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-18 10:53:07.911453	2025-08-20 10:53:07.911453
11	1	2	2	1	75000.00	75000.00	completed	debit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 10:53:07.911453	2025-08-20 10:53:07.911453
12	1	3	1	1	200000.00	200000.00	pending	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-20 04:53:07.911453	2025-08-20 10:53:07.911453
13	1	4	2	1	120000.00	120000.00	cancelled	bank_transfer	\N	Juan Pérez	juan@example.com	3001234567	2025-08-19 22:53:07.911453	2025-08-20 10:53:07.911453
14	2	1	1	2	75000.00	150000.00	completed	credit_card	\N	María García	maria@example.com	3009876543	2025-08-17 10:53:07.911453	2025-08-20 10:53:07.911453
15	2	5	1	2	90000.00	180000.00	completed	debit_card	\N	María García	maria@example.com	3009876543	2025-08-13 10:53:07.911453	2025-08-20 10:53:07.911453
16	3	2	2	1	75000.00	75000.00	cancelled	credit_card	\N	Carlos López	carlos@example.com	3005555555	2025-08-16 10:53:07.911453	2025-08-20 10:53:07.911453
17	1	1	1	2	75000.00	150000.00	completed	credit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-20 12:13:51.892343	2025-08-20 12:13:51.892343
18	1	2	3	1	85000.00	85000.00	completed	debit_card	\N	Juan Pérez	juan@example.com	3001234567	2025-08-20 12:13:51.892343	2025-08-20 12:13:51.892343
19	2	1	2	1	150000.00	150000.00	completed	credit_card	\N	María García	maria@example.com	3009876543	2025-08-20 12:13:51.899141	2025-08-20 12:13:51.899141
20	8	1	1	1	75000.00	75000.00	completed	credit_card	\N	Test User Tickets	tickets@example.com	3001234567	2025-08-20 12:16:51.592766	2025-08-20 12:16:51.592766
21	8	2	3	1	85000.00	85000.00	completed	credit_card	\N	Test User Tickets	tickets@example.com	3001234567	2025-08-20 12:17:59.615897	2025-08-20 12:17:59.615897
22	8	12	5	1	100000.00	100000.00	completed	credit_card	\N	Test User Tickets	tickets@example.com	3001234567	2025-08-20 12:19:11.256334	2025-08-20 12:19:11.256334
23	4	1	1	2	250000.00	500000.00	completed	credit_card	\N	Ana Martínez	ana.martinez@eventu.com	+57 300 456 7890	2024-12-15 14:30:00	2025-08-20 13:12:24.589052
24	5	1	2	4	150000.00	600000.00	completed	credit_card	\N	Luis Rodríguez	luis.rodriguez@eventu.com	+57 300 567 8901	2024-12-16 10:15:00	2025-08-20 13:12:24.589052
25	6	2	3	1	350000.00	350000.00	completed	bank_transfer	\N	Sofía Hernández	sofia.hernandez@eventu.com	+57 300 678 9012	2024-12-17 16:45:00	2025-08-20 13:12:24.589052
26	7	2	4	2	250000.00	500000.00	completed	credit_card	\N	Diego González	diego.gonzalez@eventu.com	+57 300 789 0123	2024-12-18 11:20:00	2025-08-20 13:12:24.589052
27	4	3	5	3	120000.00	360000.00	completed	credit_card	\N	Ana Martínez	ana.martinez@eventu.com	+57 300 456 7890	2024-12-19 09:30:00	2025-08-20 13:12:24.589052
28	8	3	6	2	80000.00	160000.00	completed	credit_card	\N	Valentina Díaz	valentina.diaz@eventu.com	+57 300 890 1234	2024-12-20 15:45:00	2025-08-20 13:12:24.589052
29	5	4	7	1	65000.00	65000.00	completed	cash	\N	Luis Rodríguez	luis.rodriguez@eventu.com	+57 300 567 8901	2024-12-21 13:15:00	2025-08-20 13:12:24.589052
30	6	4	8	2	45000.00	90000.00	completed	credit_card	\N	Sofía Hernández	sofia.hernandez@eventu.com	+57 300 678 9012	2024-12-22 17:30:00	2025-08-20 13:12:24.589052
31	7	5	9	1	500000.00	500000.00	completed	bank_transfer	\N	Diego González	diego.gonzalez@eventu.com	+57 300 789 0123	2024-12-23 08:45:00	2025-08-20 13:12:24.589052
32	8	5	10	2	350000.00	700000.00	completed	credit_card	\N	Valentina Díaz	valentina.diaz@eventu.com	+57 300 890 1234	2024-12-24 12:00:00	2025-08-20 13:12:24.589052
33	4	6	11	3	120000.00	360000.00	completed	credit_card	\N	Ana Martínez	ana.martinez@eventu.com	+57 300 456 7890	2024-12-25 14:20:00	2025-08-20 13:12:24.589052
34	5	6	12	4	75000.00	300000.00	completed	credit_card	\N	Luis Rodríguez	luis.rodriguez@eventu.com	+57 300 567 8901	2024-12-26 10:30:00	2025-08-20 13:12:24.589052
35	6	7	13	2	180000.00	360000.00	completed	credit_card	\N	Sofía Hernández	sofia.hernandez@eventu.com	+57 300 678 9012	2024-12-27 16:15:00	2025-08-20 13:12:24.589052
36	7	7	14	1	120000.00	120000.00	completed	cash	\N	Diego González	diego.gonzalez@eventu.com	+57 300 789 0123	2024-12-28 19:45:00	2025-08-20 13:12:24.589052
37	8	8	15	1	50000.00	50000.00	completed	credit_card	\N	Valentina Díaz	valentina.diaz@eventu.com	+57 300 890 1234	2024-12-29 07:30:00	2025-08-20 13:12:24.589052
38	4	8	16	1	35000.00	35000.00	completed	credit_card	\N	Ana Martínez	ana.martinez@eventu.com	+57 300 456 7890	2024-12-30 11:20:00	2025-08-20 13:12:24.589052
39	5	1	1	1	250000.00	250000.00	pending	credit_card	\N	Luis Rodríguez	luis.rodriguez@eventu.com	+57 300 567 8901	2024-12-31 14:10:00	2025-08-20 13:12:24.589052
40	6	2	4	1	250000.00	250000.00	pending	bank_transfer	\N	Sofía Hernández	sofia.hernandez@eventu.com	+57 300 678 9012	2025-01-01 09:25:00	2025-08-20 13:12:24.589052
41	7	3	6	2	80000.00	160000.00	cancelled	credit_card	\N	Diego González	diego.gonzalez@eventu.com	+57 300 789 0123	2025-01-02 16:40:00	2025-08-20 13:12:24.589052
42	8	4	8	1	45000.00	45000.00	completed	cash	\N	Valentina Díaz	valentina.diaz@eventu.com	+57 300 890 1234	2025-01-03 13:55:00	2025-08-20 13:12:24.589052
\.


--
-- Data for Name: sales_points; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_points (id, name, location, address, contact_person, contact_phone, contact_email, status, created_at, updated_at) FROM stdin;
1	Punto de Venta Centro	Centro Comercial Plaza Central	Calle 123 #45-67, Centro	María González	3001234567	centro@eventu.co	active	2025-08-26 12:39:22.110964	2025-08-26 12:39:22.110964
2	Punto de Venta Norte	Centro Comercial Norte	Avenida Norte #89-12, Norte	Carlos Rodríguez	3002345678	norte@eventu.co	active	2025-08-26 12:39:22.110964	2025-08-26 12:39:22.110964
3	Punto de Venta Sur	Centro Comercial Sur	Carrera 78 #34-56, Sur	Ana Martínez	3003456789	sur@eventu.co	active	2025-08-26 12:39:22.110964	2025-08-26 12:39:22.110964
\.


--
-- Data for Name: saved_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.saved_reports (id, name, description, type, filters, schedule, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: scheduled_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheduled_reports (id, name, description, type, schedule, recipients, status, created_by, created_at, updated_at, last_run, next_run) FROM stdin;
\.


--
-- Data for Name: seat_map_templates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seat_map_templates (id, name, description, template_data, thumbnail_url, is_public, created_by, created_at, updated_at) FROM stdin;
1	Teatro Clásico	Plantilla para teatro con palcos y platea	{"sections": [{"id": "platea", "name": "Platea", "rows": 20, "type": "seating", "price": 1.0, "seatsPerRow": 30}, {"id": "palcos", "name": "Palcos", "type": "vip", "price": 1.5, "capacity": 40}]}	\N	t	1	2025-08-19 16:06:26.152011	2025-08-19 16:06:26.152011
2	Estadio Deportivo	Plantilla para eventos deportivos	{"sections": [{"id": "tribuna-norte", "name": "Tribuna Norte", "type": "seating", "capacity": 500}, {"id": "tribuna-sur", "name": "Tribuna Sur", "type": "seating", "capacity": 500}, {"id": "vip", "name": "Palco VIP", "type": "vip", "capacity": 100}]}	\N	t	1	2025-08-19 16:06:26.152011	2025-08-19 16:06:26.152011
3	Salón de Eventos	Plantilla para salones y conferencias	{"sections": [{"id": "general", "name": "Admisión General", "type": "seating", "capacity": 200}]}	\N	t	1	2025-08-19 16:06:26.152011	2025-08-19 16:06:26.152011
\.


--
-- Data for Name: seat_maps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seat_maps (id, name, venue_name, total_capacity, map_data, template_id, created_by, created_at, updated_at) FROM stdin;
1	Teatro Nacional - Sala Principal	Teatro Nacional	800	{"sections": [{"id": "platea", "name": "Platea", "price": 50000, "capacity": 600}, {"id": "palcos", "name": "Palcos", "price": 75000, "capacity": 200}]}	1	2	2025-08-19 16:06:26.155355	2025-08-19 16:06:26.155355
2	Coliseo El Campín	Coliseo El Campín	1200	{"sections": [{"id": "tribuna-norte", "name": "Tribuna Norte", "price": 30000, "capacity": 500}, {"id": "tribuna-sur", "name": "Tribuna Sur", "price": 30000, "capacity": 500}, {"id": "vip", "name": "Palco VIP", "price": 80000, "capacity": 200}]}	2	2	2025-08-19 16:06:26.155355	2025-08-19 16:06:26.155355
3	Movistar Arena - Configuración Esports	Movistar Arena	8000	{"sections": [{"id": "general", "name": "General", "price": 35000, "capacity": 6000}, {"id": "premium", "name": "Premium", "price": 55000, "capacity": 1500}, {"id": "vip", "name": "VIP Gamer", "price": 95000, "capacity": 500}]}	2	2	2025-08-19 16:07:58.125962	2025-08-19 16:07:58.125962
\.


--
-- Data for Name: seat_sections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seat_sections (id, seat_map_id, name, section_type, capacity, price_modifier, color, position_data, created_at) FROM stdin;
\.


--
-- Data for Name: seats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seats (id, section_id, seat_number, row_number, status, position_x, position_y, created_at) FROM stdin;
\.


--
-- Data for Name: ticket_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) FROM stdin;
4	3	Entrada General	Asiento numerado	35000.00	400	0	6	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.16093
6	4	Entrada Regular	Entrada estándar	120000.00	200	0	4	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.16093
8	5	Tribuna Sur	Tribuna Sur del estadio	25000.00	500	0	10	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.16093
9	5	Palco VIP	Palco VIP con servicios premium	80000.00	200	0	4	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.16093
1	1	Platea	Asientos en platea principal	50000.00	600	2	6	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.167084
2	1	Palcos	Asientos en palcos VIP	75000.00	200	1	4	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.17141
3	2	Entrada General	Acceso completo al festival	80000.00	500	3	8	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.171618
5	4	Early Bird	Precio especial por compra anticipada	100000.00	100	1	2	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.171795
7	5	Tribuna Norte	Tribuna Norte del estadio	25000.00	500	4	10	\N	\N	active	2025-08-19 16:06:26.16093	2025-08-19 16:06:26.172023
10	6	General	Acceso general al concierto	45000.00	1500	0	8	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
11	6	VIP	Zona VIP con bar incluido	85000.00	300	0	4	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
12	6	Palco Premium	Palcos con servicio completo	150000.00	200	0	6	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
14	7	Startup	Incluye stand de exhibición	200000.00	100	0	2	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
15	7	Inversor	Acceso VIP y networking exclusivo	350000.00	100	0	2	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
17	8	Palcos	Palcos con vista privilegiada	120000.00	300	0	4	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
18	8	Premium	Experiencia completa con cena	200000.00	100	0	2	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
20	9	Preferencial	Mejores ubicaciones	65000.00	50	0	4	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
21	10	General	Acceso general al torneo	35000.00	6000	0	10	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
22	10	Premium	Zona premium con merchandising	55000.00	1500	0	6	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
23	10	VIP Gamer	Meet & greet con jugadores	95000.00	500	0	4	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
24	11	Estudiante	Precio especial estudiantes	100000.00	100	0	2	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
26	11	Empresarial	Incluye consultoría personalizada	250000.00	20	0	1	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.116019
13	7	Emprendedor	Acceso completo al evento	75000.00	600	2	3	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.120789
16	8	Platea	Asientos en platea principal	85000.00	800	1	6	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.125099
19	9	General	Asientos numerados	42000.00	300	2	6	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.125452
25	11	Profesional	Acceso completo y certificado	150000.00	80	4	3	\N	\N	active	2025-08-19 16:07:58.116019	2025-08-19 16:07:58.125703
27	1	General	Acceso general al evento	75000.00	100	0	5	\N	\N	active	2025-08-20 12:13:51.879188	2025-08-20 12:13:51.879188
28	1	VIP	Acceso VIP con beneficios especiales	150000.00	50	0	3	\N	\N	active	2025-08-20 12:13:51.879188	2025-08-20 12:13:51.879188
29	2	Platea	Asiento en platea	85000.00	80	0	4	\N	\N	active	2025-08-20 12:13:51.879188	2025-08-20 12:13:51.879188
30	2	Balcón	Asiento en balcón	65000.00	120	0	6	\N	\N	active	2025-08-20 12:13:51.879188	2025-08-20 12:13:51.879188
31	12	General	Acceso general al concierto futuro	100000.00	100	0	5	\N	\N	active	2025-08-20 12:19:03.186841	2025-08-20 12:19:03.186841
32	1	VIP	Acceso VIP con asientos preferenciales, bebidas incluidas y meet & greet	250000.00	200	0	4	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
33	1	General	Acceso general al festival	150000.00	4800	0	10	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
34	2	Premium	Acceso completo a la conferencia con networking exclusivo	350000.00	100	0	2	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
35	2	Estándar	Acceso a charlas y exhibición	250000.00	700	0	5	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
36	3	Preferencial	Asientos en las mejores ubicaciones del estadio	120000.00	5000	0	6	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
37	3	General	Asientos generales del estadio	80000.00	31000	0	10	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
38	4	Guía Incluida	Entrada con tour guiado por expertos	65000.00	100	0	4	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
39	4	General	Entrada general a la exposición	45000.00	200	0	6	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
40	5	VIP Executive	Acceso VIP con networking exclusivo y cena de gala	500000.00	50	0	2	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
41	5	Profesional	Acceso completo a la cumbre	350000.00	450	0	3	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
42	6	Gourmet	Acceso completo con degustaciones premium	120000.00	300	0	4	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
43	6	General	Acceso general al festival	75000.00	1700	0	8	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
44	7	Palco	Asientos en palco con servicio de bebidas	180000.00	100	0	4	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
45	7	Platea	Asientos en platea del teatro	120000.00	700	0	6	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
46	8	Elite	Kit completo de corredor con beneficios especiales	50000.00	500	0	2	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
47	8	General	Inscripción general a la maratón	35000.00	9500	0	1	\N	\N	active	2025-08-20 13:12:24.586558	2025-08-20 13:12:24.586558
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) FROM stdin;
1	1	TKT-001-001	\N	\N	valid	\N	2025-08-19 16:06:26.172322
2	1	TKT-001-002	\N	\N	valid	\N	2025-08-19 16:06:26.172322
3	2	TKT-002-001	\N	\N	valid	\N	2025-08-19 16:06:26.172322
4	3	TKT-003-001	\N	\N	valid	\N	2025-08-19 16:06:26.172322
5	3	TKT-003-002	\N	\N	valid	\N	2025-08-19 16:06:26.172322
6	3	TKT-003-003	\N	\N	valid	\N	2025-08-19 16:06:26.172322
7	4	TKT-004-001	\N	\N	valid	\N	2025-08-19 16:06:26.172322
8	5	TKT-005-001	\N	\N	valid	\N	2025-08-19 16:06:26.172322
9	5	TKT-005-002	\N	\N	valid	\N	2025-08-19 16:06:26.172322
10	5	TKT-005-003	\N	\N	valid	\N	2025-08-19 16:06:26.172322
11	5	TKT-005-004	\N	\N	valid	\N	2025-08-19 16:06:26.172322
15	4	TKT-004-002	\N	\N	valid	\N	2025-08-20 12:17:03.920232
16	20	TKT-020-001	\N	\N	valid	\N	2025-08-20 12:17:33.972444
17	21	TKT-021-001	\N	\N	valid	\N	2025-08-20 12:18:06.652986
18	22	TKT-022-001	\N	\N	valid	\N	2025-08-20 12:19:18.37799
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) FROM stdin;
4	Juan	Pérez	juan@example.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	\N	2025-08-19 16:06:26.143845	2025-08-19 16:06:26.143845	\N	\N
5	Ana	López	ana@example.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	\N	2025-08-19 16:06:26.143845	2025-08-19 16:06:26.143845	\N	\N
1	Admin	Sistema	admin@eventu.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	admin	active	f	\N	\N	2025-08-19 16:06:26.143845	2025-08-20 11:46:26.207686	\N	+57 300 123 4567
2	Carlos	Rodríguez	carlos@eventu.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	organizer	active	f	\N	\N	2025-08-19 16:06:26.143845	2025-08-20 11:46:26.211219	\N	+57 310 987 6543
3	María	González	maria@eventu.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	organizer	active	f	\N	\N	2025-08-19 16:06:26.143845	2025-08-20 11:46:26.211539	\N	+57 315 555 1234
26	Promotor	Eventu	promotor@eventu.co	$2a$12$jC.htC2ZXipSHmIMIsoxM.t8EnVXs2aAXRdhJhvUTDPCCU4K/6Qga	organizer	active	f	\N	\N	2025-08-25 13:47:34.10328	2025-08-25 13:49:31.986999	\N	3001234570
7	Nuevo Nombre	Nuevo Apellido	test@example.com	$2a$12$xVoEp4NA97FVg0yxozXI/uJBaTc9j5RjnizQVQugVM7MgZthBptrW	user	active	f	\N	\N	2025-08-20 11:50:12.087836	2025-08-20 12:08:12.062037	\N	3001111111
8	Test	User Tickets	tickets@example.com	$2a$12$.vnqLpGqzzUw9E4LlR0W5eNYwmA5wLRqc6xm.w.rVFY7nlX5iw.q2	user	active	f	\N	\N	2025-08-20 12:16:24.133319	2025-08-20 12:16:24.133319	\N	3001234567
9	Nuevo	Usuario	nuevo@example.com	$2a$12$RG.XXkZGH5l83yVU8t1PYutiFTHpd4ql2E8qjoVwzGlJ66WUR2y8K	user	active	f	\N	\N	2025-08-20 12:30:34.872462	2025-08-20 12:30:34.872462	\N	3009876543
10	Organizador	Test	organizador@example.com	$2a$12$4S4mwWSo.Uqo1GejSEIKROxOaqkgxB5ndQWvAQvTTP7JS/F2Ac6NC	organizer	active	f	\N	\N	2025-08-20 12:39:58.784732	2025-08-20 12:40:08.946076	\N	3001234567
11	Juan	Pérez	juan.perez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	admin	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 123 4567
12	María	García	maria.garcia@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	organizer	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 234 5678
13	Carlos	López	carlos.lopez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	organizer	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 345 6789
14	Ana	Martínez	ana.martinez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 456 7890
15	Luis	Rodríguez	luis.rodriguez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 567 8901
16	Sofía	Hernández	sofia.hernandez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 678 9012
17	Diego	González	diego.gonzalez@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 789 0123
18	Valentina	Díaz	valentina.diaz@eventu.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	user	active	f	\N	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	2025-08-20 13:08:24.814296	\N	+57 300 890 1234
6	roberto	mendoza	robertomensie@gmail.com	$2a$12$oppkPhMWVMEQ3tnv5InIAuNwS9QZTjzl3mS956ADahLysPIJpBDuG	user	active	f	\N	\N	2025-08-20 11:00:53.830233	2025-08-21 10:48:45.441364	\N	3243052154
20	Test	Admin	test@eventu.com	$2a$10$rTxNAiyZWSfqug3bIco1eeo9h.EvON0HUFtggp4AwnMLVvtQ7hkuC	admin	active	f	\N	\N	2025-08-22 14:34:44.822879	2025-08-22 14:34:44.822879	\N	\N
22	Organizador	Test	organizador@test.com	$2a$12$Bhe3qLWQkz/8EyLIp0QASedve7kUImCuJUx3GKiAIyVWjTXYPkEeW	organizer	active	f	\N	\N	2025-08-22 15:30:47.447756	2025-08-22 15:31:30.903286	\N	\N
25	Admin	Eventu	admin2@eventu.co	$2a$12$wOhOcNV.QqC.w45a8UO6zO20I.NhzbukPfoHkvHbV2cl.n3br25NO	user	active	f	\N	\N	2025-08-25 13:10:37.72742	2025-08-25 13:10:37.72742	\N	3001234569
24	Usuario	Demo	demo@eventu.co	$2a$10$MyDbB6EqQaLyOA8RcNvQ2O1mmkCGt7AP3w.EodchCyzPaD0xR55ce	user	active	f	\N	\N	2025-08-25 13:10:08.313026	2025-08-25 13:33:19.258307	\N	3001234567
21	Roberto	Mendoza	roberto@eventu.co	$2a$10$rHhV57oYqtrrMctUkUFMseJ/V3QnLtd3CV5qobTpW4njaM0oBXiw6	user	active	f	\N	\N	2025-08-22 14:45:54.987408	2025-08-25 13:39:39.709915	\N	3241119900
27	Super	Admin	superadmin@eventu.co	$2a$12$rvExGdHWiowcQJNAWSHDO.jg7hMp.5xUcJN4jMAAaMplJcNA3QEce	admin	active	f	\N	\N	2025-08-25 16:17:42.923617	2025-08-25 16:19:44.93338	\N	3001234567
28	Admin	Test	admin@test.com	$2a$12$dV63JjtvuBTuawMC9lZDde6866CLhPxd.vB672Ky5UQZN4Qu/onLu	admin	active	f	\N	\N	2025-08-26 11:45:43.746682	2025-08-26 11:45:53.238031	\N	123456789
29	Test	Admin	testadmin@eventu.com	$2a$12$HCg11wRjW.D9E0T966I0t.SVnupiGzMAArJZ.x2WkwzAQBSNQViJS	user	active	f	\N	\N	2025-08-27 16:50:34.127608	2025-08-27 16:50:34.127608	\N	\N
30	Admin	Analytics	analytics@eventu.com	$2a$12$cwEVVn40mc7KBYhobMMVUuuN3myUB0dJM7LX1Wz.TNu6zaZ9nY4PS	user	active	f	\N	\N	2025-08-28 09:56:24.35354	2025-08-28 09:56:24.35354	\N	\N
23	Administrador	Eventu	admin@eventu.co	$2a$12$D6aiFq5.KGQiqeYVA0TUUeniuzqEswI4p0IRnei8fBOUzh9gXPSQ2	admin	active	f	\N	\N	2025-08-24 19:41:51.032574	2025-09-03 12:00:28.008952	\N	\N
\.


--
-- Data for Name: virtual_tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.virtual_tickets (id, ticket_number, event_id, ticket_type_id, customer_name, customer_email, customer_phone, price, qr_code, status, purchase_date, event_date, used_at, sent_at, notes, created_at, updated_at) FROM stdin;
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 2, true);


--
-- Name: backup_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.backup_schedules_id_seq', 1, false);


--
-- Name: backups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.backups_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 10, true);


--
-- Name: check_in_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.check_in_records_id_seq', 1, false);


--
-- Name: event_additional_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_additional_data_id_seq', 1, false);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.events_id_seq', 45, true);


--
-- Name: media_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.media_files_id_seq', 1, false);


--
-- Name: media_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.media_folders_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 2, true);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.password_reset_tokens_id_seq', 1, false);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payment_methods_id_seq', 5, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 24, true);


--
-- Name: physical_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.physical_tickets_id_seq', 1, false);


--
-- Name: refunds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.refunds_id_seq', 1, false);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_id_seq', 42, true);


--
-- Name: sales_points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_points_id_seq', 3, true);


--
-- Name: saved_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.saved_reports_id_seq', 1, false);


--
-- Name: scheduled_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheduled_reports_id_seq', 1, false);


--
-- Name: seat_map_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seat_map_templates_id_seq', 3, true);


--
-- Name: seat_maps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seat_maps_id_seq', 11, true);


--
-- Name: seat_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seat_sections_id_seq', 1, false);


--
-- Name: seats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.seats_id_seq', 40, true);


--
-- Name: ticket_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ticket_types_id_seq', 51, true);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tickets_id_seq', 19, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 30, true);


--
-- Name: virtual_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.virtual_tickets_id_seq', 1, false);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: backup_schedules backup_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_schedules
    ADD CONSTRAINT backup_schedules_pkey PRIMARY KEY (id);


--
-- Name: backups backups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backups
    ADD CONSTRAINT backups_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: check_in_records check_in_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.check_in_records
    ADD CONSTRAINT check_in_records_pkey PRIMARY KEY (id);


--
-- Name: check_in_records check_in_records_ticket_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.check_in_records
    ADD CONSTRAINT check_in_records_ticket_number_key UNIQUE (ticket_number);


--
-- Name: event_additional_data event_additional_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_additional_data
    ADD CONSTRAINT event_additional_data_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: events events_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_slug_key UNIQUE (slug);


--
-- Name: media_files media_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_files
    ADD CONSTRAINT media_files_pkey PRIMARY KEY (id);


--
-- Name: media_folders media_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_folders
    ADD CONSTRAINT media_folders_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_key UNIQUE (user_id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: physical_tickets physical_tickets_batch_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.physical_tickets
    ADD CONSTRAINT physical_tickets_batch_number_key UNIQUE (batch_number);


--
-- Name: physical_tickets physical_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.physical_tickets
    ADD CONSTRAINT physical_tickets_pkey PRIMARY KEY (id);


--
-- Name: refunds refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: sales_points sales_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_points
    ADD CONSTRAINT sales_points_pkey PRIMARY KEY (id);


--
-- Name: saved_reports saved_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_reports
    ADD CONSTRAINT saved_reports_pkey PRIMARY KEY (id);


--
-- Name: scheduled_reports scheduled_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_reports
    ADD CONSTRAINT scheduled_reports_pkey PRIMARY KEY (id);


--
-- Name: seat_map_templates seat_map_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_map_templates
    ADD CONSTRAINT seat_map_templates_pkey PRIMARY KEY (id);


--
-- Name: seat_maps seat_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_maps
    ADD CONSTRAINT seat_maps_pkey PRIMARY KEY (id);


--
-- Name: seat_sections seat_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_sections
    ADD CONSTRAINT seat_sections_pkey PRIMARY KEY (id);


--
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);


--
-- Name: ticket_types ticket_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_types
    ADD CONSTRAINT ticket_types_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_ticket_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_ticket_code_key UNIQUE (ticket_code);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: virtual_tickets virtual_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_tickets
    ADD CONSTRAINT virtual_tickets_pkey PRIMARY KEY (id);


--
-- Name: virtual_tickets virtual_tickets_ticket_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_tickets
    ADD CONSTRAINT virtual_tickets_ticket_number_key UNIQUE (ticket_number);


--
-- Name: idx_audit_logs_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_action ON public.audit_logs USING btree (action);


--
-- Name: idx_audit_logs_severity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_severity ON public.audit_logs USING btree (severity);


--
-- Name: idx_audit_logs_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_timestamp ON public.audit_logs USING btree ("timestamp");


--
-- Name: idx_audit_logs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_user_id ON public.audit_logs USING btree (user_id);


--
-- Name: idx_categories_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_categories_slug ON public.categories USING btree (slug);


--
-- Name: idx_categories_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_categories_status ON public.categories USING btree (status);


--
-- Name: idx_check_in_records_check_in_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_check_in_records_check_in_time ON public.check_in_records USING btree (check_in_time);


--
-- Name: idx_check_in_records_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_check_in_records_event_id ON public.check_in_records USING btree (event_id);


--
-- Name: idx_check_in_records_ticket_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_check_in_records_ticket_number ON public.check_in_records USING btree (ticket_number);


--
-- Name: idx_event_additional_data_event_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_additional_data_event_key ON public.event_additional_data USING btree (event_id, data_key);


--
-- Name: idx_events_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_category ON public.events USING btree (category_id);


--
-- Name: idx_events_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_date ON public.events USING btree (date);


--
-- Name: idx_events_featured; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_featured ON public.events USING btree (featured);


--
-- Name: idx_events_main_image; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_main_image ON public.events USING btree (main_image_url) WHERE (main_image_url IS NOT NULL);


--
-- Name: idx_events_organizer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_organizer ON public.events USING btree (organizer_id);


--
-- Name: idx_events_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_slug ON public.events USING btree (slug);


--
-- Name: idx_events_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_status ON public.events USING btree (status);


--
-- Name: idx_events_video_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_video_url ON public.events USING btree (video_url) WHERE (video_url IS NOT NULL);


--
-- Name: idx_media_files_folder; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_files_folder ON public.media_files USING btree (folder_id);


--
-- Name: idx_media_files_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_files_type ON public.media_files USING btree (type);


--
-- Name: idx_media_files_upload_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_files_upload_date ON public.media_files USING btree (upload_date);


--
-- Name: idx_media_folders_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_folders_parent ON public.media_folders USING btree (parent_id);


--
-- Name: idx_notifications_sent_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_sent_at ON public.notifications USING btree (sent_at);


--
-- Name: idx_notifications_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_target ON public.notifications USING btree (target);


--
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- Name: idx_password_reset_tokens_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_expires_at ON public.password_reset_tokens USING btree (expires_at);


--
-- Name: idx_password_reset_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_user_id ON public.password_reset_tokens USING btree (user_id);


--
-- Name: idx_payments_gateway_transaction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payments_gateway_transaction ON public.payments USING btree (gateway_transaction_id);


--
-- Name: idx_payments_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payments_sale ON public.payments USING btree (sale_id);


--
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- Name: idx_physical_tickets_batch_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_physical_tickets_batch_number ON public.physical_tickets USING btree (batch_number);


--
-- Name: idx_physical_tickets_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_physical_tickets_created ON public.physical_tickets USING btree (created_at);


--
-- Name: idx_physical_tickets_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_physical_tickets_event ON public.physical_tickets USING btree (event_id);


--
-- Name: idx_physical_tickets_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_physical_tickets_status ON public.physical_tickets USING btree (status);


--
-- Name: idx_refunds_payment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refunds_payment ON public.refunds USING btree (payment_id);


--
-- Name: idx_refunds_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refunds_status ON public.refunds USING btree (status);


--
-- Name: idx_sales_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_created ON public.sales USING btree (created_at);


--
-- Name: idx_sales_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_event ON public.sales USING btree (event_id);


--
-- Name: idx_sales_points_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_points_name ON public.sales_points USING btree (name);


--
-- Name: idx_sales_points_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_points_status ON public.sales_points USING btree (status);


--
-- Name: idx_sales_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_status ON public.sales USING btree (status);


--
-- Name: idx_sales_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_user ON public.sales USING btree (user_id);


--
-- Name: idx_saved_reports_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_saved_reports_created_by ON public.saved_reports USING btree (created_by);


--
-- Name: idx_scheduled_reports_next_run; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_reports_next_run ON public.scheduled_reports USING btree (next_run);


--
-- Name: idx_scheduled_reports_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_reports_status ON public.scheduled_reports USING btree (status);


--
-- Name: idx_seat_sections_map; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_seat_sections_map ON public.seat_sections USING btree (seat_map_id);


--
-- Name: idx_seats_section; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_seats_section ON public.seats USING btree (section_id);


--
-- Name: idx_seats_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_seats_status ON public.seats USING btree (status);


--
-- Name: idx_ticket_types_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ticket_types_event ON public.ticket_types USING btree (event_id);


--
-- Name: idx_ticket_types_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ticket_types_status ON public.ticket_types USING btree (status);


--
-- Name: idx_tickets_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_code ON public.tickets USING btree (ticket_code);


--
-- Name: idx_tickets_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_sale ON public.tickets USING btree (sale_id);


--
-- Name: idx_tickets_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_status ON public.tickets USING btree (status);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: idx_users_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_status ON public.users USING btree (status);


--
-- Name: idx_virtual_tickets_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_virtual_tickets_created ON public.virtual_tickets USING btree (created_at);


--
-- Name: idx_virtual_tickets_customer_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_virtual_tickets_customer_email ON public.virtual_tickets USING btree (customer_email);


--
-- Name: idx_virtual_tickets_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_virtual_tickets_event ON public.virtual_tickets USING btree (event_id);


--
-- Name: idx_virtual_tickets_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_virtual_tickets_number ON public.virtual_tickets USING btree (ticket_number);


--
-- Name: idx_virtual_tickets_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_virtual_tickets_status ON public.virtual_tickets USING btree (status);


--
-- Name: unique_seat_per_section; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_seat_per_section ON public.seats USING btree (section_id, seat_number);


--
-- Name: categories update_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: event_additional_data update_event_additional_data_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_event_additional_data_updated_at BEFORE UPDATE ON public.event_additional_data FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: events update_events_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: media_files update_media_files_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_media_files_updated_at BEFORE UPDATE ON public.media_files FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: media_folders update_media_folders_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_media_folders_updated_at BEFORE UPDATE ON public.media_folders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: payment_methods update_payment_methods_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON public.payment_methods FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: payments update_payments_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: physical_tickets update_physical_tickets_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_physical_tickets_updated_at BEFORE UPDATE ON public.physical_tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: refunds update_refunds_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_refunds_updated_at BEFORE UPDATE ON public.refunds FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: sales_points update_sales_points_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_sales_points_updated_at BEFORE UPDATE ON public.sales_points FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: sales update_sales_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: seat_map_templates update_seat_map_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_seat_map_templates_updated_at BEFORE UPDATE ON public.seat_map_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: seat_maps update_seat_maps_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_seat_maps_updated_at BEFORE UPDATE ON public.seat_maps FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ticket_types update_ticket_types_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ticket_types_updated_at BEFORE UPDATE ON public.ticket_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: virtual_tickets update_virtual_tickets_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_virtual_tickets_updated_at BEFORE UPDATE ON public.virtual_tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: check_in_records check_in_records_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.check_in_records
    ADD CONSTRAINT check_in_records_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: check_in_records check_in_records_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.check_in_records
    ADD CONSTRAINT check_in_records_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- Name: event_additional_data event_additional_data_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_additional_data
    ADD CONSTRAINT event_additional_data_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: events events_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: events events_organizer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_organizer_id_fkey FOREIGN KEY (organizer_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: events events_seat_map_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_seat_map_id_fkey FOREIGN KEY (seat_map_id) REFERENCES public.seat_maps(id) ON DELETE SET NULL;


--
-- Name: media_folders media_folders_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_folders
    ADD CONSTRAINT media_folders_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.media_folders(id) ON DELETE CASCADE;


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id) ON DELETE CASCADE;


--
-- Name: physical_tickets physical_tickets_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.physical_tickets
    ADD CONSTRAINT physical_tickets_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: physical_tickets physical_tickets_ticket_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.physical_tickets
    ADD CONSTRAINT physical_tickets_ticket_type_id_fkey FOREIGN KEY (ticket_type_id) REFERENCES public.ticket_types(id) ON DELETE CASCADE;


--
-- Name: refunds refunds_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: sales sales_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: sales sales_ticket_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_ticket_type_id_fkey FOREIGN KEY (ticket_type_id) REFERENCES public.ticket_types(id) ON DELETE CASCADE;


--
-- Name: sales sales_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: seat_map_templates seat_map_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_map_templates
    ADD CONSTRAINT seat_map_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: seat_maps seat_maps_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_maps
    ADD CONSTRAINT seat_maps_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: seat_maps seat_maps_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_maps
    ADD CONSTRAINT seat_maps_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.seat_map_templates(id) ON DELETE SET NULL;


--
-- Name: seat_sections seat_sections_seat_map_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seat_sections
    ADD CONSTRAINT seat_sections_seat_map_id_fkey FOREIGN KEY (seat_map_id) REFERENCES public.seat_maps(id) ON DELETE CASCADE;


--
-- Name: seats seats_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.seat_sections(id) ON DELETE CASCADE;


--
-- Name: ticket_types ticket_types_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_types
    ADD CONSTRAINT ticket_types_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: tickets tickets_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id) ON DELETE CASCADE;


--
-- Name: virtual_tickets virtual_tickets_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_tickets
    ADD CONSTRAINT virtual_tickets_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: virtual_tickets virtual_tickets_ticket_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_tickets
    ADD CONSTRAINT virtual_tickets_ticket_type_id_fkey FOREIGN KEY (ticket_type_id) REFERENCES public.ticket_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

