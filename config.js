// config.js

// Replace these with your actual Supabase project details
const SUPABASE_URL = 'SUPABASE_URL';
const SUPABASE_ANON_KEY = 'SUPABASE_ANON';

// ImgBB API Key (from previous code)
const IMGBB_API_KEY = 'IMGBB_API';

// Initialize Supabase Client directly onto the global window object to avoid TDZ errors
window.supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
