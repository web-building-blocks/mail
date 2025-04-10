This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, install the dependencies:

```bash
npm install
# or
yarn
# or
pnpm install
# or
bun install
```

Second, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000/examples/mail](http://localhost:3000/examples/mail) with your browser to see the result of mail app.

You can start editing the page by modifying `app/examples/mail/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.



## Process

### 1. Install, setting and configuration

1. Run`pnpm dlx shadcn@latest init`

![82fb8f3561dcac310c57fb07b52df32](D:\Wechat\WeChat Files\wxid_w8c1b47xss3y21\FileStorage\Temp\82fb8f3561dcac310c57fb07b52df32.png)

2. copy all code from [project][ui/apps/www/app/(app)/examples/mail at main · shadcn-ui/ui](https://github.com/shadcn-ui/ui/tree/main/apps/www/app/(app)/examples/mail)，alter all dependencies，add components accordingly.

`npx shadcn@latest add calendar label switch textarea button input select checkbox card badge avatar skeleton tabs popover dropdown-menu separator tooltip dialog sheet select separator scroll-area`

`pnpm add date-fns`

`pnpm add jotai`

### 2. Supabase

https://supabase.com/docs/guides/functions/examples/send-emails

1. install suapbase

   ```
   # Install Supabase and Resend
   pnpm add @supabase/supabase-js @supabase/auth-helpers-nextjs
   
   # Install additional utilities
   npm install date-fns lucide-react zustand
   ```

2. Environment Setup

   Create a `.env.local` file at the root of your project:

   ```
   # Supabase Configuration
   NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

3. Create a test user together with mock data

4. database and tables

   Execute these sql snippet inside supabase sql editor

   table1: email_accounts

   ```sql
   CREATE TABLE email_accounts (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id) NOT NULL,
     email VARCHAR NOT NULL,
     display_name VARCHAR,
     provider VARCHAR NOT NULL,
     is_primary BOOLEAN DEFAULT false,
     imap_host VARCHAR,
     imap_port INTEGER,
     imap_use_ssl BOOLEAN DEFAULT true,
     smtp_host VARCHAR,
     smtp_port INTEGER,
     smtp_use_ssl BOOLEAN DEFAULT true,
     credentials_encrypted TEXT,
     oauth_access_token TEXT,
     oauth_refresh_token TEXT,
     oauth_expires_at TIMESTAMPTZ,
     last_synced_at TIMESTAMPTZ,
     created_at TIMESTAMPTZ DEFAULT NOW(),
     updated_at TIMESTAMPTZ DEFAULT NOW(),
     
     UNIQUE(user_id, email)
   );
   
   CREATE INDEX ON email_accounts(user_id);
   ```

   table2: folders

   ```sql
   CREATE TABLE folders (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id) NOT NULL,
     account_id UUID REFERENCES email_accounts(id),
     name VARCHAR NOT NULL,
     type VARCHAR NOT NULL,
     icon VARCHAR,
     color VARCHAR,
     order_index INTEGER DEFAULT 0,
     created_at TIMESTAMPTZ DEFAULT NOW()
   );
   
   CREATE INDEX ON folders(user_id);
   CREATE INDEX ON folders(account_id);
   
   -- 创建部分唯一索引
   CREATE UNIQUE INDEX folders_user_account_name_unique_idx 
   ON folders(user_id, account_id, name) 
   WHERE account_id IS NOT NULL;
   
   CREATE UNIQUE INDEX folders_user_name_unique_idx 
   ON folders(user_id, name) 
   WHERE account_id IS NULL;
   ```

   table3

   ```sql
   CREATE TABLE emails (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id) NOT NULL,
     account_id UUID REFERENCES email_accounts(id) NOT NULL,
     folder_id UUID REFERENCES folders(id),
     message_id VARCHAR,
     conversation_id VARCHAR,
     from_email VARCHAR NOT NULL,
     from_name VARCHAR,
     to_email JSONB NOT NULL,
     cc_email JSONB,
     bcc_email JSONB,
     reply_to JSONB,
     subject VARCHAR,
     snippet VARCHAR,
     body_text TEXT,
     body_html TEXT,
     has_attachments BOOLEAN DEFAULT false,
     is_read BOOLEAN DEFAULT false,
     is_starred BOOLEAN DEFAULT false,
     is_important BOOLEAN DEFAULT false,
     received_at TIMESTAMPTZ,
     sent_at TIMESTAMPTZ,
     created_at TIMESTAMPTZ DEFAULT NOW(),
     updated_at TIMESTAMPTZ DEFAULT NOW(),
     
     UNIQUE(account_id, message_id)
   );
   
   CREATE INDEX ON emails(user_id);
   CREATE INDEX ON emails(account_id);
   CREATE INDEX ON emails(folder_id);
   CREATE INDEX ON emails(conversation_id);
   CREATE INDEX ON emails(received_at);
   ```

   table4: attachments

   ```sql
   CREATE TABLE attachments (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     email_id UUID REFERENCES emails(id) ON DELETE CASCADE NOT NULL,
     filename VARCHAR NOT NULL,
     content_type VARCHAR NOT NULL,
     size INTEGER NOT NULL,
     content_id VARCHAR,
     is_inline BOOLEAN DEFAULT false,
     storage_path VARCHAR,
     created_at TIMESTAMPTZ DEFAULT NOW()
   );
   
   CREATE INDEX ON attachments(email_id);
   ```

   

5. transfer mock data into supabase database -->`generate-import-sql.js`

​	and generate a SQL file --> `import-data.sql`

​	Execute this SQL file in supabase sql editor, you will find that data is created.

### 3. Create a data access function

`//lib/supabse-data.ts`



alter `mail.tsx`

1. Import Supabase Client: Import the Supabase client from @/lib/supabase.
2. Removed mails attribute: no longer receives mock data from the parent component, but directly from Supabase.
3. Added state management:
   - mails - Stores messages fetched from Supabase
   - folderCounts - Stores the message count for each folder
   - loading - Loading status flags
   - searchQuery - Search query
   - selectedFolder - The currently selected folder 

4. Added data fetch logic:
   - Use useEffect to get message data from Supabase
   - Filter messages based on the selected folders
   - Transform data formats to match application needs

5. Useful features added:
   - Search filtering
   - Message marked as read feature
   - The loading status is displayed

6. Updated folder navigation:
   - Add a folder and click Processing
   - Displays the actual folder count
   - Update the UI status based on the selected folder

7. Added error handling and logging:
   - Log all kinds of errors for debugging
   - Update status after critical actions

### 4. Resend setting using supabase

1. edit on `.env.local`

2. domain

   buy a domain from cloudflare

   add domain

3. supabase send-email  Edge Functions

   1. at root directory, run `supabase init` wait until folder`supabase/`is created.

   2. run `supabase login` and login with browser
   3. run `supabase functions deploy send-email` select the project.

![](C:\Users\August\AppData\Roaming\Typora\typora-user-images\image-20250410182657887.png)
