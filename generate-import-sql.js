const fs = require('fs');
const path = require('path');

// set  Supabase userID and relevant info
const userId = 'f9820ef8-0b08-490e-b831-17e3c56ab3ec'; // your actual uid from supabase auth user
const accountId = '550e8400-e29b-11d4-a716-446655440000';
const inboxFolderId = 'f1000000-0000-0000-0000-000000000001';

// read data.tsx
const dataFilePath = path.join(__dirname, 'app', 'examples', 'mail', 'data.tsx');
const dataContent = fs.readFileSync(dataFilePath, 'utf8');

// extract email data from data.tsx
const extractMailsData = (content) => {
  // extract mails array
  const mailsMatch = content.match(/export const mails = \[([\s\S]*?)\]\s*export type Mail/);
  if (!mailsMatch) return [];
  
  const mailsString = mailsMatch[1];
  const mailsArray = [];
  
  // Use regular expressions to match each email object
  const mailObjectRegex = /{\s*id:\s*"([^"]+)",\s*name:\s*"([^"]+)",\s*email:\s*"([^"]+)",\s*subject:\s*"([^"]+)",\s*text:\s*"([^"]+)",\s*date:\s*"([^"]+)",\s*read:\s*(true|false),\s*labels:\s*\[([^\]]*)\]/g;
  
  let match;
  while ((match = mailObjectRegex.exec(mailsString)) !== null) {
    const id = match[1];
    const name = match[2];
    const email = match[3];
    const subject = match[4];
    const text = match[5].replace(/\\n/g, '\n').replace(/\\"/g, '"');
    const date = match[6];
    const read = match[7] === 'true';
    const labels = match[8].split(',').map(label => 
      label.trim().replace(/"/g, '').trim()
    ).filter(label => label);
    
    mailsArray.push({
      id, name, email, subject, text, date, read, labels
    });
  }
  
  return mailsArray;
};

// Extract account data
const extractAccountsData = (content) => {
  // Extract data from the first account of the accounts array
  const accountMatch = content.match(/export const accounts = \[\s*{\s*label:\s*"([^"]+)",\s*email:\s*"([^"]+)"/);
  if (!accountMatch) return { label: "Unknown", email: "unknown@example.com" };
  
  return {
    label: accountMatch[1],
    email: accountMatch[2]
  };
};

const mails = extractMailsData(dataContent);
const account = extractAccountsData(dataContent);

console.log(` ${mails.length} emails are already extracted successfully!`);

// generate SQL
let sql = `
-- create a email account
INSERT INTO email_accounts (
  id, 
  user_id, 
  email, 
  display_name, 
  provider,
  is_primary,
  imap_host,
  imap_port,
  smtp_host,
  smtp_port,
  created_at
)
VALUES (
  '${accountId}',
  '${userId}',
  '${account.email}',
  '${account.label.replace(/'/g, "''")}',
  'gmail',
  true,
  'imap.gmail.com',
  993,
  'smtp.gmail.com',
  465,
  now()
);

-- create base folder
INSERT INTO folders (id, user_id, account_id, name, type, icon, color, order_index)
VALUES 
  ('f1000000-0000-0000-0000-000000000001', '${userId}', '${accountId}', 'Inbox', 'inbox', 'inbox', '#4f46e5', 1),
  ('f2000000-0000-0000-0000-000000000002', '${userId}', '${accountId}', 'Sent', 'sent', 'send', '#10b981', 2),
  ('f3000000-0000-0000-0000-000000000003', '${userId}', '${accountId}', 'Drafts', 'draft', 'file', '#f59e0b', 3),
  ('f4000000-0000-0000-0000-000000000004', '${userId}', '${accountId}', 'Trash', 'trash', 'trash', '#6b7280', 5),
  ('f5000000-0000-0000-0000-000000000005', '${userId}', '${accountId}', 'Archive', 'archive', 'archive', '#6b7280', 4);
`;

// add all email from mock data
mails.forEach((mail, index) => {
  // Escape text and avoid SQL injection
  const escapedText = mail.text.replace(/'/g, "''");
  const htmlBody = `<div>${escapedText.replace(/\n/g, '<br/>')}</div>`.replace(/'/g, "''");
  
  sql += `
-- email ${index + 1}: ${mail.subject}
INSERT INTO emails (
  id,
  user_id,
  account_id,
  folder_id,
  message_id,
  from_email,
  from_name,
  to_email,
  subject,
  body_text,
  body_html,
  is_read,
  is_starred,
  received_at,
  created_at
)
VALUES (
  '${mail.id}',
  '${userId}',
  '${accountId}',
  '${inboxFolderId}',
  'msg_${mail.id.substring(0, 8)}',
  '${mail.email.replace(/'/g, "''")}',
  '${mail.name.replace(/'/g, "''")}',
  '["${account.email}"]'::jsonb,
  '${mail.subject.replace(/'/g, "''")}',
  '${escapedText}',
  '${htmlBody}',
  ${mail.read},
  false,
  '${mail.date}',
  now()
);
`;
});

// Write to a SQL file
fs.writeFileSync('import-data.sql', sql);
console.log('The SQL import script has been generated: import-data.sql');