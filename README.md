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
<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 41 59" src="https://github.com/user-attachments/assets/65cf03cf-9c77-4ab7-becc-252ce74d261b" />

<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 52 53" src="https://github.com/user-attachments/assets/4082cac2-7237-4cf2-a76b-76e2be4d2be0" />

<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 52 43" src="https://github.com/user-attachments/assets/7a9b588b-b008-4673-91df-60329555271e" />


<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 46 26" src="https://github.com/user-attachments/assets/f2b505f3-2f20-4a47-8dac-c2dae7799ddd" />


<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 49 12" src="https://github.com/user-attachments/assets/a6e9bac8-6ae6-447a-96d8-f6598f2ea022" />

<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 49 18" src="https://github.com/user-attachments/assets/f4bf3c26-6237-43cc-ad03-fbbb63b7f699" />

<img width="200" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-13 at 14 53 05" src="https://github.com/user-attachments/assets/2c2c8fb3-825c-4b06-a1f1-b434900e284c" />

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
