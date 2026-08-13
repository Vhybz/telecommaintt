-- =============================================================================
-- Telecom AI - Complete Database Schema
-- =============================================================================

-- 1. EXTENSIONS & CORE TABLES
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

-- 2. USER MANAGEMENT
-- PROFILES (Linked to Supabase Auth)
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

-- 3. NETWORK INFRASTRUCTURE
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

-- EQUIPMENT TYPES
CREATE TABLE IF NOT EXISTS public.equipment_types (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO public.equipment_types (name) VALUES
('Radio Unit'), ('RRU'), ('BBU'), ('Antenna'), ('Rectifier'),
('Battery'), ('Generator'), ('Air Conditioner'), ('Microwave')
ON CONFLICT (name) DO NOTHING;

-- EQUIPMENT INVENTORY
CREATE TABLE IF NOT EXISTS public.equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    type_id INTEGER REFERENCES public.equipment_types(id),
    serial_number TEXT UNIQUE,
    model TEXT,
    manufacturer TEXT,
    status TEXT DEFAULT 'Active',
    health_score INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. MONITORING & AI INSIGHTS
-- KPI RECORDS (Historical performance)
CREATE TABLE IF NOT EXISTS public.kpi_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    availability DECIMAL(10, 4),
    cssr DECIMAL(10, 4), -- Call Setup Success Rate
    cdr DECIMAL(10, 4),  -- Call Drop Rate
    latency DECIMAL(15, 4),
    throughput DECIMAL(20, 4),
    prb_utilization DECIMAL(10, 4),
    temperature DECIMAL(10, 4),
    voltage DECIMAL(10, 4)
);

-- ALARM LOGS (Incidents)
CREATE TABLE IF NOT EXISTS public.alarm_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES public.equipment(id) ON DELETE SET NULL,
    severity TEXT CHECK (severity IN ('Critical', 'Major', 'Minor', 'Warning')),
    description TEXT,
    status TEXT DEFAULT 'Open' CHECK (status IN ('Open', 'Acknowledged', 'Resolved')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE
);

-- ML PREDICTIONS
CREATE TABLE IF NOT EXISTS public.predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES public.equipment(id) ON DELETE SET NULL,
    fault_type TEXT,
    probability DECIMAL(10, 8), -- High precision for AI confidence
    risk_level TEXT CHECK (risk_level IN ('High', 'Medium', 'Low')),
    recommended_action TEXT,
    -- Derived AI features saved for audit
    dcr_cssr_ratio DECIMAL(15, 10),
    tp_prb_efficiency DECIMAL(15, 10),
    avail_x_cssr DECIMAL(15, 10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. OPERATIONS
-- REPORTS
CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- e.g., Performance, Faults, Inventory
    station_id UUID REFERENCES public.base_stations(id) ON DELETE SET NULL,
    file_url TEXT,
    created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MAINTENANCE TASKS
CREATE TABLE IF NOT EXISTS public.maintenance_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    station_id UUID REFERENCES public.base_stations(id) ON DELETE CASCADE,
    equipment_id UUID REFERENCES public.equipment(id) ON DELETE SET NULL,
    assigned_to UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    fault_description TEXT,
    scheduled_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),
    completion_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. PERMISSIONS & SECURITY
-- Disable RLS for development environment (Enable and define policies for production!)
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.base_stations DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment_types DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.kpi_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.alarm_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictions DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_tasks DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.regions DISABLE ROW LEVEL SECURITY;

-- 7. AUTOMATION (Functions & Triggers)

-- Handle updated_at timestamps automatically
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_base_stations_updated ON public.base_stations;
CREATE TRIGGER on_base_stations_updated BEFORE UPDATE ON public.base_stations FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

DROP TRIGGER IF EXISTS on_equipment_updated ON public.equipment;
CREATE TRIGGER on_equipment_updated BEFORE UPDATE ON public.equipment FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

DROP TRIGGER IF EXISTS on_maintenance_tasks_updated ON public.maintenance_tasks;
CREATE TRIGGER on_maintenance_tasks_updated BEFORE UPDATE ON public.maintenance_tasks FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

DROP TRIGGER IF EXISTS on_profiles_updated ON public.profiles;
CREATE TRIGGER on_profiles_updated BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE PROCEDURE handle_updated_at();

-- SAFE SIGN UP TRIGGER
-- Automatically creates a public profile record when a new user signs up via Supabase Auth
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
        COALESCE((NEW.raw_user_meta_data->>'role_id')::INTEGER, 3) -- Default to role 3 (Technician) if not specified
    );
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN
    -- Fallback: ensure the Auth process is never blocked by profile creation errors
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Force Schema Cache Refresh (PostgREST)
NOTIFY pgrst, 'reload schema';

-- STORAGE BUCKETS
INSERT INTO storage.buckets (id, name, public)
VALUES ('reports', 'reports', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public Access" ON storage.objects FOR ALL USING (bucket_id = 'reports');
