# Linear Clone

A Linear-style issue tracking POC. Same stack as amigo:

- **Backend**: Phoenix 1.8 + Ecto + Postgres
- **Frontend**: Next.js 16 + React 19 + TypeScript + Tailwind 4 + Zustand + axios

## Run locally

### Backend
```bash
cd backend
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
# API on http://localhost:4000
```

### Frontend
```bash
cd frontend
npm install
npm run dev
# UI on http://localhost:3000
```

## POC features

- Create / read / update / delete issues
- Auto-generated identifier (`LIN-XXXXXX`)
- Status: todo, in_progress, done, canceled
- Priority: urgent, high, medium, low, no_priority
- Linear-style dark UI
