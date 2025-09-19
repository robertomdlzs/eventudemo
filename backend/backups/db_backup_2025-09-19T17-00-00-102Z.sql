-- Backup de estructura de base de datos
-- Generado el: 2025-09-19T17:00:00.198Z

-- Estructura de tabla: audit_logs
CREATE TABLE IF NOT EXISTS audit_logs (
  id integer NOT NULL DEFAULT nextval('audit_logs_id_seq'::regclass),
  user_id character varying NOT NULL,
  user_name character varying NOT NULL,
  user_email character varying NOT NULL,
  action character varying NOT NULL,
  resource character varying NOT NULL,
  resource_id character varying,
  details jsonb,
  ip_address inet NOT NULL,
  user_agent text,
  timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  severity character varying DEFAULT 'low'::character varying,
  status character varying DEFAULT 'success'::character varying
);

-- Datos de tabla: audit_logs
INSERT INTO audit_logs VALUES ('1', 'admin1', 'Admin Principal', 'admin@eventu.co', 'LOGIN', 'auth', NULL, '[object Object]', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)', 'low', 'success');
INSERT INTO audit_logs VALUES ('2', 'admin1', 'Admin Principal', 'admin@eventu.co', 'CREATE_EVENT', 'events', NULL, '[object Object]', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('3', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 12:33:24 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('4', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 12:33:25 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('5', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@test.com', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:33:34 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('6', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@test.com', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:33:34 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('7', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.com', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:33:57 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('8', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.com', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:33:57 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('9', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:40:50 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('10', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 12:40:50 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('11', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 12:41:17 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('12', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 12:41:17 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('13', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:05:46 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('14', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:05:46 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('15', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:09:40 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('16', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:09:41 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('17', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'READ', 'USER', NULL, '[object Object]', '127.0.0.1', 'node', 'Wed Sep 10 2025 13:10:35 GMT-0500 (Colombia Standard Time)', 'high', 'success');
INSERT INTO audit_logs VALUES ('18', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'READ', 'USER', NULL, '[object Object]', '127.0.0.1', 'node', 'Wed Sep 10 2025 13:10:35 GMT-0500 (Colombia Standard Time)', 'high', 'success');
INSERT INTO audit_logs VALUES ('19', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'READ', 'USER', NULL, '[object Object]', '127.0.0.1', 'node', 'Wed Sep 10 2025 13:10:35 GMT-0500 (Colombia Standard Time)', 'high', 'success');
INSERT INTO audit_logs VALUES ('20', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:22:37 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('21', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:22:37 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('22', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:25:09 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('23', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:25:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('24', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:33:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('25', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 10 2025 13:33:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('26', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:40:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('27', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:40:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('28', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:42:25 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('29', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:42:25 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('30', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:50:34 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('31', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:50:34 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('32', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:54:42 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('33', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 13:54:42 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('34', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:05:30 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('35', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:05:30 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('36', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:21:38 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('37', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:21:38 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('38', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:29:50 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('39', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:29:50 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('40', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:35:59 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('41', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:35:59 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('42', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:36:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('43', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:36:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('44', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:45:11 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('45', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:45:12 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('46', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:45:41 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('47', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Wed Sep 10 2025 14:45:41 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('48', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 10:10:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('49', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 10:10:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('50', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 11:47:28 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('51', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 11:47:28 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('52', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 12:10:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('53', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'roberto@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 12:10:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('54', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'promotor@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 12:10:46 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('55', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'promotor@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 12:10:46 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('56', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 14:10:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('57', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Thu Sep 11 2025 14:10:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('58', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 09:43:57 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('59', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 09:43:57 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('60', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 09:51:17 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('61', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 09:51:17 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('62', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:05:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('63', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:05:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('64', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:12:00 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('65', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:12:00 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('66', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.com', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:29:35 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('67', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.com', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:29:35 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('68', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:29:44 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('69', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:29:44 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('70', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:49:40 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('71', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:49:40 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('72', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:55:49 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('73', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 10:55:50 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('74', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 11:00:27 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('75', 'anonymous', 'Usuario Anónimo', 'anonymous@eventu.com', 'LOGIN', 'AUTH', 'admin@eventu.co', '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Fri Sep 12 2025 11:00:28 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('76', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:16:03 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('77', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:16:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('78', 'login_attempt', 'Usuario (user@eventu.com)', 'user@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:16:28 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('79', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:16:57 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('80', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:17:26 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('81', '21', 'roberto@eventu.co', 'roberto@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:17:52 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('82', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:18:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('83', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:20:38 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('84', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:23:48 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('85', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:25:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('86', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:27:39 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('87', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:28:37 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('88', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:30:03 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('89', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:30:42 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('90', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:33:32 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('91', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:36:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('92', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:38:15 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('93', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:38:58 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('94', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:43:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('95', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:46:29 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('96', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:47:27 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('97', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:48:55 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('98', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 10:50:36 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('99', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:52:52 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('100', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 10:58:41 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('101', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 11:09:15 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('102', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:16:10 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('103', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:16:15 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('104', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:16:56 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('105', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:17:11 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('106', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:18:06 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('107', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Safari/605.1.15', 'Mon Sep 15 2025 11:18:42 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('108', '26', 'promotor@eventu.co', 'promotor@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Mon Sep 15 2025 11:21:02 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('109', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:11:37 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('110', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:13:07 GMT-0500 (Colombia Standard Time)', 'medium', 'failure');
INSERT INTO audit_logs VALUES ('111', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:13:45 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('112', '2', 'carlos@eventu.com', 'carlos@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:23:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('113', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:25:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('114', '2', 'carlos@eventu.com', 'carlos@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:25:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('115', '2', 'carlos@eventu.com', 'carlos@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:25:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('116', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:30:53 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('117', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:33:14 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('118', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:35:47 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('119', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:37:45 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('120', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:39:48 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('121', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:40:05 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('122', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:40:15 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('123', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Wed Sep 17 2025 14:41:15 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('124', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:45:20 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('125', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:45:30 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('126', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:45:55 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('127', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:47:03 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('128', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:47:13 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('129', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:52:36 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('130', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:52:44 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('131', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:53:49 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('132', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:54:34 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('133', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:54:42 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('134', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:54:51 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('135', '1', 'admin@eventu.com', 'admin@eventu.com', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'curl/8.7.1', 'Wed Sep 17 2025 14:54:58 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('136', '21', 'roberto@eventu.co', 'roberto@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Thu Sep 18 2025 14:28:07 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('137', '21', 'roberto@eventu.co', 'roberto@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Thu Sep 18 2025 14:31:38 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('138', '21', 'roberto@eventu.co', 'roberto@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Thu Sep 18 2025 14:35:34 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('139', '21', 'roberto@eventu.co', 'roberto@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Thu Sep 18 2025 14:42:08 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('140', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Fri Sep 19 2025 11:13:30 GMT-0500 (Colombia Standard Time)', 'medium', 'success');
INSERT INTO audit_logs VALUES ('141', '23', 'admin@eventu.co', 'admin@eventu.co', 'LOGIN', 'AUTH', NULL, '[object Object]', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'Fri Sep 19 2025 11:16:48 GMT-0500 (Colombia Standard Time)', 'medium', 'success');

-- Estructura de tabla: backup_schedules
CREATE TABLE IF NOT EXISTS backup_schedules (
  id integer NOT NULL DEFAULT nextval('backup_schedules_id_seq'::regclass),
  name character varying NOT NULL,
  frequency character varying NOT NULL,
  time time without time zone NOT NULL,
  retention_days integer DEFAULT 30,
  status character varying DEFAULT 'active'::character varying,
  created_by character varying NOT NULL,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  last_backup timestamp without time zone,
  next_backup timestamp without time zone
);

-- Estructura de tabla: backups
CREATE TABLE IF NOT EXISTS backups (
  id integer NOT NULL DEFAULT nextval('backups_id_seq'::regclass),
  filename character varying NOT NULL,
  size bigint NOT NULL,
  type character varying DEFAULT 'manual'::character varying,
  status character varying DEFAULT 'completed'::character varying,
  created_by character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  completed_at timestamp without time zone,
  file_path text
);

-- Estructura de tabla: categories
CREATE TABLE IF NOT EXISTS categories (
  id integer NOT NULL DEFAULT nextval('categories_id_seq'::regclass),
  name character varying NOT NULL,
  slug character varying NOT NULL,
  description text,
  icon character varying,
  color character varying DEFAULT '#3B82F6'::character varying,
  status character varying DEFAULT 'active'::character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: categories
INSERT INTO categories VALUES ('1', 'Conciertos', 'conciertos', 'Eventos musicales y conciertos en vivo', 'Music', '#FF6B6B', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('2', 'Teatro', 'teatro', 'Obras de teatro y espectáculos dramáticos', 'Drama', '#4ECDC4', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('3', 'Deportes', 'deportes', 'Eventos deportivos y competencias', 'Trophy', '#45B7D1', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('4', 'Conferencias', 'conferencias', 'Conferencias, seminarios y eventos corporativos', 'Users', '#96CEB4', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('5', 'Festivales', 'festivales', 'Festivales culturales y gastronómicos', 'Star', '#FFEAA7', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('6', 'Familiar', 'familiar', 'Eventos para toda la familia', 'Heart', '#DDA0DD', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO categories VALUES ('7', 'Educación', 'educacion', 'Talleres, cursos y eventos educativos', 'BookOpen', '#98D8C8', 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: check_in_records
CREATE TABLE IF NOT EXISTS check_in_records (
  id integer NOT NULL DEFAULT nextval('check_in_records_id_seq'::regclass),
  ticket_number character varying NOT NULL,
  event_name character varying NOT NULL,
  customer_name character varying NOT NULL,
  ticket_type character varying DEFAULT 'General'::character varying,
  check_in_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  gate character varying NOT NULL,
  status character varying DEFAULT 'checked-in'::character varying,
  operator character varying NOT NULL,
  event_id integer,
  sale_id integer
);

-- Estructura de tabla: event_additional_data
CREATE TABLE IF NOT EXISTS event_additional_data (
  id integer NOT NULL DEFAULT nextval('event_additional_data_id_seq'::regclass),
  event_id integer NOT NULL,
  data_key character varying NOT NULL,
  data_value text,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: events
CREATE TABLE IF NOT EXISTS events (
  id integer NOT NULL DEFAULT nextval('events_id_seq'::regclass),
  title character varying NOT NULL,
  slug character varying NOT NULL,
  description text,
  long_description text,
  date date NOT NULL,
  time time without time zone NOT NULL,
  venue character varying NOT NULL,
  location character varying NOT NULL,
  category_id integer,
  organizer_id integer NOT NULL,
  total_capacity integer DEFAULT 0,
  price numeric DEFAULT 0.00,
  status character varying DEFAULT 'draft'::character varying,
  sales_start_date timestamp without time zone,
  sales_end_date timestamp without time zone,
  youtube_url character varying,
  image_url character varying,
  featured boolean DEFAULT false,
  seat_map_id integer,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  main_image_url character varying,
  video_url character varying,
  gallery_images jsonb DEFAULT '[]'::jsonb,
  social_links jsonb DEFAULT '{}'::jsonb,
  max_seats_per_purchase integer DEFAULT 4
);

-- Datos de tabla: events
INSERT INTO events VALUES ('3', 'Obra: Romeo y Julieta', 'obra-romeo-julieta', 'Clásica obra de Shakespeare', 'La compañía de teatro más prestigiosa del país presenta esta obra maestra de William Shakespeare con una puesta en escena moderna y emotiva.', 'Tue Feb 20 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '19:30:00', 'Teatro Colón', 'BOGOTÁ', '2', '26', '400', '35000.00', 'published', 'Wed Jan 10 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, NULL, '/images/romeo-julieta.jpg', 'false', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Fri Aug 29 2025 16:01:10 GMT-0500 (Colombia Standard Time)', '/images/romeo-julieta.jpg', NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('5', 'Partido Clásico: Millonarios vs Nacional', 'partido-millonarios-nacional', 'El clásico más esperado del fútbol colombiano', 'El encuentro más emocionante del fútbol profesional colombiano. Dos equipos históricos se enfrentan en un partido que promete emociones fuertes.', 'Mon Mar 25 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '16:00:00', 'Estadio El Campín', 'BOGOTÁ', '3', '3', '1200', '25000.00', 'published', 'Sun Feb 25 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, NULL, '/images/clasico-futbol.jpg', 'true', '2', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/clasico-futbol.jpg', NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('7', 'Feria de Emprendimiento Digital', 'feria-emprendimiento-digital', 'Conecta con startups y emprendedores', 'El evento más importante para emprendedores digitales en Colombia. Networking, conferencias magistrales, pitch competitions y oportunidades de inversión.', 'Sat Apr 20 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '08:00:00', 'Centro de Convenciones Ágora', 'MEDELLÍN', '4', '3', '800', '75000.00', 'published', 'Thu Feb 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, NULL, '/images/emprendimiento-digital.jpg', 'true', NULL, 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/emprendimiento-digital.jpg', NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('9', 'Obra: La Casa de Bernarda Alba', 'obra-casa-bernarda-alba', 'Clásico de Federico García Lorca', 'Una magistral puesta en escena de una de las obras más importantes del teatro español. Dirigida por María Elena Sarmiento con un elenco de lujo.', 'Sat Mar 30 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '20:00:00', 'Teatro Nacional La Castellana', 'BOGOTÁ', '2', '3', '350', '42000.00', 'published', 'Thu Feb 01 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, NULL, '/images/bernarda-alba.jpg', 'false', NULL, 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/bernarda-alba.jpg', NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('11', 'Seminario de Inteligencia Artificial', 'seminario-inteligencia-artificial', 'El futuro de la IA en América Latina', 'Expertos internacionales comparten las últimas tendencias en IA, Machine Learning y Deep Learning. Incluye talleres prácticos y certificación.', 'Mon Apr 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '09:00:00', 'Universidad de los Andes', 'BOGOTÁ', '7', '3', '200', '150000.00', 'published', 'Tue Feb 20 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, NULL, '/images/ai-seminar.jpg', 'false', NULL, 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/ai-seminar.jpg', NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('4', 'Conferencia Tech Summit 2024', 'tech-summit-2024', 'La conferencia de tecnología más importante del año', 'Líderes de la industria tecnológica se reúnen para compartir las últimas tendencias en IA, blockchain, desarrollo web y más. Networking y oportunidades de negocio.', 'Wed Apr 10 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '09:00:00', 'Centro Empresarial', 'BOGOTÁ', '4', '2', '300', '120000.00', 'published', 'Thu Feb 01 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=example3', '/images/tech-summit.jpg', 'true', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/tech-summit.jpg', 'https://youtube.com/watch?v=example3', '', '[object Object]', '4');
INSERT INTO events VALUES ('6', 'Concierto Rock Nacional', 'concierto-rock-nacional', 'Los mejores exponentes del rock colombiano', 'Una noche épica con las bandas más representativas del rock nacional. Desde los clásicos hasta las nuevas propuestas que están revolucionando la escena musical colombiana.', 'Wed May 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '21:00:00', 'Coliseo Live', 'BOGOTÁ', '1', '2', '2000', '45000.00', 'published', 'Fri Mar 01 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=rock-nacional', '/images/rock-nacional.jpg', 'true', '2', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/rock-nacional.jpg', 'https://youtube.com/watch?v=rock-nacional', '', '[object Object]', '4');
INSERT INTO events VALUES ('8', 'Festival de Jazz Latinoamericano', 'festival-jazz-latinoamericano', 'Tres días de jazz de clase mundial', 'Los mejores exponentes del jazz latinoamericano se dan cita en este festival único. Artistas de Colombia, Argentina, Brasil, Cuba y México en un solo escenario.', 'Mon Jun 10 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '19:00:00', 'Teatro Mayor Julio Mario Santo Domingo', 'BOGOTÁ', '1', '2', '1200', '85000.00', 'published', 'Mon Apr 01 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=jazz-latino', '/images/jazz-festival.jpg', 'true', '1', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/jazz-festival.jpg', 'https://youtube.com/watch?v=jazz-latino', '', '[object Object]', '4');
INSERT INTO events VALUES ('12', 'Concierto Futuro 2025', 'concierto-futuro-2025', 'Un concierto que será en el futuro', NULL, 'Wed Dec 31 2025 00:00:00 GMT-0500 (Colombia Standard Time)', '20:00:00', 'Teatro Nacional', 'BOGOTÁ', '1', '1', '1000', '100000.00', 'published', NULL, NULL, NULL, NULL, 'true', NULL, 'Wed Aug 20 2025 12:18:32 GMT-0500 (Colombia Standard Time)', 'Wed Aug 27 2025 10:37:36 GMT-0500 (Colombia Standard Time)', NULL, NULL, '', '[object Object]', '4');
INSERT INTO events VALUES ('10', 'Torneo de Esports Championship', 'torneo-esports-championship', 'La competencia gamer más grande del país', 'Los mejores equipos de Colombia compiten en League of Legends, Dota 2, Counter-Strike y FIFA. Premios por más de $200 millones de pesos.', 'Sat May 25 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '10:00:00', 'Movistar Arena', 'BOGOTÁ', '3', '2', '8000', '35000.00', 'published', 'Fri Mar 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=esports-championship', '/images/esports-tournament.jpg', 'true', '3', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/esports-tournament.jpg', 'https://youtube.com/watch?v=esports-championship', '', '[object Object]', '4');
INSERT INTO events VALUES ('2', 'Festival Gastronómico Internacional', 'festival-gastronomico-internacional', 'Festival con los mejores chefs internacionales', 'Disfruta de una experiencia culinaria única con chefs reconocidos mundialmente. Degustaciones, talleres y espectáculos gastronómicos en un solo lugar.', 'Fri Mar 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '18:00:00', 'Centro de Convenciones', 'MEDELLÍN', '5', '2', '500', '80000.00', 'published', 'Mon Jan 15 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=example2', '/images/festival-gastronomico.jpg', 'true', '2', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 10:11:24 GMT-0500 (Colombia Standard Time)', '/images/festival-gastronomico.jpg', 'https://youtube.com/watch?v=example2', '', '[object Object]', '4');
INSERT INTO events VALUES ('1', 'Concierto Sinfónico de Año Nuevo', 'concierto-sinfonico-ano-nuevo', 'Gran concierto sinfónico para celebrar el año nuevo', 'La Orquesta Sinfónica Nacional presenta un espectacular concierto para recibir el año nuevo con las mejores melodías clásicas y contemporáneas. Una noche mágica llena de música y emociones.', 'Tue Dec 31 2024 00:00:00 GMT-0500 (Colombia Standard Time)', '20:00:00', 'Teatro Nacional', 'BOGOTÁ', '1', '2', '800', '50000.00', 'published', 'Mon Jan 01 2024 00:00:00 GMT-0500 (Colombia Standard Time)', NULL, 'https://youtube.com/watch?v=example1', '/images/concierto-sinfonico.jpg', 'true', '1', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Wed Sep 17 2025 14:54:42 GMT-0500 (Colombia Standard Time)', '/images/concierto-sinfonico.jpg', 'https://youtube.com/watch?v=example1', '', '[object Object]', '4');

-- Estructura de tabla: media_files
CREATE TABLE IF NOT EXISTS media_files (
  id integer NOT NULL DEFAULT nextval('media_files_id_seq'::regclass),
  name character varying NOT NULL,
  original_name character varying NOT NULL,
  type character varying NOT NULL,
  size bigint NOT NULL,
  url text NOT NULL,
  alt_text text,
  description text,
  tags ARRAY,
  folder_id integer,
  upload_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  last_used timestamp without time zone,
  usage_count integer DEFAULT 0,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: media_folders
CREATE TABLE IF NOT EXISTS media_folders (
  id integer NOT NULL DEFAULT nextval('media_folders_id_seq'::regclass),
  name character varying NOT NULL,
  parent_id integer,
  created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: notifications
CREATE TABLE IF NOT EXISTS notifications (
  id integer NOT NULL DEFAULT nextval('notifications_id_seq'::regclass),
  title character varying NOT NULL,
  message text NOT NULL,
  type character varying DEFAULT 'info'::character varying,
  target character varying DEFAULT 'all'::character varying,
  recipients jsonb,
  sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  read_by jsonb DEFAULT '[]'::jsonb,
  status character varying DEFAULT 'sent'::character varying,
  created_by character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: notifications
INSERT INTO notifications VALUES ('1', 'Nuevo evento publicado', 'El evento "Conferencia Tech 2024" ha sido publicado exitosamente', 'success', 'all', NULL, 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)', '', 'delivered', NULL, 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)');
INSERT INTO notifications VALUES ('2', 'Mantenimiento programado', 'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 4:00 AM', 'warning', 'admins', NULL, 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)', '', 'sent', NULL, 'Mon Aug 25 2025 12:48:29 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: password_reset_tokens
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id integer NOT NULL DEFAULT nextval('password_reset_tokens_id_seq'::regclass),
  user_id integer NOT NULL,
  token text NOT NULL,
  expires_at timestamp without time zone NOT NULL,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: payment_methods
CREATE TABLE IF NOT EXISTS payment_methods (
  id integer NOT NULL DEFAULT nextval('payment_methods_id_seq'::regclass),
  name character varying NOT NULL,
  gateway character varying NOT NULL,
  is_active boolean DEFAULT true,
  configuration jsonb,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: payment_methods
INSERT INTO payment_methods VALUES ('1', 'Tarjeta de Crédito', 'stripe', 'true', '[object Object]', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)');
INSERT INTO payment_methods VALUES ('2', 'PayPal', 'paypal', 'true', '[object Object]', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)');
INSERT INTO payment_methods VALUES ('3', 'MercadoPago', 'mercadopago', 'true', '[object Object]', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)');
INSERT INTO payment_methods VALUES ('4', 'Wompi', 'wompi', 'true', '[object Object]', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)');
INSERT INTO payment_methods VALUES ('5', 'Transferencia Bancaria', 'bank_transfer', 'true', '[object Object]', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:37 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: payments
CREATE TABLE IF NOT EXISTS payments (
  id integer NOT NULL DEFAULT nextval('payments_id_seq'::regclass),
  sale_id integer NOT NULL,
  payment_method character varying NOT NULL,
  payment_gateway character varying NOT NULL,
  gateway_transaction_id character varying,
  amount numeric NOT NULL,
  currency character varying DEFAULT 'COP'::character varying,
  status character varying DEFAULT 'pending'::character varying,
  gateway_response jsonb,
  processed_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: payments
INSERT INTO payments VALUES ('1', '1', 'credit_card', 'stripe', 'txn_123456789', '150000.00', 'COP', 'completed', NULL, 'Mon Aug 18 2025 10:58:07 GMT-0500 (Colombia Standard Time)', 'Mon Aug 18 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('2', '2', 'debit_card', 'stripe', 'txn_987654321', '75000.00', 'COP', 'completed', NULL, 'Tue Aug 19 2025 10:56:07 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('3', '3', 'credit_card', 'stripe', 'txn_555666777', '200000.00', 'COP', 'pending', NULL, NULL, 'Wed Aug 20 2025 04:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('4', '4', 'bank_transfer', 'manual', 'ref_888999000', '120000.00', 'COP', 'failed', NULL, NULL, 'Tue Aug 19 2025 22:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('5', '5', 'credit_card', 'stripe', 'txn_111222333', '150000.00', 'COP', 'completed', NULL, 'Sun Aug 17 2025 10:55:07 GMT-0500 (Colombia Standard Time)', 'Sun Aug 17 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('6', '6', 'debit_card', 'stripe', 'txn_444555666', '180000.00', 'COP', 'completed', NULL, 'Wed Aug 13 2025 11:03:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 13 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('7', '7', 'credit_card', 'stripe', 'txn_777888999', '75000.00', 'COP', 'cancelled', NULL, NULL, 'Sat Aug 16 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('8', '1', 'credit_card', 'stripe', 'ch_1234567890', '500000.00', 'COP', 'completed', '[object Object]', NULL, 'Sun Dec 15 2024 14:32:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('9', '2', 'credit_card', 'stripe', 'ch_1234567891', '600000.00', 'COP', 'completed', '[object Object]', NULL, 'Mon Dec 16 2024 10:17:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('10', '3', 'bank_transfer', 'payu', 'payu_123456', '350000.00', 'COP', 'completed', '[object Object]', NULL, 'Tue Dec 17 2024 16:47:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('11', '4', 'credit_card', 'stripe', 'ch_1234567892', '500000.00', 'COP', 'completed', '[object Object]', NULL, 'Wed Dec 18 2024 11:22:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('12', '5', 'credit_card', 'stripe', 'ch_1234567893', '360000.00', 'COP', 'completed', '[object Object]', NULL, 'Thu Dec 19 2024 09:32:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('13', '6', 'credit_card', 'stripe', 'ch_1234567894', '160000.00', 'COP', 'completed', '[object Object]', NULL, 'Fri Dec 20 2024 15:47:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('14', '7', 'cash', 'cash', 'CASH-001', '65000.00', 'COP', 'completed', '[object Object]', NULL, 'Sat Dec 21 2024 13:17:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('15', '8', 'credit_card', 'stripe', 'ch_1234567895', '90000.00', 'COP', 'completed', '[object Object]', NULL, 'Sun Dec 22 2024 17:32:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('16', '9', 'bank_transfer', 'payu', 'payu_123457', '500000.00', 'COP', 'completed', '[object Object]', NULL, 'Mon Dec 23 2024 08:47:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('17', '10', 'credit_card', 'stripe', 'ch_1234567896', '700000.00', 'COP', 'completed', '[object Object]', NULL, 'Tue Dec 24 2024 12:02:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('18', '11', 'credit_card', 'stripe', 'ch_1234567897', '360000.00', 'COP', 'completed', '[object Object]', NULL, 'Wed Dec 25 2024 14:22:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('19', '12', 'credit_card', 'stripe', 'ch_1234567898', '300000.00', 'COP', 'completed', '[object Object]', NULL, 'Thu Dec 26 2024 10:32:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('20', '13', 'credit_card', 'stripe', 'ch_1234567899', '360000.00', 'COP', 'completed', '[object Object]', NULL, 'Fri Dec 27 2024 16:17:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('21', '14', 'cash', 'cash', 'CASH-002', '120000.00', 'COP', 'completed', '[object Object]', NULL, 'Sat Dec 28 2024 19:47:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('22', '15', 'credit_card', 'stripe', 'ch_1234567900', '50000.00', 'COP', 'completed', '[object Object]', NULL, 'Sun Dec 29 2024 07:32:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('23', '16', 'credit_card', 'stripe', 'ch_1234567901', '35000.00', 'COP', 'completed', '[object Object]', NULL, 'Mon Dec 30 2024 11:22:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO payments VALUES ('24', '20', 'cash', 'cash', 'CASH-003', '45000.00', 'COP', 'completed', '[object Object]', NULL, 'Fri Jan 03 2025 13:57:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: physical_tickets
CREATE TABLE IF NOT EXISTS physical_tickets (
  id integer NOT NULL DEFAULT nextval('physical_tickets_id_seq'::regclass),
  batch_number character varying NOT NULL,
  event_id integer NOT NULL,
  ticket_type_id integer NOT NULL,
  quantity integer NOT NULL,
  printed integer DEFAULT 0,
  sold integer DEFAULT 0,
  price numeric NOT NULL,
  sales_point character varying NOT NULL,
  notes text,
  status character varying DEFAULT 'pending'::character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  printed_at timestamp without time zone,
  distributed_at timestamp without time zone
);

-- Estructura de tabla: refunds
CREATE TABLE IF NOT EXISTS refunds (
  id integer NOT NULL DEFAULT nextval('refunds_id_seq'::regclass),
  payment_id integer NOT NULL,
  amount numeric NOT NULL,
  reason text,
  status character varying DEFAULT 'pending'::character varying,
  gateway_refund_id character varying,
  processed_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: sales
CREATE TABLE IF NOT EXISTS sales (
  id integer NOT NULL DEFAULT nextval('sales_id_seq'::regclass),
  user_id integer NOT NULL,
  event_id integer NOT NULL,
  ticket_type_id integer NOT NULL,
  quantity integer NOT NULL,
  unit_price numeric NOT NULL,
  total_amount numeric NOT NULL,
  status character varying DEFAULT 'pending'::character varying,
  payment_method character varying,
  payment_reference character varying,
  buyer_name character varying NOT NULL,
  buyer_email character varying NOT NULL,
  buyer_phone character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: sales
INSERT INTO sales VALUES ('1', '4', '1', '1', '2', '50000.00', '100000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('2', '5', '1', '2', '1', '75000.00', '75000.00', 'completed', 'debit_card', NULL, 'Ana López', 'ana@example.com', '3007654321', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('3', '4', '2', '3', '3', '80000.00', '240000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('4', '5', '4', '5', '1', '100000.00', '100000.00', 'completed', 'bank_transfer', NULL, 'Ana López', 'ana@example.com', '3007654321', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('5', '4', '5', '7', '4', '25000.00', '100000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('6', '4', '6', '13', '2', '45000.00', '90000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('7', '5', '7', '16', '1', '75000.00', '75000.00', 'completed', 'bank_transfer', NULL, 'Ana López', 'ana@example.com', '3007654321', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('8', '4', '8', '19', '2', '85000.00', '170000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('9', '5', '10', '25', '4', '35000.00', '140000.00', 'completed', 'debit_card', NULL, 'Ana López', 'ana@example.com', '3007654321', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('10', '1', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Mon Aug 18 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('11', '1', '2', '2', '1', '75000.00', '75000.00', 'completed', 'debit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('12', '1', '3', '1', '1', '200000.00', '200000.00', 'pending', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Wed Aug 20 2025 04:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('13', '1', '4', '2', '1', '120000.00', '120000.00', 'cancelled', 'bank_transfer', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Tue Aug 19 2025 22:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('14', '2', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'María García', 'maria@example.com', '3009876543', 'Sun Aug 17 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('15', '2', '5', '1', '2', '90000.00', '180000.00', 'completed', 'debit_card', NULL, 'María García', 'maria@example.com', '3009876543', 'Wed Aug 13 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('16', '3', '2', '2', '1', '75000.00', '75000.00', 'cancelled', 'credit_card', NULL, 'Carlos López', 'carlos@example.com', '3005555555', 'Sat Aug 16 2025 10:53:07 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 10:53:07 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('17', '1', '1', '1', '2', '75000.00', '150000.00', 'completed', 'credit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('18', '1', '2', '3', '1', '85000.00', '85000.00', 'completed', 'debit_card', NULL, 'Juan Pérez', 'juan@example.com', '3001234567', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('19', '2', '1', '2', '1', '150000.00', '150000.00', 'completed', 'credit_card', NULL, 'María García', 'maria@example.com', '3009876543', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('20', '8', '1', '1', '1', '75000.00', '75000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', 'Wed Aug 20 2025 12:16:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:16:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('21', '8', '2', '3', '1', '85000.00', '85000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', 'Wed Aug 20 2025 12:17:59 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:17:59 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('22', '8', '12', '5', '1', '100000.00', '100000.00', 'completed', 'credit_card', NULL, 'Test User Tickets', 'tickets@example.com', '3001234567', 'Wed Aug 20 2025 12:19:11 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:19:11 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('23', '4', '1', '1', '2', '250000.00', '500000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', 'Sun Dec 15 2024 14:30:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('24', '5', '1', '2', '4', '150000.00', '600000.00', 'completed', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', 'Mon Dec 16 2024 10:15:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('25', '6', '2', '3', '1', '350000.00', '350000.00', 'completed', 'bank_transfer', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', 'Tue Dec 17 2024 16:45:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('26', '7', '2', '4', '2', '250000.00', '500000.00', 'completed', 'credit_card', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', 'Wed Dec 18 2024 11:20:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('27', '4', '3', '5', '3', '120000.00', '360000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', 'Thu Dec 19 2024 09:30:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('28', '8', '3', '6', '2', '80000.00', '160000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', 'Fri Dec 20 2024 15:45:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('29', '5', '4', '7', '1', '65000.00', '65000.00', 'completed', 'cash', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', 'Sat Dec 21 2024 13:15:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('30', '6', '4', '8', '2', '45000.00', '90000.00', 'completed', 'credit_card', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', 'Sun Dec 22 2024 17:30:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('31', '7', '5', '9', '1', '500000.00', '500000.00', 'completed', 'bank_transfer', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', 'Mon Dec 23 2024 08:45:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('32', '8', '5', '10', '2', '350000.00', '700000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', 'Tue Dec 24 2024 12:00:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('33', '4', '6', '11', '3', '120000.00', '360000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', 'Wed Dec 25 2024 14:20:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('34', '5', '6', '12', '4', '75000.00', '300000.00', 'completed', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', 'Thu Dec 26 2024 10:30:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('35', '6', '7', '13', '2', '180000.00', '360000.00', 'completed', 'credit_card', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', 'Fri Dec 27 2024 16:15:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('36', '7', '7', '14', '1', '120000.00', '120000.00', 'completed', 'cash', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', 'Sat Dec 28 2024 19:45:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('37', '8', '8', '15', '1', '50000.00', '50000.00', 'completed', 'credit_card', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', 'Sun Dec 29 2024 07:30:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('38', '4', '8', '16', '1', '35000.00', '35000.00', 'completed', 'credit_card', NULL, 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', 'Mon Dec 30 2024 11:20:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('39', '5', '1', '1', '1', '250000.00', '250000.00', 'pending', 'credit_card', NULL, 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', 'Tue Dec 31 2024 14:10:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('40', '6', '2', '4', '1', '250000.00', '250000.00', 'pending', 'bank_transfer', NULL, 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', 'Wed Jan 01 2025 09:25:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('41', '7', '3', '6', '2', '80000.00', '160000.00', 'cancelled', 'credit_card', NULL, 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', 'Thu Jan 02 2025 16:40:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales VALUES ('42', '8', '4', '8', '1', '45000.00', '45000.00', 'completed', 'cash', NULL, 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', 'Fri Jan 03 2025 13:55:00 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: sales_points
CREATE TABLE IF NOT EXISTS sales_points (
  id integer NOT NULL DEFAULT nextval('sales_points_id_seq'::regclass),
  name character varying NOT NULL,
  location character varying,
  address text,
  contact_person character varying,
  contact_phone character varying,
  contact_email character varying,
  status character varying DEFAULT 'active'::character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: sales_points
INSERT INTO sales_points VALUES ('1', 'Punto de Venta Centro', 'Centro Comercial Plaza Central', 'Calle 123 #45-67, Centro', 'María González', '3001234567', 'centro@eventu.co', 'active', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales_points VALUES ('2', 'Punto de Venta Norte', 'Centro Comercial Norte', 'Avenida Norte #89-12, Norte', 'Carlos Rodríguez', '3002345678', 'norte@eventu.co', 'active', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)');
INSERT INTO sales_points VALUES ('3', 'Punto de Venta Sur', 'Centro Comercial Sur', 'Carrera 78 #34-56, Sur', 'Ana Martínez', '3003456789', 'sur@eventu.co', 'active', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 12:39:22 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: saved_reports
CREATE TABLE IF NOT EXISTS saved_reports (
  id integer NOT NULL DEFAULT nextval('saved_reports_id_seq'::regclass),
  name character varying NOT NULL,
  description text,
  type character varying NOT NULL,
  filters jsonb,
  schedule jsonb,
  created_by character varying NOT NULL,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: scheduled_reports
CREATE TABLE IF NOT EXISTS scheduled_reports (
  id integer NOT NULL DEFAULT nextval('scheduled_reports_id_seq'::regclass),
  name character varying NOT NULL,
  description text,
  type character varying NOT NULL,
  schedule jsonb NOT NULL,
  recipients jsonb,
  status character varying DEFAULT 'active'::character varying,
  created_by character varying NOT NULL,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  last_run timestamp without time zone,
  next_run timestamp without time zone
);

-- Estructura de tabla: seat_map_templates
CREATE TABLE IF NOT EXISTS seat_map_templates (
  id integer NOT NULL DEFAULT nextval('seat_map_templates_id_seq'::regclass),
  name character varying NOT NULL,
  description text,
  template_data jsonb NOT NULL,
  thumbnail_url character varying,
  is_public boolean DEFAULT true,
  created_by integer,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: seat_map_templates
INSERT INTO seat_map_templates VALUES ('1', 'Teatro Clásico', 'Plantilla para teatro con palcos y platea', '[object Object]', NULL, 'true', '1', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO seat_map_templates VALUES ('2', 'Estadio Deportivo', 'Plantilla para eventos deportivos', '[object Object]', NULL, 'true', '1', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO seat_map_templates VALUES ('3', 'Salón de Eventos', 'Plantilla para salones y conferencias', '[object Object]', NULL, 'true', '1', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: seat_maps
CREATE TABLE IF NOT EXISTS seat_maps (
  id integer NOT NULL DEFAULT nextval('seat_maps_id_seq'::regclass),
  name character varying NOT NULL,
  venue_name character varying,
  total_capacity integer DEFAULT 0,
  map_data jsonb NOT NULL,
  template_id integer,
  created_by integer,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: seat_maps
INSERT INTO seat_maps VALUES ('1', 'Teatro Nacional - Sala Principal', 'Teatro Nacional', '800', '[object Object]', '1', '2', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO seat_maps VALUES ('2', 'Coliseo El Campín', 'Coliseo El Campín', '1200', '[object Object]', '2', '2', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO seat_maps VALUES ('3', 'Movistar Arena - Configuración Esports', 'Movistar Arena', '8000', '[object Object]', '2', '2', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: seat_sections
CREATE TABLE IF NOT EXISTS seat_sections (
  id integer NOT NULL DEFAULT nextval('seat_sections_id_seq'::regclass),
  seat_map_id integer NOT NULL,
  name character varying NOT NULL,
  section_type character varying DEFAULT 'seating'::character varying,
  capacity integer DEFAULT 0,
  price_modifier numeric DEFAULT 1.00,
  color character varying DEFAULT '#3B82F6'::character varying,
  position_data jsonb,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: seats
CREATE TABLE IF NOT EXISTS seats (
  id integer NOT NULL DEFAULT nextval('seats_id_seq'::regclass),
  section_id integer NOT NULL,
  seat_number character varying NOT NULL,
  row_number character varying,
  status character varying DEFAULT 'available'::character varying,
  position_x integer DEFAULT 0,
  position_y integer DEFAULT 0,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla: ticket_types
CREATE TABLE IF NOT EXISTS ticket_types (
  id integer NOT NULL DEFAULT nextval('ticket_types_id_seq'::regclass),
  event_id integer NOT NULL,
  name character varying NOT NULL,
  description text,
  price numeric NOT NULL,
  quantity integer NOT NULL,
  sold integer DEFAULT 0,
  max_per_order integer DEFAULT 10,
  sale_start timestamp without time zone,
  sale_end timestamp without time zone,
  status character varying DEFAULT 'active'::character varying,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: ticket_types
INSERT INTO ticket_types VALUES ('4', '3', 'Entrada General', 'Asiento numerado', '35000.00', '400', '0', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('6', '4', 'Entrada Regular', 'Entrada estándar', '120000.00', '200', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('8', '5', 'Tribuna Sur', 'Tribuna Sur del estadio', '25000.00', '500', '0', '10', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('9', '5', 'Palco VIP', 'Palco VIP con servicios premium', '80000.00', '200', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('1', '1', 'Platea', 'Asientos en platea principal', '50000.00', '600', '2', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('2', '1', 'Palcos', 'Asientos en palcos VIP', '75000.00', '200', '1', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('3', '2', 'Entrada General', 'Acceso completo al festival', '80000.00', '500', '3', '8', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('5', '4', 'Early Bird', 'Precio especial por compra anticipada', '100000.00', '100', '1', '2', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('7', '5', 'Tribuna Norte', 'Tribuna Norte del estadio', '25000.00', '500', '4', '10', NULL, NULL, 'active', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('10', '6', 'General', 'Acceso general al concierto', '45000.00', '1500', '0', '8', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('11', '6', 'VIP', 'Zona VIP con bar incluido', '85000.00', '300', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('12', '6', 'Palco Premium', 'Palcos con servicio completo', '150000.00', '200', '0', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('14', '7', 'Startup', 'Incluye stand de exhibición', '200000.00', '100', '0', '2', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('15', '7', 'Inversor', 'Acceso VIP y networking exclusivo', '350000.00', '100', '0', '2', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('17', '8', 'Palcos', 'Palcos con vista privilegiada', '120000.00', '300', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('18', '8', 'Premium', 'Experiencia completa con cena', '200000.00', '100', '0', '2', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('20', '9', 'Preferencial', 'Mejores ubicaciones', '65000.00', '50', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('21', '10', 'General', 'Acceso general al torneo', '35000.00', '6000', '0', '10', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('22', '10', 'Premium', 'Zona premium con merchandising', '55000.00', '1500', '0', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('23', '10', 'VIP Gamer', 'Meet & greet con jugadores', '95000.00', '500', '0', '4', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('24', '11', 'Estudiante', 'Precio especial estudiantes', '100000.00', '100', '0', '2', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('26', '11', 'Empresarial', 'Incluye consultoría personalizada', '250000.00', '20', '0', '1', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('13', '7', 'Emprendedor', 'Acceso completo al evento', '75000.00', '600', '2', '3', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('16', '8', 'Platea', 'Asientos en platea principal', '85000.00', '800', '1', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('19', '9', 'General', 'Asientos numerados', '42000.00', '300', '2', '6', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('25', '11', 'Profesional', 'Acceso completo y certificado', '150000.00', '80', '4', '3', NULL, NULL, 'active', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:07:58 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('27', '1', 'General', 'Acceso general al evento', '75000.00', '100', '0', '5', NULL, NULL, 'active', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('28', '1', 'VIP', 'Acceso VIP con beneficios especiales', '150000.00', '50', '0', '3', NULL, NULL, 'active', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('29', '2', 'Platea', 'Asiento en platea', '85000.00', '80', '0', '4', NULL, NULL, 'active', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('30', '2', 'Balcón', 'Asiento en balcón', '65000.00', '120', '0', '6', NULL, NULL, 'active', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:13:51 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('31', '12', 'General', 'Acceso general al concierto futuro', '100000.00', '100', '0', '5', NULL, NULL, 'active', 'Wed Aug 20 2025 12:19:03 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:19:03 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('32', '1', 'VIP', 'Acceso VIP con asientos preferenciales, bebidas incluidas y meet & greet', '250000.00', '200', '0', '4', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('33', '1', 'General', 'Acceso general al festival', '150000.00', '4800', '0', '10', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('34', '2', 'Premium', 'Acceso completo a la conferencia con networking exclusivo', '350000.00', '100', '0', '2', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('35', '2', 'Estándar', 'Acceso a charlas y exhibición', '250000.00', '700', '0', '5', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('36', '3', 'Preferencial', 'Asientos en las mejores ubicaciones del estadio', '120000.00', '5000', '0', '6', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('37', '3', 'General', 'Asientos generales del estadio', '80000.00', '31000', '0', '10', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('38', '4', 'Guía Incluida', 'Entrada con tour guiado por expertos', '65000.00', '100', '0', '4', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('39', '4', 'General', 'Entrada general a la exposición', '45000.00', '200', '0', '6', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('40', '5', 'VIP Executive', 'Acceso VIP con networking exclusivo y cena de gala', '500000.00', '50', '0', '2', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('41', '5', 'Profesional', 'Acceso completo a la cumbre', '350000.00', '450', '0', '3', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('42', '6', 'Gourmet', 'Acceso completo con degustaciones premium', '120000.00', '300', '0', '4', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('43', '6', 'General', 'Acceso general al festival', '75000.00', '1700', '0', '8', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('44', '7', 'Palco', 'Asientos en palco con servicio de bebidas', '180000.00', '100', '0', '4', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('45', '7', 'Platea', 'Asientos en platea del teatro', '120000.00', '700', '0', '6', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('46', '8', 'Elite', 'Kit completo de corredor con beneficios especiales', '50000.00', '500', '0', '2', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');
INSERT INTO ticket_types VALUES ('47', '8', 'General', 'Inscripción general a la maratón', '35000.00', '9500', '0', '1', NULL, NULL, 'active', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:12:24 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: tickets
CREATE TABLE IF NOT EXISTS tickets (
  id integer NOT NULL DEFAULT nextval('tickets_id_seq'::regclass),
  sale_id integer NOT NULL,
  ticket_code character varying NOT NULL,
  qr_code text,
  seat_info jsonb,
  status character varying DEFAULT 'valid'::character varying,
  used_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Datos de tabla: tickets
INSERT INTO tickets VALUES ('1', '1', 'TKT-001-001', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('2', '1', 'TKT-001-002', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('3', '2', 'TKT-002-001', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('4', '3', 'TKT-003-001', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('5', '3', 'TKT-003-002', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('6', '3', 'TKT-003-003', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('7', '4', 'TKT-004-001', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('8', '5', 'TKT-005-001', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('9', '5', 'TKT-005-002', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('10', '5', 'TKT-005-003', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('11', '5', 'TKT-005-004', NULL, NULL, 'valid', NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('15', '4', 'TKT-004-002', NULL, NULL, 'valid', NULL, 'Wed Aug 20 2025 12:17:03 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('16', '20', 'TKT-020-001', NULL, NULL, 'valid', NULL, 'Wed Aug 20 2025 12:17:33 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('17', '21', 'TKT-021-001', NULL, NULL, 'valid', NULL, 'Wed Aug 20 2025 12:18:06 GMT-0500 (Colombia Standard Time)');
INSERT INTO tickets VALUES ('18', '22', 'TKT-022-001', NULL, NULL, 'valid', NULL, 'Wed Aug 20 2025 12:19:18 GMT-0500 (Colombia Standard Time)');

-- Estructura de tabla: users
CREATE TABLE IF NOT EXISTS users (
  id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
  first_name character varying NOT NULL,
  last_name character varying NOT NULL,
  email character varying NOT NULL,
  password_hash character varying NOT NULL,
  role character varying DEFAULT 'user'::character varying,
  status character varying DEFAULT 'active'::character varying,
  is_2fa_enabled boolean DEFAULT false,
  two_factor_secret character varying,
  email_verified_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  last_login timestamp without time zone,
  phone character varying
);

-- Datos de tabla: users
INSERT INTO users VALUES ('4', 'Juan', 'Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('5', 'Ana', 'López', 'ana@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('1', 'Admin', 'Sistema', 'admin@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'false', NULL, NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 11:46:26 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 123 4567');
INSERT INTO users VALUES ('2', 'Carlos', 'Rodríguez', 'carlos@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'false', NULL, NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 11:46:26 GMT-0500 (Colombia Standard Time)', NULL, '+57 310 987 6543');
INSERT INTO users VALUES ('3', 'María', 'González', 'maria@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'false', NULL, NULL, 'Tue Aug 19 2025 16:06:26 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 11:46:26 GMT-0500 (Colombia Standard Time)', NULL, '+57 315 555 1234');
INSERT INTO users VALUES ('26', 'Promotor', 'Eventu', 'promotor@eventu.co', '$2a$12$jC.htC2ZXipSHmIMIsoxM.t8EnVXs2aAXRdhJhvUTDPCCU4K/6Qga', 'organizer', 'active', 'false', NULL, NULL, 'Mon Aug 25 2025 13:47:34 GMT-0500 (Colombia Standard Time)', 'Mon Aug 25 2025 13:49:31 GMT-0500 (Colombia Standard Time)', NULL, '3001234570');
INSERT INTO users VALUES ('7', 'Nuevo Nombre', 'Nuevo Apellido', 'test@example.com', '$2a$12$xVoEp4NA97FVg0yxozXI/uJBaTc9j5RjnizQVQugVM7MgZthBptrW', 'user', 'active', 'false', NULL, NULL, 'Wed Aug 20 2025 11:50:12 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:08:12 GMT-0500 (Colombia Standard Time)', NULL, '3001111111');
INSERT INTO users VALUES ('8', 'Test', 'User Tickets', 'tickets@example.com', '$2a$12$.vnqLpGqzzUw9E4LlR0W5eNYwmA5wLRqc6xm.w.rVFY7nlX5iw.q2', 'user', 'active', 'false', NULL, NULL, 'Wed Aug 20 2025 12:16:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:16:24 GMT-0500 (Colombia Standard Time)', NULL, '3001234567');
INSERT INTO users VALUES ('9', 'Nuevo', 'Usuario', 'nuevo@example.com', '$2a$12$RG.XXkZGH5l83yVU8t1PYutiFTHpd4ql2E8qjoVwzGlJ66WUR2y8K', 'user', 'active', 'false', NULL, NULL, 'Wed Aug 20 2025 12:30:34 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:30:34 GMT-0500 (Colombia Standard Time)', NULL, '3009876543');
INSERT INTO users VALUES ('10', 'Organizador', 'Test', 'organizador@example.com', '$2a$12$4S4mwWSo.Uqo1GejSEIKROxOaqkgxB5ndQWvAQvTTP7JS/F2Ac6NC', 'organizer', 'active', 'false', NULL, NULL, 'Wed Aug 20 2025 12:39:58 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 12:40:08 GMT-0500 (Colombia Standard Time)', NULL, '3001234567');
INSERT INTO users VALUES ('11', 'Juan', 'Pérez', 'juan.perez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 123 4567');
INSERT INTO users VALUES ('12', 'María', 'García', 'maria.garcia@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 234 5678');
INSERT INTO users VALUES ('13', 'Carlos', 'López', 'carlos.lopez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 345 6789');
INSERT INTO users VALUES ('14', 'Ana', 'Martínez', 'ana.martinez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 456 7890');
INSERT INTO users VALUES ('15', 'Luis', 'Rodríguez', 'luis.rodriguez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 567 8901');
INSERT INTO users VALUES ('16', 'Sofía', 'Hernández', 'sofia.hernandez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 678 9012');
INSERT INTO users VALUES ('17', 'Diego', 'González', 'diego.gonzalez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 789 0123');
INSERT INTO users VALUES ('18', 'Valentina', 'Díaz', 'valentina.diaz@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', 'false', NULL, 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', 'Wed Aug 20 2025 13:08:24 GMT-0500 (Colombia Standard Time)', NULL, '+57 300 890 1234');
INSERT INTO users VALUES ('6', 'roberto', 'mendoza', 'robertomensie@gmail.com', '$2a$12$oppkPhMWVMEQ3tnv5InIAuNwS9QZTjzl3mS956ADahLysPIJpBDuG', 'user', 'active', 'false', NULL, NULL, 'Wed Aug 20 2025 11:00:53 GMT-0500 (Colombia Standard Time)', 'Thu Aug 21 2025 10:48:45 GMT-0500 (Colombia Standard Time)', NULL, '3243052154');
INSERT INTO users VALUES ('20', 'Test', 'Admin', 'test@eventu.com', '$2a$10$rTxNAiyZWSfqug3bIco1eeo9h.EvON0HUFtggp4AwnMLVvtQ7hkuC', 'admin', 'active', 'false', NULL, NULL, 'Fri Aug 22 2025 14:34:44 GMT-0500 (Colombia Standard Time)', 'Fri Aug 22 2025 14:34:44 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('22', 'Organizador', 'Test', 'organizador@test.com', '$2a$12$Bhe3qLWQkz/8EyLIp0QASedve7kUImCuJUx3GKiAIyVWjTXYPkEeW', 'organizer', 'active', 'false', NULL, NULL, 'Fri Aug 22 2025 15:30:47 GMT-0500 (Colombia Standard Time)', 'Fri Aug 22 2025 15:31:30 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('25', 'Admin', 'Eventu', 'admin2@eventu.co', '$2a$12$wOhOcNV.QqC.w45a8UO6zO20I.NhzbukPfoHkvHbV2cl.n3br25NO', 'user', 'active', 'false', NULL, NULL, 'Mon Aug 25 2025 13:10:37 GMT-0500 (Colombia Standard Time)', 'Mon Aug 25 2025 13:10:37 GMT-0500 (Colombia Standard Time)', NULL, '3001234569');
INSERT INTO users VALUES ('24', 'Usuario', 'Demo', 'demo@eventu.co', '$2a$10$MyDbB6EqQaLyOA8RcNvQ2O1mmkCGt7AP3w.EodchCyzPaD0xR55ce', 'user', 'active', 'false', NULL, NULL, 'Mon Aug 25 2025 13:10:08 GMT-0500 (Colombia Standard Time)', 'Mon Aug 25 2025 13:33:19 GMT-0500 (Colombia Standard Time)', NULL, '3001234567');
INSERT INTO users VALUES ('21', 'Roberto', 'Mendoza', 'roberto@eventu.co', '$2a$10$rHhV57oYqtrrMctUkUFMseJ/V3QnLtd3CV5qobTpW4njaM0oBXiw6', 'user', 'active', 'false', NULL, NULL, 'Fri Aug 22 2025 14:45:54 GMT-0500 (Colombia Standard Time)', 'Mon Aug 25 2025 13:39:39 GMT-0500 (Colombia Standard Time)', NULL, '3241119900');
INSERT INTO users VALUES ('27', 'Super', 'Admin', 'superadmin@eventu.co', '$2a$12$rvExGdHWiowcQJNAWSHDO.jg7hMp.5xUcJN4jMAAaMplJcNA3QEce', 'admin', 'active', 'false', NULL, NULL, 'Mon Aug 25 2025 16:17:42 GMT-0500 (Colombia Standard Time)', 'Mon Aug 25 2025 16:19:44 GMT-0500 (Colombia Standard Time)', NULL, '3001234567');
INSERT INTO users VALUES ('28', 'Admin', 'Test', 'admin@test.com', '$2a$12$dV63JjtvuBTuawMC9lZDde6866CLhPxd.vB672Ky5UQZN4Qu/onLu', 'admin', 'active', 'false', NULL, NULL, 'Tue Aug 26 2025 11:45:43 GMT-0500 (Colombia Standard Time)', 'Tue Aug 26 2025 11:45:53 GMT-0500 (Colombia Standard Time)', NULL, '123456789');
INSERT INTO users VALUES ('29', 'Test', 'Admin', 'testadmin@eventu.com', '$2a$12$HCg11wRjW.D9E0T966I0t.SVnupiGzMAArJZ.x2WkwzAQBSNQViJS', 'user', 'active', 'false', NULL, NULL, 'Wed Aug 27 2025 16:50:34 GMT-0500 (Colombia Standard Time)', 'Wed Aug 27 2025 16:50:34 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('30', 'Admin', 'Analytics', 'analytics@eventu.com', '$2a$12$cwEVVn40mc7KBYhobMMVUuuN3myUB0dJM7LX1Wz.TNu6zaZ9nY4PS', 'user', 'active', 'false', NULL, NULL, 'Thu Aug 28 2025 09:56:24 GMT-0500 (Colombia Standard Time)', 'Thu Aug 28 2025 09:56:24 GMT-0500 (Colombia Standard Time)', NULL, NULL);
INSERT INTO users VALUES ('23', 'Administrador', 'Eventu', 'admin@eventu.co', '$2a$12$Fjd6CeT8xzkVv9IuAdUETOmczUCgcH5tKCKXvPXfKmnZSPFLJtx5S', 'admin', 'active', 'false', NULL, NULL, 'Sun Aug 24 2025 19:41:51 GMT-0500 (Colombia Standard Time)', 'Wed Sep 10 2025 12:40:44 GMT-0500 (Colombia Standard Time)', NULL, NULL);

-- Estructura de tabla: virtual_tickets
CREATE TABLE IF NOT EXISTS virtual_tickets (
  id integer NOT NULL DEFAULT nextval('virtual_tickets_id_seq'::regclass),
  ticket_number character varying NOT NULL,
  event_id integer NOT NULL,
  ticket_type_id integer NOT NULL,
  customer_name character varying NOT NULL,
  customer_email character varying NOT NULL,
  customer_phone character varying,
  price numeric NOT NULL,
  qr_code text NOT NULL,
  status character varying DEFAULT 'active'::character varying,
  purchase_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  event_date date NOT NULL,
  used_at timestamp without time zone,
  sent_at timestamp without time zone,
  notes text,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

