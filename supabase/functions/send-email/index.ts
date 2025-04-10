// supabase/functions/send-email/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  console.log("🧪 RESEND_API_KEY:", Deno.env.get("RESEND_API_KEY"))
  // 预检请求处理：支持 CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
    })
  }

  try {
    const { email, subject, message } = await req.json()

    const apiKey = Deno.env.get("RESEND_API_KEY")!
    const sender = "onboarding@resend.dev"


    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: sender,
        to: [email],
        subject,
        html: message,
      }),
    })

    const data = await res.json()
    console.log("✅ Resend Response:", data)

    const status = res.ok ? 200 : 500
    return new Response(JSON.stringify(data), {
      status,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
      },
    })
  } catch (err) {
    console.error("❌ send-email error:", err)
    return new Response(JSON.stringify({ error: "Internal Error" }), {
      status: 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
      },
    })
  }
})
