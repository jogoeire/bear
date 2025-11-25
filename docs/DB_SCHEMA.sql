-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.care_groups (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  patient_name text,
  description text,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT care_groups_pkey PRIMARY KEY (id),
  CONSTRAINT care_groups_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE TABLE public.event_participants (
  event_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text DEFAULT 'attendee'::text CHECK (role = ANY (ARRAY['organizer'::text, 'attendee'::text])),
  rsvp_status text DEFAULT 'pending'::text CHECK (rsvp_status = ANY (ARRAY['yes'::text, 'no'::text, 'maybe'::text, 'pending'::text])),
  notified_at timestamp with time zone,
  CONSTRAINT event_participants_pkey PRIMARY KEY (event_id, user_id),
  CONSTRAINT event_participants_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id),
  CONSTRAINT event_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  care_group_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  location text,
  start_at timestamp with time zone NOT NULL,
  end_at timestamp with time zone NOT NULL,
  all_day boolean NOT NULL DEFAULT false,
  timezone text,
  recurrence_rrule text,
  created_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone,
  CONSTRAINT events_pkey PRIMARY KEY (id),
  CONSTRAINT events_care_group_id_fkey FOREIGN KEY (care_group_id) REFERENCES public.care_groups(id),
  CONSTRAINT events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE TABLE public.group_members (
  care_group_id uuid NOT NULL,
  user_id uuid NOT NULL,
  role text DEFAULT 'family'::text CHECK (role = ANY (ARRAY['admin'::text, 'caregiver'::text, 'family'::text])),
  joined_at timestamp with time zone DEFAULT now(),
  CONSTRAINT group_members_pkey PRIMARY KEY (care_group_id, user_id),
  CONSTRAINT group_members_care_group_id_fkey FOREIGN KEY (care_group_id) REFERENCES public.care_groups(id),
  CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.invites (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  care_group_id uuid NOT NULL,
  email text NOT NULL,
  role text NOT NULL DEFAULT 'family'::text CHECK (role = ANY (ARRAY['admin'::text, 'caregiver'::text, 'family'::text])),
  token text NOT NULL UNIQUE,
  invited_by uuid NOT NULL,
  message text,
  expires_at timestamp with time zone NOT NULL,
  used_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT invites_pkey PRIMARY KEY (id),
  CONSTRAINT invites_care_group_id_fkey FOREIGN KEY (care_group_id) REFERENCES public.care_groups(id),
  CONSTRAINT invites_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.users(id)
);
CREATE TABLE public.medication_doses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  medication_id uuid NOT NULL,
  schedule_id uuid,
  scheduled_for timestamp with time zone,
  taken_at timestamp with time zone,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['taken'::text, 'skipped'::text, 'missed'::text, 'pending'::text])),
  amount_taken numeric,
  unit text,
  recorded_by uuid,
  note text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT medication_doses_pkey PRIMARY KEY (id),
  CONSTRAINT medication_doses_medication_id_fkey FOREIGN KEY (medication_id) REFERENCES public.medications(id),
  CONSTRAINT medication_doses_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.medication_schedules(id),
  CONSTRAINT medication_doses_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES public.users(id)
);
CREATE TABLE public.medication_schedules (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  medication_id uuid NOT NULL,
  dosage_amount numeric,
  dosage_unit text,
  as_needed boolean NOT NULL DEFAULT false,
  times_of_day ARRAY DEFAULT '{}'::time without time zone[],
  days_of_week ARRAY DEFAULT '{1,2,3,4,5,6,7}'::integer[],
  recurrence_rrule text,
  start_on date,
  end_on date,
  CONSTRAINT medication_schedules_pkey PRIMARY KEY (id),
  CONSTRAINT medication_schedules_medication_id_fkey FOREIGN KEY (medication_id) REFERENCES public.medications(id)
);
CREATE TABLE public.medications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  care_group_id uuid NOT NULL,
  name text NOT NULL,
  form text,
  strength text,
  route text,
  instructions text,
  prescriber text,
  started_on date,
  ended_on date,
  is_active boolean NOT NULL DEFAULT true,
  created_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone,
  CONSTRAINT medications_pkey PRIMARY KEY (id),
  CONSTRAINT medications_care_group_id_fkey FOREIGN KEY (care_group_id) REFERENCES public.care_groups(id),
  CONSTRAINT medications_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  care_group_id uuid NOT NULL,
  author_id uuid NOT NULL,
  body text NOT NULL,
  reply_to_id uuid,
  attachments jsonb DEFAULT '[]'::jsonb,
  edited_at timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_care_group_id_fkey FOREIGN KEY (care_group_id) REFERENCES public.care_groups(id),
  CONSTRAINT messages_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id),
  CONSTRAINT messages_reply_to_id_fkey FOREIGN KEY (reply_to_id) REFERENCES public.messages(id)
);
CREATE TABLE public.users (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  full_name text,
  avatar_url text,
  role text DEFAULT 'family'::text CHECK (role = ANY (ARRAY['admin'::text, 'caregiver'::text, 'family'::text])),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);