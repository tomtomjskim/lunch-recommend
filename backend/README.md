# Backend

This is the backend service for *오늘점심 뭐 먹지*.

## Setup

Install dependencies:

```
npm install
```

Start development server:

```
npm run start:dev
```

> Note: This project skeleton was generated without downloading any packages. Ensure required dependencies like NestJS and TypeORM are installed before running.

## Docker

Build the image:

```
docker build -t lunch-backend .
```

Run the container:

```
docker run -p 3000:3000 lunch-backend
```

The API will be available at `http://localhost:3000`.
