-- Create profiles table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  phone TEXT,
  city TEXT,
  country TEXT,
  professional_title TEXT,
  summary TEXT,
  skills TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create profile_experiences table
CREATE TABLE public.profile_experiences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  position TEXT NOT NULL,
  company TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  is_current BOOLEAN DEFAULT false,
  achievements TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create profile_education table
CREATE TABLE public.profile_education (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  degree TEXT NOT NULL,
  institution TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create profile_certifications table
CREATE TABLE public.profile_certifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  issuer TEXT,
  date_obtained DATE,
  expiry_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create profile_languages table
CREATE TABLE public.profile_languages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  language TEXT NOT NULL,
  proficiency TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create job_offers table
CREATE TABLE public.job_offers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  title TEXT,
  company TEXT,
  description TEXT NOT NULL,
  url TEXT,
  analysis JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create cvs table
CREATE TABLE public.cvs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  job_offer_id UUID REFERENCES public.job_offers(id) ON DELETE SET NULL,
  cv_type TEXT NOT NULL CHECK (cv_type IN ('general', 'job_based')),
  ats_version TEXT NOT NULL,
  recruiter_version TEXT NOT NULL,
  template TEXT DEFAULT 'default',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_experiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_education ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cvs ENABLE ROW LEVEL SECURITY;

-- Profiles RLS policies
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- Profile experiences RLS policies
CREATE POLICY "Users can view own experiences"
  ON public.profile_experiences FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_experiences.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can insert own experiences"
  ON public.profile_experiences FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_experiences.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can update own experiences"
  ON public.profile_experiences FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_experiences.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can delete own experiences"
  ON public.profile_experiences FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_experiences.profile_id AND profiles.user_id = auth.uid()));

-- Profile education RLS policies
CREATE POLICY "Users can view own education"
  ON public.profile_education FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_education.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can insert own education"
  ON public.profile_education FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_education.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can update own education"
  ON public.profile_education FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_education.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can delete own education"
  ON public.profile_education FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_education.profile_id AND profiles.user_id = auth.uid()));

-- Profile certifications RLS policies
CREATE POLICY "Users can view own certifications"
  ON public.profile_certifications FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_certifications.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can insert own certifications"
  ON public.profile_certifications FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_certifications.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can update own certifications"
  ON public.profile_certifications FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_certifications.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can delete own certifications"
  ON public.profile_certifications FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_certifications.profile_id AND profiles.user_id = auth.uid()));

-- Profile languages RLS policies
CREATE POLICY "Users can view own languages"
  ON public.profile_languages FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_languages.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can insert own languages"
  ON public.profile_languages FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_languages.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can update own languages"
  ON public.profile_languages FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_languages.profile_id AND profiles.user_id = auth.uid()));

CREATE POLICY "Users can delete own languages"
  ON public.profile_languages FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = profile_languages.profile_id AND profiles.user_id = auth.uid()));

-- Job offers RLS policies
CREATE POLICY "Users can view own job offers"
  ON public.job_offers FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own job offers"
  ON public.job_offers FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own job offers"
  ON public.job_offers FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own job offers"
  ON public.job_offers FOR DELETE
  USING (auth.uid() = user_id);

-- CVs RLS policies
CREATE POLICY "Users can view own cvs"
  ON public.cvs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own cvs"
  ON public.cvs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own cvs"
  ON public.cvs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own cvs"
  ON public.cvs FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp updates on profiles
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();