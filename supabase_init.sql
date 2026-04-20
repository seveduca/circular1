-- SQL Script para inicializar la base de datos de "Circular N°1" en Supabase.
-- Ejecuta este código en el "SQL Editor" de tu proyecto en Supabase.

-- 1. Tabla de Sesiones
CREATE TABLE IF NOT EXISTS sesiones (
    clave TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    establecimiento TEXT,
    creada TEXT,
    activa BOOLEAN DEFAULT TRUE,
    pct INTEGER DEFAULT 0,
    last_save TEXT
);

-- 2. Tabla de Progresos
CREATE TABLE IF NOT EXISTS progresos (
    clave TEXT PRIMARY KEY REFERENCES sesiones(clave) ON DELETE CASCADE,
    ind JSONB DEFAULT '{}'::jsonb,
    ver JSONB DEFAULT '{}'::jsonb,
    obs JSONB DEFAULT '{}'::jsonb,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Tabla de Configuración (para la clave de Admin)
CREATE TABLE IF NOT EXISTS config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

-- Configura la contraseña de administrador por defecto (Cámbiala más tarde desde el panel)
INSERT INTO config (key, value) VALUES ('admin_password', 'ADMIN2024')
ON CONFLICT (key) DO NOTHING;

-- Configurar RLS (Row Level Security) para permitir el acceso anónimo
-- Dado que la app corre puramente desde el frontend conectándose como anónimo sin login

ALTER TABLE sesiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE progresos ENABLE ROW LEVEL SECURITY;
ALTER TABLE config ENABLE ROW LEVEL SECURITY;

-- Políticas para acceso total con la llave anónima o public:
-- ¡OJO! Esto permite leer y escribir cualquier dato sin una sesión de usuario. 
-- Es para propósitos de prueba o si confías en que nadie malicioso usará la base de datos pública.

CREATE POLICY "Allow public access for sesiones"
ON sesiones FOR ALL
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow public access for progresos"
ON progresos FOR ALL
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow public access for config"
ON config FOR ALL
USING (true)
WITH CHECK (true);
