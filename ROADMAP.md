# Project Roadmap

This document summarizes the phased development plan for the "오늘점심 뭐 먹지" application. Each phase builds upon the previous one to deliver a social lunch recommendation service.

## Phase 1. Project Setup & Database Design
- Initialize backend (NestJS) and frontend (Flutter) repositories
- Configure PostgreSQL with TypeORM
- Define entities: `User`, `Food`, `Category`, `FoodCategory`, `Preference`

## Phase 2. Random Recommendation (Unauthenticated)
- CRUD APIs for foods and categories
- API to return a random food
- Frontend main screen with playful recommendation animation

## Phase 3. Authentication & Personalized Suggestions
- Social login using Passport and JWT
- APIs to record user likes/dislikes
- API to recommend foods based on user preferences
- Frontend login UI and buttons to like/dislike recommended foods

## Phase 4. MVP Deployment
- Dockerize backend and deploy to cloud
- Build Flutter web app and host statically
- Reserve UI space for advertisements

## Phase 5. Group Features
- Add `Group` and `GroupMember` schemas
- APIs for creating, joining, and managing groups
- Frontend pages for group management

## Phase 6. In-Group Polling
- Schemas: `Poll`, `PollOption`, `Vote`
- APIs to create polls and cast votes
- Frontend UI for poll creation and results

This roadmap will evolve as the project progresses and requirements change.
