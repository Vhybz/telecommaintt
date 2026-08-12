-- 1. SETUP EXTENSIONS & CORE TABLES
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ROLES
CREATE TABLE IF NOT EXISTS public.roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

INSERT INTO public.roles (id, name, description) VALUES
(1, 'Administrator', 'Full system access'),
(2, 'Network Engineer', 'KPI monitoring and task assignment'),
(3, 'Technician', 'Field maintenance and repair')
ON CONFLICT (id) DO NOTHING;

-- REGIONS
CREATE TABLE IF NOT EXISTS public.regions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO public.regions (name) VALUES
('Greater Accra'), ('Ashanti'), ('Western'), ('Central'), ('Eastern'),
('Northern'), ('Volta'), ('Upper East'), ('Upper West'), ('Bono'),
('Bono East'), ('Ahafo'), ('Savannah'), ('North East'), ('Oti'), ('Western North')
ON CONFLICT (name) DO NOTHING;

-- 2. FEATURE TABLES
-- PROFILES
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    phone TEXT,
    profession TEXT,
    role_id INTEGER REFERENCES public.roles(id) DEFAULT 3,
    region_id INTEGER REFERENCES public.regions(id),
    avatar_url TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- BASE STATIONS
CREATE TABLE IF NOT EXISTS public.base_stations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    site_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    status TEXT DEFAULT 'Online' CHECK (status IN ('Online', 'Offline', 'Maintenance', 'Degraded')),
    region_id INTEGER REFERENCES public.regions(id),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    tower_type TEXT,
    operator TEXT,
    installation_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- EQUIPMENT
CREATE TABLE IF NOT EXISTS public.equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    serial_number TEXT UNIQUE,
    model TEXT,
    status TEXT DEFAULT 'Active',
    health_score INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ALARM LOGS
CREATE TABLE IF NOT EXISTS public.alarm_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    severity TEXT CHECK (severity IN ('Critical', 'Major', 'Minor', 'Warning')),
    description TEXT,
    status TEXT DEFAULT 'Open' CHECK (status IN ('Open', 'Acknowledged', 'Resolved')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PREDICTIONS
CREATE TABLE IF NOT EXISTS public.predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    fault_type TEXT,
    probability DECIMAL(5, 4), -- supports 0.9999
    risk_level TEXT CHECK (risk_level IN ('High', 'Medium', 'Low')),
    recommended_action TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MAINTENANCE TASKS
CREATE TABLE IF NOT EXISTS public.maintenance_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    assigned_to UUID REFERENCES public.profiles(id),
    fault_description TEXT,
    scheduled_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. PERMISSIONS (Disable RLS for simple dev access)
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.base_stations DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.alarm_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictions DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_tasks DISABLE ROW LEVEL SECURITY;

-- 4. AUTOMATION (TRIGGERS)
-- Update timestamps
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_base_stations_updated ON public.base_stations;
CREATE TRIGGER on_base_stations_updated BEFORE UPDATE ON public.base_stations FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

DROP TRIGGER IF EXISTS on_maintenance_tasks_updated ON public.maintenance_tasks;
CREATE TRIGGER on_maintenance_tasks_updated BEFORE UPDATE ON public.maintenance_tasks FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

-- SAFE SIGN UP TRIGGER (Always creates profile, never blocks auth)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, phone, profession, role_id)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'New User'),
        COALESCE(NEW.raw_user_meta_data->>'phone', ''),
        COALESCE(NEW.raw_user_meta_data->>'profession', ''),
        COALESCE((NEW.raw_user_meta_data->>'role_id')::INTEGER, 3) -- Dynamic role from metadata
    );
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Refresh Schema Cache
NOTIFY pgrst, 'reload schema';