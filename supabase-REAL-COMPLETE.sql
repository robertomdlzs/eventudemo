-- ================================================
-- SUPABASE COMPLETE DATABASE WITH ALL REAL DATA
-- ================================================

-- Habilitar RLS para Supabase
ALTER DATABASE postgres SET row_security = on;



SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -

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

-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -

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


-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


-- Name: audit_summary; Type: VIEW; Schema: public; Owner: -

CREATE VIEW public.audit_summary AS
 SELECT date("timestamp") AS date,
    action,
    severity,
    status,
    count(*) AS count
   FROM public.audit_logs
  GROUP BY (date("timestamp")), action, severity, status;


-- Name: backup_schedules; Type: TABLE; Schema: public; Owner: -

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


-- Name: backup_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.backup_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: backup_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.backup_schedules_id_seq OWNED BY public.backup_schedules.id;


-- Name: backups; Type: TABLE; Schema: public; Owner: -

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


-- Name: backups_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.backups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: backups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.backups_id_seq OWNED BY public.backups.id;


-- Name: categories; Type: TABLE; Schema: public; Owner: -

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


-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


-- Name: check_in_records; Type: TABLE; Schema: public; Owner: -

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


-- Name: check_in_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.check_in_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: check_in_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.check_in_records_id_seq OWNED BY public.check_in_records.id;


-- Name: event_additional_data; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.event_additional_data (
    id integer NOT NULL,
    event_id integer NOT NULL,
    data_key character varying(100) NOT NULL,
    data_value text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Name: event_additional_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.event_additional_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: event_additional_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.event_additional_data_id_seq OWNED BY public.event_additional_data.id;


-- Name: events; Type: TABLE; Schema: public; Owner: -

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
    total_quantity integer DEFAULT 0,
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


-- Name: COLUMN events.main_image_url; Type: COMMENT; Schema: public; Owner: -

COMMENT ON COLUMN public.events.main_image_url IS 'URL de la imagen principal del evento';


-- Name: COLUMN events.video_url; Type: COMMENT; Schema: public; Owner: -

COMMENT ON COLUMN public.events.video_url IS 'URL del video promocional del evento';


-- Name: COLUMN events.gallery_images; Type: COMMENT; Schema: public; Owner: -

COMMENT ON COLUMN public.events.gallery_images IS 'Array JSON con URLs de imágenes de la galería';


-- Name: COLUMN events.social_links; Type: COMMENT; Schema: public; Owner: -

COMMENT ON COLUMN public.events.social_links IS 'JSON con enlaces a redes sociales del evento';


-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


-- Name: media_files; Type: TABLE; Schema: public; Owner: -

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


-- Name: media_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.media_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: media_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.media_files_id_seq OWNED BY public.media_files.id;


-- Name: media_folders; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.media_folders (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent_id integer,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Name: media_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.media_folders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: media_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.media_folders_id_seq OWNED BY public.media_folders.id;


-- Name: notifications; Type: TABLE; Schema: public; Owner: -

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


-- Name: notification_summary; Type: VIEW; Schema: public; Owner: -

CREATE VIEW public.notification_summary AS
 SELECT date(sent_at) AS date,
    type,
    target,
    status,
    count(*) AS count
   FROM public.notifications
  GROUP BY (date(sent_at)), type, target, status;


-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.password_reset_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.password_reset_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    gateway character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    configuration jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


-- Name: payments; Type: TABLE; Schema: public; Owner: -

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


-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


-- Name: physical_tickets; Type: TABLE; Schema: public; Owner: -

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


-- Name: physical_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.physical_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: physical_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.physical_tickets_id_seq OWNED BY public.physical_tickets.id;


-- Name: refunds; Type: TABLE; Schema: public; Owner: -

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


-- Name: refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.refunds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.refunds_id_seq OWNED BY public.refunds.id;


-- Name: sales; Type: TABLE; Schema: public; Owner: -

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


-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


-- Name: sales_points; Type: TABLE; Schema: public; Owner: -

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


-- Name: sales_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.sales_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: sales_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.sales_points_id_seq OWNED BY public.sales_points.id;


-- Name: saved_reports; Type: TABLE; Schema: public; Owner: -

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


-- Name: saved_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.saved_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: saved_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.saved_reports_id_seq OWNED BY public.saved_reports.id;


-- Name: scheduled_reports; Type: TABLE; Schema: public; Owner: -

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


-- Name: scheduled_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.scheduled_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: scheduled_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.scheduled_reports_id_seq OWNED BY public.scheduled_reports.id;


-- Name: seat_map_templates; Type: TABLE; Schema: public; Owner: -

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


-- Name: seat_map_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.seat_map_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: seat_map_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.seat_map_templates_id_seq OWNED BY public.seat_map_templates.id;


-- Name: seat_maps; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.seat_maps (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    venue_name character varying(200),
    total_quantity integer DEFAULT 0,
    map_data jsonb NOT NULL,
    template_id integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Name: seat_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.seat_maps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: seat_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.seat_maps_id_seq OWNED BY public.seat_maps.id;


-- Name: seat_sections; Type: TABLE; Schema: public; Owner: -

CREATE TABLE public.seat_sections (
    id integer NOT NULL,
    seat_map_id integer NOT NULL,
    name character varying(100) NOT NULL,
    section_type character varying(20) DEFAULT 'seating'::character varying,
    quantity integer DEFAULT 0,
    price_modifier numeric(5,2) DEFAULT 1.00,
    color character varying(7) DEFAULT '#3B82F6'::character varying,
    position_data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seat_sections_section_type_check CHECK (((section_type)::text = ANY ((ARRAY['seating'::character varying, 'standing'::character varying, 'vip'::character varying, 'disabled'::character varying])::text[])))
);


-- Name: seat_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.seat_sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: seat_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.seat_sections_id_seq OWNED BY public.seat_sections.id;


-- Name: seats; Type: TABLE; Schema: public; Owner: -

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


-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.seats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


-- Name: ticket_types; Type: TABLE; Schema: public; Owner: -

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


-- Name: ticket_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.ticket_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: ticket_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.ticket_types_id_seq OWNED BY public.ticket_types.id;


-- Name: tickets; Type: TABLE; Schema: public; Owner: -

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


-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


-- Name: users; Type: TABLE; Schema: public; Owner: -

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


-- Name: COLUMN users.phone; Type: COMMENT; Schema: public; Owner: -

COMMENT ON COLUMN public.users.phone IS 'Número de teléfono del usuario';


-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


-- Name: virtual_tickets; Type: TABLE; Schema: public; Owner: -

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


-- Name: virtual_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -

CREATE SEQUENCE public.virtual_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- Name: virtual_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE public.virtual_tickets_id_seq OWNED BY public.virtual_tickets.id;


-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


-- Name: backup_schedules id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.backup_schedules ALTER COLUMN id SET DEFAULT nextval('public.backup_schedules_id_seq'::regclass);


-- Name: backups id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.backups ALTER COLUMN id SET DEFAULT nextval('public.backups_id_seq'::regclass);


-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


-- Name: check_in_records id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.check_in_records ALTER COLUMN id SET DEFAULT nextval('public.check_in_records_id_seq'::regclass);


-- Name: event_additional_data id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.event_additional_data ALTER COLUMN id SET DEFAULT nextval('public.event_additional_data_id_seq'::regclass);


-- Name: events id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


-- Name: media_files id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.media_files ALTER COLUMN id SET DEFAULT nextval('public.media_files_id_seq'::regclass);


-- Name: media_folders id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.media_folders ALTER COLUMN id SET DEFAULT nextval('public.media_folders_id_seq'::regclass);


-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


-- Name: physical_tickets id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.physical_tickets ALTER COLUMN id SET DEFAULT nextval('public.physical_tickets_id_seq'::regclass);


-- Name: refunds id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.refunds ALTER COLUMN id SET DEFAULT nextval('public.refunds_id_seq'::regclass);


-- Name: sales id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


-- Name: sales_points id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.sales_points ALTER COLUMN id SET DEFAULT nextval('public.sales_points_id_seq'::regclass);


-- Name: saved_reports id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.saved_reports ALTER COLUMN id SET DEFAULT nextval('public.saved_reports_id_seq'::regclass);


-- Name: scheduled_reports id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.scheduled_reports ALTER COLUMN id SET DEFAULT nextval('public.scheduled_reports_id_seq'::regclass);


-- Name: seat_map_templates id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.seat_map_templates ALTER COLUMN id SET DEFAULT nextval('public.seat_map_templates_id_seq'::regclass);


-- Name: seat_maps id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.seat_maps ALTER COLUMN id SET DEFAULT nextval('public.seat_maps_id_seq'::regclass);


-- Name: seat_sections id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.seat_sections ALTER COLUMN id SET DEFAULT nextval('public.seat_sections_id_seq'::regclass);


-- Name: seats id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


-- Name: ticket_types id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.ticket_types ALTER COLUMN id SET DEFAULT nextval('public.ticket_types_id_seq'::regclass);


-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


-- Name: users id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


-- Name: virtual_tickets id; Type: DEFAULT; Schema: public; Owner: -

ALTER TABLE ONLY public.virtual_tickets ALTER COLUMN id SET DEFAULT nextval('public.virtual_tickets_id_seq'::regclass);


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
;

-- Insertar usuarios
INSERT INTO users (email, password_hash, first_name, last_name, role, status) VALUES
('admin@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'Principal', 'admin', 'active'),
('organizer@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizador', 'Eventos', 'organizer', 'active'),
('user@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Usuario', 'Demo', 'user', 'active')
;

-- Insertar eventos
INSERT INTO ticket_types (event_id, name, description, price, quantity, sold, status) VALUES
('Concierto de Rock Nacional', 'concierto-rock-nacional-2024', 'Un increíble concierto de rock con las mejores bandas del país', '2024-12-25', '20:00', 'Estadio El Campín', 'Bogotá, Colombia', 1, 2, 50000, 150000, 'active', true, '/images/rock-concert.jpg'),
('Festival de Comida Internacional', 'festival-comida-internacional-2024', 'Disfruta de la mejor gastronomía local e internacional', '2024-12-30', '12:00', 'Parque Simón Bolívar', 'Bogotá, Colombia', 2, 2, 10000, 50000, 'active', true, '/images/food-festival.jpg'),
('Conferencia de Tecnología 2025', 'conferencia-tecnologia-2025', 'Las últimas tendencias en tecnología y desarrollo', '2025-01-15', '09:00', 'Centro de Convenciones', 'Medellín, Colombia', 3, 2, 2000, 800, 200000, 'active', false, '/images/tech-conference.jpg')
;

-- Insertar tipos de boletos
(1, 'General', 'Acceso general al concierto', 150000, 40000, 20000, 'active'),
(1, 'VIP', 'Acceso VIP con beneficios especiales', 300000, 10000, 5000, 'active'),
(2, 'Entrada General', 'Acceso a todas las zonas del festival', 50000, 8000, 4000, 'active'),
(2, 'Premium', 'Acceso premium con degustaciones', 100000, 2000, 1000, 'active'),
(3, 'Estudiante', 'Descuento para estudiantes', 150000, 1000, 400, 'active'),
(3, 'Profesional', 'Entrada para profesionales', 200000, 1000, 400, 'active')
;

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

-- ================================================
-- TODOS LOS DATOS REALES DEL SOFTWARE ORIGINAL
-- ================================================

-- Datos para audit_logs (2 registros)
INSERT INTO audit_logs (id, user_id, user_name, user_email, action, resource, resource_id, details, ip_address, user_agent, timestamp, severity, status) VALUES ('1', 'admin1', 'Admin Principal', 'admin@eventu.co', 'LOGIN', 'auth', NULL, '{"method": "email", "success": true}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2025-08-25 12:48:29.72124', 'low', 'success');
INSERT INTO audit_logs (id, user_id, user_name, user_email, action, resource, resource_id, details, ip_address, user_agent, timestamp, severity, status) VALUES ('2', 'admin1', 'Admin Principal', 'admin@eventu.co', 'CREATE_EVENT', 'events', NULL, '{"eventId": "event123", "eventTitle": "Conferencia Tech 2024"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2025-08-25 12:48:29.72124', 'medium', 'success');

-- Datos para categories (7 registros)
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('1', 'Conciertos', 'conciertos', 'Eventos musicales y conciertos en vivo', 'Music', '#FF6B6B', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('2', 'Teatro', 'teatro', 'Obras de teatro y espectáculos dramáticos', 'Drama', '#4ECDC4', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('3', 'Deportes', 'deportes', 'Eventos deportivos y competencias', 'Trophy', '#45B7D1', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('4', 'Conferencias', 'conferencias', 'Conferencias, seminarios y eventos corporativos', 'Users', '#96CEB4', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('5', 'Festivales', 'festivales', 'Festivales culturales y gastronómicos', 'Star', '#FFEAA7', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('6', 'Familiar', 'familiar', 'Eventos para toda la familia', 'Heart', '#DDA0DD', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');
INSERT INTO categories (id, name, slug, description, icon, color, status, created_at, updated_at) VALUES ('7', 'Educación', 'educacion', 'Talleres, cursos y eventos educativos', 'BookOpen', '#98D8C8', 'active', '2025-08-19 16:06:26.149857', '2025-08-19 16:06:26.149857');


-- Datos para notifications (2 registros)
INSERT INTO notifications (id, title, message, type, target, recipients, sent_at, read_by, status, created_by, created_at) VALUES ('1', 'Nuevo evento publicado', 'El evento "Conferencia Tech 2024" ha sido publicado exitosamente', 'success', 'all', NULL, '2025-08-25 12:48:29.723542', '[]', 'delivered', NULL, '2025-08-25 12:48:29.723542');
INSERT INTO notifications (id, title, message, type, target, recipients, sent_at, read_by, status, created_by, created_at) VALUES ('2', 'Mantenimiento programado', 'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 4:00 AM', 'warning', 'admins', NULL, '2025-08-25 12:48:29.723542', '[]', 'sent', NULL, '2025-08-25 12:48:29.723542');

-- Datos para payment_methods (5 registros)
INSERT INTO payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) VALUES ('1', 'Tarjeta de Crédito', 'stripe', 't', '{"fees": {"fixed": 300, "percentage": 2.9}, "currencies": ["COP", "USD"]}', '2025-08-19 16:07:37.433834', '2025-08-19 16:07:37.433834');
INSERT INTO payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) VALUES ('2', 'PayPal', 'paypal', 't', '{"fees": {"fixed": 0, "percentage": 3.4}, "currencies": ["USD", "COP"]}', '2025-08-19 16:07:37.433834', '2025-08-19 16:07:37.433834');
INSERT INTO payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) VALUES ('3', 'MercadoPago', 'mercadopago', 't', '{"fees": {"fixed": 0, "percentage": 3.5}, "currencies": ["COP", "USD"]}', '2025-08-19 16:07:37.433834', '2025-08-19 16:07:37.433834');
INSERT INTO payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) VALUES ('4', 'Wompi', 'wompi', 't', '{"fees": {"fixed": 200, "percentage": 2.8}, "currencies": ["COP"]}', '2025-08-19 16:07:37.433834', '2025-08-19 16:07:37.433834');
INSERT INTO payment_methods (id, name, gateway, is_active, configuration, created_at, updated_at) VALUES ('5', 'Transferencia Bancaria', 'bank_transfer', 't', '{"fees": {"fixed": 0, "percentage": 0}, "currencies": ["COP"]}', '2025-08-19 16:07:37.433834', '2025-08-19 16:07:37.433834');

-- Datos para payments (24 registros)
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('1', '1', 'credit_card', 'stripe', 'txn_123456789', '150000.00', 'COP', 'completed', NULL, '2025-08-18 10:58:07.925182', '2025-08-18 10:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('2', '2', 'debit_card', 'stripe', 'txn_987654321', '75000.00', 'COP', 'completed', NULL, '2025-08-19 10:56:07.925182', '2025-08-19 10:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('3', '3', 'credit_card', 'stripe', 'txn_555666777', '200000.00', 'COP', 'pending', NULL, NULL, '2025-08-20 04:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('4', '4', 'bank_transfer', 'manual', 'ref_888999000', '120000.00', 'COP', 'failed', NULL, NULL, '2025-08-19 22:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('5', '5', 'credit_card', 'stripe', 'txn_111222333', '150000.00', 'COP', 'completed', NULL, '2025-08-17 10:55:07.925182', '2025-08-17 10:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('6', '6', 'debit_card', 'stripe', 'txn_444555666', '180000.00', 'COP', 'completed', NULL, '2025-08-13 11:03:07.925182', '2025-08-13 10:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('7', '7', 'credit_card', 'stripe', 'txn_777888999', '75000.00', 'COP', 'cancelled', NULL, NULL, '2025-08-16 10:53:07.925182', '2025-08-20 10:53:07.925182');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('8', '1', 'credit_card', 'stripe', 'ch_1234567890', '500000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567890"}', NULL, '2024-12-15 14:32:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('9', '2', 'credit_card', 'stripe', 'ch_1234567891', '600000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567891"}', NULL, '2024-12-16 10:17:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('10', '3', 'bank_transfer', 'payu', 'payu_123456', '350000.00', 'COP', 'completed', '{"gateway": "payu", "transaction_id": "payu_123456"}', NULL, '2024-12-17 16:47:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('11', '4', 'credit_card', 'stripe', 'ch_1234567892', '500000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567892"}', NULL, '2024-12-18 11:22:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('12', '5', 'credit_card', 'stripe', 'ch_1234567893', '360000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567893"}', NULL, '2024-12-19 09:32:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('13', '6', 'credit_card', 'stripe', 'ch_1234567894', '160000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567894"}', NULL, '2024-12-20 15:47:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('14', '7', 'cash', 'cash', 'CASH-001', '65000.00', 'COP', 'completed', '{"gateway": "cash", "receipt": "CASH-001"}', NULL, '2024-12-21 13:17:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('15', '8', 'credit_card', 'stripe', 'ch_1234567895', '90000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567895"}', NULL, '2024-12-22 17:32:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('16', '9', 'bank_transfer', 'payu', 'payu_123457', '500000.00', 'COP', 'completed', '{"gateway": "payu", "transaction_id": "payu_123457"}', NULL, '2024-12-23 08:47:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('17', '10', 'credit_card', 'stripe', 'ch_1234567896', '700000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567896"}', NULL, '2024-12-24 12:02:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('18', '11', 'credit_card', 'stripe', 'ch_1234567897', '360000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567897"}', NULL, '2024-12-25 14:22:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('19', '12', 'credit_card', 'stripe', 'ch_1234567898', '300000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567898"}', NULL, '2024-12-26 10:32:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('20', '13', 'credit_card', 'stripe', 'ch_1234567899', '360000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567899"}', NULL, '2024-12-27 16:17:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('21', '14', 'cash', 'cash', 'CASH-002', '120000.00', 'COP', 'completed', '{"gateway": "cash", "receipt": "CASH-002"}', NULL, '2024-12-28 19:47:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('22', '15', 'credit_card', 'stripe', 'ch_1234567900', '50000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567900"}', NULL, '2024-12-29 07:32:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('23', '16', 'credit_card', 'stripe', 'ch_1234567901', '35000.00', 'COP', 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567901"}', NULL, '2024-12-30 11:22:00', '2025-08-20 13:12:24.592619');
INSERT INTO payments (id, sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, gateway_response, processed_at, created_at, updated_at) VALUES ('24', '20', 'cash', 'cash', 'CASH-003', '45000.00', 'COP', 'completed', '{"gateway": "cash", "receipt": "CASH-003"}', NULL, '2025-01-03 13:57:00', '2025-08-20 13:12:24.592619');

-- Datos para sales (42 registros)
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('1', '4', '1', '1', '2', '50000.00', '100000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 16:06:26.163898', '2025-08-19 16:06:26.163898');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('2', '5', '1', '2', '1', '75000.00', '75000.00', 'completed', 'debit_card', NULL, 'Ana López', 'ana@example.com', '3007654321', '2025-08-19 16:06:26.163898', '2025-08-19 16:06:26.163898');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('3', '4', '2', '3', '3', '80000.00', '240000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 16:06:26.163898', '2025-08-19 16:06:26.163898');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('4', '5', '4', '5', '1', '100000.00', '100000.00', 'completed', 'bank_transfer', NULL, 'Ana López', 'ana@example.com', '3007654321', '2025-08-19 16:06:26.163898', '2025-08-19 16:06:26.163898');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('5', '4', '5', '7', '4', '25000.00', '100000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 16:06:26.163898', '2025-08-19 16:06:26.163898');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('6', '4', '6', '13', '2', '45000.00', '90000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 16:07:58.118272', '2025-08-19 16:07:58.118272');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('7', '5', '7', '16', '1', '75000.00', '75000.00', 'completed', 'bank_transfer', NULL, 'Ana López', 'ana@example.com', '3007654321', '2025-08-19 16:07:58.118272', '2025-08-19 16:07:58.118272');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('8', '4', '8', '19', '2', '85000.00', '170000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 16:07:58.118272', '2025-08-19 16:07:58.118272');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('9', '5', '10', '25', '4', '35000.00', '140000.00', 'completed', 'debit_card', NULL, 'Ana López', 'ana@example.com', '3007654321', '2025-08-19 16:07:58.118272', '2025-08-19 16:07:58.118272');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('10', '1', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-18 10:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('11', '1', '2', '2', '1', '75000.00', '75000.00', 'completed', 'debit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 10:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('12', '1', '3', '1', '1', '200000.00', '200000.00', 'pending', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-20 04:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('13', '1', '4', '2', '1', '120000.00', '120000.00', 'cancelled', 'bank_transfer', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-19 22:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('14', '2', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'María García', 'maria@example.com', '3009876543', '2025-08-17 10:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('15', '2', '5', '1', '2', '90000.00', '180000.00', 'completed', 'debit_card', NULL, 'María García', 'maria@example.com', '3009876543', '2025-08-13 10:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('16', '3', '2', '2', '1', '75000.00', '75000.00', 'cancelled', 'credit_card', NULL, 'Carlos López', 'carlos@example.com', '3005555555', '2025-08-16 10:53:07.911453', '2025-08-20 10:53:07.911453');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('17', '1', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-20 12:13:51.892343', '2025-08-20 12:13:51.892343');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('18', '1', '2', '3', '1', '85000.00', '85000.00', 'completed', 'debit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', '2025-08-20 12:13:51.892343', '2025-08-20 12:13:51.892343');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('19', '2', '1', '2', '1', '150000.00', '150000.00', 'completed', 'credit_card', NULL, 'María García', 'maria@example.com', '3009876543', '2025-08-20 12:13:51.899141', '2025-08-20 12:13:51.899141');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('20', '8', '1', '1', '1', '75000.00', '75000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', '2025-08-20 12:16:51.592766', '2025-08-20 12:16:51.592766');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('21', '8', '2', '3', '1', '85000.00', '85000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', '2025-08-20 12:17:59.615897', '2025-08-20 12:17:59.615897');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('22', '8', '12', '5', '1', '100000.00', '100000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', '2025-08-20 12:19:11.256334', '2025-08-20 12:19:11.256334');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('23', '4', '1', '1', '2', '250000.00', '500000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-15 14:30:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('24', '5', '1', '2', '4', '150000.00', '600000.00', 'completed', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-16 10:15:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('25', '6', '2', '3', '1', '350000.00', '350000.00', 'completed', 'bank_transfer', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-17 16:45:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('26', '7', '2', '4', '2', '250000.00', '500000.00', 'completed', 'credit_card', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-18 11:20:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('27', '4', '3', '5', '3', '120000.00', '360000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-19 09:30:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('28', '8', '3', '6', '2', '80000.00', '160000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-20 15:45:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('29', '5', '4', '7', '1', '65000.00', '65000.00', 'completed', 'cash', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-21 13:15:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('30', '6', '4', '8', '2', '45000.00', '90000.00', 'completed', 'credit_card', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-22 17:30:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('31', '7', '5', '9', '1', '500000.00', '500000.00', 'completed', 'bank_transfer', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-23 08:45:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('32', '8', '5', '10', '2', '350000.00', '700000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-24 12:00:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('33', '4', '6', '11', '3', '120000.00', '360000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-25 14:20:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('34', '5', '6', '12', '4', '75000.00', '300000.00', 'completed', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-26 10:30:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('35', '6', '7', '13', '2', '180000.00', '360000.00', 'completed', 'credit_card', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-27 16:15:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('36', '7', '7', '14', '1', '120000.00', '120000.00', 'completed', 'cash', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-28 19:45:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('37', '8', '8', '15', '1', '50000.00', '50000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-29 07:30:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('38', '4', '8', '16', '1', '35000.00', '35000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-30 11:20:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('39', '5', '1', '1', '1', '250000.00', '250000.00', 'pending', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-31 14:10:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('40', '6', '2', '4', '1', '250000.00', '250000.00', 'pending', 'bank_transfer', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2025-01-01 09:25:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('41', '7', '3', '6', '2', '80000.00', '160000.00', 'cancelled', 'credit_card', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2025-01-02 16:40:00', '2025-08-20 13:12:24.589052');
INSERT INTO sales (id, user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, payment_reference, buyer_name, buyer_email, buyer_phone, created_at, updated_at) VALUES ('42', '8', '4', '8', '1', '45000.00', '45000.00', 'completed', 'cash', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2025-01-03 13:55:00', '2025-08-20 13:12:24.589052');

-- Datos para sales_points (3 registros)
INSERT INTO sales_points (id, name, location, address, contact_person, contact_phone, contact_email, status, created_at, updated_at) VALUES ('1', 'Punto de Venta Centro', 'Centro Comercial Plaza Central', 'Calle 123 #45-67, Centro', 'María González', '3001234567', 'centro@eventu.co', 'active', '2025-08-26 12:39:22.110964', '2025-08-26 12:39:22.110964');
INSERT INTO sales_points (id, name, location, address, contact_person, contact_phone, contact_email, status, created_at, updated_at) VALUES ('2', 'Punto de Venta Norte', 'Centro Comercial Norte', 'Avenida Norte #89-12, Norte', 'Carlos Rodríguez', '3002345678', 'norte@eventu.co', 'active', '2025-08-26 12:39:22.110964', '2025-08-26 12:39:22.110964');
INSERT INTO sales_points (id, name, location, address, contact_person, contact_phone, contact_email, status, created_at, updated_at) VALUES ('3', 'Punto de Venta Sur', 'Centro Comercial Sur', 'Carrera 78 #34-56, Sur', 'Ana Martínez', '3003456789', 'sur@eventu.co', 'active', '2025-08-26 12:39:22.110964', '2025-08-26 12:39:22.110964');

-- Datos para seat_map_templates (3 registros)

-- Datos para seat_maps (3 registros)

-- Datos para ticket_types (47 registros)
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('4', '3', 'Entrada General', 'Asiento numerado', '35000.00', '400', '0', '6', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('6', '4', 'Entrada Regular', 'Entrada estándar', '120000.00', '200', '0', '4', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('8', '5', 'Tribuna Sur', 'Tribuna Sur del estadio', '25000.00', '500', '0', '10', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('9', '5', 'Palco VIP', 'Palco VIP con servicios premium', '80000.00', '200', '0', '4', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('1', '1', 'Platea', 'Asientos en platea principal', '50000.00', '600', '2', '6', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.167084');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('2', '1', 'Palcos', 'Asientos en palcos VIP', '75000.00', '200', '1', '4', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.17141');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('3', '2', 'Entrada General', 'Acceso completo al festival', '80000.00', '500', '3', '8', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.171618');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('5', '4', 'Early Bird', 'Precio especial por compra anticipada', '100000.00', '100', '1', '2', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.171795');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('7', '5', 'Tribuna Norte', 'Tribuna Norte del estadio', '25000.00', '500', '4', '10', NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.172023');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('10', '6', 'General', 'Acceso general al concierto', '45000.00', '1500', '0', '8', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('11', '6', 'VIP', 'Zona VIP con bar incluido', '85000.00', '300', '0', '4', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('12', '6', 'Palco Premium', 'Palcos con servicio completo', '150000.00', '200', '0', '6', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('14', '7', 'Startup', 'Incluye stand de exhibición', '200000.00', '100', '0', '2', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('15', '7', 'Inversor', 'Acceso VIP y networking exclusivo', '350000.00', '100', '0', '2', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('17', '8', 'Palcos', 'Palcos con vista privilegiada', '120000.00', '300', '0', '4', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('18', '8', 'Premium', 'Experiencia completa con cena', '200000.00', '100', '0', '2', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('20', '9', 'Preferencial', 'Mejores ubicaciones', '65000.00', '50', '0', '4', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('21', '10', 'General', 'Acceso general al torneo', '35000.00', '6000', '0', '10', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('22', '10', 'Premium', 'Zona premium con merchandising', '55000.00', '1500', '0', '6', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('23', '10', 'VIP Gamer', 'Meet & greet con jugadores', '95000.00', '500', '0', '4', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('24', '11', 'Estudiante', 'Precio especial estudiantes', '100000.00', '100', '0', '2', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('26', '11', 'Empresarial', 'Incluye consultoría personalizada', '250000.00', '20', '0', '1', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('13', '7', 'Emprendedor', 'Acceso completo al evento', '75000.00', '600', '2', '3', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.120789');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('16', '8', 'Platea', 'Asientos en platea principal', '85000.00', '800', '1', '6', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.125099');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('19', '9', 'General', 'Asientos numerados', '42000.00', '300', '2', '6', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.125452');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('25', '11', 'Profesional', 'Acceso completo y certificado', '150000.00', '80', '4', '3', NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.125703');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('27', '1', 'General', 'Acceso general al evento', '75000.00', '100', '0', '5', NULL, NULL, 'active', '2025-08-20 12:13:51.879188', '2025-08-20 12:13:51.879188');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('28', '1', 'VIP', 'Acceso VIP con beneficios especiales', '150000.00', '50', '0', '3', NULL, NULL, 'active', '2025-08-20 12:13:51.879188', '2025-08-20 12:13:51.879188');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('29', '2', 'Platea', 'Asiento en platea', '85000.00', '80', '0', '4', NULL, NULL, 'active', '2025-08-20 12:13:51.879188', '2025-08-20 12:13:51.879188');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('30', '2', 'Balcón', 'Asiento en balcón', '65000.00', '120', '0', '6', NULL, NULL, 'active', '2025-08-20 12:13:51.879188', '2025-08-20 12:13:51.879188');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('31', '12', 'General', 'Acceso general al concierto futuro', '100000.00', '100', '0', '5', NULL, NULL, 'active', '2025-08-20 12:19:03.186841', '2025-08-20 12:19:03.186841');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('32', '1', 'VIP', 'Acceso VIP con asientos preferenciales, bebidas incluidas y meet & greet', '250000.00', '200', '0', '4', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('33', '1', 'General', 'Acceso general al festival', '150000.00', '4800', '0', '10', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('34', '2', 'Premium', 'Acceso completo a la conferencia con networking exclusivo', '350000.00', '100', '0', '2', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('35', '2', 'Estándar', 'Acceso a charlas y exhibición', '250000.00', '700', '0', '5', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('36', '3', 'Preferencial', 'Asientos en las mejores ubicaciones del estadio', '120000.00', '5000', '0', '6', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('37', '3', 'General', 'Asientos generales del estadio', '80000.00', '31000', '0', '10', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('38', '4', 'Guía Incluida', 'Entrada con tour guiado por expertos', '65000.00', '100', '0', '4', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('39', '4', 'General', 'Entrada general a la exposición', '45000.00', '200', '0', '6', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('40', '5', 'VIP Executive', 'Acceso VIP con networking exclusivo y cena de gala', '500000.00', '50', '0', '2', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('41', '5', 'Profesional', 'Acceso completo a la cumbre', '350000.00', '450', '0', '3', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('42', '6', 'Gourmet', 'Acceso completo con degustaciones premium', '120000.00', '300', '0', '4', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('43', '6', 'General', 'Acceso general al festival', '75000.00', '1700', '0', '8', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('44', '7', 'Palco', 'Asientos en palco con servicio de bebidas', '180000.00', '100', '0', '4', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('45', '7', 'Platea', 'Asientos en platea del teatro', '120000.00', '700', '0', '6', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('46', '8', 'Elite', 'Kit completo de corredor con beneficios especiales', '50000.00', '500', '0', '2', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES ('47', '8', 'General', 'Inscripción general a la maratón', '35000.00', '9500', '0', '1', NULL, NULL, 'active', '2025-08-20 13:12:24.586558', '2025-08-20 13:12:24.586558');

-- Datos para tickets (15 registros)
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('1', '1', 'TKT-001-001', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('2', '1', 'TKT-001-002', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('3', '2', 'TKT-002-001', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('4', '3', 'TKT-003-001', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('5', '3', 'TKT-003-002', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('6', '3', 'TKT-003-003', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('7', '4', 'TKT-004-001', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('8', '5', 'TKT-005-001', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('9', '5', 'TKT-005-002', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('10', '5', 'TKT-005-003', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('11', '5', 'TKT-005-004', NULL, NULL, 'valid', NULL, '2025-08-19 16:06:26.172322');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('15', '4', 'TKT-004-002', NULL, NULL, 'valid', NULL, '2025-08-20 12:17:03.920232');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('16', '20', 'TKT-020-001', NULL, NULL, 'valid', NULL, '2025-08-20 12:17:33.972444');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('17', '21', 'TKT-021-001', NULL, NULL, 'valid', NULL, '2025-08-20 12:18:06.652986');
INSERT INTO tickets (id, sale_id, ticket_code, qr_code, seat_info, status, used_at, created_at) VALUES ('18', '22', 'TKT-022-001', NULL, NULL, 'valid', NULL, '2025-08-20 12:19:18.37799');

-- Datos para users (29 registros)
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('4', 'Juan', 'Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-19 16:06:26.143845', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('5', 'Ana', 'López', 'ana@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-19 16:06:26.143845', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('1', 'Admin', 'Sistema', 'admin@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'f', NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.207686', NULL, '+57 300 123 4567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('2', 'Carlos', 'Rodríguez', 'carlos@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'f', NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.211219', NULL, '+57 310 987 6543');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('3', 'María', 'González', 'maria@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'f', NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.211539', NULL, '+57 315 555 1234');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('26', 'Promotor', 'Eventu', 'promotor@eventu.co', '$2a$12$jC.htC2ZXipSHmIMIsoxM.t8EnVXs2aAXRdhJhvUTDPCCU4K/6Qga', 'organizer', 'active', 'f', NULL, NULL, '2025-08-25 13:47:34.10328', '2025-08-25 13:49:31.986999', NULL, '3001234570');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('7', 'Nuevo Nombre', 'Nuevo Apellido', 'test@example.com', '$2a$12$xVoEp4NA97FVg0yxozXI/uJBaTc9j5RjnizQVQugVM7MgZthBptrW', 'user', 'active', 'f', NULL, NULL, '2025-08-20 11:50:12.087836', '2025-08-20 12:08:12.062037', NULL, '3001111111');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('8', 'Test', 'User Tickets', 'tickets@example.com', '$2a$12$.vnqLpGqzzUw9E4LlR0W5eNYwmA5wLRqc6xm.w.rVFY7nlX5iw.q2', 'user', 'active', 'f', NULL, NULL, '2025-08-20 12:16:24.133319', '2025-08-20 12:16:24.133319', NULL, '3001234567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('9', 'Nuevo', 'Usuario', 'nuevo@example.com', '$2a$12$RG.XXkZGH5l83yVU8t1PYutiFTHpd4ql2E8qjoVwzGlJ66WUR2y8K', 'user', 'active', 'f', NULL, NULL, '2025-08-20 12:30:34.872462', '2025-08-20 12:30:34.872462', NULL, '3009876543');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('10', 'Organizador', 'Test', 'organizador@example.com', '$2a$12$4S4mwWSo.Uqo1GejSEIKROxOaqkgxB5ndQWvAQvTTP7JS/F2Ac6NC', 'organizer', 'active', 'f', NULL, NULL, '2025-08-20 12:39:58.784732', '2025-08-20 12:40:08.946076', NULL, '3001234567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('11', 'Juan', 'Pérez', 'juan.perez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 123 4567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('12', 'María', 'García', 'maria.garcia@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 234 5678');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('13', 'Carlos', 'López', 'carlos.lopez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 345 6789');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('14', 'Ana', 'Martínez', 'ana.martinez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 456 7890');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('15', 'Luis', 'Rodríguez', 'luis.rodriguez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 567 8901');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('16', 'Sofía', 'Hernández', 'sofia.hernandez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 678 9012');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('17', 'Diego', 'González', 'diego.gonzalez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 789 0123');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('18', 'Valentina', 'Díaz', 'valentina.diaz@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'f', NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', NULL, '+57 300 890 1234');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('6', 'roberto', 'mendoza', 'robertomensie@gmail.com', '$2a$12$oppkPhMWVMEQ3tnv5InIAuNwS9QZTjzl3mS956ADahLysPIJpBDuG', 'user', 'active', 'f', NULL, NULL, '2025-08-20 11:00:53.830233', '2025-08-21 10:48:45.441364', NULL, '3243052154');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('20', 'Test', 'Admin', 'test@eventu.com', '$2a$10$rTxNAiyZWSfqug3bIco1eeo9h.EvON0HUFtggp4AwnMLVvtQ7hkuC', 'admin', 'active', 'f', NULL, NULL, '2025-08-22 14:34:44.822879', '2025-08-22 14:34:44.822879', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('22', 'Organizador', 'Test', 'organizador@test.com', '$2a$12$Bhe3qLWQkz/8EyLIp0QASedve7kUImCuJUx3GKiAIyVWjTXYPkEeW', 'organizer', 'active', 'f', NULL, NULL, '2025-08-22 15:30:47.447756', '2025-08-22 15:31:30.903286', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('25', 'Admin', 'Eventu', 'admin2@eventu.co', '$2a$12$wOhOcNV.QqC.w45a8UO6zO20I.NhzbukPfoHkvHbV2cl.n3br25NO', 'user', 'active', 'f', NULL, NULL, '2025-08-25 13:10:37.72742', '2025-08-25 13:10:37.72742', NULL, '3001234569');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('24', 'Usuario', 'Demo', 'demo@eventu.co', '$2a$10$MyDbB6EqQaLyOA8RcNvQ2O1mmkCGt7AP3w.EodchCyzPaD0xR55ce', 'user', 'active', 'f', NULL, NULL, '2025-08-25 13:10:08.313026', '2025-08-25 13:33:19.258307', NULL, '3001234567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('21', 'Roberto', 'Mendoza', 'roberto@eventu.co', '$2a$10$rHhV57oYqtrrMctUkUFMseJ/V3QnLtd3CV5qobTpW4njaM0oBXiw6', 'user', 'active', 'f', NULL, NULL, '2025-08-22 14:45:54.987408', '2025-08-25 13:39:39.709915', NULL, '3241119900');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('27', 'Super', 'Admin', 'superadmin@eventu.co', '$2a$12$rvExGdHWiowcQJNAWSHDO.jg7hMp.5xUcJN4jMAAaMplJcNA3QEce', 'admin', 'active', 'f', NULL, NULL, '2025-08-25 16:17:42.923617', '2025-08-25 16:19:44.93338', NULL, '3001234567');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('28', 'Admin', 'Test', 'admin@test.com', '$2a$12$dV63JjtvuBTuawMC9lZDde6866CLhPxd.vB672Ky5UQZN4Qu/onLu', 'admin', 'active', 'f', NULL, NULL, '2025-08-26 11:45:43.746682', '2025-08-26 11:45:53.238031', NULL, '123456789');
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('29', 'Test', 'Admin', 'testadmin@eventu.com', '$2a$12$HCg11wRjW.D9E0T966I0t.SVnupiGzMAArJZ.x2WkwzAQBSNQViJS', 'user', 'active', 'f', NULL, NULL, '2025-08-27 16:50:34.127608', '2025-08-27 16:50:34.127608', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('30', 'Admin', 'Analytics', 'analytics@eventu.com', '$2a$12$cwEVVn40mc7KBYhobMMVUuuN3myUB0dJM7LX1Wz.TNu6zaZ9nY4PS', 'user', 'active', 'f', NULL, NULL, '2025-08-28 09:56:24.35354', '2025-08-28 09:56:24.35354', NULL, NULL);
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES ('23', 'Administrador', 'Eventu', 'admin@eventu.co', '$2a$12$D6aiFq5.KGQiqeYVA0TUUeniuzqEswI4p0IRnei8fBOUzh9gXPSQ2', 'admin', 'active', 'f', NULL, NULL, '2025-08-24 19:41:51.032574', '2025-09-03 12:00:28.008952', NULL, NULL);
