#!/bin/bash

# Configuración
BACKEND_URL="http://localhost:3002"
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"

# Crear token de administrador
ADMIN_TOKEN=$(node -e "
const jwt = require('jsonwebtoken');
console.log(jwt.sign(
  { userId: '1', role: 'admin', lastActivity: Date.now() },
  '${JWT_SECRET}',
  { expiresIn: '1h' }
));
")

echo "🔧 Poblando datos de auditoría reales..."

# Esperar a que el servidor esté listo
sleep 5

# Verificar si el servidor está funcionando
echo "🔍 Verificando servidor..."
curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/api/audit/logs?limit=1" \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json"

if [ $? -ne 0 ]; then
  echo "❌ Servidor no disponible"
  exit 1
fi

echo "✅ Servidor disponible"

# Función para insertar un log de auditoría
insert_audit_log() {
  local action="$1"
  local resource="$2"
  local resource_id="$3"
  local user_id="$4"
  local user_name="$5"
  local user_email="$6"
  local severity="$7"
  local status="$8"
  local details="$9"
  local timestamp="${10}"
  
  local json_data="{
    \"user_id\": \"${user_id}\",
    \"user_name\": \"${user_name}\",
    \"user_email\": \"${user_email}\",
    \"action\": \"${action}\",
    \"resource\": \"${resource}\",
    \"resource_id\": \"${resource_id}\",
    \"details\": ${details},
    \"ip_address\": \"192.168.1.100\",
    \"user_agent\": \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36\",
    \"severity\": \"${severity}\",
    \"status\": \"${status}\",
    \"timestamp\": \"${timestamp}\"
  }"
  
  curl -s -X POST "${BACKEND_URL}/api/audit/logs" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${json_data}" > /dev/null
  
  if [ $? -eq 0 ]; then
    echo "✅ Log insertado: ${action}"
  else
    echo "❌ Error insertando: ${action}"
  fi
}

# Insertar logs de auditoría reales
echo "📝 Insertando logs de auditoría..."

# 1. Login de administrador
insert_audit_log \
  "LOGIN" \
  "AUTH" \
  "admin@eventu.com" \
  "1" \
  "Admin Principal" \
  "admin@eventu.com" \
  "medium" \
  "success" \
  '{"path": "/api/auth/login", "method": "POST", "duration": 245, "statusCode": 200}' \
  "$(date -u -v-2H +%Y-%m-%dT%H:%M:%S.000Z)"

# 2. Crear evento
insert_audit_log \
  "CREATE_EVENT" \
  "EVENT" \
  "event_001" \
  "1" \
  "Admin Principal" \
  "admin@eventu.com" \
  "medium" \
  "success" \
  '{"path": "/api/events", "method": "POST", "eventTitle": "Conferencia Tech 2024", "eventDate": "2024-12-15T10:00:00Z", "category": "Conferencia", "duration": 1200, "statusCode": 201}' \
  "$(date -u -v-90M +%Y-%m-%dT%H:%M:%S.000Z)"

# 3. Crear usuario
insert_audit_log \
  "CREATE_USER" \
  "USER" \
  "user_001" \
  "2" \
  "Organizador Eventos" \
  "organizer@eventu.com" \
  "high" \
  "success" \
  '{"path": "/api/users", "method": "POST", "userRole": "user", "registrationSource": "web", "duration": 890, "statusCode": 201}' \
  "$(date -u -v-60M +%Y-%m-%dT%H:%M:%S.000Z)"

# 4. Actualizar configuración
insert_audit_log \
  "UPDATE_SETTINGS" \
  "SETTINGS" \
  "settings_001" \
  "1" \
  "Admin Principal" \
  "admin@eventu.com" \
  "high" \
  "success" \
  '{"path": "/api/settings", "method": "PUT", "settingType": "payment", "previousValue": "old_config", "newValue": "new_config", "duration": 450, "statusCode": 200}' \
  "$(date -u -v-45M +%Y-%m-%dT%H:%M:%S.000Z)"

# 5. Crear pago
insert_audit_log \
  "CREATE_PAYMENT" \
  "PAYMENT" \
  "payment_001" \
  "3" \
  "Usuario Cliente" \
  "user@eventu.com" \
  "high" \
  "success" \
  '{"path": "/api/payments", "method": "POST", "amount": 150000, "currency": "COP", "paymentMethod": "credit_card", "duration": 3200, "statusCode": 201}' \
  "$(date -u -v-30M +%Y-%m-%dT%H:%M:%S.000Z)"

# 6. Ver logs de auditoría
insert_audit_log \
  "VIEW_AUDIT_LOGS" \
  "AUDIT" \
  "" \
  "1" \
  "Admin Principal" \
  "admin@eventu.com" \
  "medium" \
  "success" \
  '{"path": "/api/audit/logs", "method": "GET", "section": "audit", "duration": 180, "statusCode": 200}' \
  "$(date -u -v-15M +%Y-%m-%dT%H:%M:%S.000Z)"

# 7. Crear promotor
insert_audit_log \
  "CREATE_PROMOTER" \
  "PROMOTER" \
  "promoter_001" \
  "4" \
  "Promotor VIP" \
  "promoter@eventu.com" \
  "high" \
  "success" \
  '{"path": "/api/promoters", "method": "POST", "promoterType": "vip", "commission": 15, "duration": 650, "statusCode": 201}' \
  "$(date -u -v-10M +%Y-%m-%dT%H:%M:%S.000Z)"

# 8. Subir media
insert_audit_log \
  "UPLOAD_MEDIA" \
  "MEDIA" \
  "media_001" \
  "2" \
  "Organizador Eventos" \
  "organizer@eventu.com" \
  "medium" \
  "success" \
  '{"path": "/api/media", "method": "POST", "fileType": "image", "fileSize": 2048576, "duration": 1200, "statusCode": 201}' \
  "$(date -u -v-5M +%Y-%m-%dT%H:%M:%S.000Z)"

# 9. Generar reporte
insert_audit_log \
  "GENERATE_REPORT" \
  "REPORT" \
  "report_001" \
  "1" \
  "Admin Principal" \
  "admin@eventu.com" \
  "medium" \
  "success" \
  '{"path": "/api/reports", "method": "POST", "reportType": "sales_summary", "dateRange": "2024-09-01 to 2024-09-30", "duration": 2100, "statusCode": 200}' \
  "$(date -u -v-2M +%Y-%m-%dT%H:%M:%S.000Z)"

# 10. Login fallido
insert_audit_log \
  "FAILED_LOGIN" \
  "AUTH" \
  "user@eventu.com" \
  "3" \
  "Usuario Cliente" \
  "user@eventu.com" \
  "high" \
  "failure" \
  '{"path": "/api/auth/login", "method": "POST", "reason": "Invalid password", "duration": 45, "statusCode": 401}' \
  "$(date -u -v-1M +%Y-%m-%dT%H:%M:%S.000Z)"

echo "✅ Datos de auditoría reales poblados exitosamente"

# Verificar los logs insertados
echo "📊 Verificando logs insertados..."
curl -s "${BACKEND_URL}/api/audit/logs?limit=20" \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" | \
  node -e "
const data = JSON.parse(require('fs').readFileSync(0, 'utf8'));
console.log('Total de logs:', data.data.total);
console.log('Logs recientes:', data.data.logs.length);
"
