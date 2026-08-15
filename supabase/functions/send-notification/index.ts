import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

serve(async (req) => {
  const { userRole, title, body } = await req.json()
  
  const supabase = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!)
  
  const { data: users } = await supabase.from('users').select('fcm_token').eq('role', userRole)
  
  for (const user of users || []) {
    if (user.fcm_token) {
      await fetch('https://fcm.googleapis.com/fcm/send', {
        method: 'POST',
        headers: {
          'Authorization': `key=${Deno.env.get('FCM_SERVER_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          to: user.fcm_token,
          notification: { title, body },
        }),
      })
    }
  }
  
  return new Response('OK')
})
