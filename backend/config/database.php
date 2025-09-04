<?php
class Database {
    private $host = "localhost";
    private $db_name = "eventu_db";
    private $username = "postgres";
    private $password = ""; // Cambiar por tu password de PostgreSQL
    private $port = "5432";
    public $conn;

    public function getConnection() {
        $this->conn = null;

        try {
            $dsn = "pgsql:host=" . $this->host . ";port=" . $this->port . ";dbname=" . $this->db_name . ";options='--client_encoding=UTF8'";
            
            $this->conn = new PDO(
                $dsn,
                $this->username,
                $this->password,
                array(
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                )
            );
            
            // Configurar timezone
            $this->conn->exec("SET timezone = 'America/Bogota'");
            
        } catch(PDOException $exception) {
            echo "Error de conexión: " . $exception->getMessage();
            die();
        }

        return $this->conn;
    }

    public function testConnection() {
        try {
            $conn = $this->getConnection();
            if ($conn) {
                $stmt = $conn->query("SELECT version()");
                $version = $stmt->fetch();
                return [
                    'success' => true,
                    'message' => 'Conexión exitosa a PostgreSQL',
                    'version' => $version['version']
                ];
            }
        } catch(Exception $e) {
            return [
                'success' => false,
                'message' => 'Error de conexión: ' . $e->getMessage()
            ];
        }
    }
}
?>
