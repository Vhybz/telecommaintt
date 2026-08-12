-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ROLES TABLE
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

INSERT INTO roles (name, description) VALUES
('Administrator', 'Full system access'),
('Network Engineer', 'KPI monitoring and task assignment'),
('Technician', 'Field maintenance and repair');

-- REGIONS TABLE
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO regions (name) VALUES
('Greater Accra'), ('Ashanti'), ('Western'), ('Central'), ('Eastern'),
('Northern'), ('Volta'), ('Upper East'), ('Upper West'), ('Bono'),
('Bono East'), ('Ahafo'), ('Savannah'), ('North East'), ('Oti'), ('Western North');

-- PROFILES TABLE
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    phone TEXT,
    profession TEXT,
    role_id INTEGER REFERENCES roles(id) DEFAULT 3,
    region_id INTEGER REFERENCES regions(id),
    avatar_url TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- BASE STATIONS TABLE
CREATE TABLE base_stations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    site_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    status TEXT DEFAULT 'Online' CHECK (status IN ('Online', 'Offline', 'Maintenance', 'Degraded')),
    region_id INTEGER REFERENCES regions(id),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    tower_type TEXT,
    operator TEXT,
    installation_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- EQUIPMENT TYPES
CREATE TABLE equipment_types (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO equipment_types (name) VALUES
('Radio Unit'), ('RRU'), ('BBU'), ('Antenna'), ('Rectifier'),
('Battery'), ('Generator'), ('Air Conditioner'), ('Microwave');

-- EQUIPMENT TABLE
CREATE TABLE equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES base_stations(id) ON DELETE CASCADE,
    type_id INTEGER REFERENCES equipment_types(id),
    serial_number TEXT UNIQUE,
    model TEXT,
    manufacturer TEXT,
    installation_date DATE,
    status TEXT DEFAULT 'Active',
    health_score INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- KPI RECORDS TABLE
CREATE TABLE kpi_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES base_stations(id) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    availability DECIMAL(5, 2),
    cssr DECIMAL(5, 2), -- Call Setup Success Rate
    cdr DECIMAL(5, 2),  -- Call Drop Rate
    rsrp DECIMAL(10, 2),
    rsrq DECIMAL(10, 2),
    sinr DECIMAL(10, 2),
    temperature DECIMAL(5, 2),
    voltage DECIMAL(5, 2),
    power_consumption DECIMAL(10, 2)
);

-- ALARM LOGS TABLE
CREATE TABLE alarm_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES equipment(id),
    severity TEXT CHECK (severity IN ('Critical', 'Major', 'Minor', 'Warning')),
    description TEXT,
    status TEXT DEFAULT 'Open' CHECK (status IN ('Open', 'Acknowledged', 'Resolved')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- PREDICTIONS TABLE
CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES equipment(id),
    fault_type TEXT,
    probability DECIMAL(5, 2),
    risk_level TEXT CHECK (risk_level IN ('High', 'Medium', 'Low')),
    recommended_action TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MAINTENANCE TASKS TABLE
CREATE TABLE maintenance_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES equipment(id),
    assigned_to UUID REFERENCES profiles(id),
    fault_description TEXT,
    scheduled_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),
    completion_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ROW LEVEL SECURITY (RLS) - DISABLED
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE base_stations DISABLE ROW LEVEL SECURITY;
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE kpi_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE alarm_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE predictions DISABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_tasks DISABLE ROW LEVEL SECURITY;

-- STORAGE BUCKET FOR AVATARS
-- This ensures the bucket exists for profile pictures
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- STORAGE POLICIES (Public access for simplicity as requested)
CREATE POLICY "Public Access" ON storage.objects FOR ALL USING (bucket_id = 'avatars');

-- Functions and Triggers for updated_at
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_base_stations_updated BEFORE UPDATE ON base_stations FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();
CREATE TRIGGER on_equipment_updated BEFORE UPDATE ON equipment FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();
CREATE TRIGGER on_maintenance_tasks_updated BEFORE UPDATE ON maintenance_tasks FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

-- Trigger for new user profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, phone, profession, avatar_url, role_id)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'phone',
        NEW.raw_user_meta_data->>'profession',
        NEW.raw_user_meta_data->>'avatar_url',
        3
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
