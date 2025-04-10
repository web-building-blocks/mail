// app/api/send/route.ts
import { Resend } from 'resend'
import { NextResponse } from 'next/server'

const resend = new Resend(process.env.RESEND_API_KEY)

export async function POST(req: Request) {
  const body = await req.json()
  const { email, subject, content } = body

  try {
    const data = await resend.emails.send({
      from: 'August <you@yourdomain.com>',
      to: [email],
      subject,
      html: content, 
    })

    return NextResponse.json({ success: true, data })
  } catch (error) {
    return NextResponse.json({ success: false, error }, { status: 500 })
  }
}
