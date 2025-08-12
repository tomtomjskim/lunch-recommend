import { DataSource } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { AuthService } from '../src/auth/auth.service';
import { User } from '../src/entities/user.entity';
import { Preference } from '../src/entities/preference.entity';
import { Food } from '../src/entities/food.entity';
import { FoodCategory } from '../src/entities/food-category.entity';
import { Category } from '../src/entities/category.entity';

describe('AuthService', () => {
  let dataSource: DataSource;
  let service: AuthService;
  let jwt: JwtService;

  beforeAll(async () => {
    dataSource = new DataSource({
      type: 'sqlite',
      database: ':memory:',
      entities: [User, Preference, Food, FoodCategory, Category],
      synchronize: true,
    });
    await dataSource.initialize();
    jwt = new JwtService({ secret: 'testsecret' });
    service = new AuthService(dataSource.getRepository(User), jwt);
  });

  afterAll(async () => {
    await dataSource.destroy();
  });

  beforeEach(async () => {
    await dataSource.synchronize(true);
  });

  it('creates new user and returns token', async () => {
    const res = await service.login('test@example.com', 'nick', 'local');
    expect(res.accessToken).toBeDefined();
    const payload = jwt.verify(res.accessToken);
    expect(payload.sub).toBeDefined();
    const users = await dataSource.getRepository(User).find();
    expect(users).toHaveLength(1);
  });

  it('reuses existing user on repeated login', async () => {
    const repo = dataSource.getRepository(User);
    await service.login('test@example.com', 'nick', 'local');
    const count1 = await repo.count();
    await service.login('test@example.com', 'nick', 'local');
    const count2 = await repo.count();
    expect(count2).toBe(count1);
  });

  it('fails to verify invalid token', () => {
    expect(() => jwt.verify('badtoken')).toThrow();
  });
});
