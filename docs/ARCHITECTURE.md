# BEAR – System Architecture

## 1. Purpose

BEAR is a communication and coordination hub for:
- Primary caregivers (professional or family)
- Family members and close contacts of the person receiving care

Goals:
- Replace fragmented WhatsApp groups and ad-hoc notes
- Provide a structured space for:
  - Chat (in the form of a message board for updates patient and fun)
  - Medication info
  - Shared calendar
  - Reource of carers like medidation tracks
- Use AI to summarize, surface risks, and reduce cognitive load

---

## 2. High-Level Architecture

- **Frontend**
  - React navive app built with Expo
  - Will use Expo to release and an ios and android app

- **Backend**
  - Supabase database
  - Auth via supabase (there will be a flow for cares to invite people via email)

- **Database**
  - Relational DB via supabase
  - Infer core entities from table names DB_Schema.sql

---

## 3. Core Data Flows

(will be added later. may be derived from genereted code)

Use best practice for routes from ROUTING_PHILOSOPHY.md


## 4. Security & Privacy Basics

- All endpoints require auth, except sign-up / sign-in
- Access is scoped to Care Circles a user belongs to
- PHI/PII is treated carefully:
  - No plaintext secrets in logs
  - Minimize data sent to AI providers
  - Where possible, anonymize before sending to LLM

---

## 5. Frontend Structure (high level)

  - Tabs:
    - Messages (chat feed)
    - Dates (calendar/scheduling)
    - Care (Medicing tracking, documention, information)
    - Team (list of cares, inviting)
    - Your (resources to help cares like meditation feature)

## 6. Style

- Use var "bear-gray-50" for bottom menu icon colour
- Use var "bear-gray-80" for active bottom menu icon colour
- Use var "bear-gray-80" for regular text colour
- Use var "bear-gray-30" for light grey text colour
- Use var "bearBlue" for button colours
