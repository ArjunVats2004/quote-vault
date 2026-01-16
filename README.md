# QuoteVault 📚✨

QuoteVault is a Flutter application that lets users discover, save, and organize inspiring quotes.  
It uses **Supabase** as the backend and a seeded CSV file to populate the quotes database.  
Users can browse random quotes, mark favorites, and manage collections — all with a clean, modern UI.

---

## 🚀 Features
- Fetch random quotes from Supabase (`get_random_quotes` RPC).
- Save quotes to **Favorites**.
- Organize quotes into **Collections**.
- Adjustable **theme, accent color, and font scale** via settings.
- Built with **Flutter + Provider** for state management.
- Backend powered by **Supabase Postgres** with CSV‑seeded data.

---

## 🛠️ Tech Stack
- **Frontend:** Flutter, Dart, Provider
- **Backend:** Supabase (Postgres, RPC functions, Auth, Storage)
- **Data:** Quotes seeded via CSV import into Supabase

---

## 📦 Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/your-username/quotevault.git
cd quotevault
