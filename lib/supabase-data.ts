// lib/supabase-data.ts
import { supabase } from './supabase';

// require email_accounts table
export async function getAccounts(userId: string) {
  const { data, error } = await supabase
    .from('email_accounts')
    .select('*')
    .eq('user_id', userId);
  
  if (error) {
    console.error('Error fetching accounts:', error);
    return [];
  }
  
  return data || [];
}

// require folder table
export async function getFolders(userId: string, accountId?: string) {
  let query = supabase
    .from('folders')
    .select('*')
    .eq('user_id', userId);
  
  if (accountId) {
    query = query.eq('account_id', accountId);
  }
  
  const { data, error } = await query;
  
  if (error) {
    console.error('Error fetching folders:', error);
    return [];
  }
  
  return data || [];
}

// require emails table
export async function getEmails(userId: string, folderId: string) {
  const { data, error } = await supabase
    .from('emails')
    .select('*')
    .eq('user_id', userId)
    .eq('folder_id', folderId)
    .order('received_at', { ascending: false });
  
  if (error) {
    console.error('Error fetching emails:', error);
    return [];
  }
  
  return data || [];
}

// require detail of emails
export async function getEmailById(emailId: string) {
  const { data, error } = await supabase
    .from('emails')
    .select('*')
    .eq('id', emailId)
    .single();
  
  if (error) {
    console.error('Error fetching email:', error);
    return null;
  }
  
  return data;
}

// update states of emails
export async function updateEmailStatus(emailId: string, updates: unknown) {
  const { error } = await supabase
    .from('emails')
    .update(updates)
    .eq('id', emailId);
  
  if (error) {
    console.error('Error updating email:', error);
    return false;
  }
  
  return true;
}