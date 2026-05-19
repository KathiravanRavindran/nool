-- Book Campus Marketplace Schema setup
-- Run this entire script in your Supabase SQL Editor

-- RESET DATABASE (Drops existing tables so we can start clean)
DROP TABLE IF EXISTS public.books;
DROP TABLE IF EXISTS public.users_profile;

-- 1. Create the users_profile table
CREATE TABLE IF NOT EXISTS public.users_profile (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT NOT NULL,
    register_no TEXT NOT NULL,
    department TEXT NOT NULL,
    year INT NOT NULL,
    email TEXT NOT NULL,
    id_card_url TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Enable Row Level Security (RLS) for users_profile
ALTER TABLE public.users_profile ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view profiles (needed for displaying user info on book listings)
CREATE POLICY "Profiles are viewable by everyone" ON public.users_profile
    FOR SELECT USING (true);

-- Allow authenticated users to insert their own profile during registration
CREATE POLICY "Users can insert their own profile" ON public.users_profile
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Allow admins to update profiles (e.g., approving users)
CREATE POLICY "Admins can update profiles" ON public.users_profile
    FOR UPDATE USING (
        (SELECT is_admin FROM public.users_profile WHERE id = auth.uid()) = true
    );

-- Allow admins to delete profiles
CREATE POLICY "Admins can delete profiles" ON public.users_profile
    FOR DELETE USING (
        (SELECT is_admin FROM public.users_profile WHERE id = auth.uid()) = true
    );

-- 3. Create the books table
CREATE TABLE IF NOT EXISTS public.books (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    seller_id UUID REFERENCES public.users_profile(id) ON DELETE CASCADE NOT NULL,
    book_name TEXT NOT NULL,
    regulation TEXT NOT NULL,
    subject TEXT NOT NULL,
    publication TEXT NOT NULL,
    original_price NUMERIC NOT NULL,
    selling_price NUMERIC NOT NULL,
    condition TEXT NOT NULL,
    image_url TEXT NOT NULL,
    contact TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Enable Row Level Security (RLS) for books
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;

-- Allow anyone to view books
CREATE POLICY "Books are viewable by everyone" ON public.books
    FOR SELECT USING (true);

-- Allow authenticated users to insert their own books
CREATE POLICY "Users can insert their own books" ON public.books
    FOR INSERT WITH CHECK (auth.uid() = seller_id);

-- Allow users and admins to delete books
CREATE POLICY "Users and admins can delete books" ON public.books
    FOR DELETE USING (
        auth.uid() = seller_id OR 
        (SELECT is_admin FROM public.users_profile WHERE id = auth.uid()) = true
    );

-- Allow users and admins to update books
CREATE POLICY "Users and admins can update books" ON public.books
    FOR UPDATE USING (
        auth.uid() = seller_id OR 
        (SELECT is_admin FROM public.users_profile WHERE id = auth.uid()) = true
    );

-- ==========================================
-- HELPER COMMAND: PROMOTING A USER TO ADMIN
-- ==========================================
-- If you need to make yourself an admin to test the dashboard, run this after registering:
-- UPDATE public.users_profile SET is_admin = true, is_approved = true WHERE email = 'your.email@gmail.com';
