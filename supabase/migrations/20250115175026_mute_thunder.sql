/*
  # Initial Schema Setup for Sports Coaching Platform

  1. New Tables
    - profiles
      - Stores user profile information
      - Links to Supabase auth.users
    - coaching_sessions
      - Stores scheduled coaching sessions
      - Links coaches and students
    - reviews
      - Stores session reviews and ratings
    
  2. Security
    - Enable RLS on all tables
    - Add policies for data access
*/

-- Create profiles table
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  username text UNIQUE,
  full_name text,
  avatar_url text,
  bio text,
  is_coach boolean DEFAULT false,
  sport_specialties text[],
  hourly_rate decimal(10,2),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create coaching_sessions table
CREATE TABLE coaching_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id uuid REFERENCES profiles(id),
  student_id uuid REFERENCES profiles(id),
  start_time timestamptz NOT NULL,
  duration interval NOT NULL,
  status text NOT NULL DEFAULT 'scheduled',
  price decimal(10,2) NOT NULL,
  notes text,
  video_room_id text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT valid_status CHECK (status IN ('scheduled', 'completed', 'cancelled'))
);

ALTER TABLE coaching_sessions ENABLE ROW LEVEL SECURITY;

-- Create reviews table
CREATE TABLE reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid REFERENCES coaching_sessions(id),
  reviewer_id uuid REFERENCES profiles(id),
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(session_id, reviewer_id)
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Policies for coaching_sessions
CREATE POLICY "Sessions viewable by participants"
  ON coaching_sessions FOR SELECT
  USING (auth.uid() IN (coach_id, student_id));

CREATE POLICY "Coaches can create sessions"
  ON coaching_sessions FOR INSERT
  WITH CHECK (auth.uid() = coach_id AND EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_coach = true
  ));

-- Policies for reviews
CREATE POLICY "Reviews are viewable by everyone"
  ON reviews FOR SELECT
  USING (true);

CREATE POLICY "Session participants can create reviews"
  ON reviews FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM coaching_sessions
      WHERE id = reviews.session_id
      AND (coach_id = auth.uid() OR student_id = auth.uid())
      AND status = 'completed'
    )
  );

-- Functions
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name, avatar_url)
  VALUES (
    new.id,
    new.raw_user_meta_data->>'username',
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();