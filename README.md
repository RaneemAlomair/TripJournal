# ✈️ Travel Journey  
iOS Trip Journal App built with SwiftUI + Async/Await + FastAPI backend.  
Users can register, log in, create trips, add events, upload media, and view locations with MapKit.

---

## 🚀 Overview  
This project upgrades the starter mock-based app by connecting it to a real FastAPI backend using Docker.  
All networking is implemented using `URLSession` + Swift Concurrency.

---

## 🛠 Tech Stack  
- Swift / SwiftUI  
- Async/Await (Concurrency)  
- URLSession + Codable  
- Combine  
- MapKit  
- MVVM  
- FastAPI + Docker  

---

## 📦 Main Features  
- User registration & login  
- Token-based authentication  
- Create / update / delete trips  
- Add events with notes, dates, locations  
- Upload media (Base64 → API)  
- Map search & coordinates picker  
- Fully replaced mock service with live networking  

---
## 🖼 Screenshots
---

## 📁 Project Structure  
```
TravelJourney/
│
├── App.swift
│
├── JournalService/
│ ├── JournalService.swift // Protocol
│ ├── JournalService+Live.swift // Networking (URLSession + async/await)
│
├── Models/
│ ├── Models.swift // Trip, Event, Token, Location, Media
│ └── Requests.swift // TripCreate, EventCreate, MediaCreate...
│
├── Views/
│ ├── Authentication // Login, Register
│ ├── Trips // Trip list + Trip details
│ ├── Events // Event details + Create event
│ └── Media // Image upload + preview
│
└── Map/
└── MapSearch + MapPicker // Location search + annotations
```


---

## 🔌 Backend Setup (API)

### 1. Navigate to the API folder
```bash
cd ~/Desktop/TripJournalAPI
```
### 2. Run the API using Docker
```bash
docker compose up --build
```
### 3. Confirm it's running
Open
```bash
http://localhost:8000/docs
```
### 📱 Running the App
Open the project in Xcode
Ensure the app uses:
```
LiveJournalService()
```
Run on iOS Simulator
Register any username/password to start

### 🧠 Networking Layer
All networking implemented in:
```
JournalService/JournalService+Live.swift
```
Supports:
- POST /register
- POST /token
- /trips CRUD
- /events CRUD
- /media upload & delete
  
Includes:
- Reusable URLRequest builder
- JSON encoding/decoding
- Token injection in headers
- Async/Await for concurrency

## 👩‍💻 Developer  
**Raneem Alomair**  
*iOS Developer | Apple Developer Academy Alumna* 
