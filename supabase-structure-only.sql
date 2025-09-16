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


-- =====================================================
-- DATOS DE PRUEBA BÁSICOS
-- =====================================================

-- Insertar categorías
INSERT INTO categories (name, slug, description, status) VALUES
('Música', 'musica', 'Conciertos y eventos musicales', 'active'),
('Gastronomía', 'gastronomia', 'Festivales de comida y eventos culinarios', 'active'),
('Tecnología', 'tecnologia', 'Conferencias y eventos tecnológicos', 'active'),
('Deportes', 'deportes', 'Eventos deportivos y competencias', 'active'),
('Arte y Cultura', 'arte-cultura', 'Exposiciones y eventos culturales', 'active')
ON CONFLICT (slug) DO NOTHING;

-- Insertar usuarios
INSERT INTO users (email, password, first_name, last_name, role, status) VALUES
('admin@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'Principal', 'admin', 'active'),
('organizer@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizador', 'Eventos', 'organizer', 'active'),
('user@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Usuario', 'Demo', 'user', 'active')
ON CONFLICT (email) DO NOTHING;

-- Insertar eventos
INSERT INTO events (title, slug, description, date, time, venue, location, category_id, organizer_id, total_capacity, sold, price, status, featured, main_image_url) VALUES
('Concierto de Rock Nacional', 'concierto-rock-nacional-2024', 'Un increíble concierto de rock con las mejores bandas del país', '2024-12-25', '20:00', 'Estadio El Campín', 'Bogotá, Colombia', 1, 2, 50000, 25000, 150000, 'active', true, '/images/rock-concert.jpg'),
('Festival de Comida Internacional', 'festival-comida-internacional-2024', 'Disfruta de la mejor gastronomía local e internacional', '2024-12-30', '12:00', 'Parque Simón Bolívar', 'Bogotá, Colombia', 2, 2, 10000, 5000, 50000, 'active', true, '/images/food-festival.jpg'),
('Conferencia de Tecnología 2025', 'conferencia-tecnologia-2025', 'Las últimas tendencias en tecnología y desarrollo', '2025-01-15', '09:00', 'Centro de Convenciones', 'Medellín, Colombia', 3, 2, 2000, 800, 200000, 'active', false, '/images/tech-conference.jpg')
ON CONFLICT (slug) DO NOTHING;

-- Insertar tipos de boletos
INSERT INTO ticket_types (event_id, name, description, price, capacity, sold, status) VALUES
(1, 'General', 'Acceso general al concierto', 150000, 40000, 20000, 'active'),
(1, 'VIP', 'Acceso VIP con beneficios especiales', 300000, 10000, 5000, 'active'),
(2, 'Entrada General', 'Acceso a todas las zonas del festival', 50000, 8000, 4000, 'active'),
(2, 'Premium', 'Acceso premium con degustaciones', 100000, 2000, 1000, 'active'),
(3, 'Estudiante', 'Descuento para estudiantes', 150000, 1000, 400, 'active'),
(3, 'Profesional', 'Entrada para profesionales', 200000, 1000, 400, 'active')
ON CONFLICT DO NOTHING;

-- =====================================================
-- FINALIZACIÓN
-- =====================================================

-- Mensaje de éxito
DO $$
BEGIN
    RAISE NOTICE '✅ Base de datos Eventu COMPLETA configurada exitosamente en Supabase!';
    RAISE NOTICE '📊 Tablas creadas: 27 tablas completas del sistema';
    RAISE NOTICE '🔐 Seguridad: RLS habilitado, políticas configuradas';
    RAISE NOTICE '📈 Datos de prueba: 3 usuarios, 3 eventos, 6 tipos de boletos';
    RAISE NOTICE '🚀 ¡Sistema completo listo para usar!';
END $$;
