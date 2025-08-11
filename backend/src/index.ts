import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { createServer, Server } from 'http';

let server: Server;

async function bootstrap(): Promise<Server> {
  const app = await NestFactory.create(AppModule);
  await app.init();
  const expressApp = app.getHttpAdapter().getInstance();
  return createServer(expressApp);
}

export default async function handler(req: any, res: any) {
  if (!server) {
    server = await bootstrap();
  }
  return server.emit('request', req, res);
}
