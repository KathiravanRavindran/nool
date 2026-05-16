// config.js

// Replace these with your actual Supabase project details
const SUPABASE_URL = 'https://ptrkrzsqhfimisndzimp.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0cmtyenNxaGZpbWlzbmR6aW1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NTg3NjAsImV4cCI6MjA5NDQzNDc2MH0.ggEJfgFHvCNSV57YAZuHepeC-Cd6MERHqP02NecfXVI';

// ImgBB API Key (from previous code)
const IMGBB_API_KEY = 'fd7bf3374f035cd051f6d024f2173564';

// Initialize Supabase Client directly onto the global window object to avoid TDZ errors
window.supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
