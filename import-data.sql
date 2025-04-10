
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
  '550e8400-e29b-11d4-a716-446655440000',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  'alicia@example.com',
  'August Test',
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
  ('f1000000-0000-0000-0000-000000000001', 'f9820ef8-0b08-490e-b831-17e3c56ab3ec', '550e8400-e29b-11d4-a716-446655440000', 'Inbox', 'inbox', 'inbox', '#4f46e5', 1),
  ('f2000000-0000-0000-0000-000000000002', 'f9820ef8-0b08-490e-b831-17e3c56ab3ec', '550e8400-e29b-11d4-a716-446655440000', 'Sent', 'sent', 'send', '#10b981', 2),
  ('f3000000-0000-0000-0000-000000000003', 'f9820ef8-0b08-490e-b831-17e3c56ab3ec', '550e8400-e29b-11d4-a716-446655440000', 'Drafts', 'draft', 'file', '#f59e0b', 3),
  ('f4000000-0000-0000-0000-000000000004', 'f9820ef8-0b08-490e-b831-17e3c56ab3ec', '550e8400-e29b-11d4-a716-446655440000', 'Trash', 'trash', 'trash', '#6b7280', 5),
  ('f5000000-0000-0000-0000-000000000005', 'f9820ef8-0b08-490e-b831-17e3c56ab3ec', '550e8400-e29b-11d4-a716-446655440000', 'Archive', 'archive', 'archive', '#6b7280', 4);

-- email 1: Meeting Tomorrow
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
  '6c84fb90-12c4-11e1-840d-7b25c5ee775a',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_6c84fb90',
  'williamsmith@example.com',
  'William Smith',
  '["alicia@example.com"]'::jsonb,
  'Meeting Tomorrow',
  'Hi, let''s have a meeting tomorrow to discuss the project. I''ve been reviewing the project details and have some ideas I''d like to share. It''s crucial that we align on our next steps to ensure the project''s success.

Please come prepared with any questions or insights you may have. Looking forward to our meeting!

Best regards, William',
  '<div>Hi, let''''s have a meeting tomorrow to discuss the project. I''''ve been reviewing the project details and have some ideas I''''d like to share. It''''s crucial that we align on our next steps to ensure the project''''s success.<br/><br/>Please come prepared with any questions or insights you may have. Looking forward to our meeting!<br/><br/>Best regards, William</div>',
  true,
  false,
  '2023-10-22T09:00:00',
  now()
);

-- email 2: Re: Project Update
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
  '110e8400-e29b-11d4-a716-446655440000',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_110e8400',
  'alicesmith@example.com',
  'Alice Smith',
  '["alicia@example.com"]'::jsonb,
  'Re: Project Update',
  'Thank you for the project update. It looks great! I''ve gone through the report, and the progress is impressive. The team has done a fantastic job, and I appreciate the hard work everyone has put in.

I have a few minor suggestions that I''ll include in the attached document.

Let''s discuss these during our next meeting. Keep up the excellent work!

Best regards, Alice',
  '<div>Thank you for the project update. It looks great! I''''ve gone through the report, and the progress is impressive. The team has done a fantastic job, and I appreciate the hard work everyone has put in.<br/><br/>I have a few minor suggestions that I''''ll include in the attached document.<br/><br/>Let''''s discuss these during our next meeting. Keep up the excellent work!<br/><br/>Best regards, Alice</div>',
  true,
  false,
  '2023-10-22T10:30:00',
  now()
);

-- email 3: Weekend Plans
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
  '3e7c3f6d-bdf5-46ae-8d90-171300f27ae2',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_3e7c3f6d',
  'bobjohnson@example.com',
  'Bob Johnson',
  '["alicia@example.com"]'::jsonb,
  'Weekend Plans',
  'Any plans for the weekend? I was thinking of going hiking in the nearby mountains. It''s been a while since we had some outdoor fun.

If you''re interested, let me know, and we can plan the details. It''ll be a great way to unwind and enjoy nature.

Looking forward to your response!

Best, Bob',
  '<div>Any plans for the weekend? I was thinking of going hiking in the nearby mountains. It''''s been a while since we had some outdoor fun.<br/><br/>If you''''re interested, let me know, and we can plan the details. It''''ll be a great way to unwind and enjoy nature.<br/><br/>Looking forward to your response!<br/><br/>Best, Bob</div>',
  true,
  false,
  '2023-04-10T11:45:00',
  now()
);

-- email 4: Re: Question about Budget
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
  '61c35085-72d7-42b4-8d62-738f700d4b92',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_61c35085',
  'emilydavis@example.com',
  'Emily Davis',
  '["alicia@example.com"]'::jsonb,
  'Re: Question about Budget',
  'I have a question about the budget for the upcoming project. It seems like there''s a discrepancy in the allocation of resources.

I''ve reviewed the budget report and identified a few areas where we might be able to optimize our spending without compromising the project''s quality.

I''ve attached a detailed analysis for your reference. Let''s discuss this further in our next meeting.

Thanks, Emily',
  '<div>I have a question about the budget for the upcoming project. It seems like there''''s a discrepancy in the allocation of resources.<br/><br/>I''''ve reviewed the budget report and identified a few areas where we might be able to optimize our spending without compromising the project''''s quality.<br/><br/>I''''ve attached a detailed analysis for your reference. Let''''s discuss this further in our next meeting.<br/><br/>Thanks, Emily</div>',
  false,
  false,
  '2023-03-25T13:15:00',
  now()
);

-- email 5: Important Announcement
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
  '8f7b5db9-d935-4e42-8e05-1f1d0a3dfb97',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_8f7b5db9',
  'michaelwilson@example.com',
  'Michael Wilson',
  '["alicia@example.com"]'::jsonb,
  'Important Announcement',
  'I have an important announcement to make during our team meeting. It pertains to a strategic shift in our approach to the upcoming product launch. We''ve received valuable feedback from our beta testers, and I believe it''s time to make some adjustments to better meet our customers'' needs.

This change is crucial to our success, and I look forward to discussing it with the team. Please be prepared to share your insights during the meeting.

Regards, Michael',
  '<div>I have an important announcement to make during our team meeting. It pertains to a strategic shift in our approach to the upcoming product launch. We''''ve received valuable feedback from our beta testers, and I believe it''''s time to make some adjustments to better meet our customers'''' needs.<br/><br/>This change is crucial to our success, and I look forward to discussing it with the team. Please be prepared to share your insights during the meeting.<br/><br/>Regards, Michael</div>',
  false,
  false,
  '2023-03-10T15:00:00',
  now()
);

-- email 6: Re: Feedback on Proposal
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
  '1f0f2c02-e299-40de-9b1d-86ef9e42126b',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_1f0f2c02',
  'sarahbrown@example.com',
  'Sarah Brown',
  '["alicia@example.com"]'::jsonb,
  'Re: Feedback on Proposal',
  'Thank you for your feedback on the proposal. It looks great! I''m pleased to hear that you found it promising. The team worked diligently to address all the key points you raised, and I believe we now have a strong foundation for the project.

I''ve attached the revised proposal for your review.

Please let me know if you have any further comments or suggestions. Looking forward to your response.

Best regards, Sarah',
  '<div>Thank you for your feedback on the proposal. It looks great! I''''m pleased to hear that you found it promising. The team worked diligently to address all the key points you raised, and I believe we now have a strong foundation for the project.<br/><br/>I''''ve attached the revised proposal for your review.<br/><br/>Please let me know if you have any further comments or suggestions. Looking forward to your response.<br/><br/>Best regards, Sarah</div>',
  true,
  false,
  '2023-02-15T16:30:00',
  now()
);

-- email 7: New Project Idea
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
  '17c0a96d-4415-42b1-8b4f-764efab57f66',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_17c0a96d',
  'davidlee@example.com',
  'David Lee',
  '["alicia@example.com"]'::jsonb,
  'New Project Idea',
  'I have an exciting new project idea to discuss with you. It involves expanding our services to target a niche market that has shown considerable growth in recent months.

I''ve prepared a detailed proposal outlining the potential benefits and the strategy for execution.

This project has the potential to significantly impact our business positively. Let''s set up a meeting to dive into the details and determine if it aligns with our current goals.

Best regards, David',
  '<div>I have an exciting new project idea to discuss with you. It involves expanding our services to target a niche market that has shown considerable growth in recent months.<br/><br/>I''''ve prepared a detailed proposal outlining the potential benefits and the strategy for execution.<br/><br/>This project has the potential to significantly impact our business positively. Let''''s set up a meeting to dive into the details and determine if it aligns with our current goals.<br/><br/>Best regards, David</div>',
  false,
  false,
  '2023-01-28T17:45:00',
  now()
);

-- email 8: Vacation Plans
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
  '2f0130cb-39fc-44c4-bb3c-0a4337edaaab',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_2f0130cb',
  'oliviawilson@example.com',
  'Olivia Wilson',
  '["alicia@example.com"]'::jsonb,
  'Vacation Plans',
  'Let''s plan our vacation for next month. What do you think? I''ve been thinking of visiting a tropical paradise, and I''ve put together some destination options.

I believe it''s time for us to unwind and recharge. Please take a look at the options and let me know your preferences.

We can start making arrangements to ensure a smooth and enjoyable trip.

Excited to hear your thoughts! Olivia',
  '<div>Let''''s plan our vacation for next month. What do you think? I''''ve been thinking of visiting a tropical paradise, and I''''ve put together some destination options.<br/><br/>I believe it''''s time for us to unwind and recharge. Please take a look at the options and let me know your preferences.<br/><br/>We can start making arrangements to ensure a smooth and enjoyable trip.<br/><br/>Excited to hear your thoughts! Olivia</div>',
  true,
  false,
  '2022-12-20T18:30:00',
  now()
);

-- email 9: Re: Conference Registration
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
  'de305d54-75b4-431b-adb2-eb6b9e546014',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_de305d54',
  'jamesmartin@example.com',
  'James Martin',
  '["alicia@example.com"]'::jsonb,
  'Re: Conference Registration',
  'I''ve completed the registration for the conference next month. The event promises to be a great networking opportunity, and I''m looking forward to attending the various sessions and connecting with industry experts.

I''ve also attached the conference schedule for your reference.

If there are any specific topics or sessions you''d like me to explore, please let me know. It''s an exciting event, and I''ll make the most of it.

Best regards, James',
  '<div>I''''ve completed the registration for the conference next month. The event promises to be a great networking opportunity, and I''''m looking forward to attending the various sessions and connecting with industry experts.<br/><br/>I''''ve also attached the conference schedule for your reference.<br/><br/>If there are any specific topics or sessions you''''d like me to explore, please let me know. It''''s an exciting event, and I''''ll make the most of it.<br/><br/>Best regards, James</div>',
  true,
  false,
  '2022-11-30T19:15:00',
  now()
);

-- email 10: Team Dinner
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
  '7dd90c63-00f6-40f3-bd87-5060a24e8ee7',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_7dd90c63',
  'sophiawhite@example.com',
  'Sophia White',
  '["alicia@example.com"]'::jsonb,
  'Team Dinner',
  'Let''s have a team dinner next week to celebrate our success. We''ve achieved some significant milestones, and it''s time to acknowledge our hard work and dedication.

I''ve made reservations at a lovely restaurant, and I''m sure it''ll be an enjoyable evening.

Please confirm your availability and any dietary preferences. Looking forward to a fun and memorable dinner with the team!

Best, Sophia',
  '<div>Let''''s have a team dinner next week to celebrate our success. We''''ve achieved some significant milestones, and it''''s time to acknowledge our hard work and dedication.<br/><br/>I''''ve made reservations at a lovely restaurant, and I''''m sure it''''ll be an enjoyable evening.<br/><br/>Please confirm your availability and any dietary preferences. Looking forward to a fun and memorable dinner with the team!<br/><br/>Best, Sophia</div>',
  false,
  false,
  '2022-11-05T20:30:00',
  now()
);

-- email 11: Feedback Request
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
  '99a88f78-3eb4-4d87-87b7-7b15a49a0a05',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_99a88f78',
  'danieljohnson@example.com',
  'Daniel Johnson',
  '["alicia@example.com"]'::jsonb,
  'Feedback Request',
  'I''d like your feedback on the latest project deliverables. We''ve made significant progress, and I value your input to ensure we''re on the right track.

I''ve attached the deliverables for your review, and I''m particularly interested in any areas where you think we can further enhance the quality or efficiency.

Your feedback is invaluable, and I appreciate your time and expertise. Let''s work together to make this project a success.

Regards, Daniel',
  '<div>I''''d like your feedback on the latest project deliverables. We''''ve made significant progress, and I value your input to ensure we''''re on the right track.<br/><br/>I''''ve attached the deliverables for your review, and I''''m particularly interested in any areas where you think we can further enhance the quality or efficiency.<br/><br/>Your feedback is invaluable, and I appreciate your time and expertise. Let''''s work together to make this project a success.<br/><br/>Regards, Daniel</div>',
  false,
  false,
  '2022-10-22T09:30:00',
  now()
);

-- email 12: Re: Meeting Agenda
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
  'f47ac10b-58cc-4372-a567-0e02b2c3d479',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_f47ac10b',
  'avataylor@example.com',
  'Ava Taylor',
  '["alicia@example.com"]'::jsonb,
  'Re: Meeting Agenda',
  'Here''s the agenda for our meeting next week. I''ve included all the topics we need to cover, as well as time allocations for each.

If you have any additional items to discuss or any specific points to address, please let me know, and we can integrate them into the agenda.

It''s essential that our meeting is productive and addresses all relevant matters.

Looking forward to our meeting! Ava',
  '<div>Here''''s the agenda for our meeting next week. I''''ve included all the topics we need to cover, as well as time allocations for each.<br/><br/>If you have any additional items to discuss or any specific points to address, please let me know, and we can integrate them into the agenda.<br/><br/>It''''s essential that our meeting is productive and addresses all relevant matters.<br/><br/>Looking forward to our meeting! Ava</div>',
  true,
  false,
  '2022-10-10T10:45:00',
  now()
);

-- email 13: Product Launch Update
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
  'c1a0ecb4-2540-49c5-86f8-21e5ce79e4e6',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_c1a0ecb4',
  'williamanderson@example.com',
  'William Anderson',
  '["alicia@example.com"]'::jsonb,
  'Product Launch Update',
  'The product launch is on track. I''ll provide an update during our call. We''ve made substantial progress in the development and marketing of our new product.

I''m excited to share the latest updates with you during our upcoming call. It''s crucial that we coordinate our efforts to ensure a successful launch. Please come prepared with any questions or insights you may have.

Let''s make this product launch a resounding success!

Best regards, William',
  '<div>The product launch is on track. I''''ll provide an update during our call. We''''ve made substantial progress in the development and marketing of our new product.<br/><br/>I''''m excited to share the latest updates with you during our upcoming call. It''''s crucial that we coordinate our efforts to ensure a successful launch. Please come prepared with any questions or insights you may have.<br/><br/>Let''''s make this product launch a resounding success!<br/><br/>Best regards, William</div>',
  false,
  false,
  '2022-09-20T12:00:00',
  now()
);

-- email 14: Re: Travel Itinerary
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
  'ba54eefd-4097-4949-99f2-2a9ae4d1a836',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_ba54eefd',
  'miaharris@example.com',
  'Mia Harris',
  '["alicia@example.com"]'::jsonb,
  'Re: Travel Itinerary',
  'I''ve received the travel itinerary. It looks great! Thank you for your prompt assistance in arranging the details. I''ve reviewed the schedule and the accommodations, and everything seems to be in order. I''m looking forward to the trip, and I''m confident it''ll be a smooth and enjoyable experience.

If there are any specific activities or attractions you recommend at our destination, please feel free to share your suggestions.

Excited for the trip! Mia',
  '<div>I''''ve received the travel itinerary. It looks great! Thank you for your prompt assistance in arranging the details. I''''ve reviewed the schedule and the accommodations, and everything seems to be in order. I''''m looking forward to the trip, and I''''m confident it''''ll be a smooth and enjoyable experience.<br/><br/>If there are any specific activities or attractions you recommend at our destination, please feel free to share your suggestions.<br/><br/>Excited for the trip! Mia</div>',
  true,
  false,
  '2022-09-10T13:15:00',
  now()
);

-- email 15: Team Building Event
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
  'df09b6ed-28bd-4e0c-85a9-9320ec5179aa',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_df09b6ed',
  'ethanclark@example.com',
  'Ethan Clark',
  '["alicia@example.com"]'::jsonb,
  'Team Building Event',
  'Let''s plan a team-building event for our department. Team cohesion and morale are vital to our success, and I believe a well-organized team-building event can be incredibly beneficial. I''ve done some research and have a few ideas for fun and engaging activities.

Please let me know your thoughts and availability. We want this event to be both enjoyable and productive.

Together, we''ll strengthen our team and boost our performance.

Regards, Ethan',
  '<div>Let''''s plan a team-building event for our department. Team cohesion and morale are vital to our success, and I believe a well-organized team-building event can be incredibly beneficial. I''''ve done some research and have a few ideas for fun and engaging activities.<br/><br/>Please let me know your thoughts and availability. We want this event to be both enjoyable and productive.<br/><br/>Together, we''''ll strengthen our team and boost our performance.<br/><br/>Regards, Ethan</div>',
  false,
  false,
  '2022-08-25T15:30:00',
  now()
);

-- email 16: Re: Budget Approval
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
  'd67c1842-7f8b-4b4b-9be1-1b3b1ab4611d',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_d67c1842',
  'chloehall@example.com',
  'Chloe Hall',
  '["alicia@example.com"]'::jsonb,
  'Re: Budget Approval',
  'The budget has been approved. We can proceed with the project. I''m delighted to inform you that our budget proposal has received the green light from the finance department. This is a significant milestone, and it means we can move forward with the project as planned.

I''ve attached the finalized budget for your reference. Let''s ensure that we stay on track and deliver the project on time and within budget.

It''s an exciting time for us! Chloe',
  '<div>The budget has been approved. We can proceed with the project. I''''m delighted to inform you that our budget proposal has received the green light from the finance department. This is a significant milestone, and it means we can move forward with the project as planned.<br/><br/>I''''ve attached the finalized budget for your reference. Let''''s ensure that we stay on track and deliver the project on time and within budget.<br/><br/>It''''s an exciting time for us! Chloe</div>',
  true,
  false,
  '2022-08-10T16:45:00',
  now()
);

-- email 17: Weekend Hike
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
  '6c9a7f94-8329-4d70-95d3-51f68c186ae1',
  'f9820ef8-0b08-490e-b831-17e3c56ab3ec',
  '550e8400-e29b-11d4-a716-446655440000',
  'f1000000-0000-0000-0000-000000000001',
  'msg_6c9a7f94',
  'samuelturner@example.com',
  'Samuel Turner',
  '["alicia@example.com"]'::jsonb,
  'Weekend Hike',
  'Who''s up for a weekend hike in the mountains? I''ve been craving some outdoor adventure, and a hike in the mountains sounds like the perfect escape. If you''re up for the challenge, we can explore some scenic trails and enjoy the beauty of nature.

I''ve done some research and have a few routes in mind.

Let me know if you''re interested, and we can plan the details.

It''s sure to be a memorable experience! Samuel',
  '<div>Who''''s up for a weekend hike in the mountains? I''''ve been craving some outdoor adventure, and a hike in the mountains sounds like the perfect escape. If you''''re up for the challenge, we can explore some scenic trails and enjoy the beauty of nature.<br/><br/>I''''ve done some research and have a few routes in mind.<br/><br/>Let me know if you''''re interested, and we can plan the details.<br/><br/>It''''s sure to be a memorable experience! Samuel</div>',
  false,
  false,
  '2022-07-28T17:30:00',
  now()
);
