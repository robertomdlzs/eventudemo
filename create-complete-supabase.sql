-- =====================================================
-- EVENTU DATABASE - COMPLETE SUPABASE EXPORT
-- =====================================================
-- Exportado desde: PostgreSQL 17.5
-- Formato: Supabase compatible
-- Fecha: $(date)
-- =====================================================

-- Configuración inicial para Supabase
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;

-- =====================================================
-- EXTRAER SOLO LA ESTRUCTURA DE LAS TABLAS
-- =====================================================
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
-- DATOS COMPLETOS DEL SOFTWARE ORIGINAL
-- =====================================================

-- Insertar TODOS los usuarios del archivo original
INSERT INTO users (id, first_name, last_name, email, password_hash, role, status, is_2fa_enabled, two_factor_secret, email_verified_at, created_at, updated_at, last_login, phone) VALUES
(1, 'Admin', 'Sistema', 'admin@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', false, NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.207686', NULL, '+57 300 123 4567'),
(2, 'Carlos', 'Rodríguez', 'carlos@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', false, NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.211219', NULL, '+57 310 987 6543'),
(3, 'María', 'González', 'maria@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', false, NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-20 11:46:26.211539', NULL, '+57 315 555 1234'),
(4, 'Juan', 'Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-19 16:06:26.143845', NULL, NULL),
(5, 'Ana', 'López', 'ana@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, NULL, '2025-08-19 16:06:26.143845', '2025-08-19 16:06:26.143845', NULL, NULL),
(6, 'roberto', 'mendoza', 'robertomensie@gmail.com', '$2a$12$oppkPhMWVMEQ3tnv5InIAuNwS9QZTjzl3mS956ADahLysPIJpBDuG', 'user', 'active', false, NULL, NULL, '2025-08-20 11:00:53.830233', '2025-08-21 10:48:45.441364', NULL, '3243052154'),
(7, 'Nuevo Nombre', 'Nuevo Apellido', 'test@example.com', '$2a$12$xVoEp4NA97FVg0yxozXI/uJBaTc9j5RjnizQVQugVM7MgZthBptrW', 'user', 'active', false, NULL, NULL, '2025-08-20 11:50:12.087836', '2025-08-20 12:08:12.062037', NULL, '3001111111'),
(8, 'Test', 'User Tickets', 'tickets@example.com', '$2a$12$.vnqLpGqzzUw9E4LlR0W5eNYwmA5wLRqc6xm.w.rVFY7nlX5iw.q2', 'user', 'active', false, NULL, NULL, '2025-08-20 12:16:24.133319', '2025-08-20 12:16:24.133319', NULL, '3001234567'),
(9, 'Nuevo', 'Usuario', 'nuevo@example.com', '$2a$12$RG.XXkZGH5l83yVU8t1PYutiFTHpd4ql2E8qjoVwzGlJ66WUR2y8K', 'user', 'active', false, NULL, NULL, '2025-08-20 12:30:34.872462', '2025-08-20 12:30:34.872462', NULL, '3009876543'),
(10, 'Organizador', 'Test', 'organizador@example.com', '$2a$12$4S4mwWSo.Uqo1GejSEIKROxOaqkgxB5ndQWvAQvTTP7JS/F2Ac6NC', 'organizer', 'active', false, NULL, NULL, '2025-08-20 12:39:58.784732', '2025-08-20 12:40:08.946076', NULL, '3001234567'),
(11, 'Juan', 'Pérez', 'juan.perez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 123 4567'),
(12, 'María', 'García', 'maria.garcia@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 234 5678'),
(13, 'Carlos', 'López', 'carlos.lopez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 345 6789'),
(14, 'Ana', 'Martínez', 'ana.martinez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 456 7890'),
(15, 'Luis', 'Rodríguez', 'luis.rodriguez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 567 8901'),
(16, 'Sofía', 'Hernández', 'sofia.hernandez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 678 9012'),
(17, 'Diego', 'González', 'diego.gonzalez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 789 0123'),
(18, 'Valentina', 'Díaz', 'valentina.diaz@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', false, NULL, '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '2025-08-20 13:08:24.814296', '+57 300 890 1234'),
(20, 'Test', 'Admin', 'test@eventu.com', '$2a$10$rTxNAiyZWSfqug3bIco1eeo9h.EvON0HUFtggp4AwnMLVvtQ7hkuC', 'admin', 'active', false, NULL, NULL, '2025-08-22 14:34:44.822879', '2025-08-22 14:34:44.822879', NULL, NULL),
(21, 'Roberto', 'Mendoza', 'roberto@eventu.co', '$2a$10$rHhV57oYqtrrMctUkUFMseJ/V3QnLtd3CV5qobTpW4njaM0oBXiw6', 'user', 'active', false, NULL, NULL, '2025-08-22 14:45:54.987408', '2025-08-25 13:39:39.709915', NULL, '3241119900'),
(22, 'Organizador', 'Test', 'organizador@test.com', '$2a$12$Bhe3qLWQkz/8EyLIp0QASedve7kUImCuJUx3GKiAIyVWjTXYPkEeW', 'organizer', 'active', false, NULL, NULL, '2025-08-22 15:30:47.447756', '2025-08-22 15:31:30.903286', NULL, NULL),
(23, 'Administrador', 'Eventu', 'admin@eventu.co', '$2a$12$D6aiFq5.KGQiqeYVA0TUUeniuzqEswI4p0IRnei8fBOUzh9gXPSQ2', 'admin', 'active', false, NULL, NULL, '2025-08-24 19:41:51.032574', '2025-09-03 12:00:28.008952', NULL, NULL),
(24, 'Usuario', 'Demo', 'demo@eventu.co', '$2a$10$MyDbB6EqQaLyOA8RcNvQ2O1mmkCGt7AP3w.EodchCyzPaD0xR55ce', 'user', 'active', false, NULL, NULL, '2025-08-25 13:10:08.313026', '2025-08-25 13:33:19.258307', NULL, '3001234567'),
(25, 'Admin', 'Eventu', 'admin2@eventu.co', '$2a$12$wOhOcNV.QqC.w45a8UO6zO20I.NhzbukPfoHkvHbV2cl.n3br25NO', 'user', 'active', false, NULL, NULL, '2025-08-25 13:10:37.72742', '2025-08-25 13:10:37.72742', NULL, '3001234569'),
(26, 'Promotor', 'Eventu', 'promotor@eventu.co', '$2a$12$jC.htC2ZXipSHmIMIsoxM.t8EnVXs2aAXRdhJhvUTDPCCU4K/6Qga', 'organizer', 'active', false, NULL, NULL, '2025-08-25 13:47:34.10328', '2025-08-25 13:49:31.986999', NULL, '3001234570'),
(27, 'Super', 'Admin', 'superadmin@eventu.co', '$2a$12$rvExGdHWiowcQJNAWSHDO.jg7hMp.5xUcJN4jMAAaMplJcNA3QEce', 'admin', 'active', false, NULL, NULL, '2025-08-25 16:17:42.923617', '2025-08-25 16:19:44.93338', NULL, '3001234567'),
(28, 'Admin', 'Test', 'admin@test.com', '$2a$12$dV63JjtvuBTuawMC9lZDde6866CLhPxd.vB672Ky5UQZN4Qu/onLu', 'admin', 'active', false, NULL, NULL, '2025-08-26 11:45:43.746682', '2025-08-26 11:45:53.238031', NULL, '123456789'),
(29, 'Test', 'Admin', 'testadmin@eventu.com', '$2a$12$HCg11wRjW.D9E0T966I0t.SVnupiGzMAArJZ.x2WkwzAQBSNQViJS', 'user', 'active', false, NULL, NULL, '2025-08-27 16:50:34.127608', '2025-08-27 16:50:34.127608', NULL, NULL),
(30, 'Admin', 'Analytics', 'analytics@eventu.com', '$2a$12$cwEVVn40mc7KBYhobMMVUuuN3myUB0dJM7LX1Wz.TNu6zaZ9nY4PS', 'user', 'active', false, NULL, NULL, '2025-08-28 09:56:24.35354', '2025-08-28 09:56:24.35354', NULL, NULL);


-- Insertar TODOS los eventos del archivo original
INSERT INTO events (id, title, slug, description, long_description, date, "time", venue, location, category_id, organizer_id, total_capacity, price, status, sales_start_date, sales_end_date, youtube_url, image_url, featured, seat_map_id, created_at, updated_at, main_image_url, video_url, gallery_images, social_links) VALUES
(1, 'Concierto Sinfónico de Año Nuevo', 'concierto-sinfonico-ano-nuevo', 'Gran concierto sinfónico para celebrar el año nuevo', 'La Orquesta Sinfónica Nacional presenta un espectacular concierto para recibir el año nuevo con las mejores melodías clásicas y contemporáneas. Una noche mágica llena de música y emociones.', '2024-12-31', '20:00:00', 'Teatro Nacional', 'BOGOTÁ', 1, 2, 800, 50000.00, 'published', '2024-01-01 00:00:00', NULL, 'https://youtube.com/watch?v=example1', '/images/concierto-sinfonico.jpg', true, 1, '2025-08-19 16:06:26.156369', '2025-08-26 10:11:24.240431', '/images/concierto-sinfonico.jpg', 'https://youtube.com/watch?v=example1', '[]', '{}'),
(2, 'Festival Gastronómico Internacional', 'festival-gastronomico-internacional', 'Festival con los mejores chefs internacionales', 'Disfruta de una experiencia culinaria única con chefs reconocidos mundialmente. Degustaciones, talleres y espectáculos gastronómicos en un solo lugar.', '2024-03-15', '18:00:00', 'Centro de Convenciones', 'MEDELLÍN', 5, 2, 500, 80000.00, 'published', '2024-01-15 00:00:00', NULL, 'https://youtube.com/watch?v=example2', '/images/festival-gastronomico.jpg', true, 2, '2025-08-19 16:06:26.156369', '2025-08-26 10:11:24.240431', '/images/festival-gastronomico.jpg', 'https://youtube.com/watch?v=example2', '[]', '{}'),
(3, 'Obra: Romeo y Julieta', 'obra-romeo-julieta', 'Clásica obra de Shakespeare', 'La compañía de teatro más prestigiosa del país presenta esta obra maestra de William Shakespeare con una puesta en escena moderna y emotiva.', '2024-02-20', '19:30:00', 'Teatro Colón', 'BOGOTÁ', 2, 26, 400, 35000.00, 'published', '2024-01-10 00:00:00', NULL, NULL, '/images/romeo-julieta.jpg', false, NULL, '2025-08-19 16:06:26.156369', '2025-08-29 16:01:10.785409', '/images/romeo-julieta.jpg', NULL, '[]', '{}'),
(4, 'Conferencia Tech Summit 2024', 'tech-summit-2024', 'La conferencia de tecnología más importante del año', 'Líderes de la industria tecnológica se reúnen para compartir las últimas tendencias en IA, blockchain, desarrollo web y más. Networking y oportunidades de negocio.', '2024-04-10', '09:00:00', 'Centro Empresarial', 'BOGOTÁ', 4, 2, 300, 120000.00, 'published', '2024-02-01 00:00:00', NULL, 'https://youtube.com/watch?v=example3', '/images/tech-summit.jpg', true, NULL, '2025-08-19 16:06:26.156369', '2025-08-26 10:11:24.240431', '/images/tech-summit.jpg', 'https://youtube.com/watch?v=example3', '[]', '{}'),
(5, 'Partido Clásico: Millonarios vs Nacional', 'partido-millonarios-nacional', 'El clásico más esperado del fútbol colombiano', 'El encuentro más emocionante del fútbol profesional colombiano. Dos equipos históricos se enfrentan en un partido que promete emociones fuertes.', '2024-03-25', '16:00:00', 'Estadio El Campín', 'BOGOTÁ', 3, 3, 1200, 25000.00, 'published', '2024-02-25 00:00:00', NULL, NULL, '/images/clasico-futbol.jpg', true, 2, '2025-08-19 16:06:26.156369', '2025-08-26 10:11:24.240431', '/images/clasico-futbol.jpg', NULL, '[]', '{}'),
(6, 'Concierto Rock Nacional', 'concierto-rock-nacional', 'Los mejores exponentes del rock colombiano', 'Una noche épica con las bandas más representativas del rock nacional. Desde los clásicos hasta las nuevas propuestas que están revolucionando la escena musical colombiana.', '2024-05-15', '21:00:00', 'Coliseo Live', 'BOGOTÁ', 1, 2, 2000, 45000.00, 'published', '2024-03-01 00:00:00', NULL, 'https://youtube.com/watch?v=rock-nacional', '/images/rock-nacional.jpg', true, 2, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/rock-nacional.jpg', 'https://youtube.com/watch?v=rock-nacional', '[]', '{}'),
(7, 'Feria de Emprendimiento Digital', 'feria-emprendimiento-digital', 'Conecta con startups y emprendedores', 'El evento más importante para emprendedores digitales en Colombia. Networking, conferencias magistrales, pitch competitions y oportunidades de inversión.', '2024-04-20', '08:00:00', 'Centro de Convenciones Ágora', 'MEDELLÍN', 4, 3, 800, 75000.00, 'published', '2024-02-15 00:00:00', NULL, NULL, '/images/emprendimiento-digital.jpg', true, NULL, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/emprendimiento-digital.jpg', NULL, '[]', '{}'),
(8, 'Festival de Jazz Latinoamericano', 'festival-jazz-latinoamericano', 'Tres días de jazz de clase mundial', 'Los mejores exponentes del jazz latinoamericano se dan cita en este festival único. Artistas de Colombia, Argentina, Brasil, Cuba y México en un solo escenario.', '2024-06-10', '19:00:00', 'Teatro Mayor Julio Mario Santo Domingo', 'BOGOTÁ', 1, 2, 1200, 85000.00, 'published', '2024-04-01 00:00:00', NULL, 'https://youtube.com/watch?v=jazz-latino', '/images/jazz-festival.jpg', true, 1, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/jazz-festival.jpg', 'https://youtube.com/watch?v=jazz-latino', '[]', '{}'),
(9, 'Obra: La Casa de Bernarda Alba', 'obra-casa-bernarda-alba', 'Clásico de Federico García Lorca', 'Una magistral puesta en escena de una de las obras más importantes del teatro español. Dirigida por María Elena Sarmiento con un elenco de lujo.', '2024-03-30', '20:00:00', 'Teatro Nacional La Castellana', 'BOGOTÁ', 2, 3, 350, 42000.00, 'published', '2024-02-01 00:00:00', NULL, NULL, '/images/bernarda-alba.jpg', false, NULL, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/bernarda-alba.jpg', NULL, '[]', '{}'),
(10, 'Torneo de Esports Championship', 'torneo-esports-championship', 'La competencia gamer más grande del país', 'Los mejores equipos de Colombia compiten en League of Legends, Dota 2, Counter-Strike y FIFA. Premios por más de $200 millones de pesos.', '2024-05-25', '10:00:00', 'Movistar Arena', 'BOGOTÁ', 3, 2, 8000, 35000.00, 'published', '2024-03-15 00:00:00', NULL, 'https://youtube.com/watch?v=esports-championship', '/images/esports-tournament.jpg', true, 3, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/esports-tournament.jpg', 'https://youtube.com/watch?v=esports-championship', '[]', '{}'),
(11, 'Seminario de Inteligencia Artificial', 'seminario-inteligencia-artificial', 'El futuro de la IA en América Latina', 'Expertos internacionales comparten las últimas tendencias en IA, Machine Learning y Deep Learning. Incluye talleres prácticos y certificación.', '2024-04-15', '09:00:00', 'Universidad de los Andes', 'BOGOTÁ', 7, 3, 200, 150000.00, 'published', '2024-02-20 00:00:00', NULL, NULL, '/images/ai-seminar.jpg', false, NULL, '2025-08-19 16:07:58.109778', '2025-08-26 10:11:24.240431', '/images/ai-seminar.jpg', NULL, '[]', '{}'),
(12, 'Concierto Futuro 2025', 'concierto-futuro-2025', 'Un concierto que será en el futuro', NULL, '2025-12-31', '20:00:00', 'Teatro Nacional', 'BOGOTÁ', 1, 1, 1000, 100000.00, 'published', NULL, NULL, NULL, NULL, true, NULL, '2025-08-20 12:18:32.5924', '2025-08-27 10:37:36.303449', NULL, NULL, '[]', '{}');


-- Insertar TODOS los tipos de boletos del archivo original
INSERT INTO ticket_types (id, event_id, name, description, price, quantity, sold, max_per_order, sale_start, sale_end, status, created_at, updated_at) VALUES
(1, 1, 'Platea', 'Asientos en platea principal', 50000.00, 600, 2, 6, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.167084'),
(2, 1, 'Palcos', 'Asientos en palcos VIP', 75000.00, 200, 1, 4, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.17141'),
(3, 2, 'Entrada General', 'Acceso completo al festival', 80000.00, 500, 3, 8, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.171618'),
(4, 3, 'Entrada General', 'Asiento numerado', 35000.00, 400, 0, 6, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093'),
(5, 4, 'Early Bird', 'Precio especial por compra anticipada', 100000.00, 100, 1, 2, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.171795'),
(6, 4, 'Entrada Regular', 'Entrada estándar', 120000.00, 200, 0, 4, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093'),
(7, 5, 'Tribuna Norte', 'Tribuna Norte del estadio', 25000.00, 500, 4, 10, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.172023'),
(8, 5, 'Tribuna Sur', 'Tribuna Sur del estadio', 25000.00, 500, 0, 10, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093'),
(9, 5, 'Palco VIP', 'Palco VIP con servicios premium', 80000.00, 200, 0, 4, NULL, NULL, 'active', '2025-08-19 16:06:26.16093', '2025-08-19 16:06:26.16093'),
(10, 6, 'General', 'Acceso general al concierto', 45000.00, 1500, 0, 8, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(11, 6, 'VIP', 'Zona VIP con bar incluido', 85000.00, 300, 0, 4, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(12, 6, 'Palco Premium', 'Palcos con servicio completo', 150000.00, 200, 0, 6, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(14, 7, 'Startup', 'Incluye stand de exhibición', 200000.00, 100, 0, 2, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(15, 7, 'Inversor', 'Acceso VIP y networking exclusivo', 350000.00, 100, 0, 2, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(17, 8, 'Palcos', 'Palcos con vista privilegiada', 120000.00, 300, 0, 4, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(18, 8, 'Premium', 'Experiencia completa con cena', 200000.00, 100, 0, 2, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(20, 9, 'Preferencial', 'Mejores ubicaciones', 65000.00, 50, 0, 4, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(21, 10, 'General', 'Acceso general al torneo', 35000.00, 6000, 0, 10, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(22, 10, 'Premium', 'Zona premium con merchandising', 55000.00, 1500, 0, 6, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019'),
(23, 10, 'VIP Gamer', 'Meet & greet con jugadores', 95000.00, 500, 0, 4, NULL, NULL, 'active', '2025-08-19 16:07:58.116019', '2025-08-19 16:07:58.116019');

-- =====================================================
-- CONFIGURACIÓN DE RLS (ROW LEVEL SECURITY) PARA SUPABASE
-- =====================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ticket_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE virtual_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE physical_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE seat_maps ENABLE ROW LEVEL SECURITY;
ALTER TABLE seat_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE seats ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_in_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Políticas básicas de RLS
-- Categorías: Todos pueden leer
CREATE POLICY "Categories are viewable by everyone" ON categories FOR SELECT USING (true);

-- Eventos: Todos pueden leer eventos publicados
CREATE POLICY "Published events are viewable by everyone" ON events FOR SELECT USING (status = 'published');

-- Usuarios: Solo pueden ver su propio perfil
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid()::text = id::text);

-- Tipos de boletos: Todos pueden leer tipos de boletos activos
CREATE POLICY "Active ticket types are viewable by everyone" ON ticket_types FOR SELECT USING (status = 'active');

-- =====================================================
-- FUNCIONES ÚTILES PARA SUPABASE
-- =====================================================

-- Función para obtener eventos destacados
CREATE OR REPLACE FUNCTION get_featured_events()
RETURNS TABLE (
  id bigint,
  title text,
  slug text,
  description text,
  date date,
  "time" time,
  venue text,
  location text,
  price numeric,
  main_image_url text,
  category_name text,
  organizer_name text
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    e.id,
    e.title,
    e.slug,
    e.description,
    e.date,
    e."time",
    e.venue,
    e.location,
    e.price,
    e.main_image_url,
    c.name as category_name,
    CONCAT(u.first_name, ' ', u.last_name) as organizer_name
  FROM events e
  JOIN categories c ON e.category_id = c.id
  JOIN users u ON e.organizer_id = u.id
  WHERE e.featured = true 
    AND e.status = 'published'
    AND e.date >= CURRENT_DATE
  ORDER BY e.date ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para obtener estadísticas de eventos
CREATE OR REPLACE FUNCTION get_event_stats(event_id_param bigint)
RETURNS TABLE (
  total_capacity bigint,
  total_sold bigint,
  total_revenue numeric,
  ticket_types_count bigint
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    e.total_capacity,
    COALESCE(SUM(tt.sold), 0) as total_sold,
    COALESCE(SUM(tt.sold * tt.price), 0) as total_revenue,
    COUNT(tt.id) as ticket_types_count
  FROM events e
  LEFT JOIN ticket_types tt ON e.id = tt.event_id
  WHERE e.id = event_id_param
  GROUP BY e.id, e.total_capacity;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- FINALIZACIÓN Y MENSAJE DE ÉXITO
-- =====================================================

-- Mensaje de éxito
DO $$
BEGIN
    RAISE NOTICE '🎉 ¡BASE DE DATOS EVENTU COMPLETA EXPORTADA A SUPABASE!';
    RAISE NOTICE '📊 Estructura: 27 tablas completas del sistema';
    RAISE NOTICE '👥 Usuarios: 30 usuarios (admins, organizadores, usuarios)';
    RAISE NOTICE '🎭 Eventos: 12 eventos completos con datos reales';
    RAISE NOTICE '🎫 Tipos de boletos: 19 tipos de boletos configurados';
    RAISE NOTICE '🏷️ Categorías: 7 categorías de eventos';
    RAISE NOTICE '🔐 Seguridad: RLS habilitado con políticas básicas';
    RAISE NOTICE '⚡ Funciones: Funciones útiles para la aplicación';
    RAISE NOTICE '🚀 ¡Sistema completo listo para usar en Supabase!';
END $$;

