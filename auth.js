// auth.js

// Shared Authentication Functions

async function checkAuth() {
    const client = window.supabase || supabase;
    const { data: { session }, error } = await client.auth.getSession();
    
    if (error) {
        console.error("Error getting session:", error.message);
        return null;
    }
    
    if (!session) {
        return null;
    }

    // Fetch user profile to check approval status
    const { data: profile, error: profileError } = await client
        .from('users_profile')
        .select('*')
        .eq('id', session.user.id)
        .single();

    if (profileError) {
        console.error("Error fetching profile:", profileError.message);
        return null;
    }

    return { session, profile };
}

async function requireAuth() {
    const authData = await checkAuth();
    if (!authData) {
        window.location.href = 'login.html';
        return null;
    }

    if (!authData.profile.is_approved) {
        alert("Your account is pending admin approval. You cannot access this page yet.");
        window.location.href = 'index.html';
        return null;
    }

    return authData;
}

async function requireAdmin() {
    const authData = await checkAuth();
    
    if (!authData) {
        window.location.href = 'login.html';
        return null;
    }

    if (!authData.profile.is_admin) {
        alert("Access Denied: Admins only.");
        window.location.href = 'index.html';
        return null;
    }
    
    return authData;
}

async function logout() {
    const client = window.supabase || supabase;
    const { error } = await client.auth.signOut();
    if (error) {
        console.error("Logout Error:", error.message);
    } else {
        window.location.href = 'index.html';
    }
}
