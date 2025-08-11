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

## Environment Variables

Configure the backend with the following variables:

- `DATABASE_URL` – full PostgreSQL connection string. If set, the individual `DB_*` variables below are ignored.
- `DB_HOST` – database host (default `localhost`).
- `DB_PORT` – database port (default `5432`).
- `DB_USER` – database user (default `postgres`).
- `DB_PASS` – database password (default `postgres`).
- `DB_NAME` – database name (default `lunch`).
- `JWT_SECRET` – secret key used to sign JWT tokens (**required**).

## Runtime

Start a development server:

```
npm run start:dev
```

For production builds:

```
npm run build
npm start
```

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

## AWS Deployment

An example script for deploying the container to AWS Elastic Container Service is provided at [`deploy/aws/deploy.sh`](deploy/aws/deploy.sh). Set the required environment variables described in the script and run:

```
./deploy/aws/deploy.sh
```
